loader = Module:extend()

function loader:onUpdate()
end

function loader:onInput(input)
    if input == 'w' then
        app:change_scene(app.ref.scenes.test)
    end
end

function loader:toString()
    return "loader"
end

return loader