local function is_config(config)
  return type(config) == "table" and type(config.window) == "table"
end

local function is_positive_number(number)
  return type(number) == "number" and number >= 0
end

local function set_title(config, title)
  assert(is_config(config))
  assert(type(title) == "string")

  config.window.title = title
  config.identity = string.lower(title)
end

local function set_screen_width(config, width, aspect_ratio, prefix)
  assert(is_config(config))
  assert(is_positive_number(width))
  assert(is_positive_number(aspect_ratio))
  assert(type(prefix) == "string")

  config.window[prefix .. "width"] = width
  config.window[prefix .. "height"] = width / aspect_ratio
end

function love.conf(config)
  config.version = "11.3"

  config.window.resizable = true
  config.window.msaa = 8

  set_title(config, "Biohazard")
  for _, prefix in ipairs({"", "min"}) do
    set_screen_width(config, 640, 16 / 10, prefix)
  end
end
