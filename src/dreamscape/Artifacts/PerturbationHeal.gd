extends Artifact

func _ready() -> void:
	print_debug('aaa')
	if is_active and effect_context == ArtifactDefinitions.EffectContext.BATTLE:
		globals.player.damage -=\
				ArtifactDefinitions.PerturbationHeal.amounts.heal_amount\
				* globals.player.deck.filter_cards("Type","Perturbation").size()
		print_debug(globals.player.deck.filter_cards("Type","Perturbation").size())
