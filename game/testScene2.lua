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


    local sheet = app.ref.nodes.Sprite()
    sheet.SpriteRenderer:fromData(app.ref.sprites.Sheet)
    sheet.SpriteRenderer.z_index = 2
    app.ref.dynamic["Sheet"] = sheet
end

return testScene2