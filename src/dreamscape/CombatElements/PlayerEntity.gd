class_name PlayerEntity
extends CombatEntity

var upgrades_increased := 0 setget set_upgrades_increased

# This variable will point to the scene which controls the targeting arrow
onready var targeting_arrow = $TargetLine

func _ready() -> void:
	entity_type = "dreamer"
# warning-ignore:return_value_discarded
	connect("entity_damaged", self, "_on_player_damaged")

func set_upgrades_increased(value) -> void:
	upgrades_increased = value
	# The player can only upgrade a number of cards equal to their deck size
	# This allows us to avoid punishing larger decks
	var upgrade_threshold = globals.player.deck.count_cards()
	# Custom code for a special Boss artifact
	if ArtifactDefinitions.ProgressiveImmersion.name in globals.player.get_all_artifact_names():
		upgrade_threshold /= 2
	if upgrades_increased >= upgrade_threshold:
		active_effects.mod_effect(
			"Creative Block",
			1,
			true,
			false,
			["Core"])


# We store how many times the player has been damaged during their own turn
# We also store the cumulative amount of damage the player has taken during their turn.
func _on_player_damaged(_pl, amount, _trigger, _tags) -> void:
	if cfc.NMAP.board.turn.current_turn == cfc.NMAP.board.turn.Turns.PLAYER_TURN:
		var turn_event_count = cfc.NMAP.board.turn.turn_event_count
		var damage_count = turn_event_count.get("player_damaged",0)
		turn_event_count["player_damaged"] = damage_count + 1
		var damage_total = turn_event_count.get("player_total_damage",0)
		turn_event_count["player_total_damage"] = damage_total + amount
		var encounter_event_count = cfc.NMAP.board.turn.encounter_event_count
		var encounter_damage_count = encounter_event_count.get("player_damaged_own_turn",0)
		encounter_event_count["player_damaged_own_turn"] = encounter_damage_count + 1
		var encounter_damage_total = encounter_event_count.get("player_total_damage_own_turn",0)
		encounter_event_count["player_total_damage_own_turn"] = encounter_damage_total + amount


func _input(event) -> void:
	if event is InputEventMouseButton and not event.is_pressed():
		if targeting_arrow.is_targeting:
			targeting_arrow.complete_targeting()
