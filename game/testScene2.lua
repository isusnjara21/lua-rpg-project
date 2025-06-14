testScene2 = Scene:extend()

function testScene2:create()
    local loader = Node()
    loader:setModule(app.ref.modules.loader())

    self:putNode(loader)

    local tilemap = app.ref.nodes.TileMap()
    tilemap.TileMapBuilder:loadData("")
    tilemap.Transform.position:set(10, 10)
    app.ref.dynamic["tileMapTest"] = tilemap

    local PlayerImage = app.IMAGE:load(app.ref.sprites.Player.path)
    app.ref.dynamic["PlayerImage"] = PlayerImage
end

return testScene2