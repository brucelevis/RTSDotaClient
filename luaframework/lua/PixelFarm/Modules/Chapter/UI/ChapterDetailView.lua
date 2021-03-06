
local _M = class(ViewBase)

function _M:OnCreate()
    print("ChapterDetailView oncreate  ~~~~~~~")
    self.chapter = self.args[1]

    self.backBtn = self.transform:Find("backBtn").gameObject
    self.backBtn:SetOnClick(function ()
        self:OnBackClick()
    end)

    self.guanKaBlock = self:InitGuanKaBlock(self.transform, "guanKas")
    self.detailBlock = self:InitDetailBlock(self.transform, "detail")

    self:InitData()
end

function _M:InitData()
   self.iCtrl:AllGuanKas(self.chapter.Id, function (guanKas)
       self:UpdateGuanKaList(guanKas)
   end)
end

function _M:InitGuanKaBlock(trans, path)
    local block = {}
    local transform = trans:Find(path)
    block.transform = transform

    block.guanKaItem = transform:Find("item").gameObject
    block.guanKaList = transform:GetComponent("ScrollRect")

    return block
end

function _M:InitDetailBlock(trans, path)
    local block = {}
    local transform = trans:Find(path)
    block.transform = transform
    block.gameObject = transform.gameObject

    block.challengeBtn = transform:Find("content/challenge").gameObject

    block.challengeBtn:SetOnClick(function ()
        self:OnChallengeClick()
    end)
    
    block.gameObject:SetOnClick(function ()
        block.gameObject:SetActive(false)
    end)

    return block
end


function _M:UpdateGuanKaList(guanKas)
    if guanKas then
        for i,gk in pairs(guanKas) do
            local gkObj = newObject(self.guanKaBlock.guanKaItem)
            gkObj.transform:SetParent(self.guanKaBlock.guanKaList.content, false)
            gkObj.transform.localScale = Vector3(1,1,1)
            gkObj:SetActive(true)

            gkObj.transform:Find("bg/name"):GetComponent("Text").text = gk.Name
            gkObj.transform:Find("bg/status"):GetComponent("Text").text = gk:StatusStr()

            gkObj:SetOnClick(function ()
                self:OnGuanKaClick(gk)
            end)
        end
    end
end

function _M:OnGuanKaClick(gk)
    self.detailBlock.data = gk
    self.detailBlock.gameObject:SetActive(true)
end

function _M:OnChallengeClick()
    self.iCtrl:ShowBattle(self.detailBlock.data)
end

function _M:OnBackClick()
    self.iCtrl:Close()
end

function _M:OnDestroy()

end

return _M