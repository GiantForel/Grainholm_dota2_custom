local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local __TS__Decorate = ____lualib.__TS__Decorate
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["8"] = 1,["9"] = 1,["10"] = 1,["11"] = 4,["12"] = 4,["13"] = 4,["14"] = 6,["15"] = 7,["16"] = 6,["17"] = 10,["18"] = 11,["19"] = 10,["20"] = 15,["21"] = 16,["22"] = 15,["23"] = 16,["24"] = 18,["25"] = 19,["26"] = 18,["27"] = 25,["28"] = 26,["29"] = 25,["30"] = 30,["31"] = 31,["32"] = 33,["34"] = 30,["35"] = 38,["36"] = 39,["37"] = 41,["38"] = 38,["39"] = 16,["40"] = 16,["41"] = 16,["42"] = 15,["45"] = 16});
local ____exports = {}
local ____dota_ts_adapter = require("lib.dota_ts_adapter")
local BaseModifier = ____dota_ts_adapter.BaseModifier
local registerModifier = ____dota_ts_adapter.registerModifier
local ModifierSpeed = __TS__Class()
ModifierSpeed.name = "ModifierSpeed"
__TS__ClassExtends(ModifierSpeed, BaseModifier)
function ModifierSpeed.prototype.DeclareFunctions(self)
    return {MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE}
end
function ModifierSpeed.prototype.GetModifierMoveSpeed_Absolute(self)
    return 300
end
____exports.modifier_panic = __TS__Class()
local modifier_panic = ____exports.modifier_panic
modifier_panic.name = "modifier_panic"
__TS__ClassExtends(modifier_panic, ModifierSpeed)
function modifier_panic.prototype.CheckState(self)
    return {[MODIFIER_STATE_COMMAND_RESTRICTED] = true}
end
function modifier_panic.prototype.GetModifierMoveSpeed_Absolute(self)
    return 540
end
function modifier_panic.prototype.OnCreated(self)
    if IsServer() then
        self:StartIntervalThink(0.3)
    end
end
function modifier_panic.prototype.OnIntervalThink(self)
    local parent = self:GetParent()
    parent:MoveToPosition(parent:GetAbsOrigin() + RandomVector(400))
end
modifier_panic = __TS__Decorate(
    modifier_panic,
    modifier_panic,
    {registerModifier(nil)},
    {kind = "class", name = "modifier_panic"}
)
____exports.modifier_panic = modifier_panic
return ____exports
