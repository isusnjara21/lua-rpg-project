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

    app.ref:createAnimations('player', {
            size = vec(16, 1),
            keyframes = {
                    default = 'sequence1',
                    sequence1 = {
                        looping = true,
                        timings = 1,
                        frames = {1, 2, 3, 4},
                        --_after = 'sequence2'
                    },
                    sequence2 = {
                        looping = true,
                        timings = 1,
                        frames = {16, 8, 4, 2, 1},
                        --_after = 'sequence3'
                    },
                    sequence3 = {
                        looping = false,
                        timings = {1/6, 1/6, 1/6, 1/6, 1, 1, 1},
                        frames = {5, 6, 7, 8, 10, 11, 12},
                        --_after = 'sequence1' -- will default to 'default' if not defined, happens if no looping
                        -- _stop = true -- will check for this if not looping, will freeze the animation at last frame until sequence changes
                    }
            } 
        })

        
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