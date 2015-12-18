--
local ticker_handler = nil
local scheduler	= Director.getScheduler()
local isShowing = false
local debug_info_layer

Debug = {} 


--显示内存占用信息
local function showMemoryInfo(layer)
    --lua虚拟机内存占用
    local collectgarbageCount = collectgarbage("count")
    local imageCacheTotalMemory = 0
    local imageCacheCount = 0
    --缓存图片数量，及内存占用量
    if CCTextureCache:getInstance().dumpCachedTextureInfoTotalMemory then
        imageCacheTotalMemory = CCTextureCache:getInstance():dumpCachedTextureInfoTotalMemory()
    end

    if cc.Director:getInstance():getTextureCache().dumpCachedTextureInfoImageCount then
        imageCacheCount = cc.Director:getInstance():getTextureCache():dumpCachedTextureInfoImageCount()
    end
    
    --cclog("Lua:"..math.ceil(collectgarbageCount).."k  imageCacheTotalMemory:"..imageCacheTotalMemory.."k  imageCacheCount:"..imageCacheCount)
    
    if not layer.memoryInfolable then 
        layer.memoryInfolable = CreateLabel(LabelChineseStr.Debug_1,nil,14,cc.c3b(0,255,0))  
        layer.memoryInfolable:setPosition(10,10)
        layer.memoryInfolable:setAnchorPoint(cc.p(0,0))
        layer:addChild(layer.memoryInfolable) 
    end
    
    local function numberFormat(num)
        num = math.ceil(num)
        if num > 1024 then
            return num.."k("..string.format("%2.2f",num/1024).."M)"
        else
            return num.."k"
        end
    end
    
    layer.memoryInfolable:setString("Lua"..LabelChineseStr.Debug_2..numberFormat(collectgarbageCount).."\n"..LabelChineseStr.Debug_3..imageCacheCount..LabelChineseStr.Debug_4..numberFormat(imageCacheTotalMemory))
end

function UpdateDebugLayer(duration)
    if not debug_info_layer then
    	debug_info_layer = cc.LayerColor:create(cc.c4b(0,0,0,200))
    	debug_info_layer:setContentSize(cc.size(300,50))
        LayerManager.addToDebugLayer(debug_info_layer)
    end
    showMemoryInfo(debug_info_layer)
	-- debug_info_layer:setScale(2)
end


local function startTicker()
    if not ticker_handler then
        --ticker_handler = scheduler:scheduleScriptFunc(UpdateDebugLayer,0.1,false)
    end
end

local function endTicker()
    if ticker_handler then
        scheduler:unscheduleScriptEntry(ticker_handler)
        ticker_handler = nil
    end
end





--显示debgu信息
function Debug.show()
   
   startTicker()
   isShowing = true
end

--隐藏debug信息
function Debug.hide()
   if not debug_info_layer then return end
   
   endTicker()
   
   if debug_info_layer then 
        debug_info_layer:removeFromParent() 
        debug_info_layer = nil 
   end
   isShowing = false
end


function Debug.toggle()
    if isShowing then
        Debug.hide()
    else
        Debug.show()
    end
end