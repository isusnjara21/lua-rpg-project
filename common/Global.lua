require "common.AssetReference"

function App:global()
    self.__VERSION = "0.0.1"

    self.ref = asset_ref()
    self.global_scale = 5

    self.TIME = Time()
    self.IMAGE = Image()

    local w, h = love.graphics.getDimensions()
    self.screen = vec(w, h)

    self.camera = {
        Transform = self.ref.modules.Transform()
    }
end

app = App()
