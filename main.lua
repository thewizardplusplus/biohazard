package.path = "/sdcard/lovegame/vendor/?.lua"

local Size = require("lualife.models.size")
local Point = require("lualife.models.point")
local Field = require("lualife.models.field")
local life = require("lualife.life")

local CELL_SIZE = 20
local FIELD_SIZE = Size:new(20, 15)
local FIELD_OFFSET = Point:new(50, 50)
local FIELD_UPDATE_PERIOD = 0.2

math.randomseed(os.time())

local field = Field:new(FIELD_SIZE)
for y = 0, field.size.height - 1 do
  for x = 0, field.size.width - 1 do
    if math.random() > 0.5 then
      field:set(Point:new(x, y))
    end
  end
end

function love.draw()
  for y = 0, field.size.height - 1 do
    for x = 0, field.size.width - 1 do
      local alive = field:contains(Point:new(x, y))
      if alive then
        local cell_x = CELL_SIZE * x + FIELD_OFFSET.x
        local cell_y = CELL_SIZE * y + FIELD_OFFSET.y

        love.graphics.setColor(0, 0, 1)
        love.graphics.rectangle(
          "fill",
          cell_x,
          cell_y,
          CELL_SIZE,
          CELL_SIZE,
          CELL_SIZE / 4
        )

        love.graphics.setColor(0, 1, 0)
        love.graphics.setLineWidth(2)
        love.graphics.rectangle(
          "line",
          cell_x,
          cell_y,
          CELL_SIZE,
          CELL_SIZE,
          CELL_SIZE / 4
        )
      end
    end
  end
end

local elapsed_time = 0

function love.update(dt)
  elapsed_time = elapsed_time + dt
  if elapsed_time > FIELD_UPDATE_PERIOD then
    field = life.populate(field)
    elapsed_time = 0
  end
end

function love.mousepressed()
  field = Field:new(FIELD_SIZE)
  for y = 0, field.size.height - 1 do
    for x = 0, field.size.width - 1 do
      if math.random() > 0.5 then
        field:set(Point:new(x, y))
      end
    end
  end
end
