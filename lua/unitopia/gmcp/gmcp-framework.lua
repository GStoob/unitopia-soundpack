require("json")
require("tprint")
Class = require("pl.class")
Constants = require("unitopia.constants")
Tablex = require("pl.tablex")

Class.GmcpFramework()

function GmcpFramework:_init()
  self.LogOutput = false
  self.GmcpData = {}

  -- TODO: At some point we might have to extract the observers here and create an own module for that.
  -- There are also already some solutions out there that we could try out.
  -- For example the beholder - https://github.com/kikito/beholder.lua
  -- The following approach has been borrowed from the Avalon soundpack
  self.Callbacks = {}
end

function GmcpFramework:AddListener(event, callback)
  if (not self.Callbacks[event]) then
    self.Callbacks[event] = {}
  end

  if (Tablex.find(self.Callbacks[event],callback) ~=nil) then
    return false
  end
  self.Callbacks[event][#(self.Callbacks[event])+1]=callback
  return true
end

function GmcpFramework:RemoveListener(event, callback)
  if (self.Callbacks[event] == nil) then
    return false
  end

  local index = Tablex.find(self.Callbacks[event], callback)

  if (index ~= nil) then
    self.Callbacks[event]=Tablex.removevalues(self.Callbacks[event],index,index)
    return true
  end

  return false
end

function GmcpFramework:NotifyListeners(event, ...)
  if (self.Callbacks[event] ~= nil) then
    for _, callbackFunction in pairs(self.Callbacks[event]) do
      callbackFunction(unpack({ select(1, ...) }))
    end
  end
end

---------------------------------------------------------------------------------------------------
-- Sends an GMCP packet to the server
-- The data must already be serialized, otherwise it will fail.
-- Example: Core.Hello { "client": "UNItopia WebMUD", "version": "2.0" }
---------------------------------------------------------------------------------------------------
function GmcpFramework:SendGmcpPacket(data)
  assert(data, "Value of data must not be nil")

  -- Create a valid GMCP packet that can be sent to the server
  local interPretAsCommand = Constants.GmcpProtocolNegotiation.IAC
  local subNegotiationStart = Constants.GmcpProtocolNegotiation.SB
  local subNegotiationEnd = Constants.GmcpProtocolNegotiation.SE
  local gmcp = Constants.GmcpProtocolNegotiation.GMCP

  local packet = string.char(interPretAsCommand, subNegotiationStart, gmcp)..
  (string.gsub(data, "\255", "\255\255")) ..  -- IAC becomes IAC IAC
  string.char(interPretAsCommand, subNegotiationEnd)

  if (self.LogOutput) then world.Note("Sending serialized GMCP data to the server... "..data) end

  world.SendPkt(packet)
end

---------------------------------------------------------------------------------------------------
-- Parses the incoming raw GMCP data and stores it in the GmcpData table
-- After parsing is done, it can be retrieved using the GetById method.
---------------------------------------------------------------------------------------------------
function GmcpFramework:ParseRawData(data)
  local message, content

  do
    local rawDataTable = utils.split(data, " ", 1)
    message, content = rawDataTable[1], rawDataTable[2]

    if (content:len() == 0) then
      content = nil
    else
      -- Not every JSON parser allows any top-level value to be valid.
      -- Ensuring that a non-object non-array value is at least within
      -- an array makes this code parser-agnostic.
      content = json.decode("["..content.."]")

      if (content ~= nil) then
        content = content[1]
      end
    end

    self.GmcpData[message] = content

    if (self.LogOutput) then self:Log(message, content) end

    self:NotifyListeners(message, content)
  end
end

---------------------------------------------------------------------------------------------------
-- Retrieves GMCP data by it's identifier. Example: GmcpFramework:GetById("Core.Hello")
---------------------------------------------------------------------------------------------------
function GmcpFramework:GetById(id)
  local node = self.GmcpData

  for level in string.gmatch(path, "%a+") do
    if (type(node) ~= "table" or node[id] == nil) then return nil end
    node = node[id]
  end
  return node
end

function GmcpFramework:EnableLogOutput()
  self.LogOutput = true
end

function GmcpFramework:DisableLogOutput()
  self.LogOutput = false
end

function GmcpFramework:IsLogOutputEnabled() return self.LogOutput end

function GmcpFramework:Log(message, content)
  world.Note(message)

  if (type(content) == "table") then
    tprint(content)
  else
    world.Note(content)
  end
end