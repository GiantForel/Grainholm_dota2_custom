local ____lualib = require("lualib_bundle")
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["6"] = 1,["7"] = 2,["8"] = 2,["9"] = 8,["10"] = 8,["11"] = 8,["12"] = 8,["13"] = 13,["14"] = 15});
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
