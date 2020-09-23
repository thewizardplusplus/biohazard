---
-- @classmod DrawingSettings

local middleclass = require("middleclass")
local types = require("lualife.types")
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
  assert(types.is_instance(field_offset, Point))
  assert(types.is_number_with_limits(grid_step, 0))
  assert(cell_kind == nil or CellClassification.is_cell_kind(cell_kind))

  self.field_offset = field_offset
  self.grid_step = grid_step
  self.cell_kind = cell_kind
end

---
-- @tparam "old"|"new"|"intersection" cell_kind
-- @treturn DrawingSettings
function DrawingSettings:with_cell_kind(cell_kind)
  assert(CellClassification.is_cell_kind(cell_kind))

  return DrawingSettings(self.field_offset, self.grid_step, cell_kind)
end

return DrawingSettings
