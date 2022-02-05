local class = require("pl.class")
local file = require("pl.file")
local json = require("json")
local path = require("pl.path")

class.Trigger()

function Trigger:_init(matchText, responseText, sendTo, sequence, group, isRegexp, omitFromOutput)
  self.Name = "t_"..utils.hash(matchText)
  self.MatchText = matchText
  self.ResponseText = responseText
  self.Sequence = sequence or 100 
  self.IsRegexp = isRegexp
  self.TriggerFlags = trigger_flag.Enabled+trigger_flag.IgnoreCase+trigger_flag.Temporary
  self.SendTo = sendTo or sendto.script
  self.Group = group or "Misc"

  if omitFromOutput ~= nil then
    self.TriggerFlags = self.TriggerFlags + trigger_flag.OmitFromOutput
  end
  
  if isRegexp ~= nil then
    self.TriggerFlags = self.TriggerFlags + trigger_flag.RegularExpression
  end
end

function Trigger:Inject()
  local success = world.AddTriggerEx(self.Name, self.MatchText, self.ResponseText, self.TriggerFlags, custom_colour.NoChange, 0, "", "", self.SendTo, self.Sequence)

  if success ~= error_code.eOK then
    error("Error when creating trigger for text '"..self.matchText.."': error code "..tostring(success))
  end
  world.SetTriggerOption(self.Name, 'group', self.Group)
end

function Trigger:Delete()
  world.DeleteTrigger(self.Name)
end

class.SoundLoader()

function SoundLoader:_init()
  self.SoundTriggers = {}
  self.SoundTriggersPath = path.join(world.GetInfo(67), "sounds.json")
end

function SoundLoader:LoadFromFile()
  self:Unload()

  world.Note("Lade Sound Trigger...")

  if not path.exists(self.SoundTriggersPath) then
    error("The JSON file holding the sound triggers is missing! Cannot continue.")
    return
  end

  local soundsLoadedCount = 0
  local jsonData = json.decode(file.read(self.SoundTriggersPath))
  assert(jsonData, "jsonData must not be nil!")

  for _, triggerData in pairs(jsonData) do
    local t = Trigger(triggerData.matchText, triggerData.responseText, triggerData.sendto, triggerData.sequence, triggerData.group, triggerData.isRegexp, triggerData.omitFromOutput)
    t:Inject()
    table.insert(self.SoundTriggers, t)
    soundsLoadedCount = soundsLoadedCount + 1
  end

  world.Note("Es wurden "..soundsLoadedCount.." Sound Trigger in den Speicher geladen.")
end

function SoundLoader:Unload()
  if #self.SoundTriggers == 0 then
    return
  end

  local soundsUnloadedCount = 0

  world.Note("Entferne Sound Trigger aus dem Speicher")

  for i, trigger in pairs(self.SoundTriggers) do
    trigger:Delete()
    soundsUnloadedCount = soundsUnloadedCount + 1
  end

  world.Note("Es wurden "..soundsUnloadedCount.." Sound Trigger aus dem Speicher entfernt.")
end

function SoundLoader:Reload()
  self:Unload()
  self:LoadFromFile()
end

return SoundLoader