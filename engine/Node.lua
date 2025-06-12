Node = Object:extend()

function Node:init()
    self.modules = {}

    self.children = {}
    self.parent = nil
end

function Node:update(dt)
    for _, module in pairs(self.modules) do
        if module.onUpdate then
            module:onUpdate(dt)
        end
    end

    for _, child in ipairs(self.children) do
        child:update(dt)
    end
end

function Node:fixedUpdate(dt)
    for _, module in pairs(self.modules) do
        if module.onFixedUpdate then
            module:onFixedUpdate(dt)
        end
    end

    for _, child in ipairs(self.children) do
        child:fixedUpdate(dt)
    end
end

function Node:lateUpdate(dt)
    for _, module in pairs(self.modules) do
        if module.onLateUpdate then
            module:onLateUpdate(dt)
        end
    end

    for _, child in ipairs(self.children) do
        child:lateUpdate(dt)
    end
end

function Node:load()
    for _, module in pairs(self.modules) do
        if module.onLoad then
            module:onLoad(dt)
        end
    end

    for _, child in ipairs(self.children) do
        child:load(dt)
    end
end

function Node:setModule(_module)
    Generic.assertType(_module, Module)
    self.modules[_module:toString()] = _module
    _module.node = self
end

function Node:getModules()
    return self.modules
end

function Node:isDescendant(ancestor)
    Generic.assertType(ancestor, Node)
    local node = self
    while node do
        if node == ancestor then return true end
        node = node.parent
    end
    return false
end

function Node:addChild(child)
    Generic.assertType(child, Node)
    if child == self then
        error("A node cannot be its own child!")
    end
    if self:isDescendant(child) then
        error("Circular connection of nodes!")
    end

    table.insert(self.children, child)
    child.parent = self
end

function Node:RemoveChild(child)
    for i, c in ipairs(self.children) do
        if c == child then
            table.remove(self.children, i)
            child.parent = nil
            return
        end
    end
end