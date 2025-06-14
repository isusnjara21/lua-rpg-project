require "common.AssetReference"

function App:global()
    self.__VERSION = "0.0.1"
    self.__RUNTIME = "release"

    self.ref = asset_ref()

    -- Size per pixel
    self.global_scale = 5

    self.mouse = vec(0, 0)

    local w, h = love.graphics.getDimensions()
    self.screen = vec(w, h)

    self.camera = {
        Transform = self.ref.modules.Transform()
    }
end

app = App()
