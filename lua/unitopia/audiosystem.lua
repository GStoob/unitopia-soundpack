local class = require("pl.class")
local ppi = require("ppi")
local constants = require("unitopia.constants")

class.AudioSystem()

function AudioSystem:_init()
  self.Audio = nil
  self.SoundFolder = world.GetInfo(74) -- Points to the MUSHclient/sounds directory
end

function AudioSystem:InitializeLuaAudio()
  local audio = ppi.Load(constants.Plugins.AUDIO_PLUGIN_ID)

  if not audio then
    error("An unexpected error has occurred. Failed to initialize the audio system")
    return
  end
  self.Audio = audio
end

function AudioSystem:Play(relativeFilePath, volume, panning, isMuted)
  if isMuted == 1 then return 0 end

  return self.Audio.play(self.SoundFolder.."/"..relativeFilePath, 0, panning, volume)
end

function AudioSystem:PlayLooped(relativeFilePath, volume, panning, isMuted)
  if isMuted == 1 then return 0 end

  return self.Audio.play(self.SoundFolder.."/"..relativeFilePath, 1, panning, volume)
end

function AudioSystem:SetVolume(volume, soundHandle)
  soundHandle = tonumber(soundHandle)
  self.Audio.setVol(volume, soundHandle)
end

function AudioSystem:IsPlaying(soundHandle)
  return self.Audio.isPlaying(soundHandle) == 1
end

function AudioSystem:StopIfPlaying(soundHandle)
  if soundHandle == nil then return end
  
  soundHandle = tonumber(soundHandle)
  
  if self:IsPlaying(soundHandle) then
    self:Stop(soundHandle)
  end
end

function AudioSystem:Stop(soundHandle)
  self.Audio.stop(soundHandle)
end

function AudioSystem:FadeOut(soundHandle, durationMilliseconds)
  if self:IsPlaying(soundHandle) then
    audio.fadeout(soundHandle, durationMilliseconds)
  end
end

return AudioSystem