TileMapBuilder = Module:extend()

function TileMapBuilder:init()
    self.path = ""
    self.data = nil
    self.map = nil
    self.reference = nil
end

function TileMapBuilder:onLoad()
    if not self.node.modules.SpriteRenderer then error("TileMapBuilder requires a SpriteRenderer") end

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

    self.node.modules.SpriteRenderer:setDirty(app.IMAGE:join(self.map, positions))
end

function TileMapBuilder:loadData(path)
    self.data = {
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