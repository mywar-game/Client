local winSize = Director.getRealWinSize()
local current_count = #DataManager.getSystemMessageClient()
local current_index =1
local targetHeight = winSize.height - 150
local targetWidth = winSize.width/2


Marquee={
    status=false,
	visible = false,
    data = {},
	default = DataManager.getSystemMessageClient(),
}

function Marquee.pushData(msg)
    local msg = msg or ""
    table.insert(Marquee.data, msg)
end

local function hideSpriteBg()
	local actionArr = {}
	actionArr[1] = cc.MoveTo:create(0.5, cc.p(- Marquee.bottomSize.width - targetWidth, targetHeight))
	actionArr[2] = cc.Hide:create()
	actionArr[3] = cc.CallFunc:create(function() Marquee.status = "available" end)
	Marquee.bgSpirte:runAction(cc.Sequence:create(actionArr))
end

local function showOneNotify()
		local data = Marquee.data
	    local txts = table.remove(data,1)
        local txt_sprite = CreateBlankCCSprite()
        txt_sprite:setPosition(winSize.width, targetHeight)
        txt_sprite:setAnchorPoint(cc.p(0.0,0.5))
        Marquee.layer:addChild(txt_sprite, 10)
		
        local width = 0 --20*string.len(txt)
        local height = -1 
        for k,v in ipairs(txts) do
            local color = v.cor or {r=255,g=255,b=255}
			local str = string.gsub(v.txt, "\n", "")
            local tmp = CreateLabel(str, nil, 20, cc.c3b(color.r,color.g,color.b), 0)
            if height == -1 then
                height = tmp:getContentSize().height
            end
			tmp:setAnchorPoint(cc.p(0, 0.5))
            tmp:setPositionX(width)
            width = width + tmp:getContentSize().width
            txt_sprite:addChild(tmp)
        end
        local txt_spriteSize = txt_sprite:getContentSize()
                
		local actionArr = {}
        actionArr[1] = cc.MoveTo:create(0.5, cc.p(targetWidth - Marquee.bottomSize.width/2 + 10, targetHeight))
		actionArr[2] = cc.DelayTime:create(3)
		actionArr[3] = cc.MoveTo:create(2, cc.p(-width, targetHeight))
		actionArr[2] = cc.DelayTime:create(1)
		actionArr[4] = cc.CallFunc:create(function()
			    hideSpriteBg()
		end)		
		txt_sprite:runAction(cc.Sequence:create(actionArr))
		Marquee.txtSprite = txt_sprite
end

function Marquee.Run()
    if Marquee.status == "occupated" then
        return
    end
	
	local data = Marquee.data
    if #data >0 then
        Marquee.status = "occupated"
		if nil ~= Marquee.txtSprite then
			Marquee.txtSprite:stopAllActions()
			Marquee.txtSprite:removeFromParent()
			Marquee.txtSprite = nil
		end
		Marquee.bgSpirte:stopAllActions()
		Marquee.bgSpirte:setPosition(cc.p(winSize.width, targetHeight))
		local actionArr = {}
		actionArr[1] = cc.Show:create()
		actionArr[2] = cc.MoveTo:create(0.5, cc.p(targetWidth, targetHeight))
		actionArr[3] = cc.DelayTime:create(1)
		actionArr[4] = cc.CallFunc:create(function(pSender)
			showOneNotify()
		end)
		Marquee.bgSpirte:runAction(cc.Sequence:create(actionArr))
    end
end

function Marquee.Init()
    local h = winSize.height
    local w = winSize.width
    local layer = cc.Layer:create()
    layer:setPosition(0,0)
	
    local templatePic = CreateCCSprite(IconPath.tongyong.."i_paomatingbgg.png")
    templatePic:setAnchorPoint(cc.p(0.5,0.5))
    Marquee.bgSpirte = templatePic
	Marquee.bgSpirte:setVisible(false)
    Marquee.bottomSize = templatePic:getContentSize()
    layer:addChild(templatePic)
	
	Marquee.status = "available"
    Marquee.layer = layer
	Marquee.update_func = Scheduler.ScheduleScriptFunc(Marquee,Marquee.Run,1,false)
    --ScheduleScriptFunc(VirtualServer.System_pushMsg,10,false) --测试用
   
    return layer
end

function Marquee.Close()
    if Marquee.update_func then
        Scheduler.UnscheduleScriptEntry(Marquee.update_func)
    end
    Marquee.layer:removeFromParent()
    Marquee.layer = nil
end

