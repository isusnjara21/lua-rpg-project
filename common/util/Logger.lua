Logger = {}
function Logger.log(information)
    if type(information) == 'string' or type(information) == 'number' then
        app.stdout = app.stdout .. tostring(information) .. '\n'
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

        app.stdout = app.stdout .. str
    else
        app.stdout = app.stdout .. "Unsupported type for Logging: " .. type(information) .. '\n'
    end
end