asset_ref = Object:extend()

function asset_ref:init()
    self:create_references()
end

function asset_ref:create_references()
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

    -- SPRITES
    self.sprites = {
        Player = {
            path = "game/assets/Sprite-0001.png",
            frame_size = vec(16, 16),
            frame_origin = vec(8, 8),
            static = true,
            size = vec(1, 1)
        },
        Floor1 = {
            path = "game/assets/floor1.png",
            frame_size = vec(8, 8),
            frame_origin = vec(4, 4),
            static = false,
            size = vec(1, 1)
        }
    }

    -- STACKED SPRITES
    self.stacked_sprites = {}

    -- SHARED STATE -- organized, managed and handled by game-side code
    self.dynamic = {}
end
