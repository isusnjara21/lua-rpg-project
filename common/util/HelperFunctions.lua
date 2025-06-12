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
