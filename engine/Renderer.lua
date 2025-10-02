Renderer = Object:extend()
function Renderer:init()
    love.graphics.setDefaultFilter("nearest", "nearest")

    self.DRAWABLE_OBJECTS = {}
    self.DEBUG_SHAPES = {}

    self.__sort_diry = false
    self.__virtual_screen = love.graphics.newCanvas(app.screen.x, app.screen.y)

    self.cam_data = {}

    self.compare = function(a, b)
        local a_z = 0
        local b_z = 0
        if a.layer == 'world' then
            a_z = a.node.modules.SpriteRenderer.z_index
        elseif a.layer == 'ui' then
            a_z = a.node.modules.ui_Canvas.z_index
        end

        if b.layer == 'world' then
            b_z = b.node.modules.SpriteRenderer.z_index
        elseif b.layer == 'ui' then
            b_z = b.node.modules.ui_Canvas.z_index
        end

        return a_z < b_z
    end

end

function Renderer:draw_call()
    self:flushSort()

    love.graphics.setCanvas(self.__virtual_screen)
    love.graphics.clear()

    local camPosition = app.camera.Transform:getAbsolutePosition()
    local camOffset = (app.screen / vec(2, 2)) * (1 / app.global_scale)
    local camRotation = app.camera.Transform:getAbsoluteRotation()
    camOffset:rotate(camRotation)
    camPosition = camPosition - camOffset

    self.cam_data = {
        camPosition = camPosition,
        camOffset = camOffset,
        camRotation = camRotation,
    }

    for _, obj in pairs(self.DRAWABLE_OBJECTS) do
        local node = obj.node
        if obj.layer == 'world' then
            self:draw_world(node)
        elseif obj.layer == 'ui' then
            self:draw_ui(node)
        end
    end

    if app.__RUNTIME == "debug" then
        local nodes = {} -- yuck
        for _, obj in pairs(self.DRAWABLE_OBJECTS) do
            table.insert(nodes, obj.node)
        end
        app.ACTIVE_SCENE:dispatch(nodes, 'onDebugDraw', {})
        --for _, node in pairs(self.DRAWABLE_OBJECTS) do
            
            --for _, module in pairs(node.modules) do
            --    if module.onDebugDraw then
            --        module:onDebugDraw()
            --    end
            --end
        --end

        for _, shape in pairs(self.DEBUG_SHAPES) do
            self:debug_draw(shape)
        end
        self.DEBUG_SHAPES = {}
    end

    love.graphics.setCanvas()

    local sw, sh = love.graphics.getDimensions()
    local scaleX = sw / app.screen.x
    local scaleY = sh / app.screen.y
    local scale = math.max(scaleX, scaleY)
    local offsetX = (sw - (app.screen.x * scale)) / 2
    local offsetY = (sh - (app.screen.y * scale)) / 2

    love.graphics.push()
    love.graphics.draw(self.__virtual_screen, offsetX, offsetY, 0, scale, scale)
    love.graphics.pop()

    self.cam_data = {}
end

--[[ -- no longer used
function Renderer:push(obj)
    table.insert(self.DRAWABLE_OBJECTS, obj)
    self.__sort_dirty = true
end
--]]
function Renderer:pop()
    self.DRAWABLE_OBJECTS = {}

    self.WORLD_OBJECTS = {}
    self.UI_OBJECTS = {}
end

function Renderer:add(node)
    if not node or not node.modules then
        return
    end
    local layer = ''
    if node.modules.SpriteRenderer then
        layer = 'world'
    elseif node.modules.ui_Canvas then
        layer = 'ui'
    else return end

    for _, existing in ipairs(self.DRAWABLE_OBJECTS) do
        if existing.node == node then
            return
        end
    end
    local drawable = {  node = node,
                        layer = layer} -- wip, might want to figure something else out 
    table.insert(self.DRAWABLE_OBJECTS, drawable)
    self.__sort_dirty = true
end

function Renderer:remove(node)
    for i, obj in ipairs(self.DRAWABLE_OBJECTS) do
        if obj.node == node then
            table.remove(self.DRAWABLE_OBJECTS, i)
            break
        end
    end
end

function Renderer:flushSort()
    if self.__sort_dirty then
        table.sort(self.DRAWABLE_OBJECTS, self.compare)
        self.__sort_dirty = false
    end
end

-- WIP currently only implemented for SpriteRenderer
function Renderer:isVisible(node)
    local pos =
    util.WorldToScreen(
        node.modules.Transform:getAbsolutePosition(),
        app.camera.Transform:getAbsolutePosition(),
        app.camera.Transform:getAbsoluteRotation()
    )
    local size = node.modules.SpriteRenderer.size * node.modules.Transform.scale * app.global_scale
    local halfScreen = app.screen / 2

    return not (pos.x + size.x < -halfScreen.x or pos.x - size.x > halfScreen.x or pos.y + size.y < -halfScreen.y or
        pos.y - size.y > halfScreen.y)
end

-- temp debug

function Renderer:debug_draw(shape) -- VERY MUCH WIP
    local camPosition = app.camera.Transform:getAbsolutePosition()
    local camOffset = (app.screen / vec(2, 2)) * (1 / app.global_scale)
    local camRotation = app.camera.Transform.rotation
    camOffset:rotate(camRotation)
    camPosition = camPosition - camOffset

    love.graphics.setColor(1, 0, 0)
    local pos = util.WorldToScreen(shape.center, camPosition, camRotation)
    love.graphics.circle("line", pos.x, pos.y, 8 * app.global_scale)

    love.graphics.setColor(1, 1, 1)
end

function Renderer:draw_world(node)
    if not self:isVisible(node) then return end
    local worldPosition = node.modules.Transform:getAbsolutePosition()
    local position = util.WorldToScreen(worldPosition, self.cam_data.camPosition, self.cam_data.camRotation)
    local worldRotation = node.modules.Transform:getAbsoluteRotation()
    local screenRotation = worldRotation - self.cam_data.camRotation

    if node.modules.SpriteRenderer.static then
        screenRotation = 0
    end

    local scale = node.modules.Transform:getAbsoluteScale()
  
    love.graphics.draw(
        node.modules.SpriteRenderer.image,
        position.x,
        position.y,
        screenRotation,
        scale.x * app.global_scale,
        scale.y * app.global_scale,
        node.modules.SpriteRenderer.origin.x,
        node.modules.SpriteRenderer.origin.y
    )
end

function Renderer:draw_ui()
end