--aloha
--aloha.wuhui@gmail.com
--[[--
本类负责解析结构化界面
结构化界面中主要包括两类元素pic和txt两种基本元素
pic为图片类控件，包括单张图片，图片按钮，输入框，进度条
所有的pic作为成员变量，构成spriteList
txt为文本类控件，包括纯文件，文字标签，及文字按钮（按钮图片为默认图片）
所有的txt作为成员变量，构成txtList
结构化界面中，通过item=1标识，可将pic和txt组织成列表项，
列表的长，宽，坐标，滑动条，列表滑动方向等信息由scroll_info描述
--]]--

require("UIConfig")
require("cocos2d/Cocos2dConstants")
require("SliderBar")

local midWidth = UIConfig.stageWidth/2--舞台
local midHeigth = UIConfig.stageHeight/2
local viewWidth,viewHeight,midscale,viewOffY,viewOffX,viewScaleX = Director.getViewSizeScale() --可视区域

local Color_White={r=255,g=255,b=255}

Panel={}
function Panel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

--初始化图片类控件
--属性字段包括
--[[--
offset      坐标偏移，默认为元素中心点，相对于屏幕左下角偏移
offset.x    相对于屏幕左下角的水平方向偏移值
offset.y    相对于屏幕左下角的竖直方向偏移值
comment     注释
pic         图片
btn         图片描述，按钮生成控件后，控件名称为原始name属性值与"_btn"做字符串连接
btn.p       按钮按下状态
btn.d       按钮不可点击状态
btn.n       按钮正常状态
name        控件名称
scale       缩放属性
hide        是否显示
zorder      z轴值
rota        旋转
color       颜色值
flip        翻转
input       该字段存在且不为false,则表示本控件为输入框
progress    进度条，进度条控件生成后，控件名称为原始name属性值与"_frontground"作字符串连接
progress.percent    进度条百分比
progress.fg         进度条前景
progress.ptype      进度后类型

参数说明：
v 表示View对象
item为ListView 或者 GridView中的数据项
--]]--
function Panel:parseImg(v,x,y,layer,item)
    local btn = v.btn
    local hide = v.hide
    local pos = v.offset or {x=0,y=0}
	local button
	local uisprite
    if btn then
        local n = btn.n
        local p = btn.p
        local d = btn.d
		if d then
			button = createMenuItem(n, p,midWidth+pos.x,midHeigth+pos.y, nil, nil, d)
		else
			button = createMenuItem(n, p,midWidth+pos.x,midHeigth+pos.y)
		end              
        if v.zorder then
            self.layer:reorderChild(button,v.zorder) 
        end
        if btn.scale then --缩放
           button:setScale(btn.scale)
           button:setAnchorPoint(cc.p(0,0))
           -- button:setPosition(cc.p((midWidth+pos.x)*btn.scale,(midHeigth+pos.y)*btn.scale))
        end
        --按钮生成控件后，名称为原始pic的name属性值与"_btn"做字段串连接    
        if hide == 1 then
            button:setVisible(false)
        end
    end
    if v.pic ~='' then
        local scale= v.scale
        local zorder = v.zorder
        local rota = v.rota
        local color = v.color
        local flip = v.flip
		uisprite = CreateCCSprite(v.pic)
        if not x then --传递坐标
            uisprite:setPosition(midWidth+pos.x,midHeigth+pos.y)
        else
            uisprite:setPosition(x,y)
        end
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
        
        if rota then
            uisprite:setRotation(rota)
        end
        if color then
            uisprite:setColor(cc.c3b(color.r,color.g,color.b))
        end
        if flip then
            if flip.x then
                uisprite:setFlipX(true)
            end
            if flip.y then
                uisprite:setFlipY(true)
            end
        end
    end
	return uisprite,button
end

--初始化文字类控件
--属性字段包括
--[[--
offset      坐标偏移，默认为元素中心点，相对于屏幕左下角偏移
offset.x    相对于屏幕左下角的水平方向偏移值
offset.y    相对于屏幕左下角的竖直方向偏移值
comment     注释
color       文字颜色值
align       水平对齐方式, 0左对齐，1居中对齐，2右对齐。垂直方向固定为居中对齐
atlas       文字标签
atlas.fnt   文字标签资源文件
dimension   文字区域宽度
font        字体
hide        是否显示
zorder      z轴值
name        控件名称
btn         图片描述，按钮生成控件后，控件名称为原始name属性值与"_btn"做字符串连接
btn.p       按钮按下状态
btn.n       按钮正常状态
scale9 		适配列表背景
allAdapt  适配列表  
--]]--
function Panel:parseTxt(v)
    local color = v.color or Color_White
    local align = v.align or 3
    local txt = v.txt or ""
	local size = v.size
    local dimension = v.dimension
    local font = nil    
    if dimension then --设置限定长宽后用黑体有bug
        font = "Arial"
    end
    local atlas = v.atlas
    local uisprite
    if atlas then
        uisprite = cc.LabelBMFont:create(txt,atlas.fnt)-- or "fight/font/skill_word.fnt") --ccLabelAtlas:create(v.txt,atlas.pic,atlas.w,atlas.h,atlas.startat)
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
        uisprite= CreateLabel(txt,nil,size,cc.c3b(color.r,color.g,color.b),align) 
    end
    local pos = v.offset or {x=0,y=0}
    local hide = v.hide --是否隐藏
    local zorder = v.zorder
    local btn = v.btn
    if not x then --传递坐标
        uisprite:setPosition(midWidth+pos.x,midHeigth+pos.y)
    else
        uisprite:setPosition(x,y)
    end
    if hide==1 then
        uisprite:setVisible(false)
    end
    if dimension and (not atlas)  then
        uisprite:setDimensions(cc.size(dimension.w,dimension.h))
    end
    return uisprite
end
    
function Panel:InitPanelOld(name,cx,cy,isnotbtn) --isnotbtn 去掉关闭
    require(name)
    local panelName = name.."PanelData" 
    local spriteList,txtList,scroll_info= loadstring("return "..panelName.."()")()
	self.scroll_info = scroll_info
	
    local layer = cc.Layer:create()
    self.layer = layer
    local itemList = {}
    --图片控件列表
    local itemSpriteList ={}
    itemList.itemSpriteList = itemSpriteList
    --文本控件列表
    local itemTxtList = {}
    itemList.itemTxtList = itemTxtList
    self.itemList = itemList
    self.is_scroll_view = false
    self.itemOffset = {}
	
	if scroll_info and scroll_info.item_file then
		self:InitItemView(scroll_info.item_file)
	end	
	
	--界面Y适配
	local function setAdaptOffsetY(a,v)
		if a == 1 then
			if v.offset.y < 0 then
				v.offset.y = v.offset.y - viewOffY
			else
				v.offset.y = v.offset.y + viewOffY
			end
		elseif a == 2 then
			v.offset.y = v.offset.y + viewOffY
		elseif a == 3 then
			v.offset.y = v.offset.y - viewOffY
		elseif a == 4 then
			if v.offset.y < 0 then
				v.offset.y = v.offset.y - viewOffY/2
			else
				v.offset.y = v.offset.y + viewOffY/2
			end
		elseif a == 5 then
			v.offset.y = v.offset.y + viewOffY/2
		elseif a == 6 then
			if v.offset.y < 0 then
				v.offset.y = v.offset.y - viewOffY*3/4
			else
				v.offset.y = v.offset.y + viewOffY*3/4
			end
		end
	end
	
	--界面X适配
	local function setAdaptOffsetX(a,v)
		if a == 1 then
			if v.offset.x < 0 then
				v.offset.x = v.offset.x - viewOffX
			else
				v.offset.x = v.offset.x + viewOffX
			end
		elseif a == 2 then
			v.offset.x = v.offset.x + viewOffX
		elseif a == 3 then
			v.offset.x = v.offset.x - viewOffX
		elseif a == 4 then
			if v.offset.x < 0 then
				v.offset.x = v.offset.x - viewOffX/2
			else
				v.offset.x = v.offset.x + viewOffX/2
			end
		elseif a == 5 then
			v.offset.x = v.offset.x + viewOffX/2
		elseif a == 6 then
			if v.offset.x < 0 then
				v.offset.x = v.offset.x - viewOffX*3/4
			else
				v.offset.x = v.offset.x + viewOffX*3/4
			end
		end
	end
	
	--适配横向放缩
	local function setAdaptScale(s,v)
		if not v.scale then
			v.scale = {x=1,y=1}
		end
		if not v.scale.x then
			v.scale.x = 1
		end
		
		if not v.scale.y then
			v.scale.y = 1
		end
		if s == 1 or s == 2 then
			v.scale.x = v.scale.x / midscale * viewScaleX
		end
	end
	
	--适配问题
	local function adaptationListLayer()
		local allAdapt
		if scroll_info then
			allAdapt = scroll_info.allAdapt
		end
		
		for k,v in pairs(spriteList)do
			if v.allAdapt then
				allAdapt = v.allAdapt
				break
			end
		end
		
		for k,v in pairs(txtList)do
			if v.allAdapt then
				allAdapt = v.allAdapt
				break
			end
		end
		
		if allAdapt then
			for k,v in pairs(spriteList) do
				 local item = v.item     --是否为列表项
				 if (not item) and (not v.scale9) then
					setAdaptOffsetY(allAdapt,v)
				 end
			end
			
			for k,v in pairs(txtList) do
				 local item = v.item     --是否为列表项
				 if not item then
					setAdaptOffsetY(allAdapt,v)
				 end
			end
			
			if self.scroll_info then
				if allAdapt == 1 then 
					self.scroll_info.x = self.scroll_info.x - viewOffX
					self.scroll_info.view_w = self.scroll_info.view_w + viewOffX * 2
					self.scroll_info.y = self.scroll_info.y - viewOffY
					self.scroll_info.view_h = self.scroll_info.view_h + viewOffY * 2
				elseif allAdapt == 2 then
					self.scroll_info.x = self.scroll_info.x - viewOffX
					self.scroll_info.view_w = self.scroll_info.view_w + viewOffX * 2
					self.scroll_info.y = self.scroll_info.y + viewOffY
				elseif allAdapt == 3 then
					self.scroll_info.y = self.scroll_info.y - viewOffY
				end
			end
		end
	end
	
	--9.png
	local function Scale9SpriteAddLayer()
		local spriteV
		for k,v in pairs(spriteList)do
			if v.scale9 == 1 then
				spriteV = v
				table.remove(spriteList,k)
				break
			end
		end
		
		if spriteV then
			local tmpSprite = CreateCCSprite(spriteV.pic)
			local tmpSize = tmpSprite:getContentSize()
			local rect = ccRectMake(0,0,tmpSize.width,tmpSize.height)   --图片的大小  
			local rectInsets = ccRectMake(1,1,tmpSize.width-2,tmpSize.height-2) --left，right，width，height  
			local winRect = cc.size(tmpSize.width+viewOffX*2,tmpSize.height+viewOffY*2) --设置要拉伸后的的大小  
			local pNextBG  = ccScale9Sprite:create(spriteV.pic,rect,rectInsets)
			pNextBG:setContentSize(winRect)
			pNextBG:setPosition(spriteV.offset.x+midWidth,spriteV.offset.y+midHeigth)
			self.layer:addChild(pNextBG)
		end
	end
	
	if viewOffX ~= 0 or viewOffY ~= 0 then
		adaptationListLayer()
		Scale9SpriteAddLayer()
	end
	
    --解析图片控件
    local function InitImg(spriteList) 
        for k,v in ipairs(spriteList) do
            local input = v.input   --是否为输入框
			
			if v.singleAdaptX and viewOffX ~= 0 then
				setAdaptOffsetX(v.singleAdaptX,v)
			end
			
			if v.singleAdaptY and viewOffY ~= 0 then
				setAdaptOffsetY(v.singleAdaptY,v)
			end

			if v.singleScale and viewOffX ~= 0 then
				setAdaptScale(v.singleScale,v)
			end
            
			if not input then 
                local uisprite,button = self:parseImg(v)
				local zorder = v.zorder or 0
				if button then
					layer:addChild(button,zorder)
					self[v.name.."_btn"] = button
				end
				if uisprite then
					layer:addChild(uisprite,zorder)
					self[v.name] = uisprite
				end

				local progress = v.progress
				if progress then
					local pg = cc.ProgressTimer:create(CreateCCSprite(progress.fg))
					pg:setType(progress.ptype)
					pg:setMidpoint(cc.p(0, 1))
					pg:setBarChangeRate(cc.p(1, 0))
					pg:setPosition(cc.p(midWidth+v.offset.x,midHeigth+v.offset.y))
					pg:setPercentage(progress.percent)
					layer:addChild(pg,zorder)
					self[v.name.."_frontground"] = pg
				end
            elseif input then 
                local placeHolder = input.place_holder or ""
                local returnType = input.return_type or kKeyboardReturnTypeDone
                local inputFlag = input.input_flag or kEditBoxInputFlagInitialCapsAllCharacters
                local color = input.color or {r=125,g=125,b=125}
                local max_length = input.max_length or 120
                local pic = input.pic or "common/editbox_bg.png"
                local lines = input.lines
                local tmp_sprite = cc.Scale9Sprite:create(v.pic)
                local x = midWidth + v.offset.x
                local y = midHeigth + v.offset.y 
                local tmp_c = tmp_sprite:getContentSize()
                local width = tmp_c.width
                local height = tmp_c.height
                local uisprite = cc.EditBox:create(cc.size(width,height),tmp_sprite)
                uisprite:setPosition(cc.p(x,y))
                uisprite:setPlaceHolder(placeHolder)
                uisprite:setFontColor(cc.c3b(color.r,color.g,color.b))
                uisprite:setInputFlag(inputFlag) 
                uisprite:setReturnType(returnType)
                uisprite:setMaxLength(max_length)
                if lines then
                    uisprite:setLines(lines)
                end
                layer:addChild(uisprite)
                self[v.name] = uisprite
            end
        end
    end
    InitImg(spriteList)
    
    local function InitTxt(txtList)
        for k,v in ipairs(txtList) do
            local item = v.item
			
			if v.singleAdaptX and viewOffX ~= 0 then
				setAdaptOffsetX(v.singleAdaptX,v)
			end
			
			if v.singleAdaptY and viewOffY ~= 0 then
				setAdaptOffsetY(v.singleAdaptY,v)
			end

            if not item then
                local uisprite = self:parseTxt(v)
                local zorder = v.zorder or 0
                layer:addChild(uisprite,zorder)
                self[v.name] = uisprite
           else
                self.is_scroll_view = true
                table.insert(itemTxtList,v)
           end
        end
    end
    InitTxt(txtList) --文本标签 
end

-- scroll_bar 为nil 为默认情况，当数量超过可显示区域则显示滚动条
-- scroll_bar 为   0 则强制不显示滚动条 为1则强制显示
-- 增加OnFocusCallback,OnUnFoucusCallback 函数，用于触摸 释放回调函数 不传则不会处理相应操作
function Panel:InitListViewOld(data,tmp_idx,OnItemShowCallback,OnTouchCallback,listView_offy,scroll_bar,segmentLen,OnFocusCallback,OnUnFocusCallback)
	
	local recordItem = {}
	local scroll_info = self.scroll_info
	local function cellSizeForTable(view,idx)
		local size
		if scroll_info.item_w < scroll_info.item_h then
			size = scroll_info.item_w 
		else			
			size =scroll_info.item_h
		end
		return size,size
	end
	
	local function tableCellTouched(view,cell)
		OnTouchCallback(cell.item,0,0)
	end
	
	local function tableCellAtIndex(view,idx)
		local nIdx = idx + 1
		local cell = recordItem[nIdx]
		if recordItem[nIdx] == nil then
			cell = cc.TableViewCell:new()
			cell.item = {}
			
			local itemLayer = cc.LayerColor:create(cc.c4b(0,0,0,0))
			itemLayer:setContentSize(cc.size(scroll_info.item_w,scroll_info.item_h))
			cell:addChild(itemLayer,-1)
			
			cell.item.itemLayer = itemLayer
			cell.item.data = data[nIdx]
			cell.item.nIdx = nIdx

			for k,v in ipairs(self.itemList.itemSpriteList) do
				local uisprite,button = self:parseImg(v) 
				local zorder = v.zorder or 0
				if button then
					cell:addChild(button,zorder)
					cell.item[v.name.."_btn"] = button
				end
				
				if uisprite then
					cell:addChild(uisprite,zorder)
					cell.item[v.name] = uisprite
				end
			end
			
			for k,v in ipairs(self.itemList.itemTxtList) do
				local uitxt = self:parseTxt(v) 
				local zorder = v.zorder or 0
				cell:addChild(uitxt,zorder)
				cell.item[v.name] = uitxt
			end 
			OnItemShowCallback(view,cell.item,data[nIdx],nIdx)
			recordItem[nIdx] = cell
		end
		return cell
	end
	
	local function numberOfCellsInTableView(view)
		return #data
	end
	
	if self.scroll_view then
		self.scroll_view:removeFromParent(true)
	end
	
	local scroll_view = cc.TableView:create(cc.size(scroll_info.view_w,scroll_info.view_h))
	scroll_view:setDirection(scroll_info.direction) 
	if scroll_info.direction == cc.SCROLLVIEW_DIRECTION_HORIZONTAL then
		scroll_view:setVerticalFillOrder(cc.TABLEVIEW_FILL_BOTTOMUP)
	else
		scroll_view:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	end
	scroll_view:setPosition(cc.p(scroll_info.x,scroll_info.y))
	scroll_view:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
	scroll_view:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
	scroll_view:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
	scroll_view:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
	scroll_view:setDelegate()
	scroll_view:reloadData()
	self.scroll_view = scroll_view
	self.layer:addChild(scroll_view)
end

function Panel:InitItemView(item_file)
	require(item_file)
	self.is_scroll_view = true
	local sList,tList = loadstring("return "..item_file.."PanelData()")()
	self.itemList.itemSpriteList = sList
	self.itemList.itemTxtList = tList
	self.itemList.itemBgScale = true
	
	local scroll_info = self.scroll_info
	for k,v in ipairs(self.itemList.itemSpriteList) do
		if v.name == self.scroll_info.item_bg then
			self.itemOffset.x = scroll_info.item_w/2 - midWidth - v.offset.x
			self.itemOffset.y = scroll_info.item_h/2 - midHeigth - v.offset.y
			break
		end
	end
	
	for k,v in ipairs(self.itemList.itemSpriteList) do
		v.offset.x = v.offset.x + self.itemOffset.x 
		v.offset.y = v.offset.y + self.itemOffset.y
	end
	
	for k,v in ipairs(self.itemList.itemTxtList) do
		v.offset.x = v.offset.x + self.itemOffset.x
		v.offset.y = v.offset.y + self.itemOffset.y
	end
end

--偏移量
function Panel:getListViewOffY()
	if self.scroll_view then
		return self.scroll_view:getContentOffset().y
	else
		return nil
	end
end

function Panel:Hide()
	self.layer:setVisible(false)
	self.layer:setTouchEnabled(false)
end

function Panel:Show()
	self.layer:setVisible(true)
	self.layer:setTouchEnabled(true)
end

function Panel:Release()
    self.layer:removeFromParent(true)
	LayerManager.nilPanel(self.panelName)	
	CacheManager.purge()
end
---------------------------cocosStudio-----------------------------

function Panel:InitPanel(name)
	local filePath = "NewUi/"..name..".json"
	if not file_exists(filePath) then
		cclog(">>>>>>>>"..filePath.."不存在<<<<<<<<<<<<<<<")
	end
	self.panelName = name.."Panel"
    cclog(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"..self.panelName)
	self.studioUI = ccs.GUIReader:getInstance():widgetFromJsonFile(filePath)
	self.layer = cc.Layer:create()
	self.layer:addChild(self.studioUI)
end

function Panel:getChildByName(name)
    return ccui.Helper:seekWidgetByName(self.studioUI,name)
end

function Panel:setLabelText(name,text,color)
    local label = self:getChildByName(name)
    if label then
		label:setString(text)
        label:setTextAreaSize(label:getContentSize())
        if color then
            label:setColor(color)
        end
	else
		cclog(name.."=========元素不存在")
   end
end

function Panel:setBitmapText(name,text)
    local label = self:getChildByName(name)
    if label then
		label:setString(text)
	else
		cclog(name.."=========元素不存在")
   end
end

function Panel:setItemBitmapText(item,name,text)
	local label = self:getItemChildByName(item, name)
    if label then
		label:setString(text)
	else
		cclog(name.."=========元素不存在")
   end
end

function Panel:setImageTexture(name,path)
	local image = self:getChildByName(name)
	if image then
		if file_exists(path) then
			image:loadTexture(path,ccui.TextureResType.localType)
		else
			cclog(path.."路径不存在")
		end
	else
		cclog(name.."=========元素不存在")
	end
end

function Panel:setProgressBarPercent(name,pro)
   local node = self:getChildByName(name)
   if node then
		node:setPercent(pro)
   else
		cclog(name.."=========元素不存在")
   end
end
--设置颜色
function Panel:setItemNodeColor(item,name)
	local node = ccui.Helper:seekWidgetByName(item,name)
	SpriteGraylightWithCCSprite(node:getVirtualRenderer())
end
--按钮事件
--name 按钮的名称
--callback 回调函数
--tag 标志
function Panel:addNodeTouchEventListener(name,callback,tag)
   local node = self:getChildByName(name)
   if node then
	   node:addTouchEventListener(function(sender,eventType)
			if eventType == ccui.TouchEventType.ended then
				SoundEffect.playSoundEffect("button")
				callback(node,tag or name)
			end
	   end)
   end
end

function Panel:addItemNodeTouchEventListener(item,name,callback,tag)
   local node = self:getItemChildByName(item, name)
   if node then
	   node:addTouchEventListener(function(sender,eventType) 
			if eventType == ccui.TouchEventType.ended then
				SoundEffect.playSoundEffect("button")
				callback(node,tag or name)
			end
	   end)
   end
end

--select事件专属checkBox
function Panel:addCheckBoxNodeSelectEvent(name, callback, tag)
    local ckbox = self:getChildByName(name)
    ckbox:addEventListenerCheckBox(function (sender,eventType)
        callback(sender, eventType, tag or name)
    end)
end

--select事件专属item checkBox
function Panel:addItemCheckBoxNodeSelectEvent(item, name, callback, tag)
    local ckbox = self:getItemChildByName(item, name)
    ckbox:addEventListenerCheckBox(function (sender,eventType)
        callback(sender, eventType, tag or name)
    end)
end

--checkbox专属
function Panel:setItemCheckBoxSelect(item, name, isSelect)
    local ckbox = self:getItemChildByName(item, name)
    ckbox:setSelectedState(isSelect)
end

function Panel:setCheckBoxSelect( name, isSelect)
    local ckbox = self:getChildByName(name)
    ckbox:setSelectedState(isSelect)
end

--textfield事件专属(deprecated )
--此控件问题太多 暂时弃用
function Panel:addTextFieldNodeEvent(name, callback, tag)
    local textField = self:getChildByName(name)
    textField:addEventListenerTextField(function (sender, eventType)
        callback(sender, eventType, tag or name)
    end)
end

function Panel:getItemChildByName(item,name)
    return ccui.Helper:seekWidgetByName(item,name)
end

function Panel:setItemLabelText(item,name,text,color)
   local label = self:getItemChildByName(item,name)
   if label then
		label:setString(text)        
        label:setTextAreaSize(label:getContentSize())
        if color then
            label:setColor(color)
        end
   else
    	cclog(name.."=========列表元素不存在")
   end
end

function Panel:setItemVisable(item,name,isVisabel)
   local node = self:getItemChildByName(item,name)
   if node then
		node:setVisible( isVisabel )
   else
    	cclog(name.."=========列表元素不存在")
   end
end


function Panel:setItemImageTexture(item,name,path)
   if file_exists(path) then
	   local image = self:getItemChildByName(item,name)
	   if image then
			image:loadTexture(path,ccui.TextureResType.localType)
		else
			cclog(name.."=========列表元素不存在")
	   end
	else
		cclog(path.."路径不存在")
	end
end

function Panel:setItemProgressBarPercent(item,name,pro)
   local node = self:getItemChildByName(item,name)
   if node then
		node:setPercent(pro)
   else
		cclog(name.."=========元素不存在")
   end
end

function Panel:InitListView(data,OnItemShowCallback,OnTouchCallback,listName,itemName,grid,offset,slider)
	local loadType = 1
	local vertiacal = 0
	local horizontal = 0
	local gridWidth=0
	local gridHeight=0
	local offsetX = 0
	local offsetY = 0
	
	local cellNum = 0 --
	local cellIndex = 1 --当前索引
	local SEGMENT_LEN = 9  --动态加载时，每次分段加载的条目数
	local offsetNum = offset or 0
	local dataLen = data and #data or 0 --数据条目数
	listName = listName or "ListView"
	itemName = itemName or "ListItem"
	local listView = self:getChildByName(listName)
	local listItem = self:getChildByName(itemName)
	local listSize = listView:getSize()
	local itemSize = listItem:getContentSize()
	listItem:setVisible(false)
	listView:removeAllItems()

	local sliderBar = nil
	if slider == 1 then   --为0不设置滚动条，为1设置滚动条
		local sliderBg = listView:getParent()
		local sliderBgSize = sliderBg:getSize()--listView

		cclog("sliderBgSize.width:"..sliderBgSize.width)
		cclog("sliderBgSize.height:"..sliderBgSize.height)
		
		local bgSliderFileName = ""
		local sliderFileName = ""
		if listView:getDirection() == 1 then --垂直
			bgSliderFileName = "NewUi/xinqietu/tongyong/i_latiao02.png"
			sliderFileName = "NewUi/xinqietu/tongyong/i_latiao01.png"

			sliderBar = SliderBar:New()
			local slider = sliderBar:Create(bgSliderFileName, sliderFileName, listSize, itemSize, listView:getDirection())
			slider:setPosition(cc.p(sliderBgSize.width-10, sliderBgSize.height/2))
			sliderBg:addChild(slider,1000)
		end
	end

	grid = grid or 1
	grid = math.abs(grid)
	dataLen = math.ceil(dataLen/grid)

	if listView:getDirection() == 2 then
		vertiacal = 1
		gridWidth = itemSize.width
		gridHeight = listSize.height
		offsetX = itemSize.width
		offsetY = itemSize.height
		cellNum = math.ceil(listSize.width / itemSize.width)
		if cellNum < SEGMENT_LEN then
			cellNum = SEGMENT_LEN
		end
	else
		horizontal = 1
		gridWidth = listSize.width
		gridHeight = itemSize.height
		offsetX = itemSize.width
		offsetY = itemSize.height
		cellNum = math.ceil(listSize.height / itemSize.height)
		if cellNum < SEGMENT_LEN then
			cellNum = SEGMENT_LEN
		end
	end

	if offsetNum > cellNum then
		cellNum = offsetNum
	end
	
	local function addItemButton(bgLayer,data,pos)
		local function touchEvent(sender,eventType)	
			if eventType == ccui.TouchEventType.ended then
				OnTouchCallback(bgLayer,data,pos)  
				SoundEffect.playSoundEffect("button")
			end
		end
		
		local imgPath = "common/itemButton.png"
		local button = ccui.Button:create()
		button:setTouchEnabled(true)
		button:loadTextures(imgPath,imgPath,"")        
		button:addTouchEventListener(touchEvent)
		bgLayer:addChild(button,999)
		
		local bgSize = bgLayer:getContentSize()
		local btSize = button:getContentSize()
		button:setScaleX(bgSize.width/btSize.width)
		button:setScaleY(bgSize.height/btSize.height)
		button:setPosition(cc.p(bgSize.width/2,bgSize.height/2))
	end
	
	local function scrollToPercent(maxNum,flag)
		if flag or offsetNum <= 1 then
			return 
		end

		local arr = {}
		arr[1] = cc.DelayTime:create(0.1)
		arr[2] = cc.CallFunc:create(function()
			local percent = 0
			if listView:getDirection() == 1 then
				percent = itemSize.height*(offsetNum-1) /(itemSize.height*maxNum-listSize.height)*100
				percent = percent < 0 and 0 or percent
				percent = percent <= 100 and percent or 100
				listView:scrollToPercentVertical(percent,offsetNum*0.2,true)
			else
				percent = itemSize.width*(offsetNum-1) /(itemSize.width*maxNum-listSize.width)*100
				percent = percent < 0 and 0 or percent
				percent = percent <= 100 and percent or 100
				listView:scrollToPercentHorizontal(percent,offsetNum*0.2,true)
			end
		end)
		local sq = cc.Sequence:create(arr)
		self.layer:runAction(sq)
	end
	
	local function addNewListItem(num,flag)
		local maxNum = cellIndex + num
		if maxNum >= dataLen then
			maxNum = dataLen
		end
	
		for idx=cellIndex,maxNum do
			local gridLayer = ccui.Layout:create()
			gridLayer:setSize(cc.size(gridWidth,gridHeight))
			listView:pushBackCustomItem(gridLayer)
			for k=1,grid do
				local pos = ((idx-1)*grid)+k
				if data[pos] then
					local itemLayer = listItem:clone()
					local w = horizontal*(gridWidth/grid*(k-1))
					local h = vertiacal*(gridHeight - listSize.height/grid*k)
					itemLayer:setName(listName..pos)
					itemLayer:setPosition(cc.p(w,h))
					itemLayer:setVisible(true)
					addItemButton(itemLayer,data[pos],pos) --添加Button

					gridLayer:addChild(itemLayer)
					OnItemShowCallback(listView,itemLayer,data[pos],pos)
				end
			end
		end
		cellIndex = maxNum + 1
		scrollToPercent(maxNum,flag)
	end
	addNewListItem(cellNum,false)
	
	local percentH
	local function listViewEvent(sender,eventType)
		if slider == 1 then
			if listView:getDirection() == 1 then
		    	local innerPosX, innerPosY = listView:getInnerContainer():getPosition()
		    	local offsetYSlider = listView:getInnerContainer():getSize().height+innerPosY-listSize.height
		    	local offsetYHeight = dataLen*itemSize.height-listSize.height
		    	cclog("offsetYSlider:"..offsetYSlider)
		    	cclog("offsetYHeight:"..offsetYHeight)
		    	if offsetYHeight == 0 then
		    		percentH = 0
		    	else
		    		percentH = offsetYSlider/offsetYHeight
		    	end
		    	--cclog("percentH:"..percentH)
		    	if type(percentH) == "number" then
		    		sliderBar:setValue(percentH)
		    	else
		    		sliderBar:setValue(0)
		    	end
			end
		end

		local size = listView:getInnerContainer():getContentSize()
		local x,y = listView:getInnerContainer():getPosition()
		local size = listView:getInnerContainer():getContentSize()
		local width = size.width-listSize.width
		
		if loadType == 0 and cellIndex < dataLen + 1 and 
		   eventType == ccui.ScrollviewEventType.scrolling then
			if (x <= offsetX-width and listView:getDirection() == 2) or 
			   (y >= -offsetY and listView:getDirection() == 1) then
				loadType = 1
				addNewListItem(SEGMENT_LEN,true)
			end
		end
	end
	
	local function selectedItemEvent(sender,eventType)
		loadType = 0
	end
	
	listView:addEventListenerScrollView(listViewEvent)
	listView:addEventListenerListView(selectedItemEvent)
	
	--[[local function selectedItemEvent(sender,eventType)
		if eventType == 0 then
			isScroll = false
		else
			if not isScroll then
				local idx = sender:getCurSelectedIndex()
				OnTouchCallback(sender:getItem(idx),data[idx+1],idx+1)
			end
		end
	end]]
	--listView:addEventListenerListView(selectedItemEvent)
end

function Panel:createEditBox(v)
	local input = v.input
    local name = v.name
    local callBack = input.callBack
    local lineLen = input.lineLen
    local bindLabel = input.bindLabel
	local placeHolder = input.place_holder or ""
	local returnType = input.return_type or 1
	local inputFlag = input.input_flag or kEditBoxInputFlagInitialCapsAllCharacters
	local color = input.color or {r=125,g=125,b=125}
	local max_length = input.max_length and tonumber(input.max_length) or 120
	local pic = input.pic or "common/editbox_bg.png"
	local tmp_sprite = cc.Scale9Sprite:create(pic)
	local x = v.offset.x
	local y = v.offset.y 
	local tmp_c = tmp_sprite:getContentSize()
	local width = tmp_c.width
	local height = tmp_c.height	
	local uisprite = cc.EditBox:create(cc.size(width,height),tmp_sprite)
	uisprite:setPosition(cc.p(x,y))
	uisprite:setPlaceHolder(placeHolder)
	uisprite:setFontColor(cc.c3b(color.r,color.g,color.b))
	uisprite:setInputFlag(inputFlag) 
	uisprite:setReturnType(returnType)
	uisprite:setMaxLength(1024)--实际长度控制由label控制
    uisprite:registerScriptEditBoxHandler(function (strEventName,pSender)
        if bindLabel then
            --bindLabel:setTextAreaSize(bindLabel:getContentSize())不需要自动换行
            local edit = pSender
		    if strEventName == "began" then
                --去除字符中的回车 传给ime
                local str = bindLabel:getString()
                str = string.gsub(str, "\n", "")
                edit:setText(str)
		    elseif strEventName == "ended" then
                edit:setText("")
            elseif strEventName == "changed" then
                --从ime中获取字符 添加回车 放到界面中显示(同时也是传输给其他人的原始字符)
                bindLabel:setString(
                        getInsertStrbyConLen(
                        edit:getText(),
                        lineLen,
                        "\n",
                        max_length)
                     )
            end
        end
        if callBack then callBack(strEventName, pSender, name) end
    end)
	return uisprite
end

function Panel:setBtnEnabled(name,enabled)
	local node = self:getChildByName(name)
	if node then
		node:setBright(enabled)
		node:setEnabled(enabled)
	end
end

function Panel:setItemBtnEnabled(item, name,enabled)
	local node = self:getItemChildByName(item, name)
	if node then
		node:setBright(enabled)
		node:setEnabled(enabled)
	end
end

function Panel:setBtnImage(name, normalImg, pressImg, disImg)
	local node = self:getChildByName(name)
    if normalImg then
        node:loadTextureNormal(normalImg)
    end
    if pressImg then
        node:loadTexturePressed(pressImg)
    end
    if disImg then
        node:loadTextureDisabled(disImg)
    end
end

function Panel:setItemBtnImage(item, name, normalImg, pressImg, pressImg)
	local node = self:getItemChildByName(item, name)
    if normalImg then
        node:loadTextureNormal(normalImg)
    end
    if pressImg then
        node:loadTexturePressed(pressImg)
    end
    if disImg then
        node:loadTextureDisabled(disImg)
    end
end

function Panel:setNodeVisible(name,visible)
	local node = self:getChildByName(name)
	if node then
		node:setVisible(visible)
	end
end

function Panel:setItemNodeVisible(item,name,visible)
	local node = ccui.Helper:seekWidgetByName(item,name)
	if node then
		node:setVisible(visible)
	else
		cclog(name.."不存在")
	end
end

function Panel:setNodeTag(name,tag)
	local node = self:getChildByName(name)
	if node then
		node:setTag(tag)
	else
		cclog(name.."不存在")
	end
end

function Panel:registerScriptTouchHandlerClose(callback)
	local touch = {x=0,y=0}
	local sprite = self:getChildByName("img_border")
	local function panel_Ontouch(e,x,y)
		x = self.layer:convertToNodeSpace(cc.p(x,y)).x
		y = self.layer:convertToNodeSpace(cc.p(x,y)).y
		if e=="began" then	
			touch.x = x
			touch.y = y
		elseif e=="moved" then
			
		else
			if(not isAbsoluteSprite(sprite,x,y)) and 
			  (math.abs(touch.x-x) < 5 and math.abs(touch.y-y) < 5) then
				local arr = {}
				arr[1] = cc.DelayTime:create(0.01)
				arr[2] = cc.CallFunc:create(function() 
					SoundEffect.playSoundEffect("button")
					if callback and callback() == true then
                        --donothing
					else
					    self:Release()
					end
				end)
				local sq = cc.Sequence:create(arr)
				self.layer:runAction(sq)
			end
		end
		return true
	end
    self.layer:setTouchEnabled(true)
	self.layer:registerScriptTouchHandler(panel_Ontouch,false,0,true)
end

function Panel:registerScriptTouchHandlerTrue()
	local function panel_Ontouch(e,x,y)
		return true
	end
    self.layer:setTouchEnabled(true)
	self.layer:registerScriptTouchHandler(panel_Ontouch,false,0,true)
end

function Panel:delayRelease(callback)
	local arr = {}
	arr[1] = cc.DelayTime:create(0.01)
	arr[2] = cc.CallFunc:create(function() 
		if callback then
			callback()
		end
	end)
	local sq = cc.Sequence:create(arr)
	self.layer:runAction(sq)
end

function Panel:scheduleScriptFunc(callback,times)
	return Director.getScheduler():scheduleScriptFunc(callback,times,false)
end

function Panel:unscheduleScriptEntry(scheduler)
	Director.getScheduler():unscheduleScriptEntry(scheduler)
	scheduler = nil
end

function Panel:registerTouchEvent(node, callBack)
    local function isContain(touch, sprite)--判断touch事件是否被包含在该sprite
        local location = sprite:convertToNodeSpace(touch:getLocation())
        local s = sprite:getContentSize()
        local rect = cc.rect(0,0,s.width,s.height)
        if cc.rectContainsPoint(rect,location) then
            return true
        end
        return false
    end
    
    local  listenner = cc.EventListenerTouchOneByOne:create()
    listenner:setSwallowTouches(true)
    listenner:registerScriptHandler(function (touch, event)
        return callBack({touch=touch, event=event, type=GameField.Event_Click, isContain=isContain(touch, node)})
    end, cc.Handler.EVENT_TOUCH_BEGAN )
    listenner:registerScriptHandler(function (touch, event)
        return callBack({touch=touch, event=event, type=GameField.Event_Move, isContain=isContain(touch, node)})
    end, cc.Handler.EVENT_TOUCH_MOVED )
    listenner:registerScriptHandler(function (touch, event)
        return callBack({touch=touch, event=event, type=GameField.Event_End, isContain=isContain(touch, node)})
    end,cc.Handler.EVENT_TOUCH_ENDED )
    listenner:registerScriptHandler(function (touch, event)
        return callBack({touch=touch, event=event, type=GameField.Event_End, isContain=isContain(touch, node)})
    end,cc.Handler.EVENT_TOUCH_CANCELLED )
    local eventDispatcher = node:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listenner, node)
end

function Panel:registerItemNodeTouchEvent(item, name, callBack)
    local node = self:getItemChildByName(item,name)
    self:registerTouchEvent(node, callBack)
end

function Panel:registerNodeTouchEvent(name, callBack)
    local node = self:getChildByName(name)
    self:registerNodeTouchEvent(node, callBack)
end


function Panel:registerSliderEvent(name, callBack)
	local node = self:getChildByName(name)
	node:addEventListenerSlider( callBack )
end