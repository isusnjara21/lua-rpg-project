require "lib.class.Object"
require "lib.class.Generic"
require "lib.struct.Vector"
require "lib.struct.Vector3"
require "common.util.HelperFunctions"
require "common.util.Logger"
require "engine.App"
require "engine.Image"
require "common.Global"

function love.load(arg)
    local args = util.__parseArgs(arg)

    if args.debug or args.d then
        print("Running in debug mode...")
        app.__RUNTIME = "debug"
    end

    local window_size = app.screen
    if args.width or args.w then
        window_size.x = args.width or args.w
    end
    if args.height or args.h then
        window_size.y = args.height or args.h
    end
    app.screen:set(window_size.x + 0, window_size.y + 0)

    app.stdout = ''

    app:load()
end

function love.update(dt)
    app.stdout = ''

    app.window:set(love.graphics.getDimensions())
    
    app.mouse:set(love.mouse.getPosition())

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