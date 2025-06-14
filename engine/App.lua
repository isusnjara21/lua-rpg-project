require "engine.Controller"
require "engine.Renderer"
require "engine.Node"
require "engine.Scene"
require "engine.Module"
require "engine.Time"

App = Object:extend()

function App:init()
    self:global()
end

function App:load()
    self.RENDERER = Renderer()
    self.CONTROLLER = Controller()
    self.TIME = Time()
    self.IMAGE = Image()
    self.ACTIVE_SCENE = {}

    self:change_scene(self.ref.scenes.test2)

    self.__dt_accumulator = 0
end

function App:update(deltaTime)
    self.TIME:__set(deltaTime)

    Logger.log(love.timer.getFPS())

    self.CONTROLLER:update()

    -- FIXED UPDATES
    self.__dt_accumulator = self.__dt_accumulator + self.TIME:get_raw() -- idk about this, 
    while self.__dt_accumulator >= self.TIME.fixedDeltaTime do
        self.ACTIVE_SCENE:fixedUpdate(self.TIME.fixedDeltaTime)
        self.__dt_accumulator = self.__dt_accumulator - self.TIME.fixedDeltaTime
    end

    -- NORMAL UPDATES
    self.ACTIVE_SCENE:update(self.TIME:get())

    -- LATE UPDATES
    self.ACTIVE_SCENE:lateUpdate(self.TIME:get())
end

function App:draw()
    --[[
    need to create dynamic buffer for renderer instead of pushing and popping entire buffer
    so that each frame every object can declare its intent to be drawn (should be handled by hidden rn but for culling later)

    should be fine by making a game side script for automatic position checking for putting things to hidden for culling,
    but a dynamic buffer should be more performant (except maybe it needing to sort again each frame??)
    --]]
    self.RENDERER:draw_call()
end

function App:input_press(key)
    self.CONTROLLER:press_key(key)
end

function App:input_release(key)
    self.CONTROLLER:release_key(key)
end

function App:change_scene(__scene)
    self.RENDERER:pop()
    self.ACTIVE_SCENE = __scene()

    app.camera.Transform.position:set(self.ACTIVE_SCENE.initial_camera_position.x, self.ACTIVE_SCENE.initial_camera_position.y, self.ACTIVE_SCENE.initial_camera_position.z)
    app.camera.Transform.rotation = 0

    -- NORMAL SPRITES
    --[[ -- no longer needed as Node handles itself on load
    for node in self.ACTIVE_SCENE:activeNode_iterator() do
        if node:getModules().SpriteRenderer then
            self.RENDERER:push(node)
        end
    end
    --]]
end
