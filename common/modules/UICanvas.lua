UICanvas = Module:extend()

function UICanvas:init()

    self.z_index = 99
end

function UICanvas:toString()
    return "UICanvas"
end

return UICanvas