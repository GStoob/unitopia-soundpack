function PlaySound(sound, volume, panning)
  volume = volume or UserConfig.Settings.SoundVolume
  panning = panning or 0

  return Audio:Play(sound, volume, panning, UserConfig.Settings.SoundsMuted)
end

function PlayLoopedSound(sound, volume, panning)
  volume = volume or UserConfig.Settings.SoundVolume
  panning = panning or 0

  return Audio:PlayLooped(sound, volume, panning, UserConfig.Settings.SoundMuted)
end

function PlayAmbienceLoop(sound, volume)
  volume = volume or UserConfig.Settings.AmbienceVolume

  return Audio:PlayLooped(sound, volume, 0, UserConfig.Settings.AmbienceMuted)
end

function PlayMusic(musicFile, volume)
  volume = volume or UserConfig.Settings.MusicVolume
  return Audio:PlayLooped(musicFile, volume, 0, UserConfig.Settings.MusicMuted)
end

function SetSoundVolume(increment)
  if UserConfig.Settings.SoundVolume + increment <= 100 and UserConfig.Settings.SoundVolume + increment >= 0 then
    UserConfig.Settings.SoundVolume = UserConfig.Settings.SoundVolume + increment
    PlaySound("Misc/Switch.ogg")
    world.Note("Lautstaerke fuer Sounds: " .. tostring(UserConfig.Settings.SoundVolume) .. "%.")
  else
    if UserConfig.Settings.SoundVolume + increment > 100 then
      world.Note("Das Maximum fuer die Sound-Lautstaerke wurde erreicht.")
    elseif UserConfig.Settings.SoundVolume + increment < 0 then
      world.Note("Das Minimum fuer die Sound-Lautstaerke wurde erreicht.")
    end
    PlaySound("Misc/Error.ogg")
  end
end

function SetAmbienceVolume(increment)
  if UserConfig.Settings.AmbienceVolume + increment <= 100 and UserConfig.Settings.AmbienceVolume + increment >= 0 then
    UserConfig.Settings.AmbienceVolume = UserConfig.Settings.AmbienceVolume + increment
    PlaySound("Misc/Switch.ogg")
    world.Note("Lautstaerke fuer Umgebung: " .. tostring(UserConfig.Settings.AmbienceVolume) .. "%.")

    if tonumber(CurrentAmbienceBeingPlayed) ~= nil and Audio:IsPlaying(CurrentAmbienceBeingPlayed) then
      Audio:SetVolume(UserConfig.Settings.AmbienceVolume, CurrentAmbienceBeingPlayed)
    end
    else
      if UserConfig.Settings.AmbienceVolume + increment > 100 then
        world.Note("Das Maximum für die Umgebungs-Lautstaerke wurde erreicht.")
      elseif UserConfig.Settings.AmbienceVolume + increment < 0 then
        world.Note("Das Minimum für die Umgebungs-Lautstaerke wurde erreicht.")
      end
      PlaySound("Misc/Error.ogg")
    end
end

function SetMusicVolume(increment)
    if UserConfig.Settings.MusicVolume + increment <= 100 and UserConfig.Settings.MusicVolume + increment >= 0 then
      UserConfig.Settings.MusicVolume = UserConfig.Settings.MusicVolume + increment
      PlaySound("Misc/Switch.ogg")
      world.Note("Lautstaerke fuer Hintergrundmusik: " .. tostring(UserConfig.Settings.MusicVolume) .. "%.")

      if tonumber(CurrentBackgroundMusicBeingPlayed) ~= nil and Audio:IsPlaying(CurrentBackgroundMusicBeingPlayed) then
        Audio:SetVolume(UserConfig.Settings.MusicVolume, CurrentBackgroundMusicBeingPlayed)
      end
    else
      if UserConfig.Settings.MusicVolume + increment > 100 then
        world.Note("Das Maximum fuer die Hintergrundmusik-Lautstaerke wurde erreicht.")
      elseif UserConfig.Settings.MusicVolume + increment < 0 then
        world.Note("Das Minimum fuer die Hintergrundmusik-Lautstaerke wurde erreicht.")
      end
      PlaySound("Misc/Error.ogg")
    end
end

function ToggleMute()
  if UserConfig.Settings.SoundsMuted == 0 and UserConfig.Settings.AmbienceMuted == 0 and
    UserConfig.Settings.MusicMuted == 0 then
    PlaySound("Misc/Switch.ogg")
    UserConfig.Settings.SoundsMuted = 1
    UserConfig.Settings.AmbienceMuted = 1
    UserConfig.Settings.MusicMuted = 1

    Audio:StopIfPlaying(CurrentAmbienceBeingPlayed)
    Audio:StopIfPlaying(CurrentBackgroundMusicBeingPlayed)
    world.Note("Soundpack komplett stummgeschaltet.")
  else
    UserConfig.Settings.SoundsMuted = 0
    UserConfig.Settings.AmbienceMuted = 0
    UserConfig.Settings.MusicMuted = 0
    world.Note("Stummschaltung aufgehoben.")
    PlaySound("Misc/Switch.ogg")
  end
end

function PlayRandomSound(path, volume, panning)
  local sound = SoundIndex:Random(path)
  if sound ~= nil then
    PlaySound(sound, volume, panning)
  end
end