local IndexScene = class("IndexScene", function()
    return cc.Scene:create()
end)

function IndexScene:ctor()
    print("IndexScene:ctor -- ")
    isEnter = false
end

function IndexScene:createScene()
    local scene = IndexScene.new()
    scene:init()
    return scene
end

function IndexScene:init()
    print("IndexScene:init -- ")

    -- 添加IndexLayer层
    local IndexLayer = require("app.layers.IndexLayer"):create()
    self:addChild(IndexLayer, 0)
    -- 添加TopLayer层
    local TopLayer = require("app.layers.TopLayer"):create()
    self:addChild(TopLayer, 1)
    TopLayer:setName("TopLayer")
end

return IndexScene