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
    if self.scanned then
        self.moveVec = vec(0, 0)
        self.scanned = nil
    end
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
    Logger.log(collider.tag)
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
    elseif event == "c" then
        local obb = {
            type = "obb",
            offset = vec(0, 0),
            collider_data = {
                size = vec(16, 16)
            },
            layer = "empty2",
            mask = {empty2 = true},
            tag = {}
        }
        obb.getShape = function()
            return {
                center = self.node.Transform.position,
                size = vec(16, 16),
                rotation = 0
            }
        end

        local hit = app.COLLISION:cast(obb, vec.DOWN, 10, 1)
        if #hit > 0 then
            Logger.log(hit[1])
            self.scanned = true
        else
            self.scanned = nil
        end
    end
end

function test:toString()
    return "test"
end

return test
