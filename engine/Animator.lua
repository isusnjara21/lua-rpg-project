Animator = Object:extend()

function Animator:init()
    self.ANIMATIONS = {}
end

function Animator:register(mod)
    local animation = {
        module = mod,
        current = mod.animations.default,
        current_frame = 1,
        dt = 0
    }
    table.insert(self.ANIMATIONS, animation)
end

function Animator:unregister(mod)
    for i = #self.ANIMATIONS, 1, -1 do
        if self.ANIMATIONS[i].module == mod then
            table.remove(self.ANIMATIONS, i)
            break
        end
    end
end

function Animator:pop()
    self.ANIMATIONS = {}
end

function Animator:update(dt)
    for i = 1, #self.ANIMATIONS do
        local animation = self.ANIMATIONS[i]
        animation.dt = animation.dt + dt
        if animation.__change_anim then
            local animationChange = {animation.current, animation.__change_anim} 

            animation.current = animation.__change_anim
            animation.__change_anim = nil
            animation.current_frame = #animation.module.animations[animation.current].frames
            if not animation.__wait_for_frame then
                animation.dt = 0
                self:nextFrame(animation)
                app.ACTIVE_SCENE:dispatch({animation.module.node}, 'onUpdateFrame', {animation.current, animation.current_frame})
            else
                animation.__wait_for_frame = nil
            end

            app.ACTIVE_SCENE:dispatch({animation.module.node}, 'onChangeAnimation', animationChange)
        end
        local currentAnimationTimings = animation.module.animations[animation.current].timings
        if type(currentAnimationTimings) == 'table' then
            if animation.dt >= currentAnimationTimings[animation.current_frame] then
                animation.dt = animation.dt - currentAnimationTimings[animation.current_frame]
                self:nextFrame(animation)
                app.ACTIVE_SCENE:dispatch({animation.module.node}, 'onUpdateFrame', {animation.current, animation.current_frame})
            end
        else
            if animation.dt >= currentAnimationTimings then
                animation.dt = animation.dt - currentAnimationTimings
                self:nextFrame(animation)
                app.ACTIVE_SCENE:dispatch({animation.module.node}, 'onUpdateFrame', {animation.current, animation.current_frame})
            end
        end
    end
end


function Animator:nextFrame(animation)
    local ref = animation.module.animations[animation.current]
    local frameCount = #ref.frames

    if animation.current_frame == frameCount and not ref.looping then
        if ref._stop then return end
        if ref._after then
            animation.current = ref._after
            animation.current_frame = 1
        else
            animation.current = animation.module.animations.default
            animation.current_frame = 1
        end
    elseif animation.current_frame == frameCount and ref.looping then
        animation.current_frame = 1
    else
        animation.current_frame = animation.current_frame + 1
    end
    local next_frame = animation.module.animations[animation.current].frames[animation.current_frame]

    animation.module.frame = next_frame

    animation.module:updateFrame() -- schedules update
end

function Animator:change_animation(mod, animation, flags)
    local flags = flags or nil
    for i = #self.ANIMATIONS, 1, -1 do
        if self.ANIMATIONS[i].module == mod then
            self.ANIMATIONS[i].__change_anim = animation
            if flags then
                self.ANIMATIONS[i].__wait_for_frame = flags.__on_frame_end or nil
            end
            break
        end
    end
end