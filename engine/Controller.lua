Controller = Object:extend()

function Controller:init()
    self.pressed_keys = {}
end

function Controller:press_key(key)
    self.pressed_keys[key] = true

    for node, mod in app.ACTIVE_SCENE:activeModule_iterator() do
        mod:onKeyDown(key)
    end
end

function Controller:release_key(key)
    self.pressed_keys[key] = nil

    for node, mod in app.ACTIVE_SCENE:activeModule_iterator() do
        mod:onKeyUp(key)
    end
end

function Controller:update()
    Logger.log(self.pressed_keys)

    for node, mod in app.ACTIVE_SCENE:activeModule_iterator() do
        for key, _ in pairs(self.pressed_keys) do
            mod:onInput(key)
        end
    end
end
