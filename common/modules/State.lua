--[[
    State module
    Used for handling changing images/frames of a sheet depending on arbitrary values for ui_Image and SpriteRenderer

    differs from AnimationState
    stores a set of values to correspond to a specific frame.
    can be given a generalized rule for deciding.
--]]

State = Module:extend()

function State:init()
end

function State:toString()
    return "State"
end

return State