------------------------------------------
-- 文件名称:    JumpFilter.lua
-- 文件标识:   
-- 内容摘要:    跳转过滤器，如果返回值为true，则全部的jump不执行，执行此程序中的jump
-- 其它说明:
------------------------------------------
require "Scheduler"
require "Config"
require("UIUtils")
require "ConfigManager"

--声音
local eSoundType = 0
function JumpFilter_soundJumpFilter(targetPanelName)
	if targetPanelName=="FightUIPanel" then
		if eSoundType ~= 2 then
			eSoundType = 2
			FightBGMusic()
		end
	else
		if eSoundType ~= 1 then
			eSoundType = 1
			MainBGMusic()
		end
	end
	return nil
end
