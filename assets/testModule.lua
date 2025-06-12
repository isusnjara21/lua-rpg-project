test = Module:extend()

function test:init()
    self.moveVec = vec(0, 0)
    self.rotate = 0
    self.speed = 300
    self.rot_speed = 0.3
end

function test:onLoad()
end

function test:onUpdate(dt)
    self.moveVec:normalize()
    self.moveVec:rotate(self.node.Transform.rotation)
    self.node.Transform:translate(self.moveVec.x * dt * self.speed, self.moveVec.y * dt * self.speed)
    self.node.Transform:rotateDeg(-self.rotate)
    self.moveVec.x = 0
    self.moveVec.y = 0
    self.rotate = 0

    Logger.log("x = " .. self.node.position.x)
    Logger.log("y = " .. self.node.position.y)
end

function test:onInput(event)
    if event == "w" then
        self.moveVec = self.moveVec + vec.UP()
    elseif event == "a" then
        self.moveVec = self.moveVec + vec.LEFT()
    elseif event == "s" then
        self.moveVec = self.moveVec + vec.DOWN()
    elseif event == "d" then
        self.moveVec = self.moveVec + vec.RIGHT()
    elseif event == "q" then
        self.rotate = self.rotate + self.rot_speed
    elseif event == "e" then
        self.rotate = self.rotate - self.rot_speed
    elseif event == "r" then
        app:change_scene(app.ref.scenes["test"])
    end
end

function test:toString()
    return "test"
end

return test