SpriteRenderer = Module:extend()

function SpriteRenderer:init()
    self.path = "common/textures/missing-texture.png"
    self.size = vec(4, 4)
    self.origin = vec(2, 2)
    self.static = false
    self.z_index = 0
end

function SpriteRenderer:onLoad()
    if self.__dirty then
        self.image = self.__dirty_image
        self.__dirty = false
    else
        self.image = love.graphics.newImage(self.path)
    end
end

function SpriteRenderer:onUpdate()
    self:applyDirty()
end

function SpriteRenderer:setDirty(image)
    self.__dirty = true
    self.__dirty_image = image
end

function SpriteRenderer:applyDirty()
    if self.__dirty then
        self.image = self.__dirty_image
        self.__dirty = false
    end
end

function SpriteRenderer:fromData(data)
    self.path = data.path
    self.size = data.size
    self.origin = data.origin
    self.static = data.static
end

function SpriteRenderer:toString()
    return "SpriteRenderer"
end

return SpriteRenderer
