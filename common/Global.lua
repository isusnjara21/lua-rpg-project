require "common.AssetReference"

function App:global()
    self.__VERSION = "0.0.1"

    self.ref = asset_ref()
    self.fixedDeltaTime = 1/60
    self.global_scale = 5

    local w, h = love.graphics.getDimensions()
    self.screen = vec(w, h)

    self.camera = {
        Transform = self.ref.modules.Transform()
    }
end

app = App()
