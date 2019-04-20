
MyApp = {}

function MyApp:run()
    print("MyApp:run -- ")

    self:enterMainMenuScene()
end

-- 主菜单
function MyApp:enterMainMenuScene()
    local scene = require("app.scenes.MainMenuScene"):createScene()
    MyApp:toScene(scene)
end

-- 首页界面
function MyApp:enterIndexScene()
    local scene = require("app.scenes.IndexScene"):createScene()
    MyApp:toScene(scene)
end

isEnter = false
-- 场景跳转方法
function MyApp:toScene(scene)
    if isEnter == true then
        return 
    end
    isEnter = true
    if cc.Director:getInstance():getRunningScene() then
        cc.Director:getInstance():replaceScene(cc.TransitionFade:create(1.0, scene))
    else    
        cc.Director:getInstance():runWithScene(scene)
    end
end

-- 获取版本号
function MyApp:getVersion()
    return 1
end

-- 判断是否联网
function MyApp:isConnect()
    return true
end

return MyApp
