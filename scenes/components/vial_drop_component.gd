extends Node

@export_range(0, 1) var drop_probability: float = 0.5
@export var health_component: Node
@export var experience_vial_scene: PackedScene


func _ready():
    (health_component as HealthComponent).died.connect(on_died)


func on_died():
    if randf() > drop_probability:
        return

    if experience_vial_scene == null:
        return

    if not owner is Node2D:
        return

    var spawn_position = (owner as Node2D).global_position
    var vial_instace = experience_vial_scene.instantiate() as Node2D
    owner.get_parent().add_child(vial_instace)
    vial_instace.global_position = spawn_position
