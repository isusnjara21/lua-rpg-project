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
        Animation = require("common.modules.Animation"),
        AnimationState = require("common.modules.AnimationState"),
    }

    -- NODES
    self.nodes = {
        Sprite = require("common.nodes.Sprite"),
        TileMap = require("common.nodes.TileMap")
    }

    -- SCENES -- WIP
    self.scenes = {
        MainScene = require("game.mainScene")
    }

    -- [[ TABLES ]]
    -- SPRITES
    self.sprites = {}

    -- STACKED SPRITES
    self.stacked_sprites = {}

    -- SHARED STATE -- organized, managed and handled by game-side code
    self.dynamic = {}
end


function asset_ref:registerScene(_scene, _requirePath)
    self.scenes[_scene] = require(_requirePath)
end

function asset_ref:registerModule(_module, _requirePath)
    self.modules[_module] = require(_requirePath)
end

function asset_ref:registerPrefab(_prefab, _requirePath)
    self.nodes[_prefab] = require(_requirePath)
end

function asset_ref:createSprite(_sprite, _spriteTable)
    self.sprites[_sprite] = _spriteTable
end

function asset_ref:createStackedSprite(_stackedSprite, _spriteTable)
    self.stacked_sprites[_stackedSprite] = _spriteTable
end