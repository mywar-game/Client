--缓存管理策略
require("CacheConfig")

CacheStrategy = {}

local _cache_level = 2       --缓存级别

local _cache_path_set_1 = {}--缓存级别为1时，需缓存的图片

_cache_path_set_1["map/bg1.png"] = true
_cache_path_set_1["map/bg2.png"] = true
_cache_path_set_1["map/bg3.png"] = true
_cache_path_set_1["map/bg4.png"] = true


local _cache_path_set_2 = {} --缓存级别为2时，需在1的基础上，额外缓存的图片

local function init()
    for i,v in ipairs(CacheConfig.cache_file_list_1) do
        _cache_path_set_2[v] = true
    end
end
--初始化配置
init()


function CacheStrategy.setCacheLevel(cache_level)
    _cache_level = cache_level
end

function CacheStrategy.isNeedCache(path)
    if path and string.find(path,"common/") then return true end
	
    if _cache_level == 1 then
        return _cache_path_set_1[path]
    elseif _cache_level == 2 then
        return _cache_path_set_1[path] or _cache_path_set_2[path]
    end
    
    return false
end

