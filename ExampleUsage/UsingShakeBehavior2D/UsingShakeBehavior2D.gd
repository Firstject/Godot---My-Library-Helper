extends Node2D



func _on_ShakeButton_pressed() -> void:
	$Sprite/ShakeBehavior.start_shake()


func _on_ShakeINFButton_pressed() -> void:
	$Sprite2/ShakeBehavior.start_shake()

func _on_ShakeConstant_pressed() -> void:
	$Sprite3/ShakeBehavior.start_shake()

func _on_ShakeCanvasBtn_pressed() -> void:
	$Camera2D/ShakeBehavior.start_shake()


