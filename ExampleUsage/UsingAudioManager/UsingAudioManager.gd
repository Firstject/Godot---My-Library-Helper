extends Node

export(AudioStreamOGGVorbis) var background_music

#We want to play background music after the button
#is pressed. By calling #AudioManager, this can be done through scripting.
func _on_PlayBgmButton_pressed() -> void:
	#Play BGM!
	if background_music != null:
		AudioManager.play_bgm(background_music)

#This will stop current bgm
func _on_StopBgmButton2_pressed() -> void:
	AudioManager.stop_bgm()

#This will play sound effect by calling
#AudioManager's variable.
func _on_PlaySfxButton_pressed() -> void:
	AudioManager.sfx_example.play()
