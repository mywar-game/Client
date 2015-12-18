LayerHelper = {}

--创建半透明层
function LayerHelper.createTranslucentLayerByValue(v)
	local layer = cc.LayerColor:create(cc.c4b(0,0,0,v))
    local winSize = Director.getViewSizeScale() --可视区域
	layer:setContentSize(cc.size(winSize.width,winSize.height))
	layer:setPosition(cc.p(0,0))
	return layer
end

--创建半透明层
function LayerHelper.createTranslucentLayer()
	return LayerHelper.createTranslucentLayerByValue(128)
end

--创建全透明层
function LayerHelper.createTransparentLayer()
	return LayerHelper.createTranslucentLayerByValue(0)
end
