extends CombatEffect

func _on_player_turn_ended(turn: Turn) -> void:
	._on_player_turn_ended(turn)
	var all_enemies := get_tree().get_nodes_in_group("EnemyEntities")
	var damage_amount : int = cfc.card_definitions[name]\
			.get("_amounts",{}).get("effect_damage")
	for _iter in range(stacks):
		CFUtils.shuffle_array(all_enemies)
		for rng_enemy in all_enemies:
			if rng_enemy.active_effects.get_effect(Terms.ACTIVE_EFFECTS.disempower.name):
				var egg = [{
					"name": "modify_damage",
					"subject": "trigger",
					"amount": damage_amount,
					"tags": ["Attack", "Combat Effect", "Concentration"],
				}]
				execute_script(egg, rng_enemy)
				if upgrade != "bouncy":
					break
