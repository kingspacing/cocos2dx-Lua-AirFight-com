-- 强化表
local consolidate = {
    [11] = {name = "zero", attack = 2, life = 50, level = 1, star = 1},
    [12] = {name = "zero", attack = 4, life = 100, level = 2, star = 1},
    [13] = {name = "zero", attack = 8, life = 200, level = 3, star = 1},
    [14] = {name = "zero", attack = 16, life = 400, level = 4, star = 2},
    [15] = {name = "zero", attack = 32, life = 800, level = 5, star = 2},
    [16] = {name = "zero", attack = 48, life = 1600, level = 6, star = 2},
    [17] = {name = "zero", attack = 96, life = 3200, level = 7, star = 3},
    [18] = {name = "zero", attack = 192, life = 4800, level = 8, star = 3},
    [19] = {name = "zero", attack = 384, life = 9600, level = 9, star = 3},
    [21] = {name = "one", attack = 5, life = 20, level = 1, star = 1},
    [22] = {name = "one", attack = 10, life = 40, level = 2, star = 2},
    [23] = {name = "one", attack = 20, life = 80, level = 3, star = 3},
    [24] = {name = "one", attack = 40, life = 160, level = 4, star = 1},
    [25] = {name = "one", attack = 80, life = 320, level = 5, star = 2},
    [26] = {name = "one", attack = 160, life = 640, level = 6, star = 3},
    [27] = {name = "one", attack = 320, life = 1280, level = 7, star = 1},
    [28] = {name = "one", attack = 640, life = 2560, level = 8, star = 2},
    [29] = {name = "one", attack = 1280, life = 5120, level = 9, star = 3},
    [31] = {name = "two", attack = 1, life = 100, level = 1, star = 1},
    [32] = {name = "two", attack = 2, life = 200, level = 2, star = 2},
    [33] = {name = "two", attack = 4, life = 400, level = 3, star = 3},
    [34] = {name = "two", attack = 8, life = 800, level = 4, star = 1},
    [35] = {name = "two", attack = 16, life = 1600, level = 5, star = 2},
    [36] = {name = "two", attack = 32, life = 3200, level = 6, star = 3},
    [37] = {name = "two", attack = 48, life = 4800, level = 7, star = 1},
    [38] = {name = "two", attack = 96, life = 9600, level = 8, star = 2},
    [39] = {name = "two", attack = 192, life = 19200, level = 9, star = 3}
}

local intensifyGold = {
    [11] = {star = 1, name = "zero", gold = 1000},
    [12] = {star = 2, name = "zero", gold = 2000},
    [13] = {star = 3, name = "zero", gold = 3000},
    [21] = {star = 1, name = "one", gold = 2000},
    [22] = {star = 2, name = "one", gold = 4000},
    [23] = {star = 3, name = "one", gold = 8000},
    [31] = {star = 1, name = "two", gold = 3000},
    [32] = {star = 2, name = "two", gold = 6000},
    [33] = {star = 3, name = "two", gold = 8000}
}

local advancedGold = {
    [11] = {star = 1, name = "zero", gold = 10000},
    [12] = {star = 2, name = "zero", gold = 20000},
    [13] = {star = 3, name = "zero", gold = 20000},
    [21] = {star = 1, name = "one", gold = 30000},
    [22] = {star = 2, name = "one", gold = 40000},
    [23] = {star = 3, name = "one", gold = 40000},
    [31] = {star = 1, name = "two", gold = 50000},
    [32] = {star = 2, name = "two", gold = 60000},
    [33] = {star = 3, name = "two", gold = 60000},
}

local dataUi = {}

function dataUi.getConsolidate(id)
    if id == nil then
        return clone(consolidate)
    else
        return clone(consolidate[id])
    end
end

function dataUi.getIntensifyGold(id)
    if id == nil then
        return clone(intensifyGold)
    else
        return clone(intensifyGold[id])
    end
end

function dataUi.getAdvancedGold(id)
    if id == nil then
        return clone(advancedGold)
    else
        return clone(advancedGold[id])
    end
end

return dataUi