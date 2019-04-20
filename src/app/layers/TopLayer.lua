local TopLayer = class("TopLayer", function()
    return cc.Layer:create()
end)

function TopLayer:ctor()
    print("TopLayer:ctor -- ")
end

function TopLayer:create()
    local layer = TopLayer.new() 
    layer:init()
    return layer
end

function TopLayer:init()
    print("TopLayer:init -- ")

    local dataUser = require("tables.dataUser")

    -- csb资源
    local rootNode = cc.CSLoader:createNode("Top.csb")
    self:addChild(rootNode)
    rootNode:setName("TopRootNode")

    local root = rootNode:getChildByName("Layout") 

    -- 1 成就 2 活动 3 充值 4 排行 5 金币
    local btn = {
        [1] = ccui.Helper:seekWidgetByName(root, "btn_achievement"),
        [2] = ccui.Helper:seekWidgetByName(root, "btn_activity"),
        [3] = ccui.Helper:seekWidgetByName(root, "btn_charge"),
        [4] = ccui.Helper:seekWidgetByName(root, "btn_ranking"),
        [5] = ccui.Helper:seekWidgetByName(root, "btn_gold_bg")
    }

    btn[1]:addClickEventListener(function(send)
        print("achievement")
    end)

    btn[2]:addClickEventListener(function(send)
        print("activity")
    end)

    btn[3]:addClickEventListener(function(send)
        print("charge")
    end)

    btn[4]:addClickEventListener(function(send)
        print("ranking")
    end)

    btn[5]:addClickEventListener(function(send)
        print("gold_add")
    end)

    local lab_gold_number = ccui.Helper:seekWidgetByName(btn[5], "lab_gold_number")       
    lab_gold_number:setString(dataUser.getGold())    
end

function TopLayer:freshGold()
    local dataUser = require("tables.dataUser")
    local rootNode = self:getChildByName("TopRootNode")        
    local root = rootNode:getChildByName("Layout") 
    local button = ccui.Helper:seekWidgetByName(root, "btn_gold_bg")      
    local lab_gold_number = ccui.Helper:seekWidgetByName(button, "lab_gold_number")   

    lab_gold_number:setString(dataUser.getGold())
end

return TopLayer