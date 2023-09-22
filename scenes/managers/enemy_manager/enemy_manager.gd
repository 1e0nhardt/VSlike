extends Node

@export var basic_enemy_scene: PackedScene
const SPAWN_RADIUS = 330


# Called when the node enters the scene tree for the first time.
func _ready():
    $Timer.timeout.connect(on_timer_timeout)


func on_timer_timeout():
    var player = get_tree().get_first_node_in_group("player") as Node2D
    if player == null:
        return

    var direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
    var spawn_position = player.global_position + direction * SPAWN_RADIUS

    var enemy_instance = basic_enemy_scene.instantiate() as Node2D
    get_parent().add_child(enemy_instance)
    enemy_instance.global_position = spawn_position
