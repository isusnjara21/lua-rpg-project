--[[
--]]

TileMapBuilder = Module:extend()

function TileMapBuilder:init()
    self.path = ""
    self.data = {}
    self.map = {}
    self.reference = {}
end

function TileMapBuilder:onLoad()
    self.node:requires(app.ref.modules.Transform)
    self.node:requires(app.ref.modules.SpriteRenderer)

    self.map = {}
    self.reference = {}

    for y, row in ipairs(self.data) do
        self.reference[y] = {}
        for x, ref in ipairs(row) do
            self.reference[y][x] = ref

            local sprite =
                app.ref.sprites[ref] or
                {path = "common/textures/missing-texture.png", size = vec(4, 4), origin = vec(2, 2), static = false}

            local image = love.graphics.newImage(sprite.path)
            table.insert(self.map, image)
        end
    end

    local positions = {}
    local tileSize = self.map[1]:getWidth()

    for y, row in ipairs(self.reference) do
        for x, _ in ipairs(row) do
            table.insert(positions, vec((x - 1) * tileSize, (y - 1) * tileSize))
        end
    end
    local dirty = app.IMAGE:join(self.map, positions)
    self.node.modules.SpriteRenderer:setDirty(dirty)
    self.node.modules.SpriteRenderer.size = vec(dirty:getWidth(), dirty:getHeight())
end

function TileMapBuilder:loadData(path)
    self.data = { -- DOESNT WORK WIP
        {
            "Player",
            "Player",
            "Player"
        },
        {
            "Player",
            "Player",
            "Player"
        },
        {
            "Player",
            "Player",
            "Player"
        }
    }
end

function TileMapBuilder:toString()
    return "TileMapBuilder"
end

return TileMapBuilder