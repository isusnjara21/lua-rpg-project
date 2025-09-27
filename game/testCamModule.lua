testCamera = Module:extend()

function testCamera:init()
    self.lerpVec = vec(0,0)
end

function testCamera:onUpdate(dt)
    Logger.log("camera")
    Logger.log(app.camera.Transform.position)
end

function testCamera:onLateUpdate(dt)
    if gameNode and gameNode.modules.Transform then
        local x = gameNode.modules.Transform.position.x
        local y = gameNode.modules.Transform.position.y
        self.lerpVec = util.lerp(app.camera.Transform.position, vec(x, y), 6 * dt)
        app.camera.Transform.position:set(self.lerpVec.x, self.lerpVec.y)
        local r = self.node.modules.Transform.rotation
        app.camera.Transform.rotation = r
    end
end

function testCamera:toString()
    return "testCam"
end

return testCamera