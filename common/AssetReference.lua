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

        test = require("game.testModule"),
        testCam = require("game.testCamModule"),
    }

    -- NODES
    self.nodes = {
        Sprite = require("common.nodes.Sprite"),
    }

    -- SCENES -- WIP
    self.scenes = {
        test = require("game.testScene")
    }

    -- SPRITES
    self.sprites = {
        Player = {
            path = "game/assets/Sprite-0001.png",
            size = vec(16, 16),
            origin = vec(8, 8),
            static = true
        },
    }

    -- STACKED SPRITES
    self.stacked_sprites = {}
end
