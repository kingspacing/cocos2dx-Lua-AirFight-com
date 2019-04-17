local MainMenuScene = class("MainMenuScene", function()
    return cc.Scene:create()
end)

function MainMenuScene:ctor()
    print("MainMenuScene:ctor -- ")
end

-- 创建场景
function MainMenuScene:createScene()
    local scene = MainMenuScene.new()
    scene:init()
    return scene 
end

-- 初始化
function MainMenuScene:init()
    print("MainMenuScene:init -- ")

    -- 添加MainMenuLayer层
    local layer = require("app.layers.MainMenuLayer"):create()
    self:addChild(layer) 
end

return MainMenuScene