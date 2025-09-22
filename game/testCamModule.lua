testCamera = Module:extend()

function testCamera:onLateUpdate(dt)
    Logger.log("camera")
    Logger.log(app.camera.Transform.position)
    if gameNode and gameNode.modules.Transform then
        local x = gameNode.modules.Transform.position.x
        local y = gameNode.modules.Transform.position.y
        local lerpVec = util.lerp(app.camera.Transform.position, vec(x, y), 0.01)
        app.camera.Transform.position:set(lerpVec.x, lerpVec.y)

        local r = self.node.modules.Transform.rotation
        app.camera.Transform.rotation = r
    end
end

function testCamera:toString()
    return "testCam"
end

return testCamera