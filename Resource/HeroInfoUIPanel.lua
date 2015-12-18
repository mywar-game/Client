require("HeroDescUIPanel")
require("PackageUIPanel")
require("HeroSkillUIPanel")

HeroInfoUIPanel = {
panel = nil,
}
function HeroInfoUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
   return o
end
--创建
function HeroInfoUIPanel:Create(para)
    local p_name = "HeroInfoUI"
    local panel = Panel:New()
	self.panel = panel
    panel:InitPanel(p_name)
	
	--业务逻辑编写处
	local actionTime = 0.6
	local showState = 0 --0代表英雄信息，1代表英雄技能
	local clickIndex = 0
	local clickItem = nil
	local clickData = nil--选中英雄的数据
	local skillPanel = nil
	local heroPanel = nil
    local heroDescUIPanel = nil
    local cacheMoveSprite
    local cacheDismissHero--缓存的待遣散的英雄
    local function checkContain(touchPos)--检查是否进入指定装备位置
        for i=1,8 do
            local equipIcon = heroPanel:getChildByName("btn_equip"..i)
            local location = equipIcon:convertToNodeSpace(touchPos)
            local s = equipIcon:getContentSize()
            local rect = cc.rect(0,0,s.width,s.height)
            if cc.rectContainsPoint(rect,location) then
                return i
            end
        end
        return nil
    end
	
    local function checkPos(pos, posList)--检查位置是否正确
        for i=1,#posList do
            if tonumber(posList[i]) == pos then
                return true
            end
        end
        return false
    end
	
    local function checkCareer(careerId, careerList)--检查职业是否正确
        for i=1,#careerList do
            local numCareer = tonumber(careerList[i])
            if numCareer == 0 or numCareer == careerId then
                return true
            end
        end
        return false
    end
	
    local function requestWear(pos, data)--请求穿戴 pos传0为快速穿戴
		--请求穿戴(可以 本地先做一下筛选)
		local systemEquip = DataManager.getSystemEquip(data.equipId)
		if not checkCareer(clickData.careerId, systemEquip.needCareer) then
			Tips(LabelChineseStr.HeroInfoUIPanel_3)
		elseif pos ~= 0 and not checkPos(pos, systemEquip.pos) then
			Tips(LabelChineseStr.HeroInfoUIPanel_4)
		elseif clickData.level < systemEquip.needLevel then
			Tips(LabelChineseStr.HeroInfoUIPanel_2)
		else--请求穿戴
			local wearEquipReq = EquipAction_wearEquipReq:New()
			wearEquipReq:setString_userHeroId(clickData.userHeroId)
			wearEquipReq:setString_userEquipId(data.userEquipId)
			wearEquipReq:setInt_pos(pos)
			NetReqLua(wearEquipReq, true)
		end
    end
	
	local function equipCallBack(para)
		if para.type == GameField.Event_Back then
		    self:Release()
        elseif para.type == GameField.Event_Move then--处理拖动
            if not cacheMoveSprite then
                cacheMoveSprite = IconUtil.GetIconByIdType(para.data.type,para.data.equipId, nil)
                self.panel.layer:addChild(cacheMoveSprite,0xffff)
            end
            cacheMoveSprite:setPosition(self.panel.layer:convertToNodeSpace(para.touchPos))
            para.sprite:setVisible(false)
        elseif para.type == GameField.Event_End then--处理按下起立
            if cacheMoveSprite then
                cacheMoveSprite:removeFromParent()
                local index=checkContain(para.touchPos)
                if index then
                    requestWear(index, para.data) 
                end
                para.sprite:setVisible(true)
                cacheMoveSprite = nil
            end
        elseif para.type == GameField.Event_DoubleClick then
            requestWear(0, para.data)
        end
	end
	
	local packageUIPanel = PackageUIPanel:New()
	local packagePanel = packageUIPanel:Create({equipTouchCallBack=equipCallBack})
	packagePanel.layer:setPosition(cc.p(500,0))
	self.panel.layer:addChild(packagePanel.layer,2)
	
	local function showHeroCallBack(hero, isAnim)
		if showState == 0 then
			if heroPanel then
				heroPanel.layer:removeFromParent(true)
				heroPanel = nil
			end
			
			local function showSkillCallBack(hero)
				showState = 1
				showHeroCallBack(hero)
			end
            local function dismissCallBack(hero)
                cacheDismissHero = hero
            end
			heroDescUIPanel = HeroDescUIPanel:New()
			heroPanel = heroDescUIPanel:Create({
            hero=hero,
            showSkillCallBack=showSkillCallBack,
            dismissCallBack=dismissCallBack})
			heroPanel.layer:stopAllActions()
			self.panel.layer:addChild(heroPanel.layer,3)
			packagePanel.layer:stopAllActions()
			
            if skillPanel or isAnim then
            	heroPanel.layer:setPosition(cc.p(-500,0))
			    packagePanel.layer:setPosition(cc.p(500,0))
			    heroPanel.layer:runAction(cc.MoveTo:create(actionTime,cc.p(10,0)))
			    packagePanel.layer:runAction(cc.MoveTo:create(actionTime,cc.p(0,0)))
            else
                heroPanel.layer:setPosition(cc.p(10,0))
			    packagePanel.layer:setPosition(cc.p(0,0))
            end

			if skillPanel then
				skillPanel.layer:runAction(cc.Sequence:create(
                    cc.ScaleTo:create(actionTime,0),
                    cc.CallFunc:create(function()
				        skillPanel.layer:removeFromParent(true)
                        skillPanel = nil
                    end)))
			end
		else
			if skillPanel then
                skillPanel.layer:stopAllActions()
				skillPanel.layer:removeFromParent(true)
				skillPanel = nil
			end
			
			local function showInfoCallBack(hero)
				showState = 0
				showHeroCallBack(hero)
			end
			local heroSkillUIPanel = HeroSkillUIPanel:New()
			skillPanel = heroSkillUIPanel:Create({hero=hero,callback=showInfoCallBack})
			self.panel.layer:addChild(skillPanel.layer,2)
			skillPanel.layer:setScale(0.2)
			skillPanel.layer:stopAllActions()
			skillPanel.layer:runAction(cc.ScaleTo:create(actionTime,1))
			
			heroPanel.layer:stopAllActions()
			heroPanel:setNodeVisible("img_heroDeac",false)
			heroPanel.layer:runAction(cc.MoveTo:create(actionTime,cc.p(-500,0)))
			
			packagePanel.layer:stopAllActions()
			packagePanel.layer:runAction(cc.MoveTo:create(actionTime,cc.p(500,0)))
		end	
	end
	
	local function createHeroDesc(item,hero,idx,isAnim)
		if clickData and clickData.userHeroId == hero.userHeroId then
			return
		end
		
		if clickItem then
			local imgSprite = self.panel:getItemChildByName(clickItem,"img_bg")
			imgSprite:setScale(1)
		end

		clickItem = item
		clickIndex = idx
		clickData = hero
		showHeroCallBack(hero, isAnim)
		
		local selSprite = self.panel:getItemChildByName(clickItem,"img_bg")
		selSprite:setScale(1.2)		
	end
	
	local function OnItemShowCallback(scroll_view,item,data,idx)
		if idx == para.idx then
            if para.stopAnim then
			    createHeroDesc(item,data,idx)
            else
                createHeroDesc(item,data,idx, true)
            end
		end
		self.panel:setItemImageTexture(item,"img_heroHead","res/hero_icon/"..data.imgId..".png")		
		self.panel:setItemImageTexture(item,"img_heroColor","common/head_color_"..data.heroColor..".png")		
	end
	
	local function OnItemClickCallback(item,data,idx)
		createHeroDesc(item,data,idx)
	end
	
	local heroList = DataManager.getUserHeroList()
    if para.idx <= 0 then para.idx = 1 end
    if para.idx > #heroList then para.idx = #heroList end
	self.panel:InitListView(heroList,OnItemShowCallback,OnItemClickCallback,nil,nil,nil,para.idx)
	
	local function clickDirectionBtn()
		local listView = self.panel:getChildByName("ListView")
		local listItem = self.panel:getChildByName("ListItem")
		local viewSize = listView:getContentSize()
		local itemSize = listItem:getContentSize()
		
		local x,y = listView:getInnerContainer():getPosition()
		local minIdx = math.abs(x)/itemSize.width
		local maxIdx = (math.abs(x)+viewSize.width)/itemSize.width	
		if minIdx > (clickIndex-1) then
			local offsetX = -itemSize.width*(clickIndex-1)
			listView:getInnerContainer():setPosition(offsetX,y)
		end
		if maxIdx < clickIndex then
			local offsetX = viewSize.width-itemSize.width*clickIndex
			listView:getInnerContainer():setPosition(offsetX,y)
		end
		
		local item = listView:getItem(clickIndex-1)
		createHeroDesc(item,heroList[clickIndex],clickIndex)
	end
	
	
	local function btnCallBack(sender,tag)
		if tag == 1 then
			if clickIndex > 1 then
				clickIndex = clickIndex - 1
				clickDirectionBtn()
			end
		elseif tag == 2 then
			if clickIndex < #heroList then
				clickIndex = clickIndex + 1
				clickDirectionBtn()
			end
		end
	end
	self.panel:addNodeTouchEventListener("btn_left",btnCallBack,1)
	self.panel:addNodeTouchEventListener("btn_right",btnCallBack,2)

    local function refreshPackageHero()
        packageUIPanel:reFreshPackage()
        heroDescUIPanel:reFreshEquip()
    end

	function HeroInfoUIPanel_EquipAction_wearEquip(msgObj)
        Tips(LabelChineseStr.HeroInfoUIPanel_1)
        refreshPackageHero()
    end

    function HeroInfoUIPanel_EquipAction_unWearEquip(msgObj)
        Tips(LabelChineseStr.HeroInfoUIPanel_5)
        refreshPackageHero()
    end

    function HeroInfoUIPanel_ToolAction_openBox(msgObj)
        heroDescUIPanel:reFreshEquip()
    end

    --遣散英雄 后重新进入本界面
    function GroceryUIPanel_HeroAction_disband(msgObj)
        Tips(LabelChineseStr.HeroInfoUIPanel_6)
        DataManager.dismissHero(cacheDismissHero.systemHeroId)
        LayerManager.show("HeroInfoUIPanel",{idx=clickIndex, stopAnim=true})
    end

	return panel
end
--退出
function HeroInfoUIPanel:Release()
	self.panel:Release()
end
--隐藏
function HeroInfoUIPanel:Hide()
	self.panel:Hide()
end
--显示
function HeroInfoUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerTrue()
end
