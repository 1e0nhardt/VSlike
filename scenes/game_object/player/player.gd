extends CharacterBody2D

@onready var damage_interval_timer = $DamageIntervalTimer
@onready var health_component = $HealthComponent
@onready var health_bar = $HealthBar
@onready var abilities = $Abilities
@onready var animation_player = $AnimationPlayer
@onready var visual = $Visual
@onready var velocity_component = $VelocityComponent

var number_colliding_bodies = 0


func _ready():
	$CollisionArea2D.body_entered.connect(on_body_entered)
	$CollisionArea2D.body_exited.connect(on_body_exited)
	$DamageIntervalTimer.timeout.connect(on_damage_interval_timer_timeout)
	health_component.health_changed.connect(on_health_changed)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	update_health_display()


func _process(delta):
	var movement = get_movement_vector()
	var direction = movement.normalized()
	velocity_component.accelerate_in_direction(direction)
	velocity_component.move(self)

	if movement.x != 0 or movement.y != 0:
		animation_player.play("move")
	else:
		animation_player.play("RESET")

	var movement_sign = sign(movement.x)
	if movement_sign == 0:
		visual.scale = Vector2.ONE
	else:
		visual.scale = Vector2(movement_sign, visual.scale.y)


func get_movement_vector():
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(x_movement, y_movement)


func check_damage():
	if number_colliding_bodies == 0 or !damage_interval_timer.is_stopped():
		return

	health_component.damage(5)
	damage_interval_timer.start()


func update_health_display():
	var health_percent = health_component.get_health_percent()
	health_bar.value = health_percent


func on_body_entered(other_body: Node2D):
	number_colliding_bodies += 1
	check_damage()


func on_body_exited(other_body: Node2D):
	number_colliding_bodies -= 1


func on_damage_interval_timer_timeout():
	check_damage()


func on_health_changed():
	update_health_display()
	GameEvents.emit_player_damaged()
	$HitRandomAudioStreamPlayer.play_random()


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade is Ability:
		var ability_scene = upgrade.ability_controller_scene
		var ability_instance = ability_scene.instantiate()
		abilities.add_child(ability_instance)
	elif upgrade.id == "player_speed":
		velocity_component.max_speed += current_upgrades["player_speed"]["quantity"] * 10
	
