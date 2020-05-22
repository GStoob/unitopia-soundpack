Class = require("pl.class")
ConfigFile = require("ini")

Class.ConfigurationManager()

function ConfigurationManager:LoadUserConfig(configFileName)
  local configTable = ConfigFile.read(configFileName)
  local userConfig = {}

  if (configTable) then
    for name, section in pairs(configTable) do
      for optionName, optionValue in pairs (section) do
        local config = nil
        config = tonumber(optionValue)

        if (config == nil) then
          config = optionValue
        end
        if (userConfig[name] == nil) then
          userConfig[name] = {}
        end
        userConfig[name][optionName] = config
      end
    end
  end
  return userConfig
end

function ConfigurationManager:SaveUserConfig(configFileName)
  ConfigFile.write(configFileName, UserConfig)
end

return ConfigurationManager