Canvas = Module:extend()

function Canvas:init()

    self.z_index = 99
end

function Canvas:toString()
    return "ui_Canvas"
end

return Canvas