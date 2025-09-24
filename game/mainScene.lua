mainScene = Scene:extend()

-- editing the _create function is unsafe as editor will wipe and regenerate it when saving Scenes
function mainScene:_create()   
end

function mainScene:create()
    local loader = Node()
    loader:setModule(app.ref.modules.loader())

    self:putNode(loader)

    local tilemap = app.ref.nodes.TileMap()
    tilemap.TileMapBuilder:loadData("")
    tilemap.Transform.position:set(10, 10)
    app.ref.dynamic["tileMapTest"] = tilemap

    local rawPlayerImage = app.IMAGE:load(app.ref.sprites.Player.path)
    app.ref.dynamic["PlayerImage"] = rawPlayerImage


    local sheet = app.ref.nodes.Sprite()
    sheet.SpriteRenderer:fromData(app.ref.sprites.Sheet)
    sheet.SpriteRenderer.z_index = 2
    sheet:setModule(app.ref.modules.Animation())
    sheet.Animation:fromData(app.ref.animations.player)
    app.ref.dynamic["Sheet"] = sheet
end

return mainScene