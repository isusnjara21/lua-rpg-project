require "lib.class.Object"
require "lib.class.Generic"
require "lib.struct.Vector"
require "lib.struct.Vector3"
require "common.util.HelperFunctions"
require "common.util.Logger"
require "engine.App"
require "engine.Image"
require "common.Global"

function love.run()
	if love.load then love.load(love.arg.parseGameArguments(arg), arg) end

	if love.timer then love.timer.step() end

	local dt = 0

	return function()
		if love.event then
			love.event.pump()
			for name, a,b,c,d,e,f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() then
						return a or 0
					end
				end
				love.handlers[name](a,b,c,d,e,f)
			end
		end
        
		if love.timer then dt = love.timer.step() end

		if love.update then love.update(dt) end

		if love.graphics and love.graphics.isActive() then
			love.graphics.origin()
			love.graphics.clear(love.graphics.getBackgroundColor())

			if love.draw then love.draw() end

			love.graphics.present()
		end

		if love.timer then love.timer.sleep(0.001) end
	end
end

function love.load(arg)
    local args = util.__parseArgs(arg)

    if args.debug or args.d then
        print("Running in debug mode...")
        app.__RUNTIME = "debug"
    end

    if args.editor or args.e then
        print("Booting up editor...")
        app.ref.scenes.MainScene = require('editor.editorScene')
        app.screen = vec(1920, 1080)
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
    app.clsout = ''

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