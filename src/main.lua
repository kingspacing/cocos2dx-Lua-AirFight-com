
cc.FileUtils:getInstance():setPopupNotify(false)
cc.FileUtils:getInstance():addSearchPath("src/")
cc.FileUtils:getInstance():addSearchPath("res/")

require "config"
require "cocos.init"

-- log 
local cclog = function(...)
    print(string.format(...))
end

-- for CCLuaEngine traceback
function __G__TRACKBACK__(msg)
    cclog("----------------------------------------")
    cclog("LUA ERROR: " .. tostring(msg) .. "\n")
    cclog(debug.traceback())
    cclog("----------------------------------------")
    return msg
end

-- 获取版本号
local function getVersion()
    return 1
end

local function main()
    collectgarbage("collect")
    -- 防止内存泄漏
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)

    local assetsManager = cc.AssetsManager:new("http://update.starwars.910app.com/dragonball/package.zip",
    "http://update.starwars.910app.com/dragonball/versioncode.txt",
    pathToSave)
    local version = assetsManager:getVersion()

    if version ~= "" and getVersion() < tonumber(version)  then 
      local paths = cc.FileUtils:getInstance():getSearchPaths()
      table.insert(paths,1,  cc.FileUtils:getInstance():getWritablePath() .. "src")
      table.insert(paths,1,  cc.FileUtils:getInstance():getWritablePath() .. "res")
      table.insert(paths,1,  cc.FileUtils:getInstance():getWritablePath())
      cc.FileUtils:getInstance():setSearchPaths(paths)
    end

    require("app.MyApp")
    MyApp:run()
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
