PlatFormFunction = {}
--获取登录token
function PlatFormFunction.getLoginToken()
    local token=nil
    if V.getPlatFormType() == 3 then--android平台的调用
        token = SendCmdToPlatFormHaveResult("com/fantingame/xgame/JniCall","getLoginToken","")
    else
        token="testtoken"
    end
    return token
end