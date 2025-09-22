function TileMapNode()
    print("tileMapNode")
    local obj = app.ref.nodes.Sprite()
    obj:setModule(app.ref.modules.TileMapBuilder())
    return obj
end

return TileMapNode
