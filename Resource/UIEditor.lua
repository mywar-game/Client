--MyRequire "lua.configuration"
-- avoid memory leak
collectgarbage("setpause", 100)
collectgarbage("setstepmul", 5000)

function cclog(...)
    if debugtofile then
        local f = io.open(writablePath.."debug.log","a+")
        f:write(string.format(...))
        f:write("\n")
        f:flush()
        f:close()
    else
        print(string.format(...))
    end
end
require("Cocos2d")
require("Director")
require("LayerManager")
require("Debug")
require("Utils")
require("UIUtils")
require("ListRect")
require("UIConfig")
require("Config")
require("ConfigManager")

--MyRequire("Json")
--UI编辑器

local LAYER_NAME = "FightDeployItemUI"
local BG = "editor/7.jpg"

local isMap = false
local baseBG = ""

local winSize = Director.getRealWinSize()
local winWidth = winSize.width
local winHeight = winSize.height

local normalWidth = UIConfig.stageWidth --舞台
local normalHeight = UIConfig.stageHeight

local viewWidth,viewHeight,midscale = Director.getViewSizeScale() --屏幕

if UIConfig.editor then
	viewWidth = UIConfig.stageWidth --屏幕
	viewHeight = UIConfig.stageHeight
end

cclog("viewWidth:"..midscale)
cclog("viewHeight:"..viewHeight)

local midViewWidth = viewWidth/2
local midViewHeight = viewHeight/2

local midNormalWidth = normalWidth/2
local midNormalHeight = normalHeight/2


Color_White={r=255,g=255,b=255}
local sceneGame = cc.Scene:create()
local rootLayer = cc.LayerColor:create(cc.c4b(0,0,0,255))
local layer = cc.Layer:create()
local PATH_ZHANZHEN =  "ui_dazao/"
local PATH_UI ="UI/"
local n_keyCode = 0

function UIEditor(layerName)
	
	if layerName then
        LAYER_NAME = layerName
    end
    require(LAYER_NAME)
	local baseLayer = cc.LayerColor:create(cc.c4b(128,128,128,128))
	baseLayer:setContentSize(cc.size(viewWidth,viewHeight))
	baseLayer:setScale(midscale)
	baseLayer:setPosition(cc.p(winWidth/2-midViewWidth,winHeight/2-midViewHeight))
	rootLayer:addChild(baseLayer,2)
	
	local rectLayer
    local panelName = LAYER_NAME.."PanelData" cclog("panelName:"..panelName)
    local spriteList,txtList,scroll_info = loadstring("return "..panelName.."()")()
    if scroll_info and type(scroll_info) == 'string' then
        scroll_info = json.Decode(scroll_info)
    end
	
	if scroll_info then
		rectLayer = createListRect(scroll_info)
		rectLayer:setPosition(cc.p(scroll_info.x,scroll_info.y))
		layer:addChild(rectLayer,2)
	end
	
    local bg = CreateCCSprite(BG)
    bg:setAnchorPoint(cc.p(0.5,0.5))
    bg:setPosition(midNormalWidth,midNormalHeight)
    layer:addChild(bg)
	
	local baseSprite = CreateCCSprite(baseBG)
    baseSprite:setAnchorPoint(cc.p(0.5,0.5))
    baseSprite:setPosition(midViewWidth,midViewHeight)
    baseLayer:addChild(baseSprite)
   
    local listSprite = {}
    for k,v in ipairs(spriteList) do        
        local pos = v.offset or {x=0,y=0}
		local zorder = v.zorder or 1
        local scale= v.scale
        local hide = v.hide
        local flip = v.flip
        local rota  = v.rota --旋转
        local color = v.color --通道混合
        local btn = v.btn
        local pic = v.pic
        local tmp_pic
        if btn then            
            tmp_pic = CreateCCSprite(btn.n)
            tmp_pic:setPosition(midNormalWidth+pos.x,midNormalHeight+pos.y)
            layer:addChild(tmp_pic,zorder)
	
			if pic == '' then
				pic = btn.n
			end
        end
			
        local uisprite 
        local btn = v.btn
        local uisprite = CreateCCSprite(pic)
        uisprite:setPosition(midNormalWidth+pos.x,midNormalHeight+pos.y)
        if scale then --缩放
            if scale.x then
                uisprite:setScaleX(scale.x)
            end
            if scale.y then
                uisprite:setScaleY(scale.y)
            end
        end
        if hide and hide==1 then
            uisprite:setVisible(false)
        end
        if flip then
            if flip.x then
                uisprite:setFlipX(true)
            end
            if flip.y then
                uisprite:setFlipY(true)
            end
        end
        if rota then
            uisprite:setRotation(rota)
        end
        if color then
            uisprite:setColor(cc.c3b(color.r,color.g,color.b))
        end
--        else
--            local n = btn.n
--            local p = btn.p
--            local d = btn.d
--            uisprite = createMenuItem(n,p,midNormalWidth+pos.x,midNormalHeight+pos.y)
--        end
        table.insert(listSprite,uisprite)
        --progress
        layer:addChild(uisprite,zorder)
		
        local progress  = v.progress
        if progress then
            local pg = cc.ProgressTimer:create(CreateCCSprite(progress.fg))
    		pg:setType(progress.ptype)
    		pg:setMidpoint(CCPoint(0, 1))
    		pg:setBarChangeRate(CCPoint(1, 0))
    		pg:setPosition(midNormalWidth+pos.x,midNormalHeight+pos.y)
    		pg:setPercentage(progress.percent)
            layer:addChild(pg)
            uisprite.pg = pg
        end
        
        if btn then
            uisprite.btn = tmp_pic
        end
		
		--sprite 锁住
		local size = uisprite:getContentSize()
		if size.width > 100 and size.height > 100 then
			local function lockFunc(btn)
				for k,v in pairs(listSprite)do
					if v.lockBtn and v.lockBtn.tag == btn.tag then
						v.isLock = not v.isLock 
						local imgPath = v.isLock and "editor/closed.png" or "editor/open.png" 
						local texture = CCTextureCache:getInstance():addImage(imgPath)
						v.lockSprite:setTexture(texture)
						break
					end
				end
			end
			
			local lockSprite = CreateCCSprite("editor/open.png")
			lockSprite:setPosition(cc.p(size.width-26,size.height-33))
			uisprite.lockSprite = lockSprite
			uisprite:addChild(lockSprite)
			
			local lockBtn = createMenuItem("editor/touming.png","editor/touming.png",size.width-26,size.height-33,lockFunc)
			uisprite.lockBtn = lockBtn
			lockBtn.tag = #listSprite+1
			uisprite:addChild(lockBtn)
			
			uisprite.isLock = false
		end
		
    end
    local color =cc.c3b(255,255,255)
    local listtxt = {}
    for k,v in ipairs(txtList) do
        local color = v.color or Color_White
        local align = v.align or 3
		local zorder = v.zorder or 1
        local size = v.size
        local atlas = v.atlas
        local uisprite
		if align == nil then
			align=1
		end
        if atlas then
            uisprite = cc.LabelBMFont:create(v.txt,atlas.fnt) --CCLabelAtlas:create(v.txt,atlas.pic,atlas.w,atlas.h,atlas.startat)
            if align then
                if align==1 then --左对齐
                    uisprite:setAnchorPoint(cc.p(0,0.5))
                elseif align==2 then --右对齐
                    uisprite:setAnchorPoint(cc.p(1,0.5))
                elseif align==3 then --居中对齐
                    uisprite:setAnchorPoint(cc.p(0.5,0.5))
                end
            end
        else
            uisprite= CreateLabel(v.txt,nil,size,cc.c3b(color.r,color.g,color.b),align) 
        end
        local pos = v.offset or {x=0,y=0}
        local hide = v.hide --是否隐藏
        local btn = v.btn
        local dimension = v.dimension
        if hide and hide==1 then
            uisprite:setVisible(false)
        end
     
        if btn then
            local button = createMenuItem(btn.n, btn.p,midNormalWidth+pos.x,midNormalHeight+pos.y)
            layer:addChild(button)
            layer:reorderChild(uisprite,zorder)
            uisprite.btn = button
        end

        if dimension and (not atlas)  then
            uisprite:setDimensions(cc.size(dimension.w,dimension.h))
            if dimension.ap then
                uisprite:setAnchorPoint(cc.p(dimension.ap.x,dimension.ap.y))
            end
        end
		
		local size = uisprite:getContentSize()
		local txtLayer = cc.LayerColor:create(cc.c4b(0,0,0,0))
		txtLayer:setContentSize(size)
		layer:addChild(txtLayer,zorder)
		txtLayer.align = align
		
		if align then
			if align==1 then --左对齐
				txtLayer:setPosition(midNormalWidth+pos.x,midNormalHeight+pos.y-size.height/2)
			elseif align==2 then --右对齐
				txtLayer:setPosition(midNormalWidth+pos.x+size.width/2,midNormalHeight+pos.y-size.height/2)
			elseif align==3 then --居中对齐
				txtLayer:setPosition(midNormalWidth+pos.x-size.width/2,midNormalHeight+pos.y-size.height/2)
			end
		end
		
        table.insert(listtxt,txtLayer)
        if btn then
            local n = btn.n
            local p = btn.p
            local d = btn.d
            local tmp_pic = CreateCCSprite(n) --createMenuItem(n,p,midWidth+pos.x,midHeight+pos.y)
            tmp_pic:setPosition(midNormalWidth+pos.x,midNormalHeight+pos.y)
            layer:addChild(tmp_pic)
            uisprite.btn = tmp_pic
        end
		
		uisprite:setAnchorPoint(cc.p(0.5,0.5))
        uisprite:setPosition(cc.p(size.width/2,size.height/2))
		txtLayer:addChild(uisprite)   
            
    end
    
    local function btnFunc() 
        local f = io.open(string.format("%s.lua",LAYER_NAME),"w")
        f:write(string.format("function %sPanelData()\n",LAYER_NAME))
        f:write("\tlocal spriteList={\n")
        for k,v in ipairs(listSprite) do
            local posx,posy = v:getPosition()
            local offsetx = math.floor(posx - midNormalWidth)
            local offsety = math.floor(posy  - midNormalHeight)
			if isMap then
				spriteList[k].offset.x = offsetx+ midNormalWidth
				spriteList[k].offset.y = offsety+ midNormalHeight
			else
				spriteList[k].offset.x = offsetx
				spriteList[k].offset.y = offsety
			end
            f:write(string.format("\t\t%s,\n",tableToStringForUIEditor(spriteList[k])))

            f:flush()
        end
        f:write("\t}\n")
        f:flush()
        f:write("\tlocal txtList={\n")
        for k,v in ipairs(listtxt) do
			local contentSize = v:getContentSize()
            local posx,posy = v:getPosition()
            local offsetx = posx - midNormalWidth
            local offsety = posy  - midNormalHeight + contentSize.height/2
            local tmp = txtList[k]
			local align = v.align or 3
			if align then
				if align==1 then --左对齐
					offsetx = offsetx
				elseif align==2 then --右对齐
					offsetx = offsetx + contentSize.width
				elseif align==3 then --居中对齐
					offsetx = offsetx + contentSize.width/2
				end
			end
            tmp.offset.x = math.floor(offsetx)
            tmp.offset.y = math.floor(offsety)
            f:write(string.format("\t\t%s,\n",tableToStringForUIEditor(tmp)))
            f:flush()
        end
        f:write("\t}\n")
        
        if scroll_info then --有滚动
            f:write("\tlocal scroll_info=")
			if rectLayer then
				local posx,posy = rectLayer:getPosition()
				scroll_info.x = math.floor(posx)
				scroll_info.y = math.floor(posy)
			end
			
            f:write(string.format("%s\n",tableToStringForUIEditor(scroll_info)))
            f:write("\t\n")
            f:write("\treturn spriteList,txtList,scroll_info\n")
        else
            f:write("\treturn spriteList,txtList\n")
        end
        f:write("end")
        f:flush()
        f:close()
        Tips("保存成功")
    end
    rootLayer:addChild(createMenuItem("ui_editor/btn_2.png", "ui_editor/btn_1.png",winSize.width-50,150,btnFunc),1024)
	local save = CreateLabel("保存",nil,20,cc.c3b(255,0,0))
    save:setPosition(winSize.width-50,150)
    rootLayer:addChild(save,1024)


    local tips_txt = CreateLabel("坐标:",nil,nil,nil,0)  
    tips_txt:setPosition(50,240)
    layer:addChild(tips_txt)
    local chosenSprite
    local preChosenSprite -- 上一个选中的
    local function ontouch(eventType,x,y)
		local pt = layer:convertToNodeSpace(cc.p(x,y))
		x = pt.x
		y = pt.y
        if eventType == "began" then 
			 for k=#listtxt,1,-1 do
				local v = listtxt[k]
                local contentSize = v:getContentSize()
                local posx,posy = v:getPosition()
                local midw =  contentSize.width/2
                local midh = contentSize.height/2
                if math.abs(x-posx-midw)<midw and math.abs(y-posy-midh) <midh then
                    chosenSprite = v
                    touchBeginPoint = {x = x, y = y}
                    return true
                end
            end
			
             for k=#listSprite,1,-1 do
				local v = listSprite[k]
                local contentSize = v:getContentSize()
                local posx,posy = v:getPosition()
                local midw = contentSize.width/2
                local midh = contentSize.height/2
                if math.abs(x-posx)<midw and math.abs(y-posy) <midh and (not v.isLock) then
					chosenSprite = v
					touchBeginPoint = {x = x, y = y}
					return true
                end
            end
            
			if rectLayer then
				local contentSize = rectLayer:getContentSize()
                local posx,posy = rectLayer:getPosition()
                local midw =  contentSize.width/2
                local midh = contentSize.height/2
				if math.abs(x-posx-midw)<midw and math.abs(y-posy-midw) <midh then
					chosenSprite = rectLayer
					touchBeginPoint = {x = x, y = y}
					return true
				end
			end
				
            if chosenSprite then
                local tmp_x,tmp_y = chosenSprite:getPosition()
                tips_txt:setString(string.format("坐标x:%d,y:%d",tmp_x,tmp_y ))

                chosenSprite:setColor(cc.c3b(255,0,0))
            end

            --标注是哪个精灵选中
            if preChosenSprite then
                if preChosenSprite ~= chosenSprite then
                    preChosenSprite:setColor(cc.c3b(255,255,255))
                    preChosenSprite = chosenSprite
                end
            else
                preChosenSprite = chosenSprite
            end

            return true
        elseif eventType == "moved" then
            if touchBeginPoint then
                local cx, cy = chosenSprite:getPosition()
                chosenSprite:setPosition(cx + x - touchBeginPoint.x,
                                      cy + y - touchBeginPoint.y)                
                if chosenSprite.btn then
                    chosenSprite.btn:setPosition(cx + x - touchBeginPoint.x,
                                      cy + y - touchBeginPoint.y)
                end
                if chosenSprite.pg then
                    chosenSprite.pg:setPosition(cx + x - touchBeginPoint.x,
                                      cy + y - touchBeginPoint.y)
                end
                touchBeginPoint = {x = x, y = y}
                if chosenSprite then
                    local tmp_x,tmp_y = chosenSprite:getPosition()
                    tips_txt:setString(string.format("坐标x:%d,y:%d",tmp_x,tmp_y ))
                end
            end
        else
            touchBeginPoint = nil
        end
        return true
    end

	baseLayer:registerScriptTouchHandler(ontouch)
    baseLayer:setTouchEnabled(true)
	layer:setPosition(cc.p(midViewWidth-midNormalWidth,midViewHeight-midNormalHeight))
	baseLayer:addChild(layer)
    sceneGame:addChild(rootLayer)
    Director.runScene(sceneGame)
		
	local function tomove(i,len)
		local offsetx=0
		local offsety = 0
		if i == 1 then --left
			offsetx=-len
		elseif i ==2 then --right
			offsetx=len
		elseif i == 3 then --top
			offsety = len
		elseif i == 4 then --buttom
			offsety = -len
		end
		
		if chosenSprite then
			 local x,y = chosenSprite:getPosition()
			 local tox = x+offsetx
			 local toy = y+offsety
			 chosenSprite:setPosition(tox,toy)                
			if chosenSprite.btn then
				chosenSprite.btn:setPosition(tox,toy)
			end
			if chosenSprite.pg then
				chosenSprite.pg:setPosition(tox,toy)
			end
			tips_txt:setString(string.format("坐标x:%d,y:%d",tox,toy ))
		end
    end
	
    local function onEnter()
        local function onKeyPressed(keyCode, event)
			if keyCode == 143 then
				tomove(3,10)
				cclog("w")
			elseif keyCode == 25 then --上
				tomove(3,1)
				cclog("w")
			elseif keyCode == 121 then
				cclog("a")
				tomove(1,10)
			elseif keyCode == 23 then --左
				tomove(1,1)
			elseif keyCode == 144 then
				tomove(4,10)
				cclog("s")
			elseif keyCode == 26 then --下
				tomove(4,1)
			elseif keyCode == 124 then
				tomove(2,10)
				cclog("d")
			elseif keyCode == 24 then --右
				tomove(2,1)
			end
			
			if keyCode == 13 then
				n_keyCode = keyCode
			end
        end
		
		local function onKeyReleased(keyCode, event)
			if n_keyCode == 13 and keyCode == 139 then
				n_keyCode = 0
				btnFunc()
			end
		end

        local listener = cc.EventListenerKeyboard:create()
        listener:registerScriptHandler(onKeyPressed,38)
		listener:registerScriptHandler(onKeyReleased,39)
		
        local eventDispatcher = layer:getEventDispatcher()
        eventDispatcher:addEventListenerWithSceneGraphPriority(listener,layer)
    end

    local function onNodeEvent(event)
        if event == "enter" then
            onEnter()
        end
    end
	
    layer:registerScriptHandler(onNodeEvent)
end


function TestUIEditor()
    local sceneGame = CCScene:create()
    local panelName = LAYER_NAME.."PanelData" cclog("panelName:"..panelName)
    local spriteList,txtList = loadstring("return "..panelName.."()")()
    local layer = cc.Layer:create()
    for k,v in ipairs(spriteList) do
        local uisprite = CreateCCSprite(v.pic)
        local pos = v.offset or {x=0,y=0}
        local scale= v.scale
        local hide = v.hide
		local zorder = v.zorder or 1
        uisprite:setPosition(midNormalWidth+pos.x,midNormalHeight+pos.y)
        if scale then --缩放
            if scale.x then
                uisprite:setScaleX(scale.x)
            end
            if scale.y then
                uisprite:setScaleY(scale.y)
            end
        end
        if hide==1 then
            uisprite:setVisible(false)
        end
        layer:addChild(uisprite,zorder)
    end
    local color = cc.c3b(255,255,255)
    for k,v in ipairs(txtList) do
        local color = v.color or Color_White
        local align = v.align
        local size = v.size
        local uisprite = CreateLabel(v.txt,nil,size,cc.c3b(color.r,color.g,color.b),align) 
        local pos = v.offset or {x=0,y=0}
        local hide = v.hide --是否隐藏
		local zorder = v.zorder or 1
        uisprite:setPosition(midNormalWidth+pos.x,midNormalHeight+pos.y)
        if hide==1 then
            uisprite:setVisible(false)
        end
        layer:addChild(uisprite,zorder)
    end
    sceneGame:addChild(rootLayer)
    Director.runScene(sceneGame)
end

function __G__TRACKBACK__(msg)
    print("\n\n\n----------------------------------------")
    print("LUA ERROR: " .. tostring(msg) .. "\n")
    print(debug.traceback())
    print("----------------------------------------\n\n\n")
end

xpcall(UIEditor,__G__TRACKBACK__)