mainScene = Scene:extend()

function mainScene:create()

    app.ref:registerModule('test', "game.testModule")
    app.ref:registerModule('testCam', "game.testCamModule")
    app.ref:registerModule('loader', "game.loaderModule")
    app.ref:registerScene('test', "game.testscene")
    app.ref:createSprite('Player', {
            path = "game/assets/Sprite-0001.png",
            size = vec(16, 16),
            origin = vec(8, 8),
            static = false,
        })
    app.ref:createSprite('Sheet', {
            path = "game/assets/Sprite-0001-Sheet.png",
            size = vec(16, 16),
            origin = vec(8, 8),
            static = true,
        })

    local playerAnimation = AnimationFactory()
                            :size(vec(16,1))
                            :keyframe('sequence1')
                                :frames({1,2,3,4})
                                :timings(1)
                                :looping()
                            :keyframe('sequence2')
                                :frames({16, 8, 4, 2, 1})
                                :timings(1)
                                :looping()
                            :keyframe('sequence3')
                                :frames({5, 6, 7, 8, 10, 11, 12})
                                :timings({1/6, 1/6, 1/6, 1/6, 1, 1, 1})
                            :build()

    app.ref:createAnimations('player', playerAnimation)

        
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