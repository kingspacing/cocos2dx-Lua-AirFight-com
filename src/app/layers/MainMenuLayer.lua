local MainMenuLayer = class("MainMenuLayer", function()
    return cc.Layer:create()
end)

require "config"

local visible = cc.Director:getInstance():getVisibleSize()

function MainMenuLayer:ctor()
    print("MainMenuLayer:ctor -- ")
end

-- 创建
function MainMenuLayer:create()
    local layer = MainMenuLayer.new()
    layer:init()
    return layer
end

-- 初始化
function MainMenuLayer:init()
    print("MainMenuLayer:init -- ")

    -- 加载动画
    local loading_sprite = cc.Sprite:create("images/shoot_background/game_loading1.png")
    loading_sprite:setPosition(cc.p(240, 150))
    self:addChild(loading_sprite, 1)
    local loading_animation = cc.Animation:create()
    local loading_frame_1 = cc.SpriteFrame:create("images/shoot_background/game_loading1.png", cc.rect(0, 0, 186, 38))
    local loading_frame_2 = cc.SpriteFrame:create("images/shoot_background/game_loading2.png", cc.rect(0, 0, 186, 38))
    local loading_frame_3 = cc.SpriteFrame:create("images/shoot_background/game_loading3.png", cc.rect(0, 0, 186, 38))
    local loading_frame_4 = cc.SpriteFrame:create("images/shoot_background/game_loading4.png", cc.rect(0, 0, 186, 38))
    loading_animation:addSpriteFrame(loading_frame_1)
    loading_animation:addSpriteFrame(loading_frame_2)
    loading_animation:addSpriteFrame(loading_frame_3)
    loading_animation:addSpriteFrame(loading_frame_4)
    loading_animation:setDelayPerUnit(0.3)
    loading_animation:setRestoreOriginalFrame(true)
    local animate = cc.Animate:create(loading_animation)
    local action = cc.RepeatForever:create(animate)
    loading_sprite:runAction(action)
    
    
    -- csb资源
    local rootNode = cc.CSLoader:createNode("MainMenu.csb")
    self:addChild(rootNode)

    local root = rootNode:getChildByName("Layout_layout")

    local start_button = ccui.Helper:seekWidgetByName(root, "start_button")
    start_button:setVisible(false)

    -- 加载资源
    local resFiles = {
        GAME_PLIST.GAME_BM_PLIST,
        GAME_PLIST.GAME_SHOOT_PLIST,
        GAME_PLIST.GAME_BACKGROUND_PLIST
    }

    local resImages = {
        GAME_IMAGE.GAME_BM_PNG,
        GAME_IMAGE.GAME_SHOOT_PNG,
        GAME_IMAGE.GAME_BACKGROUND_PNG
    }

    local isLoading = false 
    local currentRes = 0

    -- 加载精灵帧缓存
    local function loaded(texture)
        cc.SpriteFrameCache:getInstance():addSpriteFrames(resFiles[currentRes])
        isLoading = false 
    end

    -- 加载纹理缓存
    local function load(configFilePath)
        isLoading = true
        cc.Director:getInstance():getTextureCache():addImageAsync(configFilePath, loaded)
    end
    
    -- 获取动画函数
    local function getAnimationByName(animName, delay, animNum)
        local animation = cc.Animation:create()

        for i=1,animNum do
            local frameName = string.format(animName..i..".png")
            print("frameName: ".. frameName)
            local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(frameName)
            animation:addSpriteFrame(frame)
        end

        animation:setDelayPerUnit(delay)
        animation:setRestoreOriginalFrame(true)

        return animation
    end
    
    -- 加载动画缓存
    local function loadAnimationCache()
        local animation_hero_0 = getAnimationByName("hero", 0.1, 2)
        cc.AnimationCache:getInstance():addAnimation(animation_hero_0, "ANIMATION_HERO_0")
    end

    -- 可以在此加载游戏资源
    local function update()
        if isLoading then
            return
        end
        currentRes = currentRes + 1
        if currentRes > #resImages then
            self:unscheduleUpdate()
            loadAnimationCache()

            loading_sprite:stopAllActions()
            loading_sprite:setVisible(false)

            -- 飞机动画
            local sprite = cc.Sprite:createWithSpriteFrameName("hero1.png")
            sprite:setPosition(cc.p(visible.width / 2, visible.height / 2))
            self:addChild(sprite)
            local animation = cc.AnimationCache:getInstance():getAnimation("ANIMATION_HERO_0")
            local animate = cc.Animate:create(animation)
            sprite:runAction(cc.RepeatForever:create(animate))

            start_button:setVisible(true)
            start_button:addClickEventListener(function(sender)
                print("start game")
                MyApp:enterIndexScene()
            end)
            return 
        end
        load(resImages[currentRes])        
    end

    local function loadGameRes()
        self:scheduleUpdateWithPriorityLua(update, 0)        
    end


-----------------------------------------------热更新

    -- 获取版本号
    local pathToSave = cc.FileUtils:getInstance():getWritablePath()
    local assetsManager = cc.AssetsManager:new("http://update.starwars.910app.com/dragonball/package.zip",
        "http://update.starwars.910app.com/dragonball/versioncode.txt",
        pathToSave)
    assetsManager:retain()
    local version = assetsManager:getVersion()
    if version == "" then
        version = MyApp:getVersion()
    else
        version = tonumber(version)
        if MyApp:getVersion() > version then
            version = MyApp:getVersion()
        end
    end

    -- 正在更新
    local function startUpdate()
        local rootNodeUpdate = cc.CSLoader:createNode("MainMenuUpdate.csb")
        self:addChild(rootNodeUpdate)

        local rootUpdate = rootNodeUpdate:getChildByName("Layout")

        local loading = ccui.Helper:seekWidgetByName(rootUpdate, "loading_loadingbar")
        loading:setPercent(0)

        local number_text = ccui.Helper:seekWidgetByName(rootUpdate, "number_text")
        
        local char_text = ccui.Helper:seekWidgetByName(rootUpdate, "char_text")

        local loading_text = ccui.Helper:seekWidgetByName(rootUpdate, "loading_text")
        loading_text:setString("正在进行更新。。。。。。")

        local cancel_button = ccui.Helper:seekWidgetByName(rootUpdate, "cancel_button")
        cancel_button:addClickEventListener(function(sender)
            local scheduler = cc.Director:getInstance():getScheduler()
            scheduler:unscheduleScriptEntry(self.scheduleScriptEntryID)
            rootNodeUpdate:removeFromParent()
            print("cancel") 
        end)

        local ok_button = ccui.Helper:seekWidgetByName(rootUpdate, "ok_button")
        ok_button:setVisible(false)

        local yes_button = ccui.Helper:seekWidgetByName(rootUpdate, "yes_button")
        yes_button:setVisible(false)

        local no_button = ccui.Helper:seekWidgetByName(rootUpdate, "no_button")
        no_button:setVisible(false)

        local percent = 0
        function loadingbarUpdate(dt)            
            if percent <= 100 then
                loading:setPercent(percent)
                number_text:setString(tostring(percent))
                percent = percent + 1
            elseif percent > 100 then
                local scheduler = cc.Director:getInstance():getScheduler()
                scheduler:unscheduleScriptEntry(self.scheduleScriptEntryID)

                loading_text:setString("更新完成")
                cancel_button:setVisible(false)
                ok_button:setVisible(true)
                ok_button:addClickEventListener(function(sender)
                    rootNodeUpdate:removeFromParent()
                    loadGameRes()
                end)
            end
        end

        local scheduler = cc.Director:getInstance():getScheduler()
            self.scheduleScriptEntryID = scheduler:scheduleScriptFunc(function(dt)
            loadingbarUpdate(dt)
        end, 0.1, false)

        local function onError(errorCode)
            if errorCode == cc.ASSETSMANAGER_NO_NEW_VERSION then
                
            elseif errorCode == cc.ASSETSMANAGER_NETWORK then
                
            end

            performWithDelay(self, function()
                rootNodeUpdate:removeFromParent()
                loadGameRes()
            end, 0.5)
        end

        local function onProgress(percent)
            print("onProgress")
            loading:setPercent(tonumber(percent))
            number_text:setString(percent) 
        end

		local function onSuccess()
			package.loaded["app.MyApp"] = nil
			package.loaded["config"] = nil
			require "app.MyApp"
			require "config"
			performWithDelay(self, function()
				bgLayer:removeFromParent()
				local paths = cc.FileUtils:getInstance():getSearchPaths()
				table.insert(paths,1,  cc.FileUtils:getInstance():getWritablePath() .. "src")
				table.insert(paths,1,  cc.FileUtils:getInstance():getWritablePath() .. "res")
				table.insert(paths,1,  cc.FileUtils:getInstance():getWritablePath())
				cc.FileUtils:getInstance():setSearchPaths(paths)
				loadGameRes()
			end, 0.5)
        end
        
		assetsManager:setDelegate(onError, cc.ASSETSMANAGER_PROTOCOL_ERROR )
		assetsManager:setDelegate(onProgress, cc.ASSETSMANAGER_PROTOCOL_PROGRESS)
		assetsManager:setDelegate(onSuccess, cc.ASSETSMANAGER_PROTOCOL_SUCCESS )
		assetsManager:setConnectionTimeout(3)
		assetsManager:update() 

    end

    -- 更新弹窗
    local function showUpdateDialog(content)
        local rootNodeUpdate = cc.CSLoader:createNode("MainMenuUpdate.csb")
        self:addChild(rootNodeUpdate)

        local rootUpdate = rootNodeUpdate:getChildByName("Layout")

        local loading = ccui.Helper:seekWidgetByName(rootUpdate, "loading_loadingbar")
        loading:setVisible(false)

        local number_text = ccui.Helper:seekWidgetByName(rootUpdate, "number_text")
        number_text:setVisible(false)
        
        local char_text = ccui.Helper:seekWidgetByName(rootUpdate, "char_text")
        char_text:setVisible(false)

        local loading_text = ccui.Helper:seekWidgetByName(rootUpdate, "loading_text")

        local cancel_button = ccui.Helper:seekWidgetByName(rootUpdate, "cancel_button")
        cancel_button:setVisible(false)

        local ok_button = ccui.Helper:seekWidgetByName(rootUpdate, "ok_button")
        ok_button:setVisible(false)

        local yes_button = ccui.Helper:seekWidgetByName(rootUpdate, "yes_button")
        yes_button:addClickEventListener(function(sender)
            rootNodeUpdate:removeFromParent()
            startUpdate()
        end)

        local no_button = ccui.Helper:seekWidgetByName(rootUpdate, "no_button")
        no_button:addClickEventListener(function(sender)
            rootNodeUpdate:removeFromParent()
            performWithDelay(self,function()
                loadGameRes()
            end, 0.5)
        end)
    end 

    -- 连接了网络
    if MyApp:isConnect() then
        print("NetWork Connected")
        local vHttp = cc.XMLHttpRequest:new()
        vHttp.timeout = 300
        vHttp.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
        vHttp:open("GET", "http://update.starwars.910app.com/dragonball/versioncode.txt")
        local function onReadyStateChange()
            if vHttp.status == 200 then
                local v = tonumber(vHttp.response)
                print("New Version: "..v)
                print("Old Version: "..version)
                -- 修改是否进入更新界面
                -- v < version
                if v == version then
                    local sHttp = cc.XMLHttpRequest:new()
                    sHttp.timeout = 300
                    sHttp.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
                    sHttp:open("GET", "http://update.starwars.910app.com/dragonball/size.txt")
                    sHttp:registerScriptHandler(function()
                        self:unscheduleUpdate()
                        if sHttp.status == 200 then
                            print("size: ".. sHttp.response)
                            showUpdateDialog(sHttp.response)
                        else
                            performWithDelay(self, function()
                                loadGameRes()
                            end, 0.5)
                        end
                    end)
                    sHttp:send()
                else
                    performWithDelay(self, function()
                        loadGameRes()
                    end, 0.5)
                end
            else
                performWithDelay(self, function()
                    loadGameRes()
                end, 0.5)
            end
        end
        vHttp:registerScriptHandler(onReadyStateChange)
        vHttp:send()
    else
        performWithDelay(self, function()
            loadGameRes()
        end, 0.5)
    end


    -- 3秒时间网络超时
    local t = 0
    self:scheduleUpdateWithPriorityLua(function()
        if t >= 3 * 60 then
            self:unscheduleUpdate()
            loadGameRes()
        else
            t = t + 1
        end
    end, 0)
end

return MainMenuLayer