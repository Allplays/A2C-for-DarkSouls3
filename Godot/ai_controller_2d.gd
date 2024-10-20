extends AIController2D

# Stores the action sampled for the agent's policy, running in python
var move_action = Vector2(0,0)
var attack_action = Vector2(0,0)
var dash_action = Vector2(0,0)
var player_pos : Vector2
var boss_pos : Vector2
var boss_animation = [0,0,0,0,0,0,0]
var boss_time_animation
var in_control = true

func get_obs() -> Dictionary:
	var obs = [player_pos.x, player_pos.y, boss_pos.x, boss_pos.y, boss_time_animation, in_control]
	for value in boss_animation:
		obs.append(value)
	return {"obs":obs}

func get_reward() -> float:
	return reward
	
func get_action_space() -> Dictionary:
	return {
		"move_action" : {
			"size": 2,
			"action_type": "continuous"
		},
		"attack_action" : {
			"size": 2,
			"action_type": "continuous"
		},
		"dash_action" : {
			"size": 2,
			"action_type": "continuous"
		}
		}
	
func set_action(action) -> void:	
	move_action.x = action["move_action"][0]
	move_action.y = action["move_action"][1]
	attack_action.x = action["attack_action"][0]
	attack_action.y = action["attack_action"][1]
	dash_action.x = action["dash_action"][0]
	dash_action.y = action["dash_action"][1]
