Class = require("pl.class")
PPI = require("ppi")
Constants = require("unitopia.constants")

Class.AudioSystem()

function AudioSystem:_init()
  self.Audio = nil
  self.CurrentAmbienceSoundHandle = 0 -- Holds a reference to the current ambience sound being played. 0 = no sound is playing.
  self.CurrentMusicSoundHandle = 0 -- Holds a reference to the current background music being played. 0 = no music is playing.
  self.SoundFolder = world.GetInfo(74) -- Points to the MUSHclient/sounds directory
end

function AudioSystem:InitializeLuaAudio()
  local audio = PPI.Load(Constants.Plugins.AUDIO_PLUGIN_ID)

  if (not audio) then
    error("Ein unerwarteter Fehler ist aufgetreten. Das Audiosystem konnte nicht initialisiert werden.")
    return
  end
  self.Audio = audio
end

function AudioSystem:Play(relativeFilePath, volume, panning, isMuted)
  if (isMuted == 1) then return 0 end

  return self.Audio.play(self.SoundFolder.."/"..relativeFilePath, 0, panning, volume)
end

function AudioSystem:PlayLooped(relativeFilePath, volume, panning, isMuted)
  if (isMuted == 1) then return 0 end

  return self.Audio.play(self.SoundFolder.."/"..relativeFilePath, 1, panning, volume)
end

function AudioSystem:PlayAreaAmbience(relativeFilePath, volume, panning, isMuted)
  self.CurrentAmbienceSoundHandle = self:PlayLooped(relativeFilePath, volume, panning, isMuted)
  return self.CurrentAmbienceSoundHandle
end

function AudioSystem:PlayMusic(relativeFilePath, volume, panning, isMuted)
  self.CurrentMusicSoundHandle = self:PlayLooped(relativeFilePath, volume, panning, isMuted)
  return self.CurrentMusicSoundHandle
end

function AudioSystem:GetCurrentAmbienceSoundHandle()
  return self.CurrentAmbienceSoundHandle
end

function AudioSystem:GetCurrentMusicSoundHandle()
  return self.CurrentMusicSoundHandle
end

function AudioSystem:SetVolume(volume, soundHandle)
  self.Audio.setVol(volume, soundHandle)
end

function AudioSystem:IsPlaying(soundHandle)
  return self.Audio.isPlaying(soundHandle) == 1
end

function AudioSystem:Stop(soundHandle)
  if ((tonumber(soundHandle) ~= nil) and (self.Audio.isPlaying(soundHandle) == 1)) then
    self.Audio.stop(soundHandle)
  end
if (tonumber(self.CurrentAmbienceSoundHandle) == tonumber(soundHandle)) then
    self.CurrentAmbienceSoundHandle = 0  
elseif (tonumber(self.CurrentMusicSoundHandle) == tonumber(soundHandle)) then
    self.CurrentMusicSoundHandle = 0
  end
end

return AudioSystem