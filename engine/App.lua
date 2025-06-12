require "engine.Controller"
require "engine.Renderer"
require "engine.Node"
require "engine.Scene"
require "engine.Module"

App = Object:extend()

function App:init()
    self:global()
end

function App:load()
    self.RENDERER = Renderer()
    self.CONTROLLER = Controller()
    self.ACTIVE_SCENE = {}

    self:change_scene(self.ref.scenes["test"])

    self.__dt_accumulator = 0
end

function App:update(dt)
    Logger.log(love.timer.getFPS())

    self.CONTROLLER:update()

    -- FIXED UPDATES
    self.__dt_accumulator = self.__dt_accumulator + dt
    while self.__dt_accumulator >= self.fixedDeltaTime do
        self.ACTIVE_SCENE:fixedUpdate()
        self.__dt_accumulator = self.__dt_accumulator - self.fixedDeltaTime
    end

    -- NORMAL UPDATES
    self.ACTIVE_SCENE:update(dt)

    -- LATE UPDATES
    self.ACTIVE_SCENE:lateUpdate(dt)
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
    for node in self.ACTIVE_SCENE:activeNode_iterator() do
        if node:getModules().SpriteRenderer then
            self.RENDERER:push(node)
        end
    end
end


