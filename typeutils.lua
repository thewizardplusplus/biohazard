---
-- @module typeutils

local json = require("json")
local jsonschema = require("jsonschema")
local types = require("lualife.types")
local Size = require("lualife.models.size")

local typeutils = {}

---
-- @tparam func handler func(): any; function that raises an error
-- @tparam[opt] {any,...} ... handler arguments
-- @treturn any successful handler result
-- @error raised handler error
function typeutils.catch_error(handler, ...)
  assert(type(handler) == "function")

  local arguments = table.pack(...)
  local ok, result = pcall(function()
    return handler(table.unpack(arguments))
  end)
  if not ok then
    return nil, result
  end

  return result
end

---
-- @tparam lualife.models.Size size
-- @tparam int factor [0, ∞)
-- @treturn lualife.models.Size
function typeutils.scale_size(size, factor)
  assert(types.is_instance(size, Size))
  assert(types.is_number_with_limits(factor))

  return Size:new(factor * size.width, factor * size.height)
end

---
-- @tparam string path
-- @tparam tab schema JSON Schema
-- @treturn tab
-- @error error message
function typeutils.load_json(path, schema)
  assert(type(path) == "string")
  assert(type(schema) == "table")

  local data_in_json, reading_err = love.filesystem.read(path)
  if not data_in_json then
    return nil, "unable to read data: " .. reading_err
  end

  local data, decoding_err = typeutils.catch_error(json.decode, data_in_json)
  if not data then
    return nil, "unable to parse data: " .. decoding_err
  end

  local data_validator, generation_err =
    typeutils.catch_error(jsonschema.generate_validator, schema)
  if not data_validator then
    return nil, "unable to generate the validator: " .. generation_err
  end

  local ok, validation_err = data_validator(data)
  if not ok then
    return nil, "incorrect data: " .. validation_err
  end

  return data
end

return typeutils
