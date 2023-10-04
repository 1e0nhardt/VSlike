extends PanelContainer

signal selected

@onready var name_label: Label = %NameLabel
@onready var description_label: Label = %DescriptionLabel

var disable_flag = false


func _ready():
	gui_input.connect(on_gui_input)
	mouse_entered.connect(on_mouse_entered)


func play_in(delay: float):
	# scale = Vector2.ZERO # 在实际播放动画前，隐藏卡片。不起作用。
	modulate = Color.TRANSPARENT # 类似tint
	await  get_tree().create_timer(delay).timeout
	# 因为Godot的动画系统不会在play那一帧立即播放，而是在下一帧开始，因此卡片还是会以原尺寸出现一帧。
	# modulate = Color.WHITE 
	$AnimationPlayer.play("pop_in") 


func play_discard():
	$AnimationPlayer.play("discard") 


func set_ability_upgrade(upgrade: AbilityUpgrade):
	name_label.text = upgrade.name
	description_label.text = upgrade.description


func select_card():
	disable_flag = true
	$AnimationPlayer.play("selected")

	var other_cards = get_tree().get_nodes_in_group("upgrade_card")
	for card in other_cards:
		if card == self:
			continue
		
		card.play_discard()
		
	await $AnimationPlayer.animation_finished
	selected.emit()


func on_gui_input(event: InputEvent):
	if disable_flag:
		return

	if event.is_action_pressed("left_mouse_click"):
		select_card()


func on_mouse_entered():
	# 需要将鼠标过滤设为Ignore
	$HoverAnimationPlayer.play("hover")