local class = require("pl.class")
local configFile = require("ini")

class.ConfigurationManager()

function ConfigurationManager:LoadUserConfig(configFileName)
  assert(configFileName, "Value of configFileName must not be nil")

  local userConfig = {}
  local configTable = assert(configFile.read(configFileName))

  for name, section in pairs(configTable) do
    for optionName, optionValue in pairs(section) do
      local config = nil
      config = tonumber(optionValue)

      if config == nil then
        config = optionValue
      end
      if userConfig[name] == nil then
        userConfig[name] = {}
      end
      userConfig[name][optionName] = config
    end
  end
  return userConfig
end

function ConfigurationManager:SaveUserConfig(configFileName)
  assert(configFileName, "Value of configFileName must not be nil")
  configFile.write(configFileName, UserConfig)
end

return ConfigurationManager