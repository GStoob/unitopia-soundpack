-- Creates an index of the sound folder for the purpose of picking
-- a random sound from a subdirectory.
-- Note: Subdirectories, which contain sound files as well as
-- other subdirectories, are currently not supported.
local class = require("pl.class")
local constants = require("unitopia.constants")
local dir = require("pl.dir")

class.SoundIndex()

function SoundIndex:_init()
  self.Index = {}
  local currentPath = nil
  local sounds = {}
  sounds[0] = 0
  for path, mode in dir.dirtree(constants.SoundFolder) do
    if mode then
      -- path points to a (new) directory 
      if sounds[0] > 0 then
        -- Store the sounds found in the previous directory in the index
        self.Index[currentPath] = sounds
        sounds = {}
        sounds[0] = 0
      end
      currentPath = world.Replace(path, constants.SoundFolder, "")
    else
      sounds[0] = sounds[0] + 1
      sounds[sounds[0]] = world.Replace(path, constants.SoundFolder .. currentPath .. "\\", "")
    end
  end
  if sounds[0] > 0 then
    -- Store the sounds found in the last directory in the index
    self.Index[currentPath] = sounds
  end
end

function SoundIndex:Random(path)
  value = self.Index[path]
  if value == nil then
    return nil
  end
  return constants.SoundFolder .. path .. "\\" .. value[math.random(1, value[0])]
end

return SoundIndex