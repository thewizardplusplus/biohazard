local function is_config(value)
  return type(value) == "table" and type(value.window) == "table"
end

local function set_title(config, title)
  assert(is_config(config))
  assert(type(title) == "string")

  config.window.title = title
  config.identity = string.lower(title)
end

local function set_screen_width(config, width, aspect_ratio, prefix)
  assert(is_config(config))
  assert(type(width) == "number" and width > 0)
  assert(type(aspect_ratio) == "number" and aspect_ratio > 0)
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
