Collider = Module:extend()

local id_counter = 0

function Collider:init()
    id_counter = id_counter + 1
    self.__id = id_counter

    self.type = "obb"
    self.offset = vec(0, 0)

    self.collider_data = {
        size = vec(1, 1)
    }

    self.layer = "" -- very sensitive naming
    self.mask = {}
    self.tag = {}

    self.debug_color = {1, 1, 0}
end

function Collider:setCollider(collider)
end

function Collider:onLoad()
    app.COLLISION:register(self)
end

function Collider:onUnload()
    app.COLLISION:unregister(self)
end

function Collider:fromData(data)
    self.type = data.type
    self.offset = data.offset
    self.collider_data = data.collider_data
    self.layer = data.layer
    self.mask = data.mask
    self.tag = data.tag
end

function Collider:addTag(tag)
    if not self.tag[tag] then
        self.tag[tag] = true
    end
end

function Collider:removeTag(tag)
    if self.tag[tag] then
        self.tag[tag] = nil
    end
end

function Collider:onDebugDraw()
    local camPosition = app.camera.Transform.position
    local camOffset = app.screen / vec(2, 2)
    local camRotation = app.camera.Transform.rotation
    camOffset:rotate(camRotation)
    camPosition = camPosition - camOffset

    local pos = util.WorldToScreen(self:getWorldPosition(), camPosition, camRotation)

    love.graphics.setColor(self.debug_color)

    if self.type == "circle" then
        love.graphics.circle("line", pos.x, pos.y, self.collider_data.radius * app.global_scale)
        
    elseif self.type == "obb" then
        local size = self.collider_data.size:scale(app.global_scale)
        local rot = self:getRotation()
        local hw, hh = size.x / 2, size.y / 2
        local corners = {
            vec(-hw, -hh),
            vec(hw, -hh),
            vec(hw, hh),
            vec(-hw, hh)
        }

        for i = 1, 4 do
            local worldCorner = corners[i]:clone():rotate(rot) + self:getWorldPosition()
            corners[i] = util.WorldToScreen(worldCorner, camPosition, camRotation)
        end
        
        for i = 1, 4 do
            local j = i % 4 + 1
            love.graphics.line(corners[i].x, corners[i].y, corners[j].x, corners[j].y)
        end
    end

    love.graphics.setColor(1, 1, 1)
end

function Collider:getWorldPosition()
    return self.node.modules.Transform.position + self.offset
end

function Collider:getRotation()
    return self.node.modules.Transform.rotation or 0
end

function Collider:getShape()
    if self.type == "circle" then
        return {center = self:getWorldPosition(), radius = self.collider_data.radius}
    elseif self.type == "obb" then
        local pos = self:getWorldPosition()
        local size = self.collider_data.size
        local rot = self:getRotation()
        return {center = pos, size = size, rotation = rot}
    end
end

function Collider:toString()
    return "Collider"
end

return Collider
