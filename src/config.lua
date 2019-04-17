
-- 0 - disable debug info, 1 - less debug info, 2 - verbose debug info
DEBUG = 2

-- use framework, will disable all deprecated API, false - use legacy API
CC_USE_FRAMEWORK = true

-- show FPS on screen
CC_SHOW_FPS = true

-- disable create unexpected global variable
CC_DISABLE_GLOBAL = false

-- for module display
CC_DESIGN_RESOLUTION = {
    width = 480,
    height = 800,
    autoscale = "SHOW_ALL",
    callback = function(framesize)
        local ratio = framesize.width / framesize.height
        if ratio <= 1.34 then
            -- iPad 768*1024(1536*2048) is 4:3 screen
            return {autoscale = "SHOW_ALL"}
        end
    end
}

GAME_RES = {
    CURRENT = 1,
    HD = 1,
}

GAME_PLIST = {
    GAME_BM_PLIST = "plists/BM.plist",
    GAME_SHOOT_PLIST = "plists/shoot.plist",
    GAME_BACKGROUND_PLIST = "plists/shoot_background.plist",
}

GAME_IMAGE = {
    GAME_BM_PNG = "plists/BM.png",
    GAME_SHOOT_PNG = "plists/shoot.png",
    GAME_BACKGROUND_PNG = "plists/shoot_background.png",
}
