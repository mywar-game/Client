PointerManager = {}
 
function PointerManager.init(layer)
    PointerManager.layer = layer
    --绑定触摸事件
	local touch_pos
	function PointerOntouch(e,x,y)
        if e == "ended" then
			local covertX,covertY=LayerManager.convertToNodeSpace(PointerManager.layer,x,y)
			local pointer_dot,pointer_dot_action = ActionHelper.createFrameAnim("pointer")
			PointerManager.layer:addChild(pointer_dot,1024)
			pointer_dot:setPosition(covertX,covertY)
			pointer_dot:runAction(pointer_dot_action)
        end
        return true
    end
    PointerManager.layer:registerScriptTouchHandler(PointerOntouch,false,-1024,false)
	PointerManager.layer:setTouchEnabled(true)
end