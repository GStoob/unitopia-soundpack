require("unitopia.main.playback")
Audio = require("unitopia.audiosystem")()
AreaHandler = require("unitopia.areahandler")
ConfigurationManager = require("unitopia.configurationmanager")()
PluginManager = require("unitopia.pluginmanager")()
SoundIndex = require("unitopia.soundindex")()
SoundLoader = require("unitopia.soundloader")()
PPI = require("ppi")
Path = require("pl.path")
UmlautNormalizer = require("unitopia.umlautnormalizer")()

CONFIG_FILE_NAME = "settings.dat"
CurrentArea = ""
CurrentDomain = ""

Gmcp = nil

-- The following are the user specific settings. The tables hold default values, so that a
-- valid settings file can be generated on the first soundpack start
UserConfig = {}
UserConfig.Settings = {}
UserConfig.Settings.ScreenReaderPlugin = "MushReader"
UserConfig.Settings.SoundVolume = 20
UserConfig.Settings.AmbienceVolume = 15
UserConfig.Settings.MusicVolume = 10
UserConfig.Settings.SoundsMuted = 0
UserConfig.Settings.AmbienceMuted = 0
UserConfig.Settings.MusicMuted = 0

-- Ambience and back ground music
CurrentAmbienceBeingPlayed = nil
CurrentBackgroundMusicBeingPlayed = nil

-- Player's vitals
CurrentHitpoints = nil
CurrentSpellpoints = nil
HitpointsFullAnnounced = true
SpellpointsFullAnnounced = true

-- Player's stats
CurrentStats = {}

-- Player's progress
CurrentProgress = nil

function OnPluginConnect()
  -- Clear plugin list to prevent the plugins from being in an invalid state
  PluginManager:UnloadPlugins({"unitopia/umlautnormalizer.xml", UserConfig.Settings.ScreenReaderPlugin .. ".xml"})
  -- Load plugins, default ones first
  PluginManager:LoadDefaultPlugins()

  -- Check if this is the first soundpack start. This is done by checking whether the settings file exists or not.
  if IsFirstSoundpackStart() then
    world.Note(
      "Anscheinend wird das Soundpack zum ersten mal gestartet. Generiere benutzerspezivische Einstellungsdatei..."
    )
    ConfigurationManager:SaveUserConfig(CONFIG_FILE_NAME)
    world.Note("Einstellungsdatei generiert. Viel Spass mit dem UNItopia Soundpack!")
  else
    UserConfig = ConfigurationManager:LoadUserConfig(CONFIG_FILE_NAME)
    world.Note("Benutzereinstellungen geladen.")
  end

  -- Now, load the screen reader plugin
  PluginManager:LoadPlugin(UserConfig.Settings.ScreenReaderPlugin .. ".xml")
  -- Initialize the audio output plugin
  Audio:InitializeLuaAudio()
  -- Load areas
  AreaHandler.LoadFromJson(world.GetInfo(67))

  -- Load the sound triggers
  SoundLoader:Reload()
  
  -- Bootstrap the GMCP plugin once it's loaded
  -- (ID, on_success, on_failure)
  PPI.OnLoad(
    Constants.Plugins.GMCP_PLUGIN_ID,
    function(gmcp)
      gmcp.Listen("Core.Hello", OnCoreHello)
      gmcp.Listen("Comm.Say", OnUnitopiaCommunication)
      gmcp.Listen("Comm.Tell", OnUnitopiaCommunication)
      gmcp.Listen("Comm.Soul", OnUnitopiaCommunication)
      gmcp.Listen("Room.Info", OnUnitopiaRoomInfo)
      gmcp.Listen("Char.Vitals", OnUnitopiaVitals)
      gmcp.Listen("Char.Stats", OnUnitopiaStats)
      gmcp.Listen("Char.Items.Add", OnUnitopiaItems)
      gmcp.Listen("Char.Items.Remove", OnUnitopiaItems)
      Gmcp = gmcp
    end,
    function(error)
      world.Note("An unexpected error occurred when loading the GMCP plugin: " .. error)
    end
  )

  PlaySound("Misc/SoundpackStart.ogg")
  InitializeHotkeys()
  InitializeNumPad()
end

function OnPluginListChanged()
  -- Delayed call to PPI.Refresh() to ensure that all plugins are loaded on execution of this method
  DoAfterSpecial(0.5, "PPI.Refresh()", sendto.script)
end

function OnCoreHello(message, data)
  -- Register all the GMCP modules that UNItopia supports
  -- We can do this only after the handshake has been established
  Gmcp.RegisterModules()

  -- Also load the Umlaut normalizer plugin after we logged in to UNItopia.
  -- It causes weird behaviour when loading directly on startup of MUSHclient
  PluginManager:LoadPlugin("unitopia/umlautnormalizer.xml")
  -- Since we have turned the option no_echo_off on, manually clear the command history to remove login credentials
  world.DeleteCommandHistory()
end

function OnPluginDisconnect()
  Audio:StopIfPlaying(CurrentAmbienceBeingPlayed)
  Audio:StopIfPlaying(CurrentBackgroundMusicBeingPlayed)
  PlaySound("Misc/Exit.ogg")
  ConfigurationManager:SaveUserConfig(CONFIG_FILE_NAME)
  world.Note("Benutzereinstellungen gespeichert.")
  SoundLoader:Unload()
end

function OnUnitopiaCommunication(message, rawData)
  channel = "UNBEKANNT"
  if message == "Comm.Say" then
    PlaySound("Comm/Say.ogg")
    channel = "SAGEN"
  elseif message == "Comm.Tell" then
    PlaySound("Comm/Tell.ogg")
    channel = "REDEN"
  elseif message == "Comm.Soul" then
    local item = Gmcp.GetById(message)
    if item and string.find(item["player"], "kuscheli", 1, true) then
      PlaySound("Comm/Kuscheli.ogg")
      channel = "KUSCHELI"
    else
      channel = "SEELE"
    end
  end
  world.Execute("history_add "..channel.."="..UmlautNormalizer:Normalize(world.Replace(rawData.text, "\n", " ")))
end

function OnUnitopiaRoomInfo(message, rawData)
  local info = Gmcp.GetById(message)

  if info then
    local domain, room = UmlautNormalizer:Normalize(info["domain"]), UmlautNormalizer:Normalize(info["name"])
    local matchingArea = nil

    if CurrentDomain ~= domain then
      PlaySound("Player/DomainChange.ogg")
      CurrentDomain = domain
      world.Note(CurrentDomain)
    end
    
    if room and room ~= 0 then
      -- Individual rooms take precedence over the city or domain
      room = room:lower()

      if CurrentArea == room then
        return
      end

      matchingArea = AreaHandler.FindArea(room)

      if matchingArea then
        SetAmbienceAndBackgroundMusic(matchingArea)
        CurrentArea = matchingArea.Name
      end
    end
    if domain then
      domain = domain:lower()

      if CurrentArea == domain then
        return
      end

      if matchingArea == nil then
        matchingArea = AreaHandler.FindArea(domain)

        if matchingArea then
          SetAmbienceAndBackgroundMusic(matchingArea)
          CurrentArea = matchingArea.Name
        end
      end
    end
    if matchingArea == nil then
      -- When no match, then just stop ambience and background music
      Audio:StopIfPlaying(CurrentAmbienceBeingPlayed)
      Audio:StopIfPlaying(CurrentBackgroundMusicBeingPlayed)
      CurrentArea = nil
    end
  end
end

function OnUnitopiaVitals(message, rawData)
  local vitals = Gmcp.GetById(message)

  if vitals then
    local newHitpoints, maxHitpoints = tonumber(vitals["hp"]), tonumber(vitals["maxhp"])
    local newSpellpoints, maxSpellpoints = tonumber(vitals["sp"]), tonumber(vitals["maxsp"])
    PlayHitpoints(newHitpoints, maxHitpoints)
    CurrentHitpoints = newHitpoints
    PlaySpellpoints(newSpellpoints, maxSpellpoints)
    CurrentSpellpoints = newSpellpoints
  end
end

function OnUnitopiaStats(message, rawData)
  local difference, statDown, statName, statUp
  for key, value in pairs(rawData) do
    rawData[key] = tonumber(world.Replace(value, ",", "."))
    if CurrentStats[key] ~= nil and CurrentStats[key] ~= rawData[key] then
      difference = rawData[key] - CurrentStats[key]
      -- Round the difference to 2 decimal places
      difference = tonumber(string.format(" %.2f", difference))
      if difference > 0 then
        difference = "+" .. difference
        statUp = true
      else
        statDown = true
      end
      difference = world.Replace(difference, ".", ",")
      statName = Constants.StatNames[key]
      if statName == nil then
        statName = "Unbekannt"
      end
      world.Note(statName .. ": " .. value .. ", " .. difference)
    end
  end
  CurrentStats = rawData
  if statDown then
    PlaySound("Player/StatDown.ogg")
  end
  if statUp then
    PlaySound("Player/StatUp.ogg")
  end
end

function OnUnitopiaProgress(progress)
  local difference
  progress = world.Replace(progress, ",", ".")
  progress = world.Replace(progress, "%", "")
  progress = tonumber(progress)
  if CurrentProgress ~= nil and progress > CurrentProgress then
    difference = math.abs(CurrentProgress - progress)
    difference = "+" .. world.Replace(difference, ".", ",") .. "%"
    world.Note("Gratulation! " .. difference)
    PlaySound("Player/ProgressUp.ogg")
  end
  CurrentProgress = progress
end

function OnUnitopiaItems(message, rawData)
  local type
  if message == "Char.Items.Add" then
    type = "ItemAdd"
  elseif message == "Char.Items.Remove" then
    type = "ItemRemove"
  else
    return
  end
  if rawData["location"] == nil or rawData["location"] ~= "inv" then
    return
  end
  local item = rawData["item"]
  if item == nil then
    return
  end
  if item["category"] == nil then
    return
  end
  local itemCategory = Constants.ItemCategories[item["category"]]
  if itemCategory == nil then
    return
  end
  PlayRandomSound(type .. "\\" .. itemCategory)
end

function PlayHitpoints(newHitpoints, maxHitpoints)
  if CurrentHitpoints == nil then
    return
  end

  local percentage = newHitpoints / (maxHitpoints / 100)

  if newHitpoints > CurrentHitpoints then
    PlaySound("Player/HpUp.ogg", UserConfig.Settings.SoundVolume, 2 * math.floor(percentage) - 100)
    HitpointsFullAnnounced = false
  elseif newHitpoints < CurrentHitpoints then
    PlaySound("Player/HpDown.ogg", UserConfig.Settings.SoundVolume, 2 * math.floor(percentage) - 100)
    HitpointsFullAnnounced = false
  end

  if newHitpoints == maxHitpoints and HitpointsFullAnnounced == false then
    PlaySound("Player/HpFull.ogg")
    HitpointsFullAnnounced = true
  end
end

function PlaySpellpoints(newSpellpoints, maxSpellpoints)
  if CurrentSpellpoints == nil then
    return
  end

  local percentage = newSpellpoints / (maxSpellpoints / 100)

  if newSpellpoints > CurrentSpellpoints then
    PlaySound("Player/SpUp.ogg", UserConfig.Settings.SoundVolume, 2 * math.floor(percentage) - 100)
    SpellpointsFullAnnounced = false
  elseif newSpellpoints < CurrentSpellpoints then
    PlaySound("Player/SpDown.ogg", UserConfig.Settings.SoundVolume, 2 * math.floor(percentage) - 100)
    SpellpointsFullAnnounced = false
  end

  if newSpellpoints == maxSpellpoints and SpellpointsFullAnnounced == false then
    PlaySound("Player/SpFull.ogg")
    SpellpointsFullAnnounced = true
  end
end

function SetAmbienceAndBackgroundMusic(area)
  Audio:StopIfPlaying(CurrentAmbienceBeingPlayed)
  Audio:StopIfPlaying(CurrentBackgroundMusicBeingPlayed)

  if area.Ambience ~= "" then
    CurrentAmbienceBeingPlayed = PlayAmbienceLoop(area.Ambience)
  end

  if area.Music ~= "" then
    CurrentBackgroundMusicBeingPlayed = PlayMusic(area.Music)
  end
end

function IsFirstSoundpackStart()
  if not Path.exists(CONFIG_FILE_NAME) then
    return true
  end
  return false
end

function InitializeHotkeys()
  -- Volume
  world.AcceleratorTo("F9", "SetSoundVolume(-5)", sendto.script)
  world.AcceleratorTo("F10", "SetSoundVolume(5)", sendto.script)
  world.AcceleratorTo("ctrl+F9", "SetAmbienceVolume(-5)", sendto.script)
  world.AcceleratorTo("ctrl+F10", "SetAmbienceVolume(5)", sendto.script)
  world.AcceleratorTo("ctrl+shift+F9", "SetMusicVolume(-5)", sendto.script)
  world.AcceleratorTo("ctrl+shift+F10", "SetMusicVolume(5)", sendto.script)
  world.AcceleratorTo("F11", "ToggleMute()", sendto.script)

  -- Screen Reader output plugin
  world.AcceleratorTo("ctrl+F12", "SwitchScreenReaderOutputPlugin()", sendto.script)
end

function InitializeNumPad()
  world.Accelerator("Numpad1", "sw")
  world.Accelerator("Numpad2", "s")
  world.Accelerator("Numpad3", "so")
  world.Accelerator("Numpad4", "w")
  world.Accelerator("Numpad5", "betrachte")
  world.Accelerator("Numpad6", "o")
  world.Accelerator("Numpad7", "nw")
  world.Accelerator("Numpad8", "n")
  world.AcceleratorTo("Numpad9", 'world.Execute("no")', sendto.script)
  world.Accelerator("Add", "r")
  world.Accelerator("Subtract", "h")
  world.AcceleratorTo("Divide", "SpeakCurrentHitpoints()", sendto.script)
  world.AcceleratorTo("Multiply", "SpeakCurrentSpellpoints()", sendto.script)
end

function SwitchScreenReaderOutputPlugin()
  PluginManager:UnloadPlugin(UserConfig.Settings.ScreenReaderPlugin)

  if UserConfig.Settings.ScreenReaderPlugin == "MushReader" then
    UserConfig.Settings.ScreenReaderPlugin = "tts_jfw"
  else
    UserConfig.Settings.ScreenReaderPlugin = "MushReader"
  end

  PluginManager:LoadPlugin(UserConfig.Settings.ScreenReaderPlugin .. ".xml")
  PlaySound("misc/switch.ogg")
  world.Note("Ausgabesystem geaendert.")
end

function SpeakCurrentHitpoints()
  if CurrentHitpoints == nil then
    return
  end
  world.Execute("tts_interrupt "..CurrentHitpoints.." AP")
end

function SpeakCurrentSpellpoints()
  if CurrentSpellpoints == nil then
    return
  end
  world.Execute("tts_interrupt "..CurrentSpellpoints.." ZP")
end
