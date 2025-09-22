Animation = Module:extend()

function Animation:init()
end

function Animation:onLoad()
    self.node:requires(app.ref.modules.Transform)
    self.node:requires(app.ref.modules.SpriteRenderer)
end

function Animation:toString()
    return "Animation"
end

return Animation