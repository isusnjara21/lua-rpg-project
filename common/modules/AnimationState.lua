--[[
    AnimationState module
    Used for handling the changing of animation sequences based on in-game state values.
    
    stores a set of variables to interface with for changing game-states,
    is supplied lambda functions for checking when animation state should change.
--]]

AnimationState = Module:extend()

function AnimationState:init()
    self.currentState = nil
    self.states = {}

    self.variable = {}
end

-- lambda(node, currentState)

function AnimationState:setState(name, animation, lambda, flags)
    local state = {
        animation = animation,
        lambda = lambda,
        name = name,
        flags = flags or nil
    }
    table.insert(self.states, state)
end

function AnimationState:createVariable(variable)
    self.variable[variable] = 0
end

function AnimationState:setVariable(variable, value)
    self.variable[variable] = value
end

function AnimationState:onLoad()
    self.node:requires(app.ref.modules.Animation)
end

function AnimationState:onUpdate(deltaTime)
    Logger.log(self.currentState)
    for _, state in ipairs(self.states) do
        if self.currentState ~= state and state.lambda(self.node, self.currentState) then
            self.currentState = state
            self.node.modules.Animation:updateAnimation(self.currentState.animation)
        end
    end
end

function AnimationState:toString()
    return "AnimationState"
end

return AnimationState