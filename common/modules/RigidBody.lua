--[[
    WIP
    might not be implemented depending on what i can do with the current collision/transform implementations
--]]

RigidBody = Module:extend()

function RigidBody:init()
end

function RigidBody:onLoad()
    self.node:requires(app.ref.modules.Transform)
    self.node:requires(app.ref.modules.Collider)
end

function RigidBody:toString()
    return "RigidBody"
end

return RigidBody