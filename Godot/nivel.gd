extends Node2D

var current_animation
const boss_animations = ["grab", "jump", "recovering", "slam", "slash", "stab", "walk"]
var restart_player_position
var restart_boss_position
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	restart_player_position = $player_body.global_position
	restart_boss_position = $boss_body.global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	restart_player_position = $player_body.global_position
	$player_body/AIController2D.player_pos = $player_body.global_position
	$player_body/AIController2D.boss_pos = $boss_body.global_position
	current_animation = $boss_body/boss_animation_player.current_animation
	var encoded = []
	for value in range(boss_animations.size()):
		if boss_animations[value] == current_animation:
			encoded.append(1)
		else:
			encoded.append(0)
	$player_body/AIController2D.boss_animation = encoded
	$player_body/AIController2D.boss_time_animation = $boss_body/boss_animation_player.current_animation_position

	$player_body/AIController2D.reward
func _on_fall_body_entered(body: Node2D) -> void:
	$player_body/AIController2D.reward -= 1
	reset()
	
func reset():
	$player_body.global_position = restart_player_position
	$player_body.hp = 3
	$boss_body.global_position = restart_boss_position
	$boss_body.hp = 20
