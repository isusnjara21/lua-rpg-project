AnimationFactory = Object:extend()

function AnimationFactory:init()
    self.animation = {
        size = vec(0, 0),
        keyframes = {
            default = ''
        }
    }

    self.currentKeyframe = ''
end

function AnimationFactory:size(vector)
    Generic.assertType(vector, vec)
    self.animation.size = vector

    return self
end

function AnimationFactory:keyframe(name)
    if self.currentKeyframe == '' then
        self.animation.keyframes.default = name
    elseif self.currentKeyframe == name then
        error('Cannot build two same named keyframes within one animation.')
    elseif not (self.animation.keyframes[self.currentKeyframe].frames and self.animation.keyframes[self.currentKeyframe].timings) then
        error('Cannot build new keyframe until previous has atleast Frames and Timings')
    end

    self.currentKeyframe = name
    self.animation.keyframes[name] = {
        looping = false
    }

    return self
end

function AnimationFactory:frames(table)
    if self.currentKeyframe == '' then
        error("Cannot build Frames without a Keyframe for the animation")
    end

    self.animation.keyframes[self.currentKeyframe].frames = table

    return self
end

function AnimationFactory:timings(table)
    if self.currentKeyframe == '' then
        error("Cannot build Timings without a Keyframe for the animation")
    end

    self.animation.keyframes[self.currentKeyframe].timings = table

    return self
end

function AnimationFactory:looping()
    if self.currentKeyframe == '' then
        error("Cannot build Looping without a Keyframe for the animation")
    end

    self.animation.keyframes[self.currentKeyframe].looping = true

    return self
end

function AnimationFactory:after(nextName)
    if self.currentKeyframe == '' then
        error("Cannot build After without a Keyframe for the animation")
    end

    self.animation.keyframes[self.currentKeyframe]._after = nextName

    return self
end

function AnimationFactory:stop()
    if self.currentKeyframe == '' then
        error("Cannot build Stop without a Keyframe for the animation")
    end

    self.animation.keyframes[self.currentKeyframe]._stop = true

    return self
end

function AnimationFactory:defaultKeyframe(name)
    if self.currentKeyframe == '' then
        error("Cannot build Looping without a Keyframe for the animation")
    end

    self.animation.keyframes[self.currentKeyframe].looping = true

    return self
end

function AnimationFactory:build()
    if self.currentKeyframe ~= '' and self.animation.keyframes[self.currentKeyframe].frames and self.animation.keyframes[self.currentKeyframe].timings then
        return self.animation
    end
    error("Unsuccesful build of Animation")
end

-- to be implemented
function AnimationFactory.as(table)
end