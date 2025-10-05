--[[
    Logger utility
    Handles writing out objects, tables and text into output buffers
--]]

Logger = {}
function Logger.log(information)
    app.stdout = Logger.__write(information, app.stdout)
end

function Logger.error()
    app.errout = Logger.__write(information, app.errout)
end

function Logger.warn()
    app.wrnout = Logger.__write(information, app.wrnout)
end

function Logger.consoleWrite()
    app.clsout = Logger.__write(information, app.clsout)
end

function Logger.__write(information, data)
    if app.__RUNTIME ~= 'debug' then return end

    local out = data or ''

    if type(information) == 'string' or type(information) == 'number' then
        out = out .. tostring(information) .. '\n'
    elseif type(information) == 'table' then
        local str = ""
        local is_array = true
        local i = 1
        for k, _ in pairs(information) do
            if k ~= i then
                is_array = false
                break
            end
            i = i + 1
        end

        if is_array then
            for _, v in ipairs(information) do
                str = str .. tostring(v) .. '\n'
            end
        else
            for k, v in pairs(information) do
                str = str .. tostring(k) .. ": " .. tostring(v) .. '\n'
            end
        end

        out = out .. str
    else
        out = out .. "Unsupported type for Logging: " .. type(information) .. '\n'
    end

    return out
end