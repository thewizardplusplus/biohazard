package.path =
  "/sdcard/lovegame/vendor/?.lua;"
  .. "/sdcard/lovegame/vendor/?/init.lua;"
  .. "./vendor/?.lua;"
  .. "./vendor/?/init.lua"

local Size = require("lualife.models.size")
local Point = require("lualife.models.point")
local Field = require("lualife.models.field")
local random = require("lualife.random")
local life = require("lualife.life")
local suit = require("suit")

local CELL_RADIUS_FACTOR = 0.25
local FIELD_SIZE = Size:new(10, 10)
local FIELD_PART_SIZE = Size:new(3, 3)
local FIELD_FILLING = 0.5
local FIELD_PART_FILLING = 0.5
local FIELD_PART_COUNT_MIN = 5
local FIELD_PART_COUNT_MAX = 5
local BUTTON_SIZE_FACTOR = 0.25

local cell_size = 0
local cell_radius = 0
local field_offset = Point:new(0, 0)
local field = Field:new(FIELD_SIZE)
local field_part_offset = Point:new(0, 0)
local field_part = Field:new(FIELD_PART_SIZE)
local button_size = 0
local left_buttons_offset = 0
local right_buttons_offset = 0

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
  field_part = random.generate_with_limits(
    FIELD_PART_SIZE,
    FIELD_PART_FILLING,
    FIELD_PART_COUNT_MIN,
    FIELD_PART_COUNT_MAX
  )
  button_size = BUTTON_SIZE_FACTOR * height
  left_buttons_offset = Point:new(
    x + cell_size / 2,
    y + height - cell_size / 2 - button_size
  )
  right_buttons_offset = Point:new(
    x + width - cell_size / 2 - button_size,
    y + height - 1.5 * cell_size - 1.5 * button_size
  )
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

  field_part:map(function(point, contains)
    if not contains then
      return
    end

    local cell_point = point
      :scale(cell_size)
      :translate(field_offset)
      :translate(field_part_offset:scale(cell_size))

    love.graphics.setColor(0, 0.66, 0)
    love.graphics.rectangle(
      "fill",
      cell_point.x,
      cell_point.y,
      cell_size,
      cell_size,
      cell_radius
    )
  end)

  suit.draw()
end

function love.update()
  suit.Button(
    "<",
    left_buttons_offset.x,
    left_buttons_offset.y,
    button_size / 2,
    button_size
  )
  suit.Button(
    ">",
    left_buttons_offset.x + button_size / 2 + cell_size / 2,
    left_buttons_offset.y,
    button_size / 2,
    button_size
  )

  suit.Button(
    "+",
    right_buttons_offset.x,
    right_buttons_offset.y,
    button_size,
    button_size / 2
  )
  suit.Button(
    "^",
    right_buttons_offset.x,
    right_buttons_offset.y + button_size / 2 + cell_size / 2,
    button_size,
    button_size / 2
  )
  suit.Button(
    "v",
    right_buttons_offset.x,
    right_buttons_offset.y + button_size + cell_size,
    button_size,
    button_size / 2
  )
end
