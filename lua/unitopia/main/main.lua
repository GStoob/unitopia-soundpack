require("unitopia.main.playback")

Audio = require("unitopia.audiosystem")()
ConfigurationManager = require("unitopia.configurationmanager")()
PluginManager = require("unitopia.pluginmanager")()
PPI = require("ppi")
Path = require("pl.path")
CONFIG_FILE_NAME = "settings.dat"
CurrentDomain = ""
CurrentRoomName = ""

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
HitpointsSound = nil
SpellpointsSound = nil

function OnPluginConnect()
  -- Clear plugin list to prevent the plugins from being in an invalid state
  PluginManager:UnloadPlugins({"unitopia/umlautnormalizer.xml", UserConfig.Settings.ScreenReaderPlugin .. ".xml"})
  -- Load plugins, default ones first
  PluginManager:LoadDefaultPlugins()
  -- Now the screen reader plugin
  PluginManager:LoadPlugin(UserConfig.Settings.ScreenReaderPlugin .. ".xml")

  -- Check if this is the first soundpack start. This is done by checking whether the settings file exists or not.
  if IsFirstSoundpackStart() then
    world.Note(
      "Anscheinend wird das Soundpack zum ersten mal gestartet. Generiere benutzerspezivische Einstellungsdatei..."
    )
    ConfigurationManager:SaveUserConfig(CONFIG_FILE_NAME)
    world.Note("Einstellungsdatei generiert. Viel Spass mit dem UNItopia Soundpack!")
  else
    UserConfig = ConfigurationManager:LoadUserConfig(CONFIG_FILE_NAME)
    world.Note("Einstellungen geladen.")
  end

  -- Now, initialize the audio output plugin
  Audio:InitializeLuaAudio()

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
  -- Now, register all the GMCP modules that UNItopia supports
  -- We can do this only after the handshake has been established
  Gmcp.RegisterModules()

  -- Also load the Umlaut normalizer plugin after we logged in to UNItopia.
  -- It causes weird behaviour when loading directly on startup of MUSHclient
  PluginManager:LoadPlugin("unitopia/umlautnormalizer.xml")
end

function OnPluginDisconnect()
  PlaySound("Misc/Exit.ogg")
  ConfigurationManager:SaveUserConfig(CONFIG_FILE_NAME)
  world.Note("Benutzereinstellungen gespeichert.")
end

function OnUnitopiaCommunication(message, rawData)
  if message == "Comm.Say" then
    PlaySound("Comm/Say.ogg")
  elseif message == "Comm.Tell" then
    PlaySound("Comm/Tell.ogg")
  elseif message == "Comm.Soul" then
    local item = Gmcp.GetById(message)
    if item and string.find(item["player"], "/p/Item/Toy/Kuscheli/obj/kuscheli", 1, true) then
      PlaySound("Comm/Kuscheli.ogg")
    end
  end
end

function OnUnitopiaRoomInfo(message, rawData)
  local info = Gmcp.GetById(message)

  if info then
    local domain, roomName = info["domain"], info["name"]

    if domain and roomName then
      SetAmbienceForDomain(domain)
      SetAmbienceForIndividualRoom(roomName)
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

function PlayHitpoints(newHitpoints, maxHitpoints)
  if CurrentHitpoints == nil then
    return
  end

  Audio:StopIfPlaying(HitpointsSound)

  local percentage = newHitpoints / (maxHitpoints / 100)

  if newHitpoints > CurrentHitpoints then
    HitpointsSound = PlaySound("Player/HpUp.ogg", UserConfig.Settings.SoundVolume, 2 * math.floor(percentage) - 100)
    HitpointsFullAnnounced = false
  elseif newHitpoints < CurrentHitpoints then
    HitpointsSound = PlaySound("Player/HpDown.ogg", UserConfig.Settings.SoundVolume, 2 * math.floor(percentage) - 100)
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

  Audio:StopIfPlaying(SpellpointsSound)

  local percentage = newSpellpoints / (maxSpellpoints / 100)

  if newSpellpoints > CurrentSpellpoints then
    SpellpointsSound = PlaySound("Player/SpUp.ogg", UserConfig.Settings.SoundVolume, 2 * math.floor(percentage) - 100)
    SpellpointsFullAnnounced = false
  elseif newSpellpoints < CurrentSpellpoints then
    SpellpointsSound = PlaySound("Player/SpDown.ogg", UserConfig.Settings.SoundVolume, 2 * math.floor(percentage) - 100)
    SpellpointsFullAnnounced = false
  end

  if newSpellpoints == maxSpellpoints and SpellpointsFullAnnounced == false then
    PlaySound("Player/SpFull.ogg")
    SpellpointsFullAnnounced = true
  end
end

function SetAmbienceForDomain(domain)
  domain = string.lower(domain)

  if CurrentDomain == domain then
    return
  end

  Audio:StopIfPlaying(CurrentAmbienceBeingPlayed)

  if domain == "himmel" then
    CurrentAmbienceBeingPlayed = PlayAmbienceLoop("Angel/Flying.ogg")
  end
  CurrentDomain = domain
end

function SetAmbienceForIndividualRoom(roomName)
  -- TODO: Add ambience loops for individual rooms here.
  roomName = string.lower(roomName)
  CurrentRoomName = roomName
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
end

function InitializeNumPad()
  world.Accelerator("Numpad1", "sw")
  world.Accelerator("Numpad2", "s")
  world.Accelerator("Numpad3", "so")
  world.Accelerator("Numpad4", "w")
  world.Accelerator("Numpad6", "o")
  world.Accelerator("Numpad7", "nw")
  world.Accelerator("Numpad8", "n")
  world.AcceleratorTo("Numpad9", 'world.Execute("no")', sendto.script)
  world.Accelerator("Add", "r")
  world.Accelerator("Subtract", "h")
end
