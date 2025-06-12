function TileMapNode()
    local obj = app.ref.nodes.Sprite()
    obj:setModule(app.ref.modules.TileMapBuilder())
    obj.TileMapBuilder = obj.modules.TileMapBuilder
    return obj
end

return TileMapNode
