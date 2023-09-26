extends Node

@onready var timer = $Timer

@export var end_screen_scene: PackedScene


func _ready():
    timer.timeout.connect(on_timer_timeout)


func get_elapsed_time():
    return timer.wait_time - timer.time_left


func on_timer_timeout():
    var victory_screen_instance = end_screen_scene.instantiate()
    add_child(victory_screen_instance)
