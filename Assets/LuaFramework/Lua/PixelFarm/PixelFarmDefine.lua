
AppName = "PixelFarm"

App = {
    serverIp = "127.0.0.1",
    serverPort = 7000
}

-- 模块名称
MoudleNames = {
    Common = "Common",
    Loading = "Loading",
    Main = "Main",
    Login = "Login",
    Tavern = "Tavern",

    Test = "Test"
}

-- UI层级
UIPanelNames = {
    Low = "Low",
    Mid = "Mid",
    High = "High",
    Top = "Top"
}

UIPanelOrder = {UIPanelNames.Low, UIPanelNames.Mid, UIPanelNames.High, UIPanelNames.Top}

require "PixelFarm/Modules/Loading/LoadingDefine"
require "PixelFarm/Modules/Main/MainDefine"
require "PixelFarm/Modules/Login/LoginDefine"
require "PixelFarm/Modules/Tavern/TavernDefine"
require "PixelFarm/Modules/Common/CommonDefine"
require "PixelFarm/Modules/Test/TestDefine"

require "PixelFarm.EventDefine"