extends CharacterBody2D

const speed = 150
var in_control = true
var rolling = false
var hp = 3

@onready var ai_controller = $AIController2D

var previous_attack = Vector2(0,0)
var previous_dash = Vector2(0,0)

func _ready():
	ai_controller.init(self)
	$light_attack_area/light_attack_sprite.visible = false
	$light_attack_area/light_attack_collision.disabled = false

func game_over():
	ai_controller.done = true
	ai_controller.needs_reset = true

func get_input():
	var input_direction = ai_controller.move_action
	velocity = input_direction * speed

func _physics_process(delta):
	if ai_controller.needs_reset:
		ai_controller.reset()
		return
	if in_control:
		get_input()
	if not in_control and not rolling:
		velocity = Vector2(0,0)
	move_and_collide(velocity*delta)

	if ai_controller.attack_action != previous_attack and in_control:
		light_attack()
		$light_attack_area.look_at(global_position + ai_controller.attack_action)
		previous_attack = ai_controller.attack_action
		print("I have updated previous attack, I attacked in direction" + str(ai_controller.attack_action))
	if ai_controller.dash_action != previous_dash and in_control and not rolling:
		previous_dash = ai_controller.dash_action
	

func roll():
	rolling = true
	$player_collision.disabled = true
	$roll_timer.start()
	in_control = false

func light_attack():
	in_control = false
	$light_attack_startup.start()

func _on_light_attack_startup_timeout():
	$light_attack_active.start()

func _on_light_attack_active_timeout():
	$light_attack_area/light_attack_sprite.visible = true
	$light_attack_area/light_attack_collision.disabled = false
	$light_attack_recovery.start()

func _on_light_attack_recovery_timeout():
	$light_attack_area/light_attack_sprite.visible = false
	$light_attack_area/light_attack_collision.disabled = true
	in_control = true


func _on_roll_timer_timeout():
	$player_collision.disabled = false
	$roll_timer_CD.start()
	in_control = true


func _on_roll_timer_cd_timeout():
	rolling = false

func _on_light_attack_area_body_entered(body: Node2D) -> void:
	body.take_damage()
	ai_controller.reward += 0.05

func take_damage():
	hp -= 1
	if hp < 1:
		get_parent().reset()
	print("hp = " + str(hp))
	ai_controller.reward -= 0.33
