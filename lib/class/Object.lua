-- edited from https://github.com/a327ex/SNKRX

Object = {}
Object.__index = Object
function Object:init()
end

function Object:extend()
    local cls = {}
    for k, v in pairs(self) do
        if k:find("__") == 1 then
            cls[k] = v
        end
    end
    cls.__index = cls
    cls.super = self
    setmetatable(cls, self)

    if self.__interfaces then
        cls.__interfaces = {}
        for i, iface in ipairs(self.__interfaces) do
            cls.__interfaces[i] = iface
        end
    end

    return cls
end

function Object:is(T)
    local mt = getmetatable(self)
    while mt do
        if mt == T then
            return true
        end
        mt = getmetatable(mt)
    end
    return false
end

function Object:__call(...)
    local obj = setmetatable({}, self)
    obj:init(...)
    return obj
end

-- INTERFACES

Interface = Object:extend()
function Interface:init(name, methods)
    self.__class = name
    self.__methods = methods
end

function Object:implementContract(Interfaces)
    self.__interfaces = Interfaces

    for _, i in ipairs(Interfaces) do
        if type(i) == "table" and type(i.is) == "function" then
            if i:is(Interface) then
                for _, m in ipairs(i.__methods) do
                    local method = self[m]
                    if type(method) ~= "function" then
                        error("Class doesn't implement all required methods")
                    end
                end
            else
                error("Given class is not an Interface")
            end
        else
            error("Given interface is non existent")
        end
    end

    return self
end

function Object:implements(Interface)
    if not self.__interfaces then
        return false
    end
    for _, i in ipairs(self.__interfaces) do
        if i == Interface then
            return true
        end
    end
    return false
end
