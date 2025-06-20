Collision = Object:extend()
function Collision:init()
    self.COLLIDERS = {}
    self.COLLISIONS = {}
end

function Collision:register(collider)
    local layer = collider.layer or "default" -- defaults to 'default' if you dont specify a layer (this doesnt mean it will interact with all layers, just a generic layer)
    if not self.COLLIDERS[layer] then
        self.COLLIDERS[layer] = {}
    end
    table.insert(self.COLLIDERS[layer], collider)
end

function Collision:unregister(collider)
    local layer = collider.layer or "default"
    local layerColliders = self.COLLIDERS[layer]

    for i = #layerColliders, 1, -1 do
        if layerColliders[i] == collider then
            table.remove(layerColliders, i)
            break
        end
    end
end

function Collision:pop()
    self.COLLIDERS = {}
    self.COLLISIONS = {}
end

function Collision:update()
    local seen = {}
    for layerA, collidersA in pairs(self.COLLIDERS) do
        seen[layerA] = true
        for layerB, collidersB in pairs(self.COLLIDERS) do
            if not seen[layerB] or layerA == layerB then
                for _, a in ipairs(collidersA) do
                    for _, b in ipairs(collidersB) do
                        if a ~= b and self:_checkMask(a, b) then
                            local aShape = self:_getScaledShape(a)
                            local bShape = self:_getScaledShape(b)
                            if aShape and bShape then
                                local isColliding = self:checkCollision(aShape, bShape)
                                local collision_key = self:_createCollisionKey(a, b)

                                if isColliding then
                                    if not self.COLLISIONS[collision_key] then
                                        self:_dispatch(a, b, "onEnterCollision")
                                        self.COLLISIONS[collision_key] = true
                                    else
                                        self:_dispatch(a, b, "onCollision")
                                    end
                                elseif self.COLLISIONS[collision_key] then
                                    self:_dispatch(a, b, "onExitCollision")
                                    self.COLLISIONS[collision_key] = nil
                                end
                            end
                        end
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

function Collision:cast(testCollider, direction, distance, step)
    local hits = {}
    local steps = math.floor(distance / step)
    local shapeType = testCollider.type

    for s = 1, steps do
        local moveVec = direction:clone() * (s * step)
        local testShape = self:_getMovedShape(testCollider, moveVec)

        for _, collider in ipairs(self:getAllColliders()) do
            if self:_checkMask(testCollider, collider) then
                local otherShape = self:_getScaledShape(collider)
                if self:checkCollision(testShape, otherShape) then
                    table.insert(hits, {collider = collider, distance = s * step})
                    break
                end
            end
        end

        if #hits > 0 then break end
    end

    return hits
end

function Collision:getAllColliders()
    local allColliders = {}

    for _, colliders in pairs(self.COLLIDERS) do
        for _, collider in ipairs(colliders) do
            table.insert(allColliders, collider)
        end 
    end

    return allColliders
end

function Collision:_getMovedShape(collider, offset)
    local shape = collider:getShape()
    local movedShap = {}

    if collider.type == "circle" then
        movedShape = {
            center = shape.center + offset,
            radius = shape.radius * app.global_scale
        }
    elseif collider.type == "obb" then
        movedShape = {
            center = shape.center + offset,
            size = shape.size:scale(app.global_scale),
            rotation = shape.rotation
        }
    end

    return movedShape
end

function Collision:_getScaledShape(collider)
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

function Collision:_checkMask(a, b)
    return (not a.mask or a.mask[b.layer] or a.layer == b.layer) and
        (not b.mask or b.mask[a.layer] or a.layer == b.layer)
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
