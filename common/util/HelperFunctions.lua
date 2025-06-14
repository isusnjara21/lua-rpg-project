util = {}

function util.TransformAlias(node)
    Generic.assertType(node, Node)
    if not node.modules.Transform then
        error("cannot create alias for Transform without there being a Transform module attached")
    end

    node.Transform = node.modules.Transform
    node.position = node.Transform.position
    -- node.rotation = node.Transform.rotation  [[ removed, rotation is no longer a vector ]]
    node.scale = node.Transform.scale
end

function util.WorldToScreen(worldPos, camPos, camRot)
    Generic.assertType(worldPos, vec)
    Generic.assertType(camPos, vec)
    Generic.assertType(camRot, vec)
    local screenPos = vec(worldPos.x - camPos.x, worldPos.y - camPos.y)

    local cos = math.cos(-camRot)
    local sin = math.sin(-camRot)

    local rotatedScreenPos = vec(screenPos.x * cos - screenPos.y * sin, screenPos.x * sin + screenPos.y * cos)
    return rotatedScreenPos
end

function util.__parseArgs(arg)
    local args = {}
    local skip_next = false
    for i = 1, #arg do
        if skip_next then
            skip_next = false
        else
            local a = arg[i]

            if a:sub(1, 2) == "--" then
                local eqPos = a:find("=")

                if eqPos then
                    local key = a:sub(3, eqPos - 1)
                    local value = a:sub(eqPos + 1)
                    args[key] = value
                else
                    local key = a:sub(3)
                    local nextArg = arg[i + 1]
                    if nextArg and nextArg:sub(1, 1) ~= "-" then
                        args[key] = nextArg
                        skipNext = true
                    else
                        args[key] = true
                    end
                end
            elseif a:sub(1, 1) == "-" then
                local key = a:sub(2)
                local nextArg = arg[i + 1]
                if nextArg and nextArg:sub(1, 1) ~= "-" then
                    args[key] = nextArg
                    skipNext = true
                else
                    args[key] = true
                end
            else
                table.insert(args, a)
            end
        end
    end
    return args
end
