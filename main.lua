require "lib.class.Object"
require "lib.class.Generic"
require "lib.struct.Vector"
require "lib.struct.Vector3"
require "common.util.HelperFunctions"
require "common.util.Logger"
require "engine.App"
require "engine.Image"
require "common.Global"

function love.load()
    app.stdout = ''

    app:load()
end

function love.update(dt)
    app.stdout = ''

    app.mouse:set(love.mouse.getPosition())
    app.screen:set(love.graphics.getDimensions())

    app:update(dt)
end

function love.draw()
    app:draw()

    -- standard output // for debugging purposes
    love.graphics.printf(app.stdout, 1, 1, 500, "left")
end

function love.keypressed(key)
    app:input_press(key)
end

function love.keyreleased(key)
    app:input_release(key)
end

function love.mousepressed()
end

function love.mousereleased()
end