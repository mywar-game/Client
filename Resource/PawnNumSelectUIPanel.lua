--当铺数量选择
PawnNumSelectUIPanel = {}
function PawnNumSelectUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

--创建
function PawnNumSelectUIPanel:Create(para)
	local p_name = "PawnNumSelectUI"
    self.panel = Panel:New()
    self.panel:InitPanel(p_name)
	local userInfo = DataManager.getUserBO()
    local data = para.data
    local userToolNum = DataManager.getUserToolNum(data.toolId)
    local nowSelectNum = data.toolNum
    local callReq
    local price = 0

    local function reqSell()
        local sellReq = PawnshopAction_sellReq:New()
        sellReq:setInt_camp(userInfo.camp)
        sellReq:setInt_mallId(data.mallId)
        sellReq:setInt_num(nowSelectNum)
	    NetReqLua(sellReq, true)
    end

    local function reqBuy()
        local buyInReq = PawnshopAction_buyInReq:New()
        buyInReq:setInt_camp(userInfo.camp)
        buyInReq:setInt_mallId(data.mallId)
        buyInReq:setInt_num(nowSelectNum)
	    NetReqLua(buyInReq, true)
    end

    local function refreshSelectNum(addNum)
        nowSelectNum = nowSelectNum + addNum
        if para.type == 1 then --1代表买入
            callReq = reqBuy
            self.panel:setLabelText("lab_topTip", LabelChineseStr.PawnNumSelectUIPanel_1..data.name..LabelChineseStr.PawnNumSelectUIPanel_3)
            self.panel:setLabelText("lab_bottomTip", LabelChineseStr.PawnNumSelectUIPanel_4)
            if nowSelectNum > data.num then--物品不够时候
                nowSelectNum = data.num
                Tips(LabelChineseStr.PawnNumSelectUIPanel_7)
            elseif nowSelectNum < data.toolNum then--底线
                nowSelectNum = data.toolNum
                Tips(LabelChineseStr.PawnNumSelectUIPanel_8)
            end
            price = data.price*nowSelectNum
            if price > userInfo.gold then--如果钱不够 则设为能购买的最大值
                nowSelectNum = math.floor(userInfo.gold/data.price)*data.toolNum
                price = data.price*nowSelectNum
                Tips(LabelChineseStr.PawnNumSelectUIPanel_6)
            end
        else--  否则为卖出
            callReq = reqSell
            self.panel:setLabelText("lab_topTip", LabelChineseStr.PawnNumSelectUIPanel_2..data.name..LabelChineseStr.PawnNumSelectUIPanel_3)
            self.panel:setLabelText("lab_bottomTip", LabelChineseStr.PawnNumSelectUIPanel_5)
            if nowSelectNum > math.floor(userToolNum/data.toolNum)*data.toolNum then--物品数量不够时候(注意必须是每一份的倍数)
                nowSelectNum = math.floor(userToolNum/data.toolNum)*data.toolNum
                Tips(LabelChineseStr.PawnNumSelectUIPanel_7)
            elseif nowSelectNum < data.toolNum then--底线
                nowSelectNum = data.toolNum
                Tips(LabelChineseStr.PawnNumSelectUIPanel_8)
            end
            price = data.price*data.floatValue/100*nowSelectNum
        end
        self.panel:setLabelText("lab_money", price)
        self.panel:setLabelText("lab_num", nowSelectNum)
    end
    refreshSelectNum(0)

	local function btnCallBack(sender,tag)
		
        if tag == "btn_close" or tag == "btn_cancel" then
		    self:Release()
        elseif tag == "btn_sure" then
            callReq()
            if para.callBack then
                para.callBack({price = price})
            end
        elseif tag == "btn_add" then
            refreshSelectNum(data.toolNum)
        elseif tag == "btn_addTen" then
            refreshSelectNum(10*data.toolNum)
        elseif tag == "btn_subtract" then
            refreshSelectNum(-data.toolNum)
        elseif tag == "btn_subTen" then
            refreshSelectNum(-10*data.toolNum)
        end
	end
	self.panel:addNodeTouchEventListener("btn_close",btnCallBack)
	self.panel:addNodeTouchEventListener("btn_cancel",btnCallBack)
	self.panel:addNodeTouchEventListener("btn_sure",btnCallBack)
	self.panel:addNodeTouchEventListener("btn_add",btnCallBack)
	self.panel:addNodeTouchEventListener("btn_addTen",btnCallBack)
	self.panel:addNodeTouchEventListener("btn_subtract",btnCallBack)
	self.panel:addNodeTouchEventListener("btn_subTen",btnCallBack)

    return self.panel
end

--退出
function PawnNumSelectUIPanel:Release()
	self.panel:Release(true)
end

--隐藏
function PawnNumSelectUIPanel:Hide()
	self.panel:Hide()
end

--显示
function PawnNumSelectUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerTrue()
end