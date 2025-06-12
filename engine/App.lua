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

    for node, mod in app:activeModule_iterator() do
        mod:onLoad()
    end
end

function App:update(dt)
    Logger.log(love.timer.getFPS())

    self.CONTROLLER:update()

    -- FIXED UPDATES
    self.__dt_accumulator = self.__dt_accumulator + dt
    while self.__dt_accumulator >= self.fixedDeltaTime do
        for node, mod in app:activeModule_iterator() do
            mod:onFixedUpdate(self.fixedDeltaTime)
        end
        self.__dt_accumulator = self.__dt_accumulator - self.fixedDeltaTime
    end

    -- NORMAL UPDATES
    for node, mod in app:activeModule_iterator() do
        mod:onUpdate(dt)
    end

    -- LATE UPDATES
    for node, mod in app:activeModule_iterator() do
        mod:onLateUpdate(dt)
    end
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

    for node, mod in app:activeModule_iterator() do
        mod:onLoad() 
    end

    -- NORMAL SPRITES
    for node in app:activeNode_iterator() do
        if node:getModules().SpriteRenderer then
            self.RENDERER:push(node)
        end
    end
end

function App:activeNode_iterator()
    local index = #self.ACTIVE_SCENE.nodes + 1
    return function()
        index = index - 1
        if index >= 1 then
            return self.ACTIVE_SCENE.nodes[index]
        end
    end
end

function App:activeModule_iterator()
    local node_iter = self:activeNode_iterator()
    local current_node = nil
    local modules = nil
    local mod_keys = nil
    local mod_index = 0

    return function()
        repeat
            if not modules then
                current_node = node_iter()
                if not current_node then
                    return
                end
                modules = current_node:getModules()
                mod_keys = {}
                for k in pairs(modules) do
                    table.insert(mod_keys, k)
                end
                mod_index = 1
            end

            local key = mod_keys[mod_index]
            mod_index = mod_index + 1

            if key then
                return current_node, modules[key]
            else
                modules = nil
            end
        until false
    end
end
