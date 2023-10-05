extends PanelContainer

@onready var name_label: Label = %NameLabel
@onready var description_label: Label = %DescriptionLabel
@onready var progress_bar: ProgressBar = %ProgressBar
@onready var purchase_button: Button = %PurchaseButton

var meta_upgrade: MetaUpgrade


func _ready():
    purchase_button.pressed.connect(on_purchase_pressed)


func set_meta_upgrade(upgrade: MetaUpgrade):
    meta_upgrade = upgrade
    name_label.text = upgrade.title
    description_label.text = upgrade.description
    update_progress_bar()


func update_progress_bar():
    var percent = MetaProgression.save_data["meta_upgrade_currency"] / meta_upgrade.experience_cost
    percent = min(percent, 1)
    progress_bar.value = percent
    purchase_button.disabled = percent < 1


func on_purchase_pressed():
    if meta_upgrade == null:
        return
    
    MetaProgression.save_data["meta_upgrade_currency"] -= meta_upgrade.experience_cost
    MetaProgression.add_meta_upgrade(meta_upgrade)
    get_tree().call_group("meta_upgrade_card", "update_progress_bar")
    $AnimationPlayer.play("selected")