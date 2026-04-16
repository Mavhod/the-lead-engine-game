extends Resource
class_name Member

const exp_per_level = 10

@export var name: String = "New Member"
@export var member_exp: float = 0.0
@export var exp_to_next_level: int = exp_per_level
@export var level_up_points: int = 0

@export_group("Skills")
@export var technical: float = 1
@export var admin: float = 1
@export var creative: float = 1

@export_group("Attributes")
@export var stamina: float = 10.0
@export var max_stamina: int = 10
@export var recover_speed: float = 0
@export var speed: int = 0 # max 20 = 120%
@export var learning_rate: int = 0 # max 10 = 120%
@export var multitask_skill: int = -10 # max 10 = 120%
@export var teamwork_skill: int = -10 # max 10 = 120%

var current_task_count: int = 0

func get_skill_value(type: String) -> float:
	match type.to_lower():
		"technical": return technical
		"admin": return admin
		"creative": return creative
	return 0.0

func up_skill(type: String, value: float) -> void:
	value *= (1 + learning_rate*0.02)
	match type.to_lower():
		"technical": technical += value
		"admin": admin += value
		"creative": creative += value

func add_exp(value: float) -> void:
	member_exp += value
	if(member_exp < exp_to_next_level): return;
	exp_to_next_level += exp_per_level
	level_up_points += 2

func drop_stamina(value: float) -> void:
	stamina -= value
