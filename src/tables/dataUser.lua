local dataUser = {}

dataUser.user_data = {
    -- 金币
    gold = 100000,
    -- 是否拥有英雄以及数据
    hero = {
        [1] = {is_have = true, star = 1, level = 1, attack = 0, life = 0}, 
        [2] = {is_have = false, star = 1, level = 1, attack = 0, life = 0},
        [3] = {is_have = false, star = 1, level = 1, attack = 0, life = 0}
    },
    ID = 1
    
}

-- 读取数据
function dataUser.readPlayerDataFromFile()
    local file = io.open(cc.FileUtils:getInstance():getWritablePath().."data5.dat", "r")
    require("json")
    local jsondata = file:read("*all")
    dataUser.user_data = json.decode(jsondata)
    file:close()
end

-- 写入数据
function dataUser.writePlayerDataFile()
    -- 存档兼容处理
    if dataUser.user_data.attack == nil then
        dataUser.user_data.attack = 1
        dataUser.user_data.life = 1
    end

    local file = io.open(cc.FileUtils:getInstance():getWritablePath().."data5.dat", "w")
    require("json")
    local jsondata = json.encode(dataUser.user_data)
    file:write(jsondata)
    file:close()
end

function dataUser.flushJson()
    dataUser.writePlayerDataFile()
    dataUser.readPlayerDataFromFile()
    print(" -- NOW STATE: -------------------------------")    
    print("dataUser_hero: ".." star: "..dataUser.user_data.hero[1].star)
    print("dataUser_hero: ".." level: "..dataUser.user_data.hero[1].level)
    print("dataUser_hero: ".." attack: "..dataUser.user_data.hero[1].attack)
    print("dataUser_hero: ".." life: "..dataUser.user_data.hero[1].life)
    print(" -- END --------------------------------------")
end

-- 测试存档数据
function dataUser.initDataUser()
    print("dataUser:initDataUser -- ")

    local flag

    if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_MAC then
        if cc.FileUtils:getInstance():isFileExist(cc.FileUtils:getInstance():getWritablePath().."data5.dat") then
            flag = false
        else    
            flag = true
        end
    else
        flag = cc.UserDefault:getInstance():getBoolForKey("FirstIn", true)
    end

    if flag == true then
        cc.UserDefault:getInstance():setBoolForKey("FirstIn", false)
        cc.UserDefault:getInstance():flush()
        dataUser.writePlayerDataFile()
    else    
        dataUser.readPlayerDataFromFile()

        if dataUser.user_data.gold == 10000 then
            dataUser.user_data.gold = 23333
        end

        dataUser.flushJson()
        print("gold: "..dataUser.user_data.gold)
    end
end

-- 获取金币数据
function dataUser.getGold()
    return dataUser.user_data.gold
end

-- 增加金币
function dataUser.upGold(n)
    dataUser.user_data.gold = dataUser.user_data.gold + n
    return dataUser.user_data.gold
end

-- 减少金币
function dataUser.downGold(n)
    dataUser.user_data.gold = dataUser.user_data.gold - n
    return dataUser.user_data.gold
end

-- 获取英雄
function dataUser.getHero()
    return dataUser.user_data.hero
end

-- 获取英雄ID
function dataUser.getHeroID()
    return dataUser.user_data.ID
end

return dataUser