Scene = Object:extend()

function Scene:init()
    self.nodes = {}
    self.initial_camera_position = vec(0, 0)
    self:load()
end

function Scene:load()
end

function Scene:putNode(node)
    Generic.assertType(node, Node)
    table.insert(self.nodes, node)
end
