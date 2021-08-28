Class = require("pl.class")
List = require("pl.List")
require("pairsbykeys")

Class.PluginManager()

function PluginManager:_init()
  self.PluginDirectory = world.GetInfo(60) -- Points to world/plugins
  self.Plugins = List.new()
end

function PluginManager:AddPlugin(plugin)
  self.Plugins:append(plugin)
end

function PluginManager:LoadPlugins()
  for i, plugin in pairs(self.Plugins) do
    local pluginPath = self.PluginDirectory.."/"..plugin
    world.LoadPlugin(pluginPath)
  end
end

function PluginManager:UnloadPlugins()
  for i, plugin in pairs(self.Plugins) do
    local pluginPath = self.PluginDirectory.."/"..plugin
    world.UnloadPlugin(pluginPath)
  end
  self.Plugins = List.new()
end

return PluginManager