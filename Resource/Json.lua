--使用开源库dkjson，执行编码和解码
--http://dkolf.de/src/dkjson-lua.fsl/home
require ("dkjson")

json = {}

local cjson = require "cjson.safe" 

function json.encode(tbl)
    --return dkjson.encode (tbl)
    return cjson.encode (tbl)
end

function json.decode(str)
--    local obj, pos, err = dkjson.decode (str, 1, nil)
--    if err then
--        print ("Json Decode Error:", err)
--    else
--        return obj
--    end
--return obj

    local tbl,err = cjson.decode(str)
    if not tbl then
        cclog("\n\n================================")
        cclog("Json Decode Error:", err)
        cclog(str)
        cclog("================================\n\n")
    end
    
    if tbl == cjson.null then tbl=nil end
    
    --过滤cjson.null,将其替换为nil
    local function replace_cjson_null(t)
        if not t then return end
        if type(t) == "userdata" then t=nil return end
        if type(t) ~= "table" then return end
        
        
        for k,v in pairs(t) do
            if type(v) == "table" then
                replace_cjson_null(v)
            elseif type(v) == "userdata" then
                --cclog("======================userdata key="..k)
                t[k] = nil
            else
                --cclog(k..":"..tostring(v))
            end
        end
    end
    
    replace_cjson_null(tbl)
    
    return tbl
end

