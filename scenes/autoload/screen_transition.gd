extends CanvasLayer

signal transitoned_halfway

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func transition():
    animation_player.play("default")
    await animation_player.animation_finished
    transitoned_halfway.emit()
    animation_player.play_backwards("default")


func transition_to_scene(scene_path: String):
    transition()
    await  transitoned_halfway
    get_tree().change_scene_to_file(scene_path)