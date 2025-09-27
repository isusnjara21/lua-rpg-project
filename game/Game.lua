
-- game entry point, will switch to 'mainScene' after running this.
-- use for declaring static assets like scripts(modules)

function game_entry()
    app.ref:registerModule('test', "game.testModule")
    app.ref:registerModule('testCam', "game.testCamModule")
    app.ref:registerModule('loader', "game.loaderModule")
    app.ref:registerScene('test', "game.testScene")
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
end

function game_config(g) -- these are default values
    g.resolution = vec(640,480)
    g.scale = 1
    g.version = ''
end