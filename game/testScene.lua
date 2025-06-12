testScene = Scene:extend()

function testScene:create()
    local aaa = app.ref.nodes.Sprite()
    aaa.SpriteRenderer:fromData(app.ref.sprites.Player)
    aaa.position:set(300, 300)
    self:putNode(aaa)

    local player = app.ref.nodes.Sprite()

    player.SpriteRenderer:fromData(app.ref.sprites.Player)

    player:setModule(app.ref.modules.test())
    player:setModule(app.ref.modules.testCam())

    player.SpriteRenderer.z_index = 1
    self:putNode(player)

    local empty = Node()
    empty:setModule(app.ref.modules.Transform())
    util.TransformAlias(empty)
    empty:setModule(app.ref.modules.SpriteRenderer())
    empty.SpriteRenderer = empty.modules.SpriteRenderer

    empty.position:set(150, 150)
    empty.scale:set(10, 10)
    empty.Transform:setRotation(2)

    self:putNode(empty)

    local empty2 = Node()
    empty2:setModule(app.ref.modules.Transform())
    util.TransformAlias(empty2)
    empty2:setModule(app.ref.modules.SpriteRenderer())
    empty2.SpriteRenderer = empty2.modules.SpriteRenderer

    empty2.position:set(300, 359)
    empty2.scale:set(10, 10)
    empty2.Transform:setRotation(0.7)

    self:putNode(empty2)

    local tilemap = app.ref.nodes.TileMap()
    tilemap.TileMapBuilder:loadData("")
    tilemap.Transform.position:set(10, 10)

    self:putNode(tilemap)
end

return testScene
