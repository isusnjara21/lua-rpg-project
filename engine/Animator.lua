Animator = Object:extend()

function Animator:init()
    self.animations = {}
end

function Animator:register(mod)
    local animation = {
        module = mod,
        current = mod.animation.default,
        current_frame = 1,
        dt = 0
    }
    table.insert(self.animations, animation)
end

function Animator:unregister(mod)
    for i = #self.animations, 1, -1 do
        if self.animations[i].module == mod then
            table.remove(self.animations, i)
            break
        end
    end
end

function Animator:update(dt)
    for i = 1, #self.animations do
        local animation = self.animations[i]
        animation.dt = animation.dt + dt
        local currentAnimationTimings =animation.module.animation[animation.current].timings
        if type(currentAnimationTimings) == 'table' then
            if animation.dt >= currentAnimationTimings[animation.current_frame] then
                animation.dt = animation.dt - currentAnimationTimings[animation.current_frame]
                self:nextFrame(animation)
            end
        else
            if animation.dt >= currentAnimationTimings then
                animation.dt = animation.dt - currentAnimationTimings
                self:nextFrame(animation)
            end
        end

    end
end

function Animator:nextFrame(animation)
    local ref = animation.module.animation[animation.current]
    local frameCount = #ref.frames

    if animation.current_frame == frameCount and not ref.looping then
        if ref._stop then return end
        if ref._after then
            animation.current = ref._after
            animation.current_frame = 1
        else
            animation.current = animation.module.animation.default
            animation.current_frame = 1
        end
    elseif animation.current_frame == frameCount and ref.looping then
        animation.current_frame = 1
    else
        animation.current_frame = animation.current_frame + 1
    end
    local next_frame = animation.module.animation[animation.current].frames[animation.current_frame]

    animation.module.frame = next_frame

    animation.module:updateFrame() -- schedules update
end