local resVersion="1.74" --特别重要

--获取本地资源版本
VersionNumRes = {}
function VersionNumRes.getLocalResVersion()
    print("本地资源版本号为"..resVersion)
    return resVersion
end