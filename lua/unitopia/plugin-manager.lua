Class = require("pl.class")
List = require("pl.List")
require("pairsbykeys")

Class.PluginManager()

function PluginManager:_init()
  self.Plugins = List.new()
end

function PluginManager:AddPlugin(plugin)
  self.Plugins:append(plugin)
end

function PluginManager:LoadPlugins(pluginDirectory)
  for i, plugin in pairs(self.Plugins) do
    local pluginPath = pluginDirectory.."/"..plugin
    world.LoadPlugin(pluginPath)
  end
end

function PluginManager:UnloadPlugins(pluginDirectory)
  for i, plugin in pairs(self.Plugins) do
    local pluginPath = pluginDirectory.."/"..plugin
    world.UnloadPlugin(pluginPath)
  end
  self.Plugins = nil
end

return PluginManager