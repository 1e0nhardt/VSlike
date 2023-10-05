extends CanvasLayer

@onready var options_scene = preload("res://scenes/ui/options_menu.tscn")


func _ready():
    %PlayButton.pressed.connect(on_play_pressed)
    %UpgradeButton.pressed.connect(on_upgrade_pressed)
    %OptionsButton.pressed.connect(on_options_pressed)
    %QuitButton.pressed.connect(on_quit_pressed)


func on_play_pressed():
    ScreenTransition.transition()
    await ScreenTransition.transitoned_halfway
    get_tree().change_scene_to_file("res://scenes/main/main.tscn")


func on_upgrade_pressed():
    ScreenTransition.transition_to_scene("res://scenes/ui/meta_upgrade_menu.tscn")


func on_options_pressed():
    ScreenTransition.transition()
    await ScreenTransition.transitoned_halfway
    var options_instance = options_scene.instantiate()
    add_child(options_instance)
    options_instance.back_pressed.connect(on_back.bind(options_instance))


func on_quit_pressed():
    get_tree().quit()


func on_back(options_instance: Node):
    ScreenTransition.transition()
    await ScreenTransition.transitoned_halfway
    options_instance.queue_free()
    