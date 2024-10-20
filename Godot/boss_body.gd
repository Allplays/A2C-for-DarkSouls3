extends CharacterBody2D


const SPEED = 300.0

const attacks = {"slash_into_large_slam": ["slash", "slam"],
 				"stab_into_smash": ["stab", "slam"],
 				"smash_into_smash": ["slam", "slam"],
				"double_slash": ["slash", "slash"],
				"double_slash_into_smash": ["slash", "slash", "slam"],
				"gundyr_grab": ["grab"],
				"jumping_slash": ["jump"]}
const decisions = ["walk",
				"attack"]
				
var hp = 20

func _ready() -> void:
	$attacks/jump_area/jump_collision.disabled = true

func _physics_process(delta: float) -> void:
	if $boss_animation_player.get_queue().size() == 0:
		decide()
	move_and_collide(velocity*delta)

func decide():
	var vector_to_player = (get_node("../player_body").global_position - global_position)
	if vector_to_player.length() > 100:
		velocity = vector_to_player.normalized()*SPEED
		$boss_animation_player.play("walk")
	else:
		velocity = Vector2(0,0)
		var choice = attacks.keys().pick_random()
		for action in attacks[choice]:
			$boss_animation_player.queue(action)
		$boss_animation_player.queue("recovering")

func _on_boss_animation_player_animation_changed(old_name: StringName, new_name: StringName) -> void:
	$attacks.look_at(get_node("../player_body").global_position)

func take_damage():
	hp -= 1
	if hp < 1:
		get_parent().reset()

func _on_jump_area_body_entered(body: Node2D) -> void:
	body.take_damage()

func _on_slash_area_body_entered(body: Node2D) -> void:
	body.take_damage()

func _on_stab_area_body_entered(body: Node2D) -> void:
	body.take_damage()

func _on_grab_area_body_entered(body: Node2D) -> void:
	body.take_damage()

func _on_slam_area_body_entered(body: Node2D) -> void:
	body.take_damage()
