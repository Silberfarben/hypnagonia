extends ModAmountsArtifact

func _on_artifact_added() -> void:
	amount_name = "damage_amount"
	amount_value = '+1'
	selection_type = SelectionType.RANDOM
	._on_artifact_added()
