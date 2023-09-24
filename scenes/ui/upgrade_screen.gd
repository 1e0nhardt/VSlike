extends CanvasLayer

@export var ability_card_scene: PackedScene

@onready var card_contrainer: HBoxContainer = $MarginContainer/CardContainer


func _ready():
    get_tree().paused = true


func set_ability_upgrades(upgrades: Array[AbilityUpgrade]):
    for upgrade in upgrades:
        var card_instance = ability_card_scene.instantiate()
        card_contrainer.add_child(card_instance)
        card_instance.set_ability_upgrade(upgrade)
