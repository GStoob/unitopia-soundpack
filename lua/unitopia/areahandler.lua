local class = require("pl.class")
local file = require("pl.file")
local json = require("json")
local path = require("pl.path")

class.Area()
function Area:_init(name, ambience, music)
  self.Name = name:lower()
  self.Ambience = ambience
  self.Music = music
end

local areas = {}

local loadFromJson = function(basePath)
  if not path.exists(basePath) then
    error("Path ".. basePath .. " does not exist.")
  end

  local jsonData = json.decode(file.read(path.join(basePath, "areas.json")))

  -- Compose the table which holds the areas
  for _, areaData in pairs(jsonData) do
    local area = Area(areaData.name, areaData.ambience, areaData.music)
    areas[areaData.name] = area
  end 
end

local findArea = function(toSearch)
  for name, area in pairs(areas) do
    if name == toSearch then
      return area
    end
  end  
  return nil
end

local unloadAll = function()
  areas = {}
end

AreaHandler = {}
AreaHandler.LoadFromJson = loadFromJson
AreaHandler.FindArea = findArea
AreaHandler.UnloadAll = unloadAll

return AreaHandler