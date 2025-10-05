--[[
    AssetReference

    component for registering, creating and organizing a variety of objects
    also listing predefined objects
--]]

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
        
        --RigidBody = require("common.modules.RigidBody"), -- not yet supported
    }

    self.modules.UI = {
        Canvas = require("common.modules.UI.ui_Canvas"),
        Label = require("common.modules.UI.ui_Label"),
        Images = require("common.modules.UI.ui_Image"),
        Button = require("common.modules.UI.ui_Button"),
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

    -- ANIMATIONS -- keyframes
    self.animations = {}

    -- STACKED SPRITES
    self.stacked_sprites = {}

    -- SHARED STATE -- organized, managed and handled by game-side code
    self.dynamic = {}
end


-- endpoints

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

function asset_ref:createAnimations(_anim, _animTable)
    self.animations[_anim] = _animTable
end

function asset_ref:createStackedSprite(_stackedSprite, _spriteTable)
    self.stacked_sprites[_stackedSprite] = _spriteTable
end