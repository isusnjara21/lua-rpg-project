Scene = Object:extend()

function Scene:init()
    self.nodes = {}
    self.initial_camera_position = vec(0, 0)
    self:create()

    self:load()
end

function Scene:create()
end

function Scene:putNode(node)
    Generic.assertType(node, Node)
    table.insert(self.nodes, node)
end

function Scene:load()
    for node, mod in self:activeModule_iterator() do
        mod:onLoad() 
    end
end

function Scene:update(dt)
    for node, mod in self:activeModule_iterator() do
        mod:onUpdate(dt)
    end
end

function Scene:fixedUpdate()
    for node, mod in self:activeModule_iterator() do
        mod:onFixedUpdate(app.fixedDeltaTime)
    end
end

function Scene:lateUpdate(dt)
    for node, mod in self:activeModule_iterator() do
        mod:onLateUpdate(dt)
    end
end

function Scene:activeNode_iterator()
    local index = #self.nodes + 1
    return function()
        index = index - 1
        if index >= 1 then
            return self.nodes[index]
        end
    end
end

function Scene:activeModule_iterator()
    local node_iter = self:activeNode_iterator()
    local current_node = nil
    local modules = nil
    local mod_keys = nil
    local mod_index = 0

    return function()
        repeat
            if not modules then
                current_node = node_iter()
                if not current_node then
                    return
                end
                modules = current_node:getModules()
                mod_keys = {}
                for k in pairs(modules) do
                    table.insert(mod_keys, k)
                end
                mod_index = 1
            end

            local key = mod_keys[mod_index]
            mod_index = mod_index + 1

            if key then
                return current_node, modules[key]
            else
                modules = nil
            end
        until false
    end
end
