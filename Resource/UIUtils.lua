require("SoundEffect")
require("CacheManager")
UIUtils = { }

-- 创建层
function CreateLayer()
    return cc.Layer:create()
end

-- 创建空的精灵
function CreateBlankCCSprite()
    return cc.Sprite:create()
end

-- 创建精灵
function CreateCCSprite(path)
    if not path or #path == 0 then
        -- 加入长度判断 兼容android平台
        cclog("cannot load sprite ->  path is nil")
        return cc.Sprite:create("common/default_hero_icon.png")
    end

    if not file_exists(path) then
        cclog("cannot find file " .. path)
        return cc.Sprite:create("common/default_hero_icon.png")
    end

    local sprit = cc.Sprite:create(path)
    if not sprit then
        cclog("cannot load sprite -> " .. path)
        sprit = cc.Sprite:create("common/default_hero_icon.png")
    else
        CacheManager.cacheTexture(path)
    end
    return sprit

end

--与上面差不多 不过创建的是ccui元素
function CreateImageView(path)
    local imageView
    if not path or #path == 0 then
        -- 加入长度判断 兼容android平台
        cclog("cannot load imgView ->  path is nil")
        return ccui.ImageView:create("common/default_hero_icon.png")
    end

    if not file_exists(path) then
        cclog("cannot find file " .. path)
        return ccui.ImageView:create("common/default_hero_icon.png")
    end

    imageView = ccui.ImageView:create(path)
    if not imageView then
        cclog("cannot load imgView -> " .. path)
        imageView = ccui.ImageView:create("common/default_hero_icon.png")
    else
        CacheManager.cacheTexture(path)
    end
    return imageView
end

function LoadSpriteFrames(plist, path)
    if not path or not plist then
        error("CreateCCSpriteFrames invalid para")
    end
    cc.SpriteFrameCache:getInstance():addSpriteFrames(plist, path)
    CacheManager.cacheTextureFrame(path)
end

function GetSpriteFrame(path)
    local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(path)
    if not frame then
        local sprite = CreateCCSprite(path)
        if sprite then
            frame = sprite:displayFrame()
        else
            frame = CreateCCSprite("common/default_hero_icon.png"):displayFrame()
        end
    end
    return frame
end

function GetSpriteByFrame(frameName)
    local sprite = cc.Sprite:createWithSpriteFrameName(frameName)
    if not sprite then
        sprite = CreateCCSprite("common/default_hero_icon.png")
    end
    return sprite
end


function CreateLabel(text, font, fontSize, color, align, dimensions, anchorY)
    if dimensions == nil then
        dimensions = cc.size(0, 0)
    end
    local labelTTF
    if type(text) == 'number' then
        labelTTF = cc.Label:createWithTTF(text or "0", font or Config.FontName, fontSize or 20, dimensions)
    else
        labelTTF = cc.Label:createWithTTF(text or "0", font or Config.FontName, fontSize or 20, dimensions)
    end
    if align then
        if align == 1 then
            -- 左对齐
            labelTTF:setAnchorPoint(cc.p(0, anchorY or 0.5))
        elseif align == 2 then
            -- 右对齐
            labelTTF:setAnchorPoint(cc.p(1, anchorY or 0.5))
        elseif align == 3 then
            -- 居中对齐
            labelTTF:setAnchorPoint(cc.p(0.5, anchorY or 0.5))
        end
        labelTTF:setHorizontalAlignment(align - 1)
    end

    if not color then color = cc.c3b(251, 251, 252) end
    labelTTF:setColor(color)

    return labelTTF
end

function getLabelRowHeight(text, fontSize, width)

    if #text == 0 then
        return 0
    end
    local tmpList = { }
    local aString = text
    local pos = 0
    local rowcount = 1

    pos = string.find(aString, "\n")
    while pos do
        rowcount = rowcount + 1
        pos = string.find(aString, "\n", pos + 1)
    end

    table.insert(tmpList, aString)
    local temp_label = cc.LabelTTF:create(LabelChineseStr.UIUtils_1, "Arial", fontSize)
    local label = cc.LabelTTF:create(LabelChineseStr.UIUtils_2, "Arial", fontSize)
    if #tmpList > 1 then
        for i = 1, #tmpList do
            local tmpString = tmpList[i]
            label = ccLabelTTF:create(tmpString, "Arial", fontSize)
            local strWidth = label:getContentSize().width
            if strWidth > width and #tmpString > 30 then
                local row = math.ceil(strWidth / width) -1
                rowcount = rowcount + row
            end
        end
    else
        label = cc.LabelTTF:create(text, "Arial", fontSize)
        local strWidth = label:getContentSize().width
        local row = math.ceil(strWidth / width) -1
        rowcount = rowcount + row
    end
    return rowcount * temp_label:getContentSize().height
end


local tips_sprite = nil
function Tips(txt,frontSize,color,x,y)
    -- 删除tips
    local function removeTips()
        if tips_sprite then
            tips_sprite:removeFromParent(true)
            tips_sprite = nil
        end
    end

    if tips_sprite then
        removeTips()
    end

    local tmplayer = LayerManager.getGameLayer()
    if not tmplayer then cclog("Cannot show tips : " .. txt) return end
    local winSize = Director.getRealWinSize()
    local x = x or winSize.width / 2
    local y = y or winSize.height / 2
    local tips = CreateCCSprite("common/tips_bg.png")
    local len = string.len(txt)

    tips:setPosition(winSize.width / 2, winSize.height / 2)
    local bg_c = tips:getContentSize()
    local txt_sprite = CreateLabel(txt, nil, frontSize or 25, color)
    local tips_c = tips:getContentSize()
    txt_sprite:setPosition(tips_c.width / 2, tips_c.height / 2)
    tmplayer:addChild(tips, 1024)
    tips:addChild(txt_sprite)

    -- 出现后消失
    local fadein_t = 0.1
    local move_time = 0.3
    local fadeout_t = 0.5
    local fadein = cc.FadeIn:create(fadein_t)
    local delay = cc.MoveTo:create(move_time, cc.p(winSize.width / 2, winSize.height / 2 + 30))
    local fadeout = cc.FadeOut:create(fadeout_t)
    local arr = { }
    arr[1] = fadein
    arr[2] = delay
    arr[3] = fadeout
    arr[4] = cc.CallFunc:create(removeTips)
    local sq = cc.Sequence:create(arr)
    tips:runAction(sq)
    tips_sprite = tips
end

function CreateMenuItemImage(img, x, y, f, img3)
    local p
    if img3 and img3 ~= '' then
        p = cc.MenuItemImage:create(img, img, img3)
    else
        p = cc.MenuItemImage:create(img, img)
    end

    p:setPosition(x, y)
    p:registerScriptHandler(f)
    return p
end

function createMenuItem(img1, img2, x, y, calfunc, delayRegister, img3)
    -- 延迟注册回调
    local _close
    if img3 and img3 ~= '' then
        _close = cc.MenuItemImage:create()
        -- img1, img2, img3
        _close:setNormalImage(CreateCCSprite(img1))
        _close:setSelectedImage(CreateCCSprite(img2))
        _close:setDisabledImage(CreateCCSprite(img3))
    else
        -- img1, img2
        _close = cc.MenuItemImage:create()
        _close:setNormalImage(CreateCCSprite(img1))
        _close:setSelectedImage(CreateCCSprite(img2))
    end

    _close:setPosition(cc.p(0, 0))
    local _closeBtn = cc.Menu:create(_close)
    _closeBtn:setPosition(x, y)
    _closeBtn:alignItemsHorizontally()
    _closeBtn.item = _close
    if calfunc then
        local function _func()
            
            calfunc(_closeBtn)
        end
        _close:registerScriptTapHandler(_func)
    end
    if delayRegister then
        return _closeBtn, _close
    end
    return _closeBtn
end

function isClickSprite(sprite, x, y)
    local size = sprite:getContentSize()
    local pos_x, pos_y = sprite:getPosition()
    local mid_w = size.width / 2 * sprite:getScaleX()
    local mid_h = size.height / 2 * sprite:getScaleY()

    if math.abs(x - pos_x) < math.abs(mid_w) and math.abs(y - pos_y) < math.abs(mid_h) then
        return true
    end
    return false
end

function isAbsoluteSprite(sprite,x,y)
	
	if not sprite then
		return false
	end
	
    local size = sprite:getContentSize()
	local space = sprite:convertToWorldSpace(cc.p(0,0))
    local mid_w = size.width * sprite:getScaleX()
    local mid_h = size.height * sprite:getScaleY()

	if space.x <= x and space.x + mid_w >= x and
	   space.y <= y and space.y + mid_h >= y then
	   return true
	end
    return false
end

function CreateColorLable(name, color)
    name = name or ""

    local tmp = ""
    local txt = { }
    local arr = lua_string_array(name)
    for k, v in pairs(arr) do
        if v == '(' or v == ')' then
            table.insert(txt, tmp)
            tmp = ""
        else
            tmp = tmp .. v
        end
    end


    local lbl
    if #txt == 0 or #txt == 1 then
        lbl = CreateLabel(name)
        lbl:setAnchorPoint(cc.p(0, 0.5))
    elseif #txt == 2 then
        lbl = CreateLabel(txt[1] .. "(")
        lbl:setAnchorPoint(cc.p(0, 0.5))

        local size = lbl:getContentSize()

        -- 字体
        local fontLbl = CreateLabel(txt[2], nil, nil, color)
        local sz = fontLbl:getContentSize()
        fontLbl:setAnchorPoint(cc.p(0, 0))
        fontLbl:setPosition(cc.p(size.width, 0))
        lbl:addChild(fontLbl)

        local symbolLbl = CreateLabel(")")
        symbolLbl:setAnchorPoint(cc.p(0, 0))
        symbolLbl:setPosition(cc.p(size.width + sz.width, 0))
        lbl:addChild(symbolLbl)
    end

    return lbl
end

--修复本版本richLabel换行乱码问题
function initElement(storeTab, str, color)
    local strTab = splitStr(str, 1)
    for _,v in pairs(strTab) do
        table.insert(storeTab, {str=v, color=color})
    end
end
--富彩色文本(用的是ccstudio控件)
--stringTab格式{{str="",color=""}}
function createRichColorLabel(stringTab, fontSize, size)
    local _richText = ccui.RichText:create()
    _richText:ignoreContentAdaptWithSize(false)
    _richText:setSize(size)
    for k,v in pairs(stringTab) do
        local re = ccui.RichElementText:create(k, v.color, 255, v.str, Config.FontName, fontSize)
        _richText:pushBackElement(re)
    end
    return _richText
end

-- UI布局整体偏移
function UIUtils.setUILayoutOffset(item_file, panel, tx, ty)
    require(item_file)
    local sList, tList = loadstring("return " .. item_file .. "PanelData()")()
    for k, v in pairs(sList) do
        local x, y = panel[v.name]:getPosition()
        panel[v.name]:setPosition(cc.p(x + tx, y + ty))
    end

    for k, v in pairs(tList) do
        local x, y = panel[v.name]:getPosition()
        panel[v.name]:setPosition(cc.p(x + tx, y + ty))
    end
end

function CreateSkeleton(root, name)
    -- 图片的名称
    local pngName = root .. "0.png"
    -- plist名称
    local plistName = root .. "0.plist"
    -- 工程名
    local exportJson = root .. ".ExportJson"
    -- 读取骨骼
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(pngName, plistName, exportJson)
    local armature = ccs.Armature:create(name)
	--[[
	local rect = armature:getBoundingBox()
	local layer = cc.LayerColor:create(cc.c4b(0,0,0,125))
	layer:setContentSize(cc.size(rect.width,rect.height))
	layer:setPosition(cc.p(rect.x,rect.y))
	armature:addChild(layer,-1)
	]]
    return armature
end

-- 人物骨骼
function CreateHeroSkeleton(name)
	if not file_exists("res/action/" ..name.. "/"..name.."0.png") then
		name = "10010"
	end
    local root = "res/action/" .. name .. "/" .. name
    local armature = CreateSkeleton(root, name)
	--[[
	local rect = armature:getBoundingBox()
	rect.width = rect.width*2/3
	local layer = cc.LayerColor:create(cc.c4b(0,0,0,125))
	layer:setContentSize(cc.size(rect.width,rect.height))
	layer:setPosition(cc.p(rect.x,rect.y))
	armature:addChild(layer,-1)
	armature.layer = layer]]
    return armature
end

-- 技能骨骼
function CreateSkillSkeleton(name)
	if not file_exists("res/effect/" ..name.. "/"..name.."0.png") then
		cclog("name=========="..name)
		name = "t0001"
	end
    local root = "res/effect/" .. name .. "/" .. name
    local armature = CreateSkeleton(root, name)
    return armature
end

-- 效果骨骼
function CreateEffectSkeleton(name)
    local root = "res/effect/" .. name .. "/" .. name
    local armature = CreateSkeleton(root, name)
    armature:getAnimation():play("tx")
    return armature
end

--品质颜色提取
function GetQualityColor(qualityNum)
    local retColor=cc.c3b(255,255,255)
    if qualityNum == 1 then--白色
        retColor=cc.c3b(255,255,255)
    elseif qualityNum == 2 then--绿色
        retColor=cc.c3b(0,255,0)
    elseif qualityNum == 3 then--蓝色
        retColor=cc.c3b(0,0,255)
    elseif qualityNum == 4 then--紫色
        retColor=cc.c3b(255,0,255)
    elseif qualityNum == 5 then--橙色
        retColor=cc.c3b(0xff,0x7f,0)
    end
    return retColor
end