function love.conf(config)
  local title = "Biohazard"
  local aspect_ratio = 16 / 10
  config.version = "11.3"
  config.identity = string.lower(title)
  config.window.title = title
  config.window.width = 640
  config.window.height = config.window.width / aspect_ratio
  config.window.minwidth = 640
  config.window.minheight = config.window.minheight / aspect_ratio
  config.window.resizable = true
  config.window.msaa = 8
end
