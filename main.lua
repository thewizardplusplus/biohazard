package.path = "/sdcard/lovegame/vendor/?.lua;./vendor/?.lua"

local Size = require("lualife.models.size")
local Point = require("lualife.models.point")
local Field = require("lualife.models.field")
local random = require("lualife.random")
local life = require("lualife.life")

local CELL_RADIUS_FACTOR = 0.25
local FIELD_SIZE = Size:new(10, 10)
local FIELD_FILLING = 0.5
local FIELD_UPDATE_PERIOD = 0.2

local cell_size = 0
local cell_radius = 0
local field_offset = Point:new(0, 0)
local field = Field:new(FIELD_SIZE)
local elapsed_time = 0

function love.load()
  math.randomseed(os.time())
  love.graphics.setBackgroundColor(0.5, 0.5, 0.5)

  local ok = love.window.setFullscreen(true)
  assert(ok, "unable to enter fullscreen")

  local x, y, width, height = love.window.getSafeArea()
  cell_size = height / (FIELD_SIZE.height + 1)
  cell_radius = CELL_RADIUS_FACTOR * cell_size
  field_offset = Point
    :new(x, y)
    :translate(Point:new(
      (width - cell_size * FIELD_SIZE.width) / 2,
      cell_size / 2
    ))
  field = random.generate(FIELD_SIZE, FIELD_FILLING)
end

function love.draw()
  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle(
    "fill",
    field_offset.x,
    field_offset.y,
    cell_size * FIELD_SIZE.width,
    cell_size * FIELD_SIZE.height
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
  field = random.generate(FIELD_SIZE, FIELD_FILLING)
end
