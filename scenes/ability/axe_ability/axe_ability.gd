extends Node2D

const MAX_RADIUS = 100

@onready var hitbox_component = $HitboxComponent

var base_rotation = Vector2.RIGHT

func _ready():
    # 如果在tween_method之后修改，则无法影响tween_method。
    base_rotation = Vector2.RIGHT.rotated(randf_range(0, TAU))

    var tween = create_tween()
    tween.tween_method(tween_method, 0.0, 2.0, 2)
    tween.tween_callback(queue_free)


func tween_method(rotations: float):
    var percent = rotations / 2.0
    var current_radius = MAX_RADIUS * percent
    var current_rotation = base_rotation.rotated(rotations * TAU)

    var player = get_tree().get_first_node_in_group("player") as Node2D
    if player == null:
        return
    
    global_position = player.global_position + current_rotation * current_radius
    rotation = percent * TAU * 4.0 # 0.5秒转一周
    
    
    


