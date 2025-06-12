Generic = Object:extend()
function Generic:init(T)
    self.__type = T

    if type(T) == "string" then
        if T == "any" then
            self.type_checker = function(_)
                return true
            end
        else
            self.type_checker = function(value)
                return type(value) == T
            end
        end
    elseif type(T) == "table" and type(T.is) == "function" then
        self.type_checker = function(value)
            return type(value) == "table" and value.is and value:is(T)
        end
    else
        error("Invalid type specifier for Generic class")
    end
end

function Generic:isType(T)
    return self.type_checker(T)
end

function Generic:enforceType(variable)
    if not self:isType(variable) then
        error(string.format("Invalid type - expected %s, got %s", tostring(self.type), type(element)))
    end
end

function Generic:opt_enforceType(variable)
    if variable and not self:isType(variable) then
        error(string.format("Invalid type - expected %s, got %s", tostring(self.type), type(element)))
    end
end

-- STATIC functions

function Generic.assertType(variable, T)
    if type(T) == "string" then
        if not type(variable) == T then
            error("Wrong type")
        end
    elseif type(T) == "table" and type(T.is) == "function" then
        if not type(variable) == "table" and variable.is and variable:is(T) then
            error("Wrong type")
        end
    end
end
