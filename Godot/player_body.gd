extends CharacterBody2D

const speed = 150
var in_control = true
var rolling = false
var hp = 3

func _ready():
	$light_attack_area/light_attack_sprite.visible = false
	$light_attack_area/light_attack_collision.disabled = false
	
func get_input():
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_direction * speed

func _physics_process(delta):
	if in_control:
		get_input()
	if not in_control and not rolling:
		velocity = Vector2(0,0)
	move_and_collide(velocity*delta)

	if Input.is_action_pressed("left_click") and in_control:
		light_attack()
	if Input.is_action_pressed("spacebar") and in_control and not rolling:
		roll()

func roll():
	rolling = true
	$player_collision.disabled = true
	$roll_timer.start()
	in_control = false

func light_attack():
	in_control = false
	$light_attack_startup.start()

func _on_light_attack_startup_timeout():
	$light_attack_area.look_at(get_global_mouse_position())
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

func take_damage():
	hp -= 1
	if hp < 1:
		get_tree().reload_current_scene()
	print("hp = " + str(hp))
