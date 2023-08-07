---
-- @classmod DrawingSettings

local middleclass = require("middleclass")
local assertions = require("luatypechecks.assertions")
local Point = require("lualife.models.point")
local CellClassification = require("biohazardcore.models.cellclassification")

local DrawingSettings = middleclass("DrawingSettings")

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
-- @tparam lualife.models.Point point
-- @treturn lualife.models.Point
function DrawingSettings:map_point(point)
  assertions.is_instance(point, Point)

  return point
    :scale(self.grid_step)
    :translate(self.field_offset)
end

return DrawingSettings
