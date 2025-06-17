require "common.AssetReference"

function App:global()
    self.__VERSION = "0.0.1"
    self.__RUNTIME = "release"

    self.ref = asset_ref()

    -- window
    self.global_scale = 1
    self.screen = vec(640, 480)
    self.window = vec(love.graphics.getDimensions())

    -- mouse
    self.mouse = vec(0, 0)

    -- camera
    self.camera = {
        Transform = self.ref.modules.Transform()
    }
end

app = App()
