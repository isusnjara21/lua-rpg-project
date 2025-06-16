asset_ref = Object:extend()

function asset_ref:init()
    self:create_references()
end

function asset_ref:create_references()
    --[[ OBJECTS ]]
    -- MODULES
    self.modules = {
        Transform = require("common.modules.Transform"),
        SpriteRenderer = require("common.modules.SpriteRenderer"),
        Collider = require("common.modules.Collider"),
        TileMapBuilder = require("common.modules.TileMapBuilder"),
        test = require("game.testModule"),
        testCam = require("game.testCamModule"),
        loader = require("game.loaderModule")
    }

    -- NODES
    self.nodes = {
        Sprite = require("common.nodes.Sprite"),
        TileMap = require("common.nodes.TileMap")
    }

    -- SCENES -- WIP
    self.scenes = {
        test = require("game.testScene"),
        test2 = require("game.testScene2")
    }

    -- [[ TABLES ]]
    -- SPRITES
    self.sprites = {
        Player = {
            path = "game/assets/Sprite-0001.png",
            frame_size = vec(16, 16),
            frame_origin = vec(8, 8),
            static = false,
            size = vec(1, 1)
        },
        Sheet = {
            path = "game/assets/Sprite-0001-Sheet.png",
            frame_size = vec(16, 16),
            frame_origin = vec(8, 8),
            static = true,
            size = vec(16, 1),
            animation = {
                default = 'sequence1',
                sequence1 = {
                    looping = false,
                    timings = 1/3,
                    frames = {1, 2, 3, 4},
                    _after = 'sequence2'
                },
                sequence2 = {
                    looping = false,
                    timings = 1/12,
                    frames = {16, 8, 4, 2, 1},
                    _after = 'sequence3'
                },
                sequence3 = {
                    looping = false,
                    timings = {1/6, 1/6, 1/6, 1/6, 1, 1, 1},
                    frames = {5, 6, 7, 8, 10, 11, 12},
                    _after = 'sequence1' -- will default to 'default' if not defined, happens if no looping
                    -- _stop = true -- will check for this if not looping, will freeze the animation at last frame until sequence changes
                }
            }, 
        }
    }

    -- STACKED SPRITES
    self.stacked_sprites = {}

    -- SHARED STATE -- organized, managed and handled by game-side code
    self.dynamic = {}
end
