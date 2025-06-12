function TileMapNode()
    local obj = app.ref.nodes.Sprite()

    obj.map = {}
    obj.tile_ref = {}

    function obj:loadMap()
    end

    function obj:reference()
    end

    function obj:create()
    end



    return obj
end

return TileMapNode