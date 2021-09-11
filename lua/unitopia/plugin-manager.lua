local class = require("pl.class")
local list = require("pl.List")
local path = require("pl.path")
require("pairsbykeys")

class.PluginManager()

function PluginManager:_init()
  self.PluginDirectory = world.GetInfo(60) -- Points to world/plugins
  self.DefaultPlugins = list.new()
  self:InitDefaultPluginList()
end

function PluginManager:InitDefaultPluginList()
  self.DefaultPlugins:append("LuaAudio.xml")
  self.DefaultPlugins:append("output_functions.xml")
  self.DefaultPlugins:append("omit_blank_lines.xml")
  self.DefaultPlugins:append("channel_history.xml")
  self.DefaultPlugins:append("unitopia/GMCP.xml")
end

function PluginManager:LoadPlugin(plugin)
  local pluginPath = self.PluginDirectory.."/"..plugin
  world.LoadPlugin(pluginPath)
end

function PluginManager:LoadDefaultPlugins()
  for _, plugin in pairs(self.DefaultPlugins) do
    self:LoadPlugin(plugin)
  end
end

function PluginManager:UnloadPlugin(plugin)
  local filenameWithExtension = path.basename(plugin)
  local pluginName = string.gsub(filenameWithExtension, ".xml", "")
  world.UnloadPlugin(pluginName)
end

function PluginManager:UnloadPlugins(additionalPlugins)
  local unload = function(plugins)
    for _, plugin in pairs(plugins) do
      self:UnloadPlugin(plugin)
    end
  end

  unload(self.DefaultPlugins)
  unload(additionalPlugins)
end

return PluginManager