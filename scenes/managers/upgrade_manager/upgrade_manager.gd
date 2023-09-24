extends Node

@export var upgrade_screen_scene: PackedScene
@export var upgrade_pool: Array[AbilityUpgrade]
@export var experience_manager: Node

var current_upgrades = {
    "test": "hello"
}


func _ready():
    experience_manager.level_up.connect(on_level_up)


func on_level_up(current_level: int):
    var choosen_upgrade = upgrade_pool.pick_random() as AbilityUpgrade
    if choosen_upgrade == null:
        return

    var upgrade_screen_instance = upgrade_screen_scene.instantiate()
    add_child(upgrade_screen_instance)
    upgrade_screen_instance.set_ability_upgrades([choosen_upgrade] as Array[AbilityUpgrade])


func apply_upgrade(upgrade: AbilityUpgrade):
    var has_upgrade = current_upgrades.has(upgrade.id)
    if !has_upgrade:
        current_upgrades[upgrade.id] = {
            "resource": upgrade,
            "quantity": 1
        }
    else:
        current_upgrades[upgrade.id]["quantity"] += 1

    print(current_upgrades)