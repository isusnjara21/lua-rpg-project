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
end

function Vector3.__add(a, b)
    return vec3(a.x + b.x, a.y + b.y, a.z + b.z)
end

function Vector3.__sub(a, b)
    return vec3(a.x - b.x, a.y - b.y, a.z - b.z)
end

function Vector3.__div(a, b)
    return vec3(a.x / b.x, a.y / b.y, a.z / b.z)
end