require "engine.Controller"
require "engine.Renderer"
require "engine.Node"
require "engine.Scene"
require "engine.Module"
require "engine.Time"
require "engine.Animator"
require "engine.Collision"
require "lib.struct.model.AnimationFactory"
require "lib.struct.model.SpriteFactory"
require "game.Game"


App = Object:extend()

function App:init()
    self:global()
end

function App:load()
    self.RENDERER = Renderer()
    self.CONTROLLER = Controller()
    self.TIME = Time()
    self.IMAGE = Image()
    self.COLLISION = Collision()
    self.ANIMATOR = Animator()
    self.ACTIVE_SCENE = {}

    self:__load_plugins()

    self:__game_entry()

    self:change_scene(self.ref.scenes.MainScene)

    self.__dt_accumulator = 0
end

function App:update(deltaTime)
    self.TIME:__set(deltaTime)

    Logger.log(self.TIME:get_fps())

    self.global_scale = 1 / self.camera.zoom

    self.CONTROLLER:update()

    self.COLLISION:update()

    self.ANIMATOR:update(self.TIME:get())

    self.ACTIVE_SCENE:checkNodeDependencies()

    -- FIXED UPDATES
    self.__dt_accumulator = self.__dt_accumulator + self.TIME:get_raw() -- idk about this, 
    while self.__dt_accumulator >= self.TIME.fixedDeltaTime do
        self.ACTIVE_SCENE:fixedUpdate(self.TIME.fixedDeltaTime)
        self.ACTIVE_SCENE:lateFixedUpdate(self.TIME.fixedDeltaTime)
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

function App:change_scene(__scene, args)
    self.RENDERER:pop()
    self.ANIMATOR:pop()
    self.COLLISION:pop()
    self.ACTIVE_SCENE = __scene(args)

    app.camera.Transform.position:set(self.ACTIVE_SCENE.initial_camera_position.x, self.ACTIVE_SCENE.initial_camera_position.y)
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

function App:__load_plugins()
    self.plugin = {}
    local files = love.filesystem.getDirectoryItems("lib/plugin")
    for _,file in ipairs(files) do
        if file:match('%.lua$') then
            local pluginName = file:sub(1, -5)
            local requirePath = "lib.plugin." .. pluginName
            self.plugin[pluginName] = require(requirePath)
        end
    end
end

function App:__serialize(module)
    local data = {}
    if obj.__serialize then
        for key, _ in ipairs(obj.__serialize) do
            data[key] = obj[key]
        end
    end
    return data
end

function App:__deserialize(module, data)
    if obj.__serialize then
        for _, key in ipairs(obj.__serialize) do
            if data[key] ~= nil then
                obj[key] = data[key]
            end
        end
    end
end

function App:__game_entry()
    game_entry()

    local config = {}
    game_config(config)

    app.screen = config.virtual_resolution or vec(640, 480)
    app.global_scale = config.scale or 1
    app.game_version = config.version or ''
end