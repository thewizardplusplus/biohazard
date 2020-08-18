package.path =
  "/sdcard/lovegame/vendor/?.lua;"
  .. "/sdcard/lovegame/vendor/?/init.lua;"
  .. "./vendor/?.lua;"
  .. "./vendor/?/init.lua"

local Size = require("lualife.models.size")
local Point = require("lualife.models.point")
local PlacedField = require("lualife.models.placedfield")
local random = require("lualife.random")
local sets = require("lualife.sets")
local matrix = require("lualife.matrix")
local life = require("lualife.life")
local suit = require("suit")
local drawing = require("drawing")

local FIELD_SIZE = Size:new(10, 10)
local FIELD_PART_SIZE = Size:new(3, 3)
local FIELD_FILLING = 0.2
local FIELD_PART_FILLING = 0.5
local FIELD_PART_COUNT_MIN = 5
local FIELD_PART_COUNT_MAX = 5
local BUTTON_SIZE_FACTOR = 0.25

local cell_size = 0
local field_offset = Point:new(0, 0)
local field = PlacedField:new(FIELD_SIZE)
local field_part = PlacedField:new(FIELD_PART_SIZE)
local button_size = 0
local left_buttons_offset = 0
local right_buttons_offset = 0

function love.load()
  math.randomseed(os.time())
  love.setDeprecationOutput(true)
  love.graphics.setBackgroundColor(0.5, 0.5, 0.5)

  local ok = love.window.setFullscreen(true)
  assert(ok, "unable to enter fullscreen")

  local x, y, width, height = love.window.getSafeArea()
  cell_size = height / (FIELD_SIZE.height + 1)
  field_offset = Point
    :new(x, y)
    :translate(Point:new(
      (width - cell_size * FIELD_SIZE.width) / 2,
      cell_size / 2
    ))
  field = random.generate(field, FIELD_FILLING)
  field_part = random.generate_with_limits(
    field_part,
    FIELD_PART_FILLING,
    FIELD_PART_COUNT_MIN,
    FIELD_PART_COUNT_MAX
  )
  button_size = BUTTON_SIZE_FACTOR * height
  left_buttons_offset = Point:new(
    x + cell_size / 2,
    y + height - cell_size - 1.5 * button_size
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

  drawing.draw_field(field, field_offset, cell_size, {0, 0, 1})

  local allowed_field_part = sets.complement(field_part, field)
  drawing.draw_field(allowed_field_part, field_offset, cell_size, {0, 0.66, 0})

  local disabled_field_part = sets.intersection(field_part, field)
  drawing.draw_field(disabled_field_part, field_offset, cell_size, {0.85, 0, 0})

  love.graphics.setColor(0.75, 0.75, 0)
  love.graphics.setLineWidth(cell_size / 10)
  love.graphics.rectangle(
    "line",
    field_offset.x + cell_size * field_part.offset.x,
    field_offset.y + cell_size * field_part.offset.y,
    FIELD_PART_SIZE.width * cell_size,
    FIELD_PART_SIZE.height * cell_size
  )

  suit.draw()
end

function love.update()
  local to_left_button = suit.Button(
    "<",
    left_buttons_offset.x,
    left_buttons_offset.y + button_size / 2 + cell_size / 2,
    button_size / 2,
    button_size
  )
  local to_right_button = suit.Button(
    ">",
    left_buttons_offset.x + button_size / 2 + cell_size / 2,
    left_buttons_offset.y + button_size / 2 + cell_size / 2,
    button_size / 2,
    button_size
  )
  local to_top_button = suit.Button(
    "^",
    right_buttons_offset.x,
    right_buttons_offset.y + button_size / 2 + cell_size / 2,
    button_size,
    button_size / 2
  )
  local to_bottom_button = suit.Button(
    "v",
    right_buttons_offset.x,
    right_buttons_offset.y + button_size + cell_size,
    button_size,
    button_size / 2
  )

  local field_part_offset_next = Point:new(
    field_part.offset.x,
    field_part.offset.y
  )
  if to_left_button.hit then
    field_part_offset_next.x = field_part_offset_next.x - 1
  end
  if to_right_button.hit then
    field_part_offset_next.x = field_part_offset_next.x + 1
  end
  if to_top_button.hit then
    field_part_offset_next.y = field_part_offset_next.y - 1
  end
  if to_bottom_button.hit then
    field_part_offset_next.y = field_part_offset_next.y + 1
  end

  local field_part_next = PlacedField.place(field_part, field_part_offset_next)
  if field_part_next:fits(field) then
    field_part = field_part_next
  end

  local rotate_button = suit.Button(
    "@",
    left_buttons_offset.x,
    left_buttons_offset.y,
    button_size + cell_size / 2,
    button_size / 2
  )
  if rotate_button.hit then
    field_part = matrix.rotate(field_part)
  end

  local union_button = suit.Button(
    "+",
    right_buttons_offset.x,
    right_buttons_offset.y,
    button_size,
    button_size / 2
  )
  if union_button.hit then
    local disabled_field_part = sets.intersection(field_part, field)
    local has_collision = disabled_field_part:count() ~= 0
    if not has_collision then
      field = sets.union(field, field_part)
      field = life.populate(field)

      field_part.offset = Point:new(0, 0)
      field_part = random.generate_with_limits(
        field_part,
        FIELD_PART_FILLING,
        FIELD_PART_COUNT_MIN,
        FIELD_PART_COUNT_MAX
      )
    end
  end
end
