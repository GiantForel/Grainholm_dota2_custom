import { BaseAbility, registerAbility } from "../../../lib/dota_ts_adapter";
import "../../../modifiers/heroes/meepo/modifier_meepo_funny_flask_ts";
//src\vscripts\modifiers\heroes\meepo\modifier_meepo_funny_flask_ts.ts

@registerAbility()
export class meepo_funny_flask_ts extends BaseAbility {

    caster: CDOTA_BaseNPC = this.GetCaster();
    funny_duration = this.GetSpecialValueFor("bonus_flask_duration");
    modifier_funny: string = "modifier_meepo_funny_flask_ts";

    public static Precache(context: CScriptPrecacheContext) {
        PrecacheResource("texture", "panorama/images/flask2_png.vtex",context);
        PrecacheResource("particle", "particles/high_five_mug_travel.vpcf",context);
        PrecacheResource("sound", "sounds/weapons/hero/brewmaster/cinderbrew_creep.vsnd", context)
    }

    sound_cast = "sounds/weapons/hero/brewmaster/cinderbrew_creep.vsnd";
    OnUpgrade(): void {
		this.funny_duration = this.GetSpecialValueFor("dig_interval");
	}

    OnSpellStart() {
        // Play sound
        this.caster.EmitSound(this.sound_cast);

        // Add modifier
        this.caster.AddNewModifier(this.caster, this, this.modifier_funny, { duration: this.funny_duration });
    }
}