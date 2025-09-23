Animation = Module:extend()

function Animation:init()
    self.animations = {}

    self.size = vec(1, 1)

    self.frames = {}
    self.frame = 1
end

function Animation:onLoad()
    self.node:requires(app.ref.modules.Transform)
    self.node:requires(app.ref.modules.SpriteRenderer)

    self.frames = self:sheetToFrames() or {love.graphics.newImage("common/textures/missing-texture.png")}

    self.node.modules.SpriteRenderer:setDirty(self.frames[self.frame])

    app.ANIMATOR:register(self)
end

function Animation:onUnload()
    app.ANIMATOR:unregister(self)
end

function Animation:updateAnimation(animation)
    app.ANIMATOR:change_animation(self, animation)
end

function Animation:updateFrame()
    self.node.modules.SpriteRenderer:setDirty(self.frames[self.frame])
end

function Animation:fromData(data)
    self.size = data.size
    self.animations = data.keyframes
end

function Animation:sheetToFrames()
    local sheet = app.IMAGE:load(self.node.modules.SpriteRenderer.path)
    local frames = app.IMAGE:split(sheet, self.node.modules.SpriteRenderer.size, self.size)
    return frames
end

function Animation:toString()
    return "Animation"
end

return Animation