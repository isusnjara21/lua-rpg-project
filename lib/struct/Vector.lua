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
    return self
end

function Vector:clone()
    local newVec = vec(self.x, self.y)
    return newVec
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

function Vector:scale(scalar)
    return vec(self.x * scalar, self.y * scalar)
end

local function freezeVector(v)
    return setmetatable({}, {
        __index = v,
        __newindex = function()
            error("Cannot modify a static direction vector", 2)
        end
    })
end

Vector.LEFT = freezeVector(vec(-1, 0))

Vector.RIGHT = freezeVector(vec(1, 0))

Vector.UP = freezeVector(vec(0, -1))

Vector.DOWN = freezeVector(vec(0, 1))