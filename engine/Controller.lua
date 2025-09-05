Controller = Object:extend()

function Controller:init()
    self.pressed_keys = {}
end

function Controller:press_key(key)
    self.pressed_keys[key] = true

    app.ACTIVE_SCENE:dispatch(app.ACTIVE_SCENE:getAllNodes(), 'onKeyDown', {key})
end

function Controller:release_key(key)
    self.pressed_keys[key] = nil


    app.ACTIVE_SCENE:dispatch(app.ACTIVE_SCENE:getAllNodes(), 'onKeyUp', {key})
end

function Controller:update()
    Logger.log(self.pressed_keys)
    
    for key, _ in pairs(self.pressed_keys) do
        app.ACTIVE_SCENE:dispatch(app.ACTIVE_SCENE:getAllNodes(), 'onInput', {key})
    end
end
