local IndexLayer = class("IndexLayer", function()
    return cc.Layer:create()
end)

local visible = cc.Director:getInstance():getVisibleSize()
local dataUser = require("tables.dataUser")
local dataUi = require("tables.dataUi")

function IndexLayer:ctor()
    print("IndexLayer:ctor -- ")    
end

function IndexLayer:create()
    local layer = IndexLayer.new() 
    layer:init()
    return layer
end

function IndexLayer:init()
    print("IndexLayer:init -- ")

    local rootNode = cc.CSLoader:createNode("Index.csb")
    self:addChild(rootNode)

    local root = rootNode:getChildByName("Layout")

    --1 强化 2 进阶 3 左箭头 4 右箭头 5 礼包 6 音乐 7 冒险 8 客服 9-11 选择角色 12-13 范围 14 幸运转盘
    local btn = {
        [1] = ccui.Helper:seekWidgetByName(root, "btn_intensify"),
        [2] = ccui.Helper:seekWidgetByName(root, "btn_advanced"),
        [3] = ccui.Helper:seekWidgetByName(root, "btn_left"),
        [4] = ccui.Helper:seekWidgetByName(root, "btn_right"),
        [5] = ccui.Helper:seekWidgetByName(root, "btn_gift"),
        [6] = ccui.Helper:seekWidgetByName(root, "btn_music"),
        [7] = ccui.Helper:seekWidgetByName(root, "btn_adventure"),
        [8] = ccui.Helper:seekWidgetByName(root, "btn_phone"),
        [9] = ccui.Helper:seekWidgetByName(root, "btn_hero_0"),
        [10] = ccui.Helper:seekWidgetByName(root, "btn_hero_1"),
        [11] = ccui.Helper:seekWidgetByName(root, "btn_hero_2"),
        [12] = ccui.Helper:seekWidgetByName(root, "btn_disabled_1"),
        [13] = ccui.Helper:seekWidgetByName(root, "btn_disabled_2"),
        [14] = ccui.Helper:seekWidgetByName(root, "btn_lucky")
    }

    -- 1 攻击力 2 生命值 3-5 角色名 6 强化消耗 7 进阶消耗
    local lab = {
        [1] = ccui.Helper:seekWidgetByName(root, "lab_attack"),
        [2] = ccui.Helper:seekWidgetByName(root, "lab_life"),
        [3] = ccui.Helper:seekWidgetByName(root, "lab_hero_name_0"),
        [4] = ccui.Helper:seekWidgetByName(root, "lab_hero_name_1"),
        [5] = ccui.Helper:seekWidgetByName(root, "lab_hero_name_2"),
        [6] = ccui.Helper:seekWidgetByName(root, "lab_intensify_consume"),
        [7] = ccui.Helper:seekWidgetByName(root, "lab_advanced_consume")
    }
    -- 1 强化消耗 2 进阶消耗 3 攻击力 4 生命值 5 等级
    local num = {
        [1] = ccui.Helper:seekWidgetByName(root, "lab_intensify_number"),
        [2] = ccui.Helper:seekWidgetByName(root, "lab_advanced_number"),
        [3] = ccui.Helper:seekWidgetByName(root, "lab_attack_number"),
        [4] = ccui.Helper:seekWidgetByName(root, "lab_life_number"),
        [5] = ccui.Helper:seekWidgetByName(root, "lab_level_number")
    }

    -- 星星
    local star = {
        [1] = ccui.Helper:seekWidgetByName(root, "img_star_1"),
        [2] = ccui.Helper:seekWidgetByName(root, "img_star_2"),
        [3] = ccui.Helper:seekWidgetByName(root, "img_star_3")
    }

    -- 英雄精灵图片
    local hero = {
        [1] = cc.Sprite:createWithSpriteFrameName("hero1.png")
    }

    -- 初始化部分控件
    btn[12]:setVisible(false)
    btn[13]:setVisible(false)

    -- 选择英雄按钮
    local function changeBtnState()
        local hero_data = dataUser.getHero()
        for i=9,11 do
            -- 锁上和变暗
            if hero_data[i-8].isHave == false then
                btn[i]:setBright(false)
                btn[i]:setTouchEnabled(false)                
            end            
        end
    end
    changeBtnState()

    -- 英雄ID
    local ID = dataUser.getHeroID()

    -- 默认英雄
    local sprite_hero = hero[ID]

    -- 英雄名字
    local hero_name = {
        [1] = "zero",
        [2] = "one",
        [3] = "three" 
    }

    -- 刷新TopLayer金币数
    local function freshGold()
        self:getParent():getChildByName("TopLayer"):freshGold()
    end

    -- 显示星级
    local function showStar()
        local user_data = dataUser.getHero()
        if user_data[ID].star == 1 then
            star[1]:setVisible(true)
            star[2]:setVisible(false)
            star[3]:setVisible(false)
        elseif user_data[ID].star == 2 then
            star[1]:setVisible(true)
            star[2]:setVisible(true)
            star[3]:setVisible(false)
        elseif user_data[ID].star == 3 then
            star[1]:setVisible(true)
            star[2]:setVisible(true)
            star[3]:setVisible(true)
        end
    end    

    -- 根据名字和等级获取强化表
    local function getHeroConsolidataTableByNameAndLevel(name, level)
        local table = nil 
        local t = dataUi.getConsolidate()
        
        for k,v in pairs(t) do
            if v.name == name and v.level == level then
                table = v
            end
        end

        return table
    end

    -- 根据名字和星级获取强化所需金币表
    local function getIntensifyGoldTableByNameAndStar(name, star)
        local table = nil 
        local t = dataUi.getIntensifyGold()

        for k,v in pairs(t) do
            if v.name == name and v.star == star then
                table = v 
            end
        end
        
        return table
    end

    -- 根据名字和等级获取进阶所需金币表
    local function getAdvencedGoldTableByNameAndStar(name, star)
        local table = nil
        local t = dataUi.getAdvancedGold()

        for k,v in pairs(t) do
            if v.name == name and v.star == star then
                table = v 
            end
        end

        return table
    end


    -- 强化按钮
    btn[1]:addClickEventListener(function(sender)
        -- 英雄属性
        local hero_data = dataUser.getHero()        
         -- 强化消耗金币数表
        local table_Intensify_gold = getIntensifyGoldTableByNameAndStar(hero_name[ID], hero_data[ID].star)

        -- 修改英雄属性
        if hero_data[ID].star == 1 then
            if hero_data[ID].level < 3 then
                hero_data[ID].level = hero_data[ID].level + 1   
                dataUser.user_data.gold = dataUser.user_data.gold - table_Intensify_gold.gold             
            else
                print("一星满等级，进阶")
            end
        elseif hero_data[ID].star == 2 then
            if hero_data[ID].level >= 3 and hero_data[ID].level < 6 then
                hero_data[ID].level = hero_data[ID].level + 1      
                dataUser.user_data.gold = dataUser.user_data.gold - table_Intensify_gold.gold          
            else
                print("二星满等级，进阶")
            end
        elseif hero_data[ID].star == 3 then
            if hero_data[ID].level >= 6 and hero_data[ID].level < 9 then
                hero_data[ID].level = hero_data[ID].level + 1    
                dataUser.user_data.gold = dataUser.user_data.gold - table_Intensify_gold.gold            
            else
                print("最大等级")
            end
        end

        -- 强化表
        local table_hero = getHeroConsolidataTableByNameAndLevel(hero_name[ID], hero_data[ID].level)

        if hero_data[ID].star == 1 then
            if hero_data[ID].level <= 3 then
                hero_data[ID].attack = table_hero.attack
                hero_data[ID].life = table_hero.life                
            end
        elseif hero_data[ID].star == 2 then
            if hero_data[ID].level >= 3 and hero_data[ID].level <= 6 then
                hero_data[ID].attack = table_hero.attack
                hero_data[ID].life = table_hero.life
            end
        elseif hero_data[ID].star == 3 then
            if hero_data[ID].level >= 6 and hero_data[ID].level <= 9 then
                hero_data[ID].attack = table_hero.attack
                hero_data[ID].life = table_hero.life
            end
        end
        
        -- 修改面板数值        
        num[3]:setString(table_hero.attack)
        num[4]:setString(table_hero.life)
        num[5]:setString(table_hero.level)
        num[1]:setString(table_Intensify_gold.gold)

        dataUser:flushJson()

        freshGold()

    end)
    
    btn[2]:addClickEventListener(function(sender)
        -- 英雄属性
        local hero_data = dataUser.getHero()        
        -- 进阶表
        local table_hero = getHeroConsolidataTableByNameAndLevel(hero_name[ID], hero_data[ID].level) 
              
        -- 修改英雄属性
        if hero_data[ID].level == 3 and hero_data[ID].star == 1 then
            hero_data[ID].star = hero_data[ID].star + 1
            local table_advanced_gold = getAdvencedGoldTableByNameAndStar(hero_name[ID], hero_data[ID].star)
            dataUser.user_data.gold = dataUser.user_data.gold - table_advanced_gold.gold          
        elseif hero_data[ID].level == 6 and hero_data[ID].star == 2 then
            hero_data[ID].star = hero_data[ID].star + 1
            local table_advanced_gold = getAdvencedGoldTableByNameAndStar(hero_name[ID], hero_data[ID].star)
            dataUser.user_data.gold = dataUser.user_data.gold - table_advanced_gold.gold
        elseif hero_data[ID].level == 9 and hero_data[ID].star == 3 then
            print("最大星级")
        else
            print("等级不足，无法进阶")
        end
        
        local table_hero = getHeroConsolidataTableByNameAndLevel(hero_name[ID], hero_data[ID].level)        
        -- 进阶消耗金币数表
        local table_advanced_gold = getAdvencedGoldTableByNameAndStar(hero_name[ID], hero_data[ID].star)
        -- 强化消耗金币数表
        local table_Intensify_gold = getIntensifyGoldTableByNameAndStar(hero_name[ID], hero_data[ID].star)

        -- 显示星级
        showStar()

        -- 修改面板数据
        num[1]:setString(table_Intensify_gold.gold)
        num[2]:setString(table_advanced_gold.gold)

        dataUser:flushJson()
        freshGold()
    end)
    
    btn[3]:addClickEventListener(function(sender)
        print("3")
    end)

    btn[4]:addClickEventListener(function(sender)
        print("4")
    end)

    btn[5]:addClickEventListener(function(sender)
        print("5")
    end)

    btn[6]:addClickEventListener(function(sender)
        print("6")
    end)

    btn[7]:addClickEventListener(function(sender)
        print("7")
    end)

    btn[8]:addClickEventListener(function(sender)
        print("8")
    end)

    btn[9]:addClickEventListener(function(sender)
        print("9")
    end)

    btn[10]:addClickEventListener(function(sender)
        print("10")
    end)

    btn[11]:addClickEventListener(function(sender)
        print("11")
    end)

    btn[12]:addClickEventListener(function(sender)
        print("12")
    end)

    btn[13]:addClickEventListener(function(sender)
        print("13")
    end)

    btn[14]:addClickEventListener(function(sender)
        print("14")
    end)

    -- 默认界面
    local function initShow()
        -- 英雄属性
        local hero_data = dataUser.getHero()
        -- 强化表
        local table_hero = getHeroConsolidataTableByNameAndLevel(hero_name[ID], hero_data[ID].level)
        -- 强化金币表
        local table_intensify_gold = getIntensifyGoldTableByNameAndStar(hero_name[ID], hero_data[ID].star)
        -- 进阶金币表
        local table_advanced_gold = getAdvencedGoldTableByNameAndStar(hero_name[ID], hero_data[ID].level)

        -- 初始化英雄精灵
        sprite_hero:setPosition(cc.p(visible.width / 2, visible.height * 0.6))
        self:addChild(sprite_hero)    
        local animation_hero = cc.RepeatForever:create(cc.Animate:create(cc.AnimationCache:getInstance():getAnimation("ANIMATION_HERO_0")))
        sprite_hero:runAction(animation_hero)

        -- 初始化数据
        hero_data[ID].attack = table_hero.attack
        hero_data[ID].life = table_hero.life
        hero_data[ID].level = table_hero.level
        num[1]:setString(table_intensify_gold.gold)
        num[2]:setString(table_advanced_gold.gold)
        num[3]:setString(hero_data[ID].attack)
        num[4]:setString(hero_data[ID].life)
        num[5]:setString(hero_data[ID].level)    

        -- 显示英雄星级
        showStar() 

        -- 刷新数据
        dataUser:flushJson()
    end
    initShow()
end

return IndexLayer