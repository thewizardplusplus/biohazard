package.path = "/sdcard/lovegame/vendor/?.lua"

local Size = require("lualife.models.size")
local Point = require("lualife.models.point")
local Field = require("lualife.models.field")
local life = require("lualife.life")
local random = require("lualife.random")

local CELL_RADIUS_FACTOR = 0.25
local CELL_BORDER_FACTOR = 0.1
local FIELD_HEIGHT = 10
local FIELD_FILLING = 0.5
local FIELD_UPDATE_PERIOD = 0.2

local cell_size = 0
local cell_radius = 0
local cell_border = 0
local field_size = Size:new(0, 0)
local field_offset = Point:new(0, 0)
local field = Field:new(field_size)
local elapsed_time = 0

function love.load()
  math.randomseed(os.time())
  love.graphics.setBackgroundColor(0.5, 0.5, 0.5)

  local ok = love.window.setFullscreen(true)
  assert(ok, "unable to enter fullscreen")

  local x, y, width, height = love.window.getSafeArea()
  cell_size = height / (FIELD_HEIGHT + 1)
  cell_radius = CELL_RADIUS_FACTOR * cell_size
  cell_border = CELL_BORDER_FACTOR * cell_size
  field_size = Size:new(math.floor(width / cell_size) - 1, FIELD_HEIGHT)
  field_offset = Point
    :new(x, y)
    :translate(Point:new(cell_size, cell_size):scale(0.5))
    :translate(Point:new(width % cell_size, 0):scale(0.5))
  field = random.generate(field_size, FIELD_FILLING)
end

function love.draw()
  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle(
    "fill",
    field_offset.x,
    field_offset.y,
    cell_size * field.size.width,
    cell_size * field.size.height
  )

  field:map(function(point, contains)
    if not contains then
      return
    end

    local cell_point = point
      :scale(cell_size)
      :translate(field_offset)

    love.graphics.setColor(0, 0, 1)
    love.graphics.rectangle(
      "fill",
      cell_point.x,
      cell_point.y,
      cell_size,
      cell_size,
      cell_radius
    )
  end)
end

function love.update(dt)
  elapsed_time = elapsed_time + dt
  if elapsed_time > FIELD_UPDATE_PERIOD then
    field = life.populate(field)
    elapsed_time = 0
  end
end

function love.mousepressed()
  field = random.generate(field_size, FIELD_FILLING)
end
