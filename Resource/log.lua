local debugtofile = false
function cclog(...)
    if not Config.debug then return end
    if debugtofile then
        local file_path = "debug.log"
        local os = cc.Application:getInstance():getTargetPlatform() 
        if os and os == kTargetAndroid then 
            file_path = "/sdcard/ldsg_debug.log"
        end
        local f = io.open(file_path,"a+")
        f:write(Json.Encode(...))
        f:write("\n")
        f:flush()
        f:close()
    else
       print(...)
    end
end

function cclogtab(tab)
    if not Config.debug then return end
    cclog(json.encode(tab or {}))
end

function cclogtable(sth)
    if type(sth) ~= "table" then
        print(sth)
        return
    end
    local space, deep = string.rep(' ', 4), 0
    local function _dump(t)
        local temp = {}
        for k,v in pairs(t) do
            local key = tostring(k)

            if type(v) == "table" then
                deep = deep + 2
                print(string.format("%s[%s] => Table\n%s(",
                    string.rep(space, deep - 1),
                    key,
                    string.rep(space, deep)
                )
                ) --print.
                _dump(v)

                print(string.format("%s)",string.rep(space, deep)))
                deep = deep - 2
            else
                print(string.format("%s[%s] => %s",
                    string.rep(space, deep + 1),
                    key,
                    v
                )
                ) --print.
            end 
        end 
    end
    print(string.format("Table"))
    print(string.format("("))
    _dump(sth)
    print(string.format(")"))
end
local bgSprite = nil
local logLable = nil
function Main_logToUi(msg)
    if not Config.debug then return end
	if bgSprite == nil then
		bgSprite = CreateCCSprite("common/tips_bg.png")
		bgSprite:setPosition(cc.p(480,320))
		LayerManager.addToDebugLayer(bgSprite)
		local size = bgSprite:getContentSize()
		logLable = CreateLabel(msg,nil,14,cc.c3b(255,255,255),1) 
		logLable:setDimensions(cc.size(size.width-20,size.height-20))
		logLable:setAnchorPoint(cc.p(0,0))
		logLable:setPosition(cc.p(10,10))
		logLable:setHorizontalAlignment(0)
		bgSprite:addChild(logLable)
	end	
	logLable:setString(msg)
end

function Main_cleanLog()
	if bgSprite then
		bgSprite:removeFromParent(true)
		bgSprite = nil
	end
end

--潜在的错误
function ccloge(msg)
    if not Config.debug then return end
    
    cclog("\n[error] --> "..(msg and msg or "no msg"))
    cclog("---------------------------------------------------")
end