Collision = Object:extend()
function Collision:init()
    self.colliders = {}
    self.collisions = {}
end

function Collision:register(collider)
    table.insert(self.colliders, collider)
end

function Collision:unregister(collider)
    for i = #self.colliders, 1, -1 do
        if self.colliders[i] == collider then
            table.remove(self.colliders, i)
            break
        end
    end
end

function Collision:update()
    local function getScaledShape(collider)
        local shape = collider:getShape()
        if collider.type == "circle" then
            return {
                center = shape.center,
                radius = shape.radius * app.global_scale
            }
        elseif collider.type == "obb" then
            return {
                center = shape.center,
                size = shape.size:scale(app.global_scale),
                rotation = shape.rotation
            }
        end
    end
    for i = 1, #self.colliders do
        local a = self.colliders[i]
        local aShape = getScaledShape(a)
        if aShape then
            for j = i + 1, #self.colliders do
                local b = self.colliders[j]
                local bShape = getScaledShape(b)
                if bShape then
                    local isColliding = self:checkCollision(aShape, bShape)
                    local collision_key = self:_createCollisionKey(a, b)
                    if isColliding then
                        if not self.collisions[collision_key] then
                            self:_dispatch(a, b, "onEnterCollision")
                            self.collisions[collision_key] = true
                        else
                            self:_dispatch(a, b, "onCollision")
                        end
                    elseif self.collisions[collision_key] then
                        self:_dispatch(a, b, "onExitCollision")
                        self.collisions[collision_key] = nil
                    end
                end
            end
        end
    end
end

function Collision:checkCollision(a, b)
    if a.radius and b.radius then
        return self:_circle_circle(a, b)
    elseif a.radius then
        return self:_circle_obb(a, b)
    elseif b.radius then
        return self:_circle_obb(b, a)
    else
        return self:_obb_obb(a, b)
    end
end

function Collision:_circle_circle(a, b)
    local dx = a.center.x - b.center.x
    local dy = a.center.y - b.center.y
    local r = a.radius + b.radius
    return dx * dx + dy * dy <= r * r
end

function Collision:_circle_obb(a, b)
    local cx, cy = a.center.x, a.center.y
    local ox, oy = b.center.x, b.center.y
    local rot = -b.rotation
    local hw, hh = b.size.x / 2, b.size.y / 2

    local dx = cx - ox
    local dy = cy - oy

    local localX = dx * math.cos(rot) - dy * math.sin(rot)
    local localY = dx * math.sin(rot) + dy * math.cos(rot)

    local closestX = math.max(-hw, math.min(localX, hw))
    local closestY = math.max(-hh, math.min(localY, hh))

    local distX = localX - closestX
    local distY = localY - closestY

    return distX * distX + distY * distY <= a.radius * a.radius
end

function Collision:_obb_obb(a, b)
    local function getAxes(obb)
        local angle = obb.rotation
        return {
            vec(math.cos(angle), math.sin(angle)),
            vec(-math.sin(angle), math.cos(angle))
        }
    end

    local function project(shape, axis)
        local hw, hh = shape.size.x / 2, shape.size.y / 2
        local corners = {
            vec(-hw, -hh),
            vec(hw, -hh),
            vec(hw, hh),
            vec(-hw, hh)
        }
        local min, max = nil, nil
        for _, corner in ipairs(corners) do
            corner:rotate(shape.rotation)
            corner = corner + shape.center
            local dot = corner:dot(axis)
            min = (not min or dot < min) and dot or min
            max = (not max or dot > max) and dot or max
        end
        return min, max
    end

    for _, axis in ipairs(getAxes(a)) do
        local minA, maxA = project(a, axis)
        local minB, maxB = project(b, axis)
        if maxA < minB or maxB < minA then
            return false
        end
    end

    for _, axis in ipairs(getAxes(b)) do
        local minA, maxA = project(a, axis)
        local minB, maxB = project(b, axis)
        if maxA < minB or maxB < minA then
            return false
        end
    end

    return true
end

function Collision:_createCollisionKey(a, b)
    return a.__id .. "_" .. b.__id
end

function Collision:_dispatch(a, b, method)
    for _, module in pairs(a.node.modules) do
        if module[method] then
            module[method](module, b)
        end
    end
    for _, module in pairs(b.node.modules) do
        if module[method] then
            module[method](module, a)
        end
    end
end
