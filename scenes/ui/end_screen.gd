extends CanvasLayer

@onready var panel_container = %PanelContainer


func _ready():
	panel_container.pivot_offset = panel_container.size / 2
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0)
	tween.tween_property(panel_container, "scale", Vector2.ONE, .3)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

	get_tree().paused = true
	%RestartButton.pressed.connect(on_restart_pressed)
	%QuitButton.pressed.connect(on_quit_pressed)


func set_defeat():
	%TitleLabel.text = "Defeat"
	%DescriptionLabel.text = "You lost!"
	play_jingle(true)


func play_jingle(defeat: bool = false):
	if defeat:
		$DefeatAudioStreamPlayer.play()
	else:
		$VictoryAudioStreamPlayer.play()


func on_restart_pressed():
	ScreenTransition.transition_to_scene("res://scenes/ui/meta_upgrade_menu.tscn")
	await ScreenTransition.transitoned_halfway
	get_tree().paused = false


func on_quit_pressed():
	ScreenTransition.transition_to_scene("res://scenes/ui/main_menu.tscn")
	await ScreenTransition.transitoned_halfway
	get_tree().paused = false

