Time = Object:extend()

function Time:init()
    self.time_scale = 1
    self.fixedDeltaTime = 1/60
    self.deltaTime = 0
end

function Time:set(dt)
    self.deltaTime = dt
end

function Time:set_scale(time)
    if time < 0 then self.time_scale = 0 return end
    self.time_scale = time
end

function Time:get()
    return self.deltaTime * self.time_scale
end

function Time:get_raw()
    return self.deltaTime
end

