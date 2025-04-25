import { BaseModifier, registerModifier } from "../../../lib/dota_ts_adapter";

@registerModifier()
export class modifier_meepo_funny_flask_ts extends BaseModifier {
    caster: CDOTA_BaseNPC = this.GetCaster() as CDOTA_BaseNPC;
    ability: CDOTABaseAbility = this.GetAbility() as CDOTABaseAbility;
    parent: CDOTA_BaseNPC = this.GetParent();
    particle_buff: string = "particles/units/heroes/hero_ringmaster/funnel_cake_ground_anchors.vpcf";
	sound:string = "Hero_Alchemist.ChemicalRage.Cast"
    bonus_atack_speed?: number;
    bonus_incoming_damage?: number;

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
		this.caster.EmitSound("Hero_Brewmaster.Brawler.Crit");
		// Modifier specials
		this.bonus_atack_speed = this.ability.GetSpecialValueFor("bonus_attack_speed");
		this.bonus_incoming_damage = this.ability.GetSpecialValueFor("bonus_incoming_damage_percent");
		//Timers.CreateTimer(0.01, ()=>{
            const effect = ParticleManager.CreateParticle(
                this.particle_buff,
                ParticleAttachment.ABSORIGIN_FOLLOW,
				undefined,
            );
			ParticleManager.SetParticleControl(
                effect,
                0,
                this.caster.GetAbsOrigin(),
            );
			//ParticleManager.SetParticleAlwaysSimulate(effect);
		//})

	}
    GetEffectName(): string {
		return this.particle_buff;
	}
    GetEffectAttachType(): ParticleAttachment {
		return ParticleAttachment.ABSORIGIN_FOLLOW;
	}

    DeclareFunctions(): ModifierFunction[] {
		return [
			ModifierFunction.ATTACKSPEED_BONUS_CONSTANT,
			ModifierFunction.INCOMING_DAMAGE_PERCENTAGE,
		];
	}
    GetModifierAttackSpeedBonus_Constant(): number {
        return this.bonus_atack_speed?? 0;
    }

    GetModifierIncomingDamage_Percentage(event: ModifierAttackEvent): number {
        return this.bonus_incoming_damage?? 0;
    }

}
