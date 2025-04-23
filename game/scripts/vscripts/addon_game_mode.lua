local ____lualib = require("lualib_bundle")
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["6"] = 1,["7"] = 2,["8"] = 2,["9"] = 5,["10"] = 5,["11"] = 5,["12"] = 5,["13"] = 10,["14"] = 12});
local ____exports = {}
require("lib.timers")
local ____GameMode = require("GameMode")
local GameMode = ____GameMode.GameMode
__TS__ObjectAssign(
    getfenv(),
    {Activate = GameMode.Activate, Precache = GameMode.Precache}
)
if GameRules.Addon ~= nil then
    GameRules.Addon:Reload()
end
return ____exports
