Vector = Generic:extend()
vec = Vector
function Vector:init(x, y, Type --[[optional]])
    if Type then
        self.super:init(Type)
    else
        self.super:init("number")
    end
    self:enforceType(x)
    self:enforceType(y)
    self.x = x
    self.y = y
end

function Vector:set(x, y)
    self:enforceType(x)
    self:enforceType(y)
    self.x = x
    self.y = y
end

function Vector:normalize()
    if self.x == 0 and self.y == 0 then
        return
    end

    local length = math.sqrt(self.x ^ 2 + self.y ^ 2)

    self.x = self.x / length
    self.y = self.y / length
end

function Vector:rotate(angle)
    local x = self.x
    local y = self.y
    local cosA = math.cos(angle)
    local sinA = math.sin(angle)
    self.x = x * cosA - y * sinA
    self.y = x * sinA + y * cosA
end

function Vector.LEFT()
    return vec(-1, 0)
end

function Vector.RIGHT()
    return vec(1, 0)
end

function Vector.UP()
    return vec(0, -1)
end

function Vector.DOWN()
    return vec(0, 1)
end

function Vector.__add(a, b)
    return vec(a.x + b.x, a.y + b.y)
end

function Vector.__sub(a, b)
    return vec(a.x - b.x, a.y - b.y)
end

function Vector.__div(a, b)
    return vec(a.x / b.x, a.y / b.y)
end


