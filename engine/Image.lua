Image = Object:extend()

function Image:init()
end

--[[
    image buffer is an array of images while position is an array of relative positions wow :O
    the position of image has to be at same index as image in respective buffers
--]]
function Image:join(image_buffer, position_buffer)
    if #image_buffer ~= #position_buffer then error("Image buffer and Position buffer need to be the same length.") end


    local minX, minY, maxX, maxY = math.huge, math.huge, -math.huge, -math.huge
    for i, img in ipairs(image_buffer) do
        local pos = position_buffer[i]
        local w, h = img:getWidth(), img:getHeight()

        minX = math.min(minX, pos.x)
        minY = math.min(minY, pos.y)
        maxX = math.max(maxX, pos.x + w)
        maxY = math.max(maxY, pos.y + h)
    end

    local canvasWidth = maxX - minX
    local canvasHeight = maxY - minY
    local canvas = love.graphics.newCanvas(canvasWidth, canvasHeight)


    love.graphics.setCanvas(canvas)
    love.graphics.clear()

    for i, img in ipairs(image_buffer) do
        local pos = position_buffer[i]

        love.graphics.draw(img, pos.x - minX, pos.y - minY)
    end

    love.graphics.setCanvas()

    return canvas
end