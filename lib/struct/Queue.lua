Queue = Generic:extend()

function Queue:init(Type)
    if Type then
        self.super:init(Type)
    else
        self.super:init("any")
    end

    self.__memory = {}
end

function Queue:isEmpty()
    if #self.__memory == 0 then
        return true
    else
        return false
    end
end

function Queue:push(element)
    self:enforceType(element)
    table.insert(self.__memory, 1, element)
end

function Queue:pop()
    if self:isEmpty() then
        return
    end
    table.remove(self.__memory, #self.__memory)
end

function Queue:front()
    if self:isEmpty() then
        return
    end
    return self.__memory[#self.__memory]
end