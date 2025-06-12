Controller = Object:extend()

function Controller:init()
    self.pressed_keys = {}
end

function Controller:press_key(key)
    self.pressed_keys[key] = true
end

function Controller:release_key(key)
    self.pressed_keys[key] = nil
end

function Controller:update()
    
    Logger.log(self.pressed_keys)

    for _, node in ipairs(app.ACTIVE_SCENE.nodes) do
        for _, mod in pairs(node:getModules()) do
            for key, _ in pairs(self.pressed_keys) do
                mod:onInput(key)
            end
        end
    end
end
