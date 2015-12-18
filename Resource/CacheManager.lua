--缓存管理
require("CacheStrategy")

CacheManager = {}

local cache_set = {} --1是texture 2是textureframe


function CacheManager.cacheTexture(path)
    if CacheStrategy.isNeedCache(path) then
        cache_set[path] = 1
        local texture = cc.Director:getInstance():getTextureCache():getTextureForKey(path)
        if texture then texture:retain() end
    end
end

function CacheManager.cacheTextureFrame(path)
    if CacheStrategy.isNeedCache(path) then
        cache_set[path] = 2
        local texture_frame = cc.SpriteFrameCache:getInstance():spriteFrameByName(path)
        if texture_frame then texture_frame:retain() end
    end
end

function CacheManager.purge()
    --清理缓存资源
    --cc.SpriteFrameCache:getInstance():removeUnusedSpriteFrames()
    --cc.Director:getInstance():getTextureCache():removeUnusedTextures()
end


--预加载图片
function CacheManager.perLoader(imagePath,onProgressCallback,onFinishCallback)

end

function CacheManager.perLoaderAllSilently()
    function callback(path)
        cclog("CacheManager.perLoaderAllSilently -> ".. path)
    end

    require("CacheConfig")
    for i,v in ipairs(CacheConfig.perloadImages) do
        --LoadImageAsync(v,callback)
    end
end
