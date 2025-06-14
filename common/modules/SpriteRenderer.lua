SpriteRenderer = Module:extend()

function SpriteRenderer:init()
    self.path = "common/textures/missing-texture.png"

    self.frame_size = vec(4, 4)
    self.frame_origin = vec(2, 2)

    self.size = vec(1, 1)

    self.static = false
    --self.animated = false --testing

    self.z_index = 0

    self.frame = 1
end

function SpriteRenderer:onLoad()
    if self.__use_image_override then
        self.image = self.__dirty_image or love.graphics.newImage("common/textures/missing-texture.png")
        self.frames = {self.image}
        return
    end

    if self.__dirty then
        self.image = self.__dirty_image
        self.__dirty = false
    else
        self.frames = self:sheetToFrames() or {love.graphics.newImage("common/textures/missing-texture.png")}
        self.image = self.frames[self.frame]
    end
end

function SpriteRenderer:onUpdate()
    if not self:applyDirty() and self.__frame_update then
        self:updateFrame()
        self.__frame_update = false
    end
end

function SpriteRenderer:updateFrame()
    self.image = self.frames[self.frame]
    self.__frame_update = true
end

function SpriteRenderer:sheetToFrames()
    local sheet = app.IMAGE:load(self.path)
    local frames = app.IMAGE:split(sheet, self.frame_size, self.size)
    return frames
end

function SpriteRenderer:setDirty(image, arg)
    arg = arg or {}
    if arg.override then
        self.__use_image_override = true
    elseif not arg.override and self.__use_image_override then
        self.__use_image_override = false
    end

    self.__dirty = true
    self.__dirty_image = image
end

function SpriteRenderer:applyDirty()
    if self.__dirty then
        self.image = self.__dirty_image
        self.__dirty = false
        self.__frame_update = false -- will block out frame updates when applying dirty to stop overriding (WIP)
        return true
    end
    return false
end

function SpriteRenderer:fromData(data)
    self.path = data.path
    self.frame_size = data.frame_size
    self.frame_origin = data.frame_origin
    self.static = data.static
    self.size = data.size
end

function SpriteRenderer:toString()
    return "SpriteRenderer"
end

return SpriteRenderer
