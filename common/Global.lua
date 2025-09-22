require "common.AssetReference"

function App:global()
    self.__VERSION = "0.0.2"
    self.__RUNTIME = "release"

    self.ref = asset_ref()
    
    -- not necessarily used, just a cool feature to include outside bits of code for now, and is able to be hot reloaded kind of
    -- will be used for enabling services in the future
    self.plugin = {}

    -- window
    self.global_scale = 1
    self.screen = vec(640, 480)
    self.window = vec(love.graphics.getDimensions())

    -- mouse
    self.mouse = vec(0, 0)

    -- camera
    self.camera = {
        Transform = self.ref.modules.Transform(),
        zoom = 1
    }
end

app = App()


-- global node reference

gameNode = {}