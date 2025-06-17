test = Module:extend()

function test:init()
    self.moveVec = vec(0, 0)
    self.rotate = 0
    self.speed = 300
    self.rot_speed = 15
end

function test:onLoad()
end

function test:onUpdate(dt)
    --Logger.log(app.ACTIVE_SCENE.nodes[1].SpriteRenderer)
    self.moveVec:normalize()
    self.moveVec:rotate(self.node.Transform.rotation)
    self.node.Transform:translate(self.moveVec.x * dt * self.speed, self.moveVec.y * dt * self.speed)
    self.node.Transform:rotateDeg(-self.rotate * dt * self.rot_speed)
    self.moveVec.x = 0
    self.moveVec.y = 0
    self.rotate = 0

    Logger.log(self.node.position)
    Logger.log(app.TIME:get())
end

function test:onEnterCollision(collider)
    self.node.modules.Collider.debug_color = {0, 1, 0}
    collider.debug_color = {0, 0, 1}
end

function test:onExitCollision(collider)
    self.node.modules.Collider.debug_color = {1, 1, 0}
    collider.debug_color = {1, 1, 0}
end

function test:onCollision(collider)
    Logger.log(collider)
end

function test:onInput(event)
    if event == "w" then
        self.moveVec = self.moveVec + vec.UP
    elseif event == "a" then
        self.moveVec = self.moveVec + vec.LEFT
    elseif event == "s" then
        self.moveVec = self.moveVec + vec.DOWN
    elseif event == "d" then
        self.moveVec = self.moveVec + vec.RIGHT
    elseif event == "q" then
        self.rotate = self.rotate + 10
    elseif event == "e" then
        self.rotate = self.rotate - 10
    elseif event == "r" then
        app:change_scene(app.ref.scenes.test)
    elseif event == "k" then
        app.ACTIVE_SCENE:unloadNode(app.ACTIVE_SCENE.nodes[1])
    elseif event == "j" then
        app.ACTIVE_SCENE.nodes[1]:load()
    end
end

function test:toString()
    return "test"
end

return test
