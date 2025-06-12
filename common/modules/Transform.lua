Transform = Module:extend()

function Transform:init()
    self.position = vec(0, 0)
    self.rotation = 0
    self.scale = vec(1, 1)
end

function Transform:translate(x, y)
    local lx = x or 0
    local ly = y or 0
    Generic.assertType(lx, "number")
    Generic.assertType(ly, "number")

    self.position.x = self.position.x + lx
    self.position.y = self.position.y + ly
end

function Transform:rotateRad(rad)
    local lrad = rad or 0
    Generic.assertType(lrad, "number")

    self.rotation = self.rotation + lrad
end

function Transform:rotateDeg(deg)
    local ldeg = deg or 0
    Generic.assertType(ldeg, "number")

    self.rotation = self.rotation + (ldeg * (math.pi / 180))
end

function Transform:setRotation(rad)
    Generic.assertType(rad, "number")

    self.rotation = rad
end

function Transform:scale(x, y)
    local lx = x or 0
    local ly = y or 0
    Generic.assertType(lx, "number")
    Generic.assertType(ly, "number")

    self.scale.x = self.scale.x + lx
    self.scale.y = self.scale.y + ly
end

--[[
    MANDATORY IMPLEMENTATION!!!!
    Ensures being able to access other modules of a node
    ie. through self.node.Transform to access a nodes transform module
--]]
function Transform:toString()
    return "Transform"
end

--[[
    also mandatory for creating references,
    ensures that a constructor is given to the reference instead of a singleton
--]]
return Transform