extends CanvasLayer

signal upgrade_selected(upgrade: AbilityUpgrade)

@export var upgrade_card_scene: PackedScene

@onready var card_contrainer: HBoxContainer = $MarginContainer/CardContainer


func _ready():
    get_tree().paused = true


func set_ability_upgrades(upgrades: Array[AbilityUpgrade]):
    var delay = 0
    for upgrade in upgrades:
        var card_instance = upgrade_card_scene.instantiate()
        card_contrainer.add_child(card_instance)
        card_instance.play_in(delay)
        card_instance.set_ability_upgrade(upgrade)
        # card只知道自己被选择了，但具体分配什么能力是在设置时决定的。
        card_instance.selected.connect(on_upgrade_selected.bind(upgrade))
        delay += .2

func remove():
    # 通知完就可以移除
    get_tree().paused = false
    queue_free()

func on_upgrade_selected(upgrade: AbilityUpgrade):
    # ui不处理具体的能力升级，只有通知责任
    upgrade_selected.emit(upgrade)
    var tween = create_tween()
    tween.tween_property($ColorRect, "modulate", Color.TRANSPARENT, .3)
    tween.tween_callback(remove)
    
