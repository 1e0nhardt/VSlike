extends Node2D

@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D


func _ready():
    $Area2D.area_entered.connect(on_area_entered)


func tween_collect(percent: float, start_position: Vector2):
    var player = get_tree().get_first_node_in_group("player") as Node2D
    if player == null:
        return
    
    global_position = start_position.lerp(player.global_position, percent)
    var direction_from_start = player.global_position - global_position

    var target_rotation = direction_from_start.angle() + deg_to_rad(90)
    rotation = lerp_angle(rotation, target_rotation, 1 - exp(-2* get_process_delta_time()))


func collect():
    GameEvents.emit_experience_vial_collected(1)
    queue_free()


func disable_collision():
    collision_shape_2d.disabled = true


func on_area_entered(other_area: Area2D):
    Callable(disable_collision).call_deferred() # 不要在物体碰撞计算过程中改变Collision的属性

    var tween = create_tween()
    tween.set_parallel() # 设置多个tween并行执行
    tween.tween_method(tween_collect.bind(global_position), 0.0, 1.0, 0.5)\
    .set_ease(Tween.EASE_IN)\
    .set_trans(Tween.TRANS_BACK)
    tween.tween_property(sprite, "scale", Vector2.ZERO, 0.1).set_delay(0.4)
    tween.chain() # 等待所有tween执行完成
    tween.tween_callback(collect)
    
