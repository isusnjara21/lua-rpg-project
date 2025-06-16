Renderer = Object:extend()
function Renderer:init()
    love.graphics.setDefaultFilter("nearest", "nearest")

    self.DRAWABLE_OBJECTS = {}
    self.__sort_diry = false
    self.__virtual_screen = love.graphics.newCanvas(app.screen.x, app.screen.y)
    self.compare = function(a, b)
        return a.modules.SpriteRenderer.z_index < b.modules.SpriteRenderer.z_index
    end

    
end

function Renderer:draw_call()
    self:flushSort()

    love.graphics.setCanvas(self.__virtual_screen)
    love.graphics.clear()

    for _, node in pairs(self.DRAWABLE_OBJECTS) do
        if node.modules.SpriteRenderer and node.modules.Transform and not node.hidden then
            local worldPosition = node.modules.Transform.position
            local camPosition = app.camera.Transform.position
            local camOffset = app.screen / vec(2, 2)
            local camRotation = app.camera.Transform.rotation
            camOffset:rotate(camRotation)
            camPosition = camPosition - camOffset

            local position = util.WorldToScreen(worldPosition, camPosition, camRotation)

            local worldRotation = node.modules.Transform.rotation
            local screenRotation = worldRotation - camRotation

            if node.modules.SpriteRenderer.static then
                screenRotation = 0
            end

            local scale = node.modules.Transform.scale

            love.graphics.draw(
                node.modules.SpriteRenderer.image,
                position.x,
                position.y,
                screenRotation,
                scale.x * app.global_scale,
                scale.y * app.global_scale,
                node.modules.SpriteRenderer.frame_origin.x,
                node.modules.SpriteRenderer.frame_origin.y
            )
        end
    end

    if app.__RUNTIME == "debug" then
        for _, node in pairs(self.DRAWABLE_OBJECTS) do
            for _, module in pairs(node.modules) do
                if module.onDebugDraw then
                    module:onDebugDraw()
                end
            end
        end
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
end

--[[ -- no longer used
function Renderer:push(obj)
    table.insert(self.DRAWABLE_OBJECTS, obj)
    self.__sort_dirty = true
end
--]]
function Renderer:pop()
    self.DRAWABLE_OBJECTS = {}
end

function Renderer:add(node)
    if not node or not node.modules or not node.modules.SpriteRenderer then
        return
    end

    for _, existing in ipairs(self.DRAWABLE_OBJECTS) do
        if existing == node then
            return
        end
    end

    table.insert(self.DRAWABLE_OBJECTS, node)
    self.__sort_dirty = true
end

function Renderer:remove(node)
    for i, obj in ipairs(self.DRAWABLE_OBJECTS) do
        if obj == node then
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
        node.modules.Transform.position,
        app.camera.Transform.position,
        app.camera.Transform.rotation
    )
    local size = node.modules.SpriteRenderer.frame_size * node.modules.Transform.scale * app.global_scale
    local halfScreen = app.screen / 2

    return not (pos.x + size.x < 0 or pos.x - size.x > app.screen.x or pos.y + size.y < 0 or
        pos.y - size.y > app.screen.y)
end
