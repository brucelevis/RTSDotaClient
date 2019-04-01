
local _M = class(CtrlBase)

function _M:StartView()
    print("EquipCtrl startView ~~~~~~~")
	ViewManager:Start(self, MoudleNames.Equip, EquipViewNames.Equip, PANEL_HIGH(), self.args)
end

function _M:Close()
    CtrlManager:CloseCtrl(EquipCtrlNames.Equip)
end

return _M