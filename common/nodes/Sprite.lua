function SpriteNode()
    local obj = Node()
    obj:setModule(app.ref.modules.Transform())
    util.TransformAlias(obj)
    obj:setModule(app.ref.modules.SpriteRenderer())
    obj.SpriteRenderer = obj.modules.SpriteRenderer
    return obj
end

return SpriteNode