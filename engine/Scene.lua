Scene = Object:extend()

function Scene:init(...)
    self.nodes = {}
    self.initial_camera_position = vec(0, 0)
    self:_create(...)
    self:create(...)
    self:load()
end

function Scene:_create(...)
end

function Scene:create(...)
end

function Scene:putNode(node)
    Generic.assertType(node, Node)
    if node.parent ~= nil then
        error("Can only putNode with root Nodes that dont have a parent")
    end
    table.insert(self.nodes, node)
end

function Scene:putNodes(nodes)
    for _, node in ipairs(nodes) do
        self:putNode(node)
    end
end

function Scene:load()
    for node in self:activeNode_iterator() do
        gameNode = node
        node:load(dt)
    end
    gameNode = {}
end

function Scene:unloadNode(node, arg)
    arg = arg or {}
    node:unload(arg)

    if arg.full and not arg.deep then
        self:putNodes(children)
    end

    return node
end

function Scene:update(dt)
    for node in self:activeNode_iterator() do
        gameNode = node
        node:update(dt)
    end
    gameNode = {}
end

function Scene:fixedUpdate(dt)
    for node in self:activeNode_iterator() do
        gameNode = node
        node:fixedUpdate(dt)
    end
    gameNode = {}
end

function Scene:lateUpdate(dt)
    for node in self:activeNode_iterator() do
        gameNode = node
        node:lateUpdate(dt)
    end
    gameNode = {}
end

function Scene:checkNodeDependencies()
    for node in self:activeNode_iterator() do
        node:checkRequirement()
    end
end

-- targets are nodes
function Scene:dispatch(targets, method, args)
    for _, node in pairs(targets) do
        gameNode = node
        for _, module in pairs(node.modules) do
            if module[method] then
                module[method](module, unpack(args))
            end
        end
    end
    gameNode = {}
end

function Scene:getAllNodes()
    local nodes = {}
    for node in self:activeNode_iterator() do
        table.insert(nodes, node)
    end
    return nodes
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
