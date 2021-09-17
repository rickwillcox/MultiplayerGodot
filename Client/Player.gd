extends KinematicBody2D

onready var animation_tree = get_node("AnimationTree")
onready var animation_mode = animation_tree.get("parameters/playback")
onready var animation_player = get_node("AnimationPlayer")
onready var player_stats_panel = get_node("../../GUI/PlayerStats")
onready var login_screen_panel = get_node("../../GUI/LoginScreen")

var ice_spear = preload("res://Scenes/Player/IceSpear.tscn")

var max_speed = 200
var speed = 0
var acceleration = 600
var destination = Vector2()
var movement = Vector2()
var attacking = false
var moving = false
var rate_of_fire = 0.2
var can_fire = true


func _ready():
	pass
	
func _unhandled_input(event):
	if event.is_action_pressed("Click"):
		moving = true
		#destination = get_global_mouse_position()
	elif event.is_action_pressed("Attack") and can_fire == true:
		moving = false
		attacking = true
		can_fire = false
		print(position.direction_to(get_global_mouse_position()).normalized())
		animation_tree.set("parameters/Attack_Spell/blend_position", position.direction_to(get_global_mouse_position()).normalized())
		animation_tree.set("parameters/Idle/blend_position", position.direction_to(get_global_mouse_position()).normalized())
		Attack()
	#this bit is busted
	elif event.is_action_released("PlayerStatsPanel") and get_tree().get_nodes_in_group("LoginGroup").size() == 0: 
		Server.FetchPlayerStats()
		player_stats_panel.visible = !player_stats_panel.visible
		
		
		

func _physics_process(delta):
	animation_player.playback_speed = 15
	destination = get_global_mouse_position()
	MovementLoop(delta)
	
func Attack():
	animation_mode.travel("Attack_Spell")
	get_node("TurnAxis").rotation = get_angle_to(get_global_mouse_position())
	var ice_spear_instance = ice_spear.instance()
	ice_spear_instance.position = get_node("TurnAxis/CastPoint").get_global_position() 
	ice_spear_instance.rotation = get_angle_to(get_global_mouse_position())
	get_parent().add_child(ice_spear_instance)
	
	yield(get_tree().create_timer(rate_of_fire), "timeout")
	can_fire = true
	attacking = false
	
func MovementLoop(delta):
	if !moving:
		speed = 0
	else:
		speed += acceleration * delta
		if speed > max_speed:
			speed = max_speed
		movement = position.direction_to(destination) * speed
		if position.distance_to(destination) > 10:
			movement = move_and_slide(movement)
			animation_tree.set("parameters/Walk/blend_position", movement.normalized())
			animation_tree.set("parameters/Idle/blend_position", movement.normalized())	
			animation_mode.travel("Walk")
		else:
			moving = false	
			animation_mode.travel("Idle")
			print("idle")
			