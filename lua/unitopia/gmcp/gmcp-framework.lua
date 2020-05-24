require("json")
require("tprint")
Class = require("pl.class")
Constants = require("unitopia.constants")
Tablex = require("pl.tablex")

Class.GmcpFramework()

function GmcpFramework:_init()
  self.DebuggingEnabled = false
  self.GmcpData = {}
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
  if (self.Callbacks ~= nil) then
    for index, callbackFunction in pairs(self.Callbacks) do
      callbackFunction(unpack({ select(1, ...) }))
    end
  end
end

---------------------------------------------------------------------------------------------------
-- Send an GMCP packet to the server
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

  world.SendPkt(packet)
end

---------------------------------------------------------------------------------------------------
-- Retrieves a single value from the GMCP Data table
---------------------------------------------------------------------------------------------------
function GmcpFramework:GetGmcpValue(fieldValuePath)
  assert(fieldValuePath, "fieldValuePath must not be nil")

  local function GetLastTag(str) return string.match(str,"^.*%.(%a+)$") or str end

  local parrentNode = self.GmcpData
  local lastValue = GetLastTag(fieldValuePath)

  for item in string.gmatch(fieldValuePath,"%a+") do
    if (parrentNode[item] ~= nil) then
      if (item == lastValue) then return parrentNode[item] end

      if (type(item) == "table") then
        parrentNode = parrentNode[item]
      else
        return parrentNode[item]
      end
    else
      return "" -- Couldn't find any matching value for given field value path
    end
    end

  return ""
  end
end

function GmcpFramework:ParseRawData(data)
  local message, content

  do
    local rawTable = utils.split(data, " ", 1)
    message, content = rawTable[1], rawTable[2]

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

    if (self.DebuggingEnabled) then self:Log(message, content) end

    self:NotifyListeners(message, content)
  end
end

function GmcpFramework:EnableDebugging()
  self.DebuggingEnabled = true
end

function GmcpFramework:DisableDebugging()
  self.DebuggingEnabled = false
end

function GmcpFramework:Log(message, content)
  world.Note(message)
  if (type(content) == "table") then
    tprint(content)
  else
    world.Note(content)
  end
end