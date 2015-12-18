-------------------------------------------------------------------------
--
-- 文 件 名 : SliderBar.lua
-- 创 建 者 ：chenximin
-- 创建时间 ：2015-04-23
-- 功能描述 ：滚动条
--
-------------------------------------------------------------------------

SliderBar = {
	bgSize = nil,
	backgroundSprite = nil,
	sliderSprite = nil,
	beginPos = nil,
	endPos = nil,
	sdSize = nil,
}

function SliderBar:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

--创建
function SliderBar:Create(backgroundFileName, sliderFileName, bgSize, itemSize, director)
	--滚动条背景精灵大小
    self.bgSize = bgSize
    
    --一定要使用九宫格精灵
    local backgroundSprite = cc.Scale9Sprite:create(backgroundFileName)
    self.backgroundSprite = backgroundSprite
    
    local sliderSprite = cc.Scale9Sprite:create(sliderFileName)
    backgroundSprite:addChild(sliderSprite)
    self.sliderSprite = sliderSprite
    
    --[[
    --滚动条精灵初始位置
    local beginPos = cc.p(-bgSize.width/2 + sliderSprite:getContentSize().width/2,0)
    --滚动条精灵最终位置
    local endPos = cc.p(bgSize.width/2 - sliderSprite:getContentSize().width/2,0)

    self.beginPos = beginPos
    self.endPos = endPos
    ]]

    --滚动条方向
    self.director = director

    if director == 2 then--水平

    elseif director == 1 then--垂直
        backgroundSprite:setContentSize(cc.size(backgroundSprite:getContentSize().width, bgSize.height))
        sliderSprite:setContentSize(cc.size(sliderSprite:getContentSize().width, itemSize.height))

        sliderSprite:setAnchorPoint(cc.p(0.5, 0.5))
        sliderSprite:setPosition(cc.p(backgroundSprite:getContentSize().width/2,backgroundSprite:getContentSize().height-sliderSprite:getContentSize().height/2))
    end

    --滚动条精灵大小
    local sdSize = sliderSprite:getContentSize()
    self.sdSize = sdSize

    return self.backgroundSprite
end

function SliderBar:setValue(value)
    cclog("70:>>>>>>>>>>>>>>>>>>>>")
    cclog("value:"..value)
    self.backgroundSprite:setVisible(true)
    self.backgroundSprite:stopAllActions()
    
    local arr = {}
    arr[1] = cc.DelayTime:create(2.0)
    arr[2] = cc.CallFunc:create(function()
        self.backgroundSprite:setVisible(false)
    end)
    local sq = cc.Sequence:create(arr)
    self.backgroundSprite:runAction(sq)
    
    if self.director == 2 then--水平
        cclog("1111111111111")
    else--垂直
        --正常区间范围活动
        if (value > 0 and value <= 1) then
            cclog("222222222222222222")
            --重新设置位置
            self.sliderSprite:setScaleY(1)

            self.sliderSprite:setPosition(cc.p(self.backgroundSprite:getContentSize().width/2,self.backgroundSprite:getContentSize().height*(1-value)))
            if self.sliderSprite:getPositionY() <= self.sdSize.height/2 then
                self.sliderSprite:setPosition(cc.p(self.backgroundSprite:getContentSize().width/2,self.sliderSprite:getContentSize().height/2))
            end

            if self.backgroundSprite:getContentSize().height - self.sliderSprite:getPositionY() <= self.sdSize.height/2  then
                self.sliderSprite:setPosition(cc.p(self.backgroundSprite:getContentSize().width/2,self.backgroundSprite:getContentSize().height-self.sliderSprite:getContentSize().height/2))
            end
        --滑动到最顶侧
        elseif (value <= 0) then
            cclog("3333333333333333")
            --重新设置大小及位置
            --self.sliderSprite:setScaleY(value)
            cclog("self.backgroundSprite:getContentSize().width/2:"..self.backgroundSprite:getContentSize().width/2)
            cclog("self.backgroundSprite:getContentSize().height-self.sdSize.height/2:"..self.backgroundSprite:getContentSize().height-self.sdSize.height/2)
            self.sliderSprite:setPosition(cc.p(self.backgroundSprite:getContentSize().width/2,self.backgroundSprite:getContentSize().height-self.sdSize.height/2))
        --滑动到最底侧
        elseif (value > 1) then
            cclog("444444444444444444")
            --重新设置大小及位置
            --self.sliderSprite:setScaleY(1-value)
            self.sliderSprite:setPosition(cc.p(self.backgroundSprite:getContentSize().width/2,self.sliderSprite:getContentSize().height/2))
        end
    end
end
