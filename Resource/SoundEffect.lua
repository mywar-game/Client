SoundEffect={}

function SoundEffect.playSoundEffect(sound_name)
    if not isNotPlaySound() then --音效开
        local path = "sound/"..sound_name..".mp3"
		local effectPath=cc.FileUtils:getInstance():fullPathForFilename(path)
		cc.SimpleAudioEngine:getInstance():playEffect(effectPath)
    end
end

local loopSound = {}
function SoundEffect.playLoopSoundEffect(sound_name)
    if not isNotPlaySound() then --音效开
		local path = "sound/"..sound_name..".mp3"
		local effectPath=cc.FileUtils:getInstance():fullPathForFilename(path)
		local soundId = cc.SimpleAudioEngine:getInstance():playEffect(effectPath,true)
		loopSound[sound_name] = soundId
    end
end

function SoundEffect.stopLoopSoundEffect(sound_name)
    if not isNotPlaySound() then --音效开
		cc.SimpleAudioEngine:getInstance():stopEffect(loopSound[sound_name])
    end
end

--技能音效
local skillSound = {}
function SoundEffect.playSkillSound(sound_name)
    if not isNotPlaySound() then --音效开
        local path = "res/sound_skill/y"..sound_name..".mp3"
		local effectPath = cc.FileUtils:getInstance():fullPathForFilename(path) 
		local soundId = skillSound[sound_name]
		if soundId == nil then
			soundId = cc.SimpleAudioEngine:getInstance():playEffect(effectPath)
		elseif not cc.SimpleAudioEngine:getInstance():isEffectPlaying(soundId) then
			soundId = cc.SimpleAudioEngine:getInstance():playEffect(effectPath)
		end
		skillSound[sound_name] = soundId
    end
end

--背景
function SoundEffect.playBgMusic(sound_name)
	if not isNotPlayBg() then
		local mainBGMusicPath = cc.FileUtils:getInstance():fullPathForFilename("sound/"..sound_name..".mp3")
		cc.SimpleAudioEngine:getInstance():playMusic(mainBGMusicPath,true)
	else
		cc.SimpleAudioEngine:getInstance():stopMusic(true)
	end
end

function SoundEffect.stopBgMusic()
	cc.SimpleAudioEngine:getInstance():stopMusic(true)
end

function SoundEffect.pauseBackgroundMusic()
	cc.SimpleAudioEngine:getInstance():pauseMusic()
end

function SoundEffect.resumeBackgroundMusic()
	cc.SimpleAudioEngine:getInstance():resumeMusic()
end

function SoundEffect.setBackgrouondMusicVolume(volume)
	cc.SimpleAudioEngine:getInstance():setMusicVolume(volume)
end

function SoundEffect.setEffectsVolume(volume)
	cc.SimpleAudioEngine:getInstance():setEffectsVolume(volume)
end
