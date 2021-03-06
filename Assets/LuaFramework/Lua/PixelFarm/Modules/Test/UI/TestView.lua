local LoginLogic = require "PixelFarm.Modules.Login.Logic.LoginLogic"
local HeroLogic = require "PixelFarm.Modules.Logic.HeroLogic"
local SkillLogic = require "PixelFarm.Modules.Logic.SkillLogic"
local ItemLogic = require "PixelFarm.Modules.Logic.ItemLogic"
local MapLogic = require "PixelFarm.Modules.Logic.MapLogic"
local BattleLogic = require "PixelFarm.Modules.Logic.BattleLogic"

local _M = class(ViewBase)

local ownHeros = {}
local heroSkills = {}
local heroItems = {}

function _M:OnCreate()
    self.item = self.transform:Find("bg/btnList/item").gameObject
    self.btnList = self.transform:Find("bg/btnList/Viewport/Content").gameObject
    self.requestText = self.transform:Find("bg/request/Viewport/Content/text"):GetComponent("Text")
    self.responseText = self.transform:Find("bg/response/Viewport/Content/text"):GetComponent("Text")
    self.requestText.text = ""
    self.responseText.text = ""

    self.strs = {
        login_login = function() self:Login() end,
        login_registe = function() self:Registe() end,
        login_allZone = function() self:AllZone() end,
        hero_allHero = function() self:AllHero() end,
        hero_randomHero = function() self:RandomHero() end,
        hero_ownHero = function() self:OwnHero() end,
        hero_selectHero = function() self:SelectHero() end,
        hero_unSelectHero = function() self:UnSelectHero() end,
        hero_heroSkills = function() self:HeroSkills() end,
        hero_heroItems = function() self:HeroItems() end,
        skill_allSkill = function() self:AllSkill() end,
        skill_skillUpgrade1 = function() self:UpgradeSkill(1) end,
        skill_skillUpgrade2 = function() self:UpgradeSkill(2) end,
        skill_skillUpgrade3 = function() self:UpgradeSkill(3) end,
        skill_skillUpgrade4 = function() self:UpgradeSkill(4) end,
        item_allItem = function() self:AllItem() end,
        map_allGuanKa = function() self:AllGuanKa() end,
        map_allChapter = function() self:AllChapter() end,
        battle_battleGuanKa = function() self:BattleGuanKa() end,
    }

    for k,v in pairs(self.strs) do
        local obj = newObject(self.item)
        obj.transform:SetParent(self.btnList.transform, false)
        obj.transform.localScale = Vector3(1,1,1)
        obj:SetActive(true)

        obj.transform:Find("Text"):GetComponent("Text").text = k

        obj:GetComponent("Button").onClick:AddListener(function ()
            self:OnRequestClick(k)
        end)
    end

 
end

function _M:OnRequestClick(str)
    print("click  " .. str)
    self.strs[str]()
end

function _M:Login()
    _name = "zhoulk"
    _pwd = "123456"
    self.requestText.text = "name : " .. _name .. "\n" .. "pwd : " .. _pwd
    LoginLogic:Login(_name, _pwd, function (succeed, err, player)
        self.responseText.text = tostring(succeed) .. "\nerr : " .. self:ErrStr(err) .. "\nplayer : " .. self:PlayerStr(player)
    end)
end

function _M:Registe()
    _name = "zhoulk"
    _pwd = "123456"
    self.requestText.text = "name : " .. _name .. "\n" .. "pwd : " .. _pwd
    LoginLogic:Registe(_name, _pwd, function (succeed, err, player)
        self.responseText.text = tostring(succeed) .. "\nerr : " .. self:ErrStr(err) .. "\nplayer : " .. self:PlayerStr(player)
    end)
end

function _M:AllZone()
    self.requestText.text = "null"
    LoginLogic:AllZone(function (succeed, err, zones)
        local str = ""
        if zones then
            for i,zone in pairs(zones) do
                str = str .. self:ZoneStr(zone)
            end
        end
        self.responseText.text = tostring(succeed) .. "\nerr : " .. self:ErrStr(err) .. "\nzones : " .. str
    end)
end

function _M:RandomHero()
    _level = "GOOD"
    self.requestText.text = "level : " .. _level .. "\n"
    HeroLogic:RandomHero(_level, function (succeed, err)
        local str = ""
        self.responseText.text = tostring(succeed) .. "\nerr : " .. self:ErrStr(err)
    end)
end

function _M:OwnHero()
    self.requestText.text = "null"
    HeroLogic:AllOwnHero(function (succeed, err, heros)
        local str = ""
        if heros then
            for i,hero in pairs(heros) do
                str = str .. self:HeroStr(hero)
            end
            ownHeros = heros
        end
        self.responseText.text = tostring(succeed) .. "\nerr : " .. self:ErrStr(err) .. "\nheros : " .. str
    end)
end

function _M:AllHero()
    self.requestText.text = "null"
    HeroLogic:AllHero(function (succeed, err, heros)
        local str = ""
        if heros then
            for i,hero in pairs(heros) do
                str = str .. self:HeroStr(hero)
            end
        end
        self.responseText.text = tostring(succeed) .. "\nerr : " .. self:ErrStr(err) .. "\nheros : " .. str
    end)
end

function _M:SelectHero()
    if ownHeros ~= null and #ownHeros > 0 then
        _heroId = ownHeros[1].HeroId
        _pos = 1
        self.requestText.text = "heroId : " .. _heroId .. ", pos : " .. _pos
        HeroLogic:SelectHero(_heroId, _pos, function (succeed, err, heroIds)
            local str = tabStr(heroIds)
            self.responseText.text = tostring(succeed) .. "\nerr : " .. self:ErrStr(err) .. "\nheroIds : " .. str
        end)
    else
        self.responseText.text = "own heros is null"
    end
end

function _M:UnSelectHero()
    if ownHeros ~= null and #ownHeros > 0 then
        _heroId = ownHeros[1].HeroId
        self.requestText.text = "heroId : " .. _heroId
        HeroLogic:UnSelectHero(_heroId, function (succeed, err, heroIds)
            local str = tabStr(heroIds)
            self.responseText.text = tostring(succeed) .. "\nerr : " .. self:ErrStr(err) .. "\nheroIds : " .. str
        end)
    else
        self.responseText.text = "own heros is null"
    end
end

function _M:HeroSkills()
    if ownHeros ~= null and #ownHeros > 0 then
        _heroId = ownHeros[1].HeroId
        self.requestText.text = "heroId : " .. _heroId
        HeroLogic:HeroSkills(_heroId, function (succeed, err, skills)
            heroSkills = skills
            local str = ""
            if skills then
                for i,skill in pairs(skills) do
                    str = str .. self:SkillStr(skill)
                end
            end
            self.responseText.text = tostring(succeed) .. "\nerr : " .. self:ErrStr(err) .. "\nskills : " .. str
        end)
    else
        self.responseText.text = "own heros is null"
    end
end

function _M:HeroItems()
    if ownHeros ~= nil and #ownHeros > 0 then
        _heroId = ownHeros[1].HeroId
        self.requestText.text = "heroId : " .. _heroId
        HeroLogic:HeroItems(_heroId, function (succeed, err, items)
            heroItems = items
            local str = tabStr(items)
            self.responseText.text = tostring(succeed) .. "\nerr : " .. self:ErrStr(err) .. "\nitems : " .. str
        end)
    else
        self.responseText.text = "own heros is null"
    end
end

function _M:AllSkill()
    self.requestText.text = "null"
    SkillLogic:AllSkill(function (succeed, err, skills)
        local str = ""
        if skills then
            for i,skill in pairs(skills) do
                str = str .. self:SkillStr(skill)
            end
        end
        self.responseText.text = tostring(succeed) .. "\nerr : " .. self:ErrStr(err) .. "\nskills : " .. str
    end)
end

function _M:UpgradeSkill(index)
    if heroSkills ~= nil and #heroSkills > 0 then
        _skillId = heroSkills[index].SkillId
        self.requestText.text = "skillId : " .. _skillId
        SkillLogic:UpgradeSkill(_skillId, function (succeed, err)
            self.responseText.text = tostring(succeed) .. "\nerr : " .. self:ErrStr(err)
        end)
    else
        self.responseText.text = "own heroSkills is null"
    end
end

function _M:AllItem()
    self.requestText.text = "null"
    ItemLogic:AllItem(function (succeed, err, items)
        local str = ""
        if items then
            for i,item in pairs(items) do
                str = str .. self:ItemStr(item)
            end
        end
        self.responseText.text = tostring(succeed) .. "\nerr : " .. self:ErrStr(err) .. "\nitems : " .. str
    end)
end

function _M:AllChapter()
    self.requestText.text = "null"
    MapLogic:AllChapter(function (succeed, err, chapters)
        local str = ""
        if chapters then
            for i,chapter in pairs(chapters) do
                str = str .. self:chapterStr(chapter)
            end
        end
        self.responseText.text = tostring(succeed) .. "\nerr : " .. self:ErrStr(err) .. "\nchapters : " .. str
    end)
end

function _M:AllGuanKa()
    self.requestText.text = "null"
    MapLogic:AllGuanKa(function (succeed, err, guanKas)
        local str = ""
        if guanKas then
            for i,guanKa in pairs(guanKas) do
                str = str .. self:guanKaStr(guanKa)
            end
        end
        self.responseText.text = tostring(succeed) .. "\nerr : " .. self:ErrStr(err) .. "\nguanKas : " .. str
    end)
end

function _M:BattleGuanKa()
    _guanKaId = 1
    self.requestText.text = "guanKaId : " .. _guanKaId .. "\n"
    BattleLogic:BattleGuanKa(_guanKaId, function (succeed, err, result, guanka)
        local str = ""
        if guanka then
            str = str .. self:guanKaStr(guanka)
        end
        self.responseText.text = tostring(succeed) .. "\nerr : " .. self:ErrStr(err) .. "\nresult : " .. tostring(result) .. "\nguanKa : " .. str
    end)
end

function _M:ErrStr(err)
    local str = ""
    if err then
        str = str .. "\n{ code = " .. err.code .. " , msg = " .. err.msg .. "}"
    end
    return str
end

function _M:HeroStr(hero)
    local str = ""
    if hero then
        str = str .. "\n{Id : " .. hero.Id
        str = str .. ", HeroId : " .. hero.HeroId
        str = str .. ", PlayerId : " .. hero.PlayerId
        str = str .. ", IsSelect : " .. tostring(hero.IsSelect)
        str = str .. ", Pos : " .. hero.Pos
        str = str .. ", Name : " .. hero.Name
        str = str .. ", Level : " .. hero.Level
        str = str .. ", Exp : " .. hero.Exp
        str = str .. ", Type : " .. hero.Type
        str = str .. ", Strength : " .. hero.Strength .. "(+" .. hero.StrengthStep .. ")"
        str = str .. ", Agility : " .. hero.Agility .. "(+" .. hero.AgilityStep .. ")"
        str = str .. ", Intelligence : " .. hero.Intelligence .. "(+" .. hero.IntelligenceStep .. ")"
        str = str .. ", Armor : " .. hero.Armor
        str = str .. ", Attack : (" .. hero.AttackMin .. "~" .. hero.AttackMax .. ")"
        str = str .. ", Blood : " .. hero.Blood
        str = str .. ", SkillIds : " .. tabStr(hero.SkillIds)
        str = str .. "},"
    end
    return str
end

function _M:SkillStr(skill)
    local str = ""
    if skill then
        str = str .. "\n{Id : " .. skill.Id
        str = str .. ", Name : " .. skill.Name
        str = str .. ", Level : " .. skill.Level
        str = str .. ", Type : " .. skill.Type
        str = str .. ", Desc : " .. skill.Desc
        str = str .. ", IsOpen : " .. tostring(skill.IsOpen)
        str = str .. "},"
    end
    return str
end

function _M:ItemStr(item)
    local str = ""
    if item then

        local mixStr = ""
        if item.Mixs then
            mixStr = mixStr .. "["
            for i, mix in pairs(item.Mixs) do
                mixStr = mixStr .. "{ItemId : " .. mix.ItemId .. ", Num : " .. mix.Num .. "},"
            end
            mixStr = mixStr .. "]"
        end

        str = str .. "\n{Id : " .. item.Id
        str = str .. ", Name : " .. item.Name
        str = str .. ", Price : " .. item.Price
        str = str .. ", Effect : " .. item.Effect
        str = str .. ", Desc : " .. item.Desc
        str = str .. ", Mixs : " .. mixStr
        str = str .. "},"
    end
    return str
end

function _M:chapterStr(chapter)
    local str = ""
    if chapter then
        str = str .. "\n{Id : " .. chapter.Id
        str = str .. ", Name : " .. chapter.Name
        str = str .. ", IsOpen : " .. tostring(chapter.IsOpen)
        str = str .. "},"
    end
    return str
end

function _M:guanKaStr(guanKa)
    local str = ""
    if guanKa then
        str = str .. "\n{Id : " .. guanKa.Id
        str = str .. ", Name : " .. guanKa.Name
        str = str .. ", ChapterId : " .. guanKa.ChapterId
        str = str .. ", IsOpen : " .. tostring(guanKa.IsOpen)
        str = str .. ", Earn : " .. self:earnStr(guanKa.Earn)
        str = str .. ", Expend : " .. self:expendStr(guanKa.Expend)
        str = str .. "},"
    end
    return str
end

function _M:earnStr(earn)
    local str = ""
    if earn then
        str = str .. "{ItemIds : " .. tabStr(earn.ItemIds)
        str = str .. ", HeroExp : " .. earn.HeroExp
        str = str .. ", PlayerExp : " .. earn.PlayerExp
        str = str .. ", Gold : " .. earn.Gold
        str = str .. "},"
    end
    return str
end

function _M:expendStr(expend)
    local str = ""
    if expend then
        str = str .. "{ Power : " .. expend.Power
        str = str .. "},"
    end
    return str
end

function _M:PlayerStr(player)
    local str = ""
    if player then
        str = str .. "\n{UserId : " .. player.UserId
        str = str .. ", Name : " .. player.Name
        str = str .. ", BaseInfo : " .. self:BaseInfoStr(player.BaseInfo)
        str = str .. "},"
    end
    return str
end

function _M:BaseInfoStr(baseInfo)
    local str = ""
    if baseInfo then
        str = str .. "{ Gold : " .. baseInfo.Gold
        str = str .. ", Diamond : " .. baseInfo.Diamond
        str = str .. ", Exp : " .. baseInfo.Exp
        str = str .. ", Power : " .. baseInfo.Power
        str = str .. ", Level : " .. baseInfo.Level
        str = str .. "},"
    end
    return str
end

function _M:ZoneStr(zone)
    local str = ""
    if zone then
        str = str .. "\n{ Id : " .. zone.Id
        str = str .. ", Name : " .. zone.Name
        str = str .. ", IsNew : " .. tostring(zone.IsNew)
        str = str .. "},"
    end
    return str
end

function _M:OnDestroy()
    
end

return _M