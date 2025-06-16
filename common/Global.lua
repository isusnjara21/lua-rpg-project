require "common.AssetReference"

function App:global()
    self.__VERSION = "0.0.1"
    self.__RUNTIME = "release"

    self.ref = asset_ref()

    -- zoom
    self.global_scale = 1

    self.mouse = vec(0, 0)

    self.screen = vec(640, 480)

    self.camera = {
        Transform = self.ref.modules.Transform()
    }
end

app = App()
