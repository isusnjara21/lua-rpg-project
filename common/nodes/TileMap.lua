function TileMapNode()
    local obj = app.ref.nodes.Sprite()

    obj.map = {}
    obj.reference = {}

    function obj:loadMap()
    end

    function obj:create()
    end

    return obj
end

return TileMapNode
