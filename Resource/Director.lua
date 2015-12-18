require("UIConfig")

Director = {}

local current_scene 
local director = cc.Director:getInstance()
local scheduler = director:getScheduler()
local winSize 

function Director.runScene(scene)
	local runingScene = director:getRunningScene()
	if not runingScene then
		director:runWithScene(scene)
	else
        director:replaceScene(scene)
	end
    current_scene = scene
end

--获取舞台区域长宽
function Director.getStageSize()
	return UIConfig.stageSize
end

--[[function Director.getHeightOffY()
	if not winSize then
		Director.getViewSizeScale()
	end
	return winSize.offY
end

function Director.getWidthOffX()
	if not winSize then
		Director.getViewSizeScale()
	end
	return winSize.offX
end]]

function Director.getScalePanel()
	if not winSize then
		Director.getViewSizeScale()
	end
	return winSize.scalePanel
end

function Director.getScaleX()
	if not winSize then
		Director.getViewSizeScale()
	end
	return winSize.scaleX
end

function Director.getViewSizeScale()
    if not winSize then
    	winSize = director:getWinSize()
    	local winWidth = winSize.width
    	local winHeight = winSize.height
		
    	local normalWidth = UIConfig.stageWidth --舞台
    	local normalHeight = UIConfig.stageHeight
		
    	winSize.scaleX = winWidth / normalWidth
    	winSize.scaleY = winHeight / normalHeight
		
		--[[local offY = 0
		if winHeight > normalHeight then
			offY = (winHeight - normalHeight)/2
		end
		winSize.offY = offY
		
        local offX = 0
        if winWidth > normalWidth then
           offX = (winWidth - normalWidth)/2
        end
       winSize.offX = offX]]
    end
	return winSize
end

function Director.getRealWinSize()
    return director:getWinSize()
end

function Director.getScheduler()
    return scheduler
end

function Director.exitGame()
    director:endToLua()
end

Director.sharedDirector = function()
    error("please not use ccDirector.sharedDirector directly")
end

