import { BaseAbility, registerAbility } from "../../../lib/dota_ts_adapter";
import "../../../modifiers/heroes/meepo/modifier_meepo_funny_flask_ts";
//src\vscripts\modifiers\heroes\meepo\modifier_meepo_funny_flask_ts.ts

@registerAbility()
export class meepo_funny_flask_ts extends BaseAbility {

    caster: CDOTA_BaseNPC = this.GetCaster();
    funny_duration = this.GetSpecialValueFor("bonus_flask_duration");
    modifier_funny: string = "modifier_meepo_funny_flask_ts";
    public static Precache(context: CScriptPrecacheContext) {
        PrecacheResource("particle", "particles/units/heroes/hero_ringmaster/funnel_cake_ground_anchors.vpcf", context);
        //PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_brewmaster.vsndevts", context)
    }



    OnUpgrade(): void {
		this.funny_duration = this.GetSpecialValueFor("bonus_flask_duration");
	}

    OnSpellStart() {
        this.caster.EmitSound("Hero_Brewmaster.CinderBrew.Target");

        // Add modifier
        this.caster.AddNewModifier(this.caster, this, this.modifier_funny, { duration: this.funny_duration });
    }
}