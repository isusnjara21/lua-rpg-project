Stack = Generic:extend()

function Stack:init(Type)
    if Type then
        self.super:init(Type)
    else
        self.super:init("any")
    end

    self.__memory = {}
end

function Stack:isEmpty()
    if #self.__memory == 0 then
        return true
    else
        return false
    end
end

function Stack:push(element)
    self:enforceType(element)
    if next(self.__memory) == nil then
        self.__memory[1] = element
    else
        self.__memory[#self.__memory + 1] = element
    end
end

function Stack:pop()
    local top = self.__memory[#self.__memory]
    self.__memory[#self.__memory] = nil
    return top
end

function Stack:count()
    return #self.__memory
end

function Stack:__tostring()
    local string = '[ '
    for k, v in ipairs(self.__memory) do
        if k == 1 then
            string = string .. tostring(v)
        else
            string = string .. ', ' .. tostring(v)
        end
    end
    string = string .. ' ]'
    return string
end

function Stack:top_is(lambda)
    if lambda(self.__memory[#self.__memory]) then
        return true
    end
    return false
end