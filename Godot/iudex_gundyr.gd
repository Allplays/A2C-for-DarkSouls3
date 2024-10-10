extends CharacterBody2D

const attacks = ["slash_into_large_slam",
 				"stab_into_smash",
 				"smash_into_smash",
				"double_slash",
				"double_slash_into_smash",
				"gundyr_grab",
				"jumping_slash"]
const decisions = ["walk",
				"attack"]

# Get the gravity from the project settings to be synced with RigidBody nodes.
var attacking = false
var last_decision
var arena_center

func _ready():
	$decision_timer.start()
	arena_center = get_node("../arena_center").global_position
	
func _physics_process(delta):
	move_and_collide(velocity*delta)

func decide():
	var choice = decisions.pick_random()
	print(choice)
	velocity = Vector2(0,0)
	if choice == "walk" and last_decision != "walk":
		last_decision = "walk"
		walk()
	else:
		last_decision = "attack"
		attack()
		
func walk():
	var center_direction =  arena_center - global_position
	velocity = center_direction.normalized()*100
	$decision_timer.start()

func attack():
	velocity = Vector2(0,0)
	var choice = attacks[randi() % attacks.size()]
	print(get_node("../../player_body"))
	match choice:
		"slash_into_large_slam":
			last_decision = "slash_into_large_slam"
			$slash_area.look_at(get_node("../../player_body").global_position)
			$slash_into_large_slam/slash_into_large_slam_startup.start()
			print("slash_into_large_slam")
		"stab_into_smash":
			last_decision = "stab_into_smash"
			$slash_area.look_at(get_node("../../player_bdody").global_position)
			$slash_into_large_slam/slash_into_large_slam_startup.start()
			print("stab_into_smash")
		"smash_into_smash":
			last_decision = "smash_into_smash"
			$slam_area.look_at(get_node("../player_body").global_position)
			$smash_into_smash/startup.start()
			print("smash_into_smash")
		"double_slash":
			last_decision = "double_slash"
			$slash_area.look_at(get_node("../player_body").global_position)
			$double_slash/startup3.start()
			print("double_slash")
		"double_slash_into_smash":
			last_decision = "double_slash_into_smash"
			$slash_area.look_at(get_node("../player_body").global_position)
			$double_slash_into_smash/startup4.start()
			print("double_slash_into_smash")
		"gundyr_grab":
			pass
		"jumping_slash":
			pass
		"default":
			$recovery_timer.start()

func _on_decision_timer_timeout():
	decide()

func _on_recovery_timer_timeout():
	$decision_timer.start()



func _on_slash_into_large_slam_startup_timeout():
	$slash_area/slash_collision.disabled = false
	$slash_into_large_slam/slash_into_large_slam_first_active.start()
	
func _on_slash_into_large_slam_first_active_timeout():
	$slash_area/slash_collision.disabled = true
	$slash_into_large_slam/slash_into_large_slam_mid.start()
	$large_slam_area.look_at(get_node("../player_body").global_position)
	
func _on_slash_into_large_slam_mid_timeout():
	$large_slam_area/large_slam_collision.disabled = false
	$slash_into_large_slam/slash_into_large_slam_second_active.start()

func _on_slash_into_large_slam_second_active_timeout():
	$large_slam_area/large_slam_collision.disabled = true
	$recovery_timer.start()



func _on_startup_timeout():
	$stab_area/stab_colision.disabled = false
	$stab_into_smash/first_active.start()

func _on_first_active_timeout():
	$stab_area/stab_colision.disabled = true
	$stab_into_smash/mid.start()
	$slam_area.look_at(get_node("../player_body").global_position)

func _on_mid_timeout():
	$slam_area/slam_colision.disabled = false
	$stab_into_smash/second_active.start()

func _on_second_active_timeout():
	$slam_area/slam_colision.disabled = true
	$recovery_timer.start()



func _on_startup2_timeout():
	$slam_area/slam_colision.disabled = false
	$smash_into_smash/first_active.start()

func _on_first_active2_timeout():
	$slam_area/slam_colision.disabled = true
	$smash_into_smash/mid.start()
	$smash_area.look_at(get_node("../player_body").global_position)

func _on_mid_2_timeout():
	$slam_area/slam_colision.disabled = false
	$smash_into_smash/second_active2.start()

func _on_second_active_2_timeout():
	$slam_area/slam_colision.disabled = true
	$recovery_timer.start()



func _on_startup_3_timeout():
	$slash_area/slash_collision.disabled = false
	$double_slash/first_active3.start()

func _on_first_active_3_timeout():
	$slash_area/slash_collision.disabled = true
	$double_slash/mid3.start()
	$slash_area.look_at(get_node("../player_body").global_position)

func _on_mid_3_timeout():
	$slash_area/slash_collision.disabled = false
	$double_slash/second_active3.start()

func _on_second_active_3_timeout():
	$slash_area/slash_collision.disabled = true
	$recovery_timer.start()



func _on_startup_4_timeout():
	$slash_area/slash_collision.disabled = false
	$double_slash_into_smash/first_active4.start()

func _on_first_active_4_timeout():
	$slash_area/slash_collision.disabled = true
	$double_slash_into_smash/mid4.start()
	$slash_area.look_at(get_node("../player_body").global_position)

func _on_mid_4_timeout():
	$slash_area/slash_collision.disabled = false
	$double_slash_into_smash/second_active4.start()

func _on_second_active_4_timeout():
	$slash_area/slash_collision.disabled = true
	$double_slash_into_smash/second_mid.start()
	$slam_area.look_at(get_node("../player_body").global_position)

func _on_second_mid_timeout():
	$slam_area/slam_collision.disabled = false
	$double_slash_into_smash/last_active.start()

func _on_last_active_timeout():
	$slam_area/slam_collision.disabled = true
	$recovery_timer.start()
