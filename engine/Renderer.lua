Renderer = Object:extend()
function Renderer:init()
    self.DRAWABLE_OBJECTS = {}

    self.compare = function(a, b) return a.modules.SpriteRenderer.z_index < b.modules.SpriteRenderer.z_index end

    love.graphics.setDefaultFilter("nearest")
end

function Renderer:draw_call()
    for _, node in pairs(self.DRAWABLE_OBJECTS) do
        if node.modules.SpriteRenderer and node.modules.Transform and not node.hidden then
            local worldPosition = node.modules.Transform.position
            local camPosition = app.camera.Transform.position
            local camOffset = app.screen / vec(2, 2)
            local camRotation = app.camera.Transform.rotation
            camOffset:rotate(camRotation)
            camPosition = camPosition - camOffset

            local position = util.WorldToScreen(worldPosition, camPosition, camRotation)

            local worldRotation = node.modules.Transform.rotation
            local screenRotation = worldRotation - camRotation
            
            if node.modules.SpriteRenderer.static then
                screenRotation = 0
            end

            local scale = node.modules.Transform.scale

            love.graphics.draw(
                node.modules.SpriteRenderer.image,
                position.x,
                position.y,
                screenRotation,
                scale.x * app.global_scale,
                scale.y * app.global_scale,
                node.modules.SpriteRenderer.frame_origin.x,
                node.modules.SpriteRenderer.frame_origin.y
            )
        end
    end
end

function Renderer:push(obj)
    table.insert(self.DRAWABLE_OBJECTS, obj)
    table.sort(self.DRAWABLE_OBJECTS, self.compare)
end

function Renderer:pop()
    self.DRAWABLE_OBJECTS = {}
end
