local StoreLogic = require "PixelFarm.Modules.Logic.StoreLogic"
local LoginLogic = require "PixelFarm.Modules.Logic.LoginLogic"

local _M = class(CtrlBase)

function _M:StartView()
    print("_MainCtrl startView ~~~~~~~")
    ViewManager:Start(self, MoudleNames.Main, MainViewNames.Main, PANEL_MID(), self.args)
end

function _M:CurrentPlayer(cb)
    local player = StoreLogic:CurrentPlayer()
    LoginLogic:Login(player.UserId, "", function (succeed, err, player)
        if cb then
            cb(player)
        end
    end)
end

function _M:ShowTavern()
    CtrlManager:OpenCtrl(MoudleNames.Tavern, TavernCtrlNames.Tavern)
    CtrlManager:CloseCtrl(MainViewNames.Main)
end

return _M