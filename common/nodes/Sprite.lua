function SpriteNode()
    local obj = Node()
    obj:setModule(app.ref.modules.Transform())
    obj:setModule(app.ref.modules.SpriteRenderer())
    return obj
end

return SpriteNode