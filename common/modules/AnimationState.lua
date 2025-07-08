AnimationState = Module:extend()

function AnimationState:init()
    self.currentState = nil
    self.states = {}
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

function AnimationState:onLoad()
end

function AnimationState:onUnload()
end

function AnimationState:onDestroy()
end

function AnimationState:onUpdate(deltaTime)
    Logger.log(self.currentState)
    for _, state in ipairs(self.states) do
        if self.currentState ~= state and state.lambda(self.node, self.currentState) then
            self.currentState = state
            self.node.modules.SpriteRenderer:updateAnimation(self.currentState.animation)
        end
    end
end

function AnimationState:onUpdateFrame(animation, frame)
end

function AnimationState:onChangeAnimation(animation)
end

function AnimationState:toString()
    return "AnimationState"
end

return AnimationState