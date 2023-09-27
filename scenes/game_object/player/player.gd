extends CharacterBody2D

const MAX_SPEED = 125
const ACCELERATION_SMOOTHING = 25

@onready var damage_interval_timer = $DamageIntervalTimer
@onready var health_component = $HealthComponent
@onready var health_bar = $HealthBar
@onready var abilities = $Abilities

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
    var target_velocity = MAX_SPEED * direction
    velocity = velocity.lerp(target_velocity, 1 - exp(-delta * ACCELERATION_SMOOTHING))
    move_and_slide()


func get_movement_vector():
    var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
    var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
    return Vector2(x_movement, y_movement)


func check_damage():
    if number_colliding_bodies == 0 or !damage_interval_timer.is_stopped():
        return

    health_component.damage(5)
    damage_interval_timer.start()

    print(health_component.current_health)


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


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
    if not upgrade is Ability:
        return
        
    var ability_scene = upgrade.ability_controller_scene
    var ability_instance = ability_scene.instantiate()
    abilities.add_child(ability_instance)