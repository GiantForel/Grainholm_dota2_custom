import { BaseModifier, registerModifier } from "../../../lib/dota_ts_adapter";

@registerModifier()
export class modifier_meepo_dig_up_ts extends BaseModifier {
    caster: CDOTA_BaseNPC = this.GetCaster() as CDOTA_BaseNPC;
    ability: CDOTABaseAbility = this.GetAbility() as CDOTABaseAbility;
    parent: CDOTA_BaseNPC = this.GetParent();
    particle_buff: string = "particles/units/heroes/heroes_underlord/abyssal_underlord_dust_impact_loadout.vpcf";
	interval?:number;


	


    IsHidden() {
		return false;
	}
	IsDebuff() {
		return false;
	}
	IsPurgable() {
		return true;
	}

    OnCreated(): void {
		this.interval =this.ability.GetSpecialValueFor("bonus_incoming_damage_percent");

		this.StartIntervalThink(this.interval)
		// Modifier specials
	}
    GetEffectName(): string {
		return this.particle_buff;
	}
    GetEffectAttachType(): ParticleAttachment {
		return ParticleAttachment.ABSORIGIN_FOLLOW;
	}
	StartIntervalThink(interval: number): void {
		
	}
	OnIntervalThink(){

	}

}
