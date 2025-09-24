SpriteFactory = Object:extend()

function SpriteFactory:init()
    self.sprite = {
        size = vec(0, 0),
        origin = vec(0, 0),
        static = false
    }
end

function SpriteFactory:path(path)
    self.sprite.path = path
    return self
end

function SpriteFactory:size(vector)
    Generic.assertType(vector, vec)
    self.sprite.size = vector
    return self
end

function SpriteFactory:origin(vector)
    Generic.assertType(vector, vec)
    self.sprite.origin = vector
    return self
end

function SpriteFactory:static()
    self.sprite.static = true
    return self
end

function SpriteFactory:build()
    return self.sprite
end

function SpriteFactory.as(table)
end