extends CombatEffect

var reduced_strength := 0

func _ready():
	# warning-ignore:return_value_discarded
	owning_entity.connect("entity_damaged", self, "_on_entity_damaged")

func _on_entity_damaged(entity, amount, _trigger: Node, _tags: Array) -> void:
	if amount >= cfc.card_definitions["The Victim"]\
			.get("_amounts",{}).get("effect_threshold", 9) and reduced_strength == 0:
		var discern = [
			{
				"name": "apply_effect",
				"effect_name": Terms.ACTIVE_EFFECTS.strengthen.name,
				"subject": "self",
				"modification": -stacks
			},
		]
		execute_script(discern, entity)
		reduced_strength = stacks


func _on_enemy_turn_started(_turn: Turn) -> void:
	owning_entity.active_effects.mod_effect(Terms.ACTIVE_EFFECTS.strengthen.name, reduced_strength, false, false, ["Scripted"])
	reduced_strength = 0
