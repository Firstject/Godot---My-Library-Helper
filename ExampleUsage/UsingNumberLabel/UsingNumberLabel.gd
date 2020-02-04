extends Node

func _on_Button_pressed() -> void:
	$Control/NumberLabel.set_number($Control2/SpinBox.value)
