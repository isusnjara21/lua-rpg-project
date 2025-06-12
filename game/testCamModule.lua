testCamera = Module:extend()

function testCamera:onUpdate(dt)
    if self.node and self.node.modules.Transform then
        local x = self.node.modules.Transform.position.x
        local y = self.node.modules.Transform.position.y
        app.camera.Transform.position:set(x, y, z)

        local r = self.node.modules.Transform.rotation
        app.camera.Transform.rotation = r
    end
end

function testCamera:toString()
    return "testCam"
end

return testCamera