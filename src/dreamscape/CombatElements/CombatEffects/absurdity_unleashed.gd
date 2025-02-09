extends CombatEffect

func _ready() -> void:
	for enemy in get_tree().get_nodes_in_group("EnemyEntities"):
		enemy.connect("effect_modified", self, "on_enemy_effect_added")
	
func on_enemy_effect_added(entity: CombatEntity, _trigger: String, details: Dictionary) -> void:
	if details["effect_name"] == Terms.ACTIVE_EFFECTS.disempower.name\
		and details[SP.TRIGGER_PREV_COUNT] < details[SP.TRIGGER_NEW_COUNT]:
			var base_amount : int = cfc.card_definitions[name]\
					.get("_amounts",{}).get("effect_damage")
			var absurdity = [{
				"name": "modify_damage",
				"subject": "trigger",
				"amount": base_amount * stacks,
				"tags": ["Attack", "Combat Effect", "Concentration"],
			}]
			execute_script(absurdity, entity)
