---
-- @module factory

local types = require("lualife.types")
local PlacedField = require("lualife.models.placedfield")
local FieldSettings = require("biohazardcore.models.fieldsettings")
local random = require("lualife.random")

local factory = {}

---
-- @tparam FieldSettings settings
-- @treturn lualife.models.PlacedField
function factory.create_field(settings)
  assert(types.is_instance(settings, FieldSettings))

  local field_sample = PlacedField:new(settings.size, settings.initial_offset)
  return random.generate_with_limits(
    field_sample,
    settings.filling,
    settings.minimal_count,
    settings.maximal_count
  )
end

return factory
