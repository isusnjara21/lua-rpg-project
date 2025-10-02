Vector3 = Generic:extend()
vec3 = Vector3
function Vector3:init(x, y, z, Type --[[optional]])
    if Type then
        self.super:init(Type)
    else
        self.super:init("number")
    end
    self:enforceType(x)
    self:enforceType(y)
    self:enforceType(z)
    self.x = x
    self.y = y
    self.z = z
end

function Vector3:set(x, y, z)
    self:enforceType(x)
    self:enforceType(y)
    self:enforceType(z)
    self.x = x
    self.y = y
    self.z = z
    return self
end

function Vector3:normalize()
    if self.x == 0 and self.y == 0 and self.z == 0 then
        return
    end

    local length = self:length()

    self.x = self.x / length
    self.y = self.y / length
    self.z = self.z / length
    return self
end

function Vector3:rotate(axis, angle)
    return self
end

function Vector3:clone()
    local newVec = vec3(self.x, self.y, self.z)
    return newVec
end

function Vector3.__add(a, b)
    if type(a) == 'table' and type(b) == 'table' and a.x and a.y and a.z and b.x and b.y and b.z then
        return vec3(a.x + b.x, a.y + b.y, a.z + b.z)
    else
        error('Cannot add Vector3 with a non-vector3 type')
    end
end

function Vector3.__sub(a, b)
    if type(a) == 'table' and type(b) == 'table' and a.x and a.y and a.z and b.x and b.y and b.z then
        return vec3(a.x - b.x, a.y - b.y, a.z - b.z)
    else
        error('Cannot subtract Vector3 with a non-vector3 type')
    end
end

-- will allow component wise division
function Vector3.__div(a, b)
    if type(a) == 'number' and type(b) == "table" and b.x and b.y and b.z then
        error("Invalid operands for vector3 division")
    elseif type(b) == "number" and type(a) == "table" and a.x and a.y and a.z then
        return vec3(a.x / b, a.y / b, a.z / b)
    elseif type(a) == "table" and type(b) == "table" and a.x and a.y and a.z and b.x and b.y and b.z then
        return vec3(a.x / b.x, a.y / b.y, a.z / b.z)
    else
        error("Invalid operands for vector3 division")
    end
end

-- will allow component wise multiplication
function Vector3.__mul(a, b)
    if type(a) == 'number' and type(b) == "table" and b.x and b.y and b.z then
        return vec(b.x * a, b.y * a, b.z * a)
    elseif type(b) == "number" and type(a) == "table" and a.x and a.y and a.z then
        return vec(a.x * b, a.y * b, a.z * b)
    elseif type(a) == "table" and type(b) == "table" and a.x and a.y and a.z and b.x and b.y and b.z then
        return vec(a.x * b.x, a.y * b.y, a.z * b.z)
    else
        error("Invalid operands for vector3 multiplication")
    end
end

function Vector3:scale(scalar)
    return vec3(self.x * scalar, self.y * scalar, self.z * scalar)
end
function Vector3:dot(vector)
    return self.x * vector.x + self.y * vector.y + self.z * vector.z
end
function Vector3:cross(vector)
    return vec3(
        self.y * vector.z - self.z * vector.y,
        self.z * vector.x - self.x * vector.z,
        self.x * vector.y - self.y * vector.x
    )
end
function Vector3:length()
    return math.sqrt(self.x * self.x + self.y * self.y + self.z * self.z)
end

local function freezeVector(v)
    return setmetatable({}, {
        __index = v,
        __newindex = function()
            error("Cannot modify a static direction vector", 2)
        end
    })
end