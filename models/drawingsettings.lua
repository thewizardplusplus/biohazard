-- luacheck: no max comment line length

---
-- @classmod DrawingSettings

local middleclass = require("middleclass")
local assertions = require("luatypechecks.assertions")
local Nameable = require("luaserialization.nameable")
local Stringifiable = require("luaserialization.stringifiable")
local Point = require("lualife.models.point")
local CellClassification = require("biohazardcore.models.cellclassification")

local DrawingSettings = middleclass("DrawingSettings")
DrawingSettings:include(Nameable)
DrawingSettings:include(Stringifiable)

---
-- @table instance
-- @tfield lualife.models.Point field_offset
-- @tfield int grid_step [0, ∞)
-- @tfield[opt] "old"|"new"|"intersection" cell_kind

---
-- @function new
-- @tparam lualife.models.Point field_offset
-- @tparam int grid_step [0, ∞)
-- @tparam[opt] "old"|"new"|"intersection" cell_kind
-- @treturn DrawingSettings
function DrawingSettings:initialize(field_offset, grid_step, cell_kind)
  assertions.is_instance(field_offset, Point)
  assertions.is_integer(grid_step)
  assertions.is_true(
    cell_kind == nil or CellClassification.is_cell_kind(cell_kind)
  )

  self.field_offset = field_offset
  self.grid_step = grid_step
  self.cell_kind = cell_kind
end

---
-- @treturn tab table with instance fields
--   (see the [luaserialization](https://github.com/thewizardplusplus/luaserialization) library)
function DrawingSettings:__data()
  return {
    field_offset = self.field_offset,
    grid_step = self.grid_step,
    cell_kind = self.cell_kind,
  }
end

---
-- @function __tostring
-- @treturn string stringified table with instance fields
--   (see the [luaserialization](https://github.com/thewizardplusplus/luaserialization) library)

---
-- @tparam lualife.models.Point point
-- @treturn lualife.models.Point
function DrawingSettings:map_point(point)
  assertions.is_instance(point, Point)

  return point
    :scale(self.grid_step)
    :translate(self.field_offset)
end

return DrawingSettings
