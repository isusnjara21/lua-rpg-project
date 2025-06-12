Node = Object:extend()

function Node:init()
    self.modules = {}
end

function Node:setModule(_module)
    Generic.assertType(_module, Module)
    self.modules[_module:toString()] = _module
    _module.node = self
end

function Node:getModules()
    return self.modules
end
