extends CombatEffect

func _on_player_turn_ended(_turn: Turn) -> void:
	var cards = cfc.card_definitions[name]\
			.get("_amounts",{}).get("effect_amount")
	var wait_time := 0.3
	if upgrade == "total":
		# Because Recall and total recall use different instances
		# of this effect, we make total recall wait longer before initializing
		# to avoid executing at the same time as Recall and possibly
		# causing issues
		wait_time = 0.55
	yield(get_tree().create_timer(wait_time), "timeout")
	while not cfc.NMAP.hand.is_hand_refilled:
		yield(cfc.NMAP.hand, "hand_refilled")
	for _iter in range(stacks):
		# If we don't have any more cards in the discard, we stop trying 
		# to reshuffle them (to avoid retriggering reshuffle effects)
		if not cfc.NMAP.discard.get_card_count():
			continue
		var recall = [{
				"name": "move_card_to_container",
				"dest_container": "deck",
				"src_container": "discard",
				"subject": "index",
				"subject_index": "top",
				"subject_count": cards,
				"is_cost": true,
				"tags": ["Combat Effect", "Concentration"],
			},
			{
				"name": "shuffle_container",
				"dest_container": "deck",
				"tags": ["Combat Effect", "Concentration"],
			},
		]
		# I am waiting a bit to avoid conflicting with the normal hand reshuffle.
		# This means this effect will happen only after the hand is reshuffled.
		execute_script(recall)
		yield(get_tree().create_timer(0.1), "timeout")
