extends CharacterBody2D

@export var current_level : Node2D # Get current level

@onready var animated_sprite = $AnimatedSprite2D
@onready var collision_shape_2d_sword = $CollisionShape2D_Sword

const SPEED = 50.0
const COLLIDER_POS_X_LEFT = -12
const COLLIDER_POS_X_RIGHT = 12
const COLLIDER_POS_Y = -12

var attack_animation_active : bool = false
var hp = 100
var max_hp = 100
var sword_pos_x = COLLIDER_POS_X_RIGHT
var sword_pos_y = COLLIDER_POS_Y
var sword_collision = null

func _physics_process(delta):
	#print("Curr Anim: ", animated_sprite.animation)
	# Get the input direction: -1, 0, or 1
	var direction_x = Input.get_axis("move_left", "move_right")
	var direction_y = Input.get_axis("move_up", "move_down")
	
	# Check for collision with the player's sword's collider
	sword_collision = move_and_collide(Vector2(direction_x, direction_y) * delta)
	if sword_collision != null:
		var body = sword_collision.get_collider()
		print("Collided with: ", body.name)
	
	if ((animated_sprite.animation == "attack") and (animated_sprite.frame_progress == 1.0)):
		attack_animation_active = false
		collision_shape_2d_sword.disabled = true
	
	if attack_animation_active == false:
		# Flip sprite
		if direction_x > 0:
			animated_sprite.flip_h = false
			# Face sword collider to the right
			sword_pos_x = COLLIDER_POS_X_RIGHT
			sword_pos_y = COLLIDER_POS_Y
		elif direction_x < 0:
			animated_sprite.flip_h = true
			# Face sword collider to the left
			sword_pos_x = COLLIDER_POS_X_LEFT
			sword_pos_y = COLLIDER_POS_Y
		# Apply collider position movement
		collision_shape_2d_sword.position = Vector2(sword_pos_x, sword_pos_y)
			
		# Play animations
		if (int(direction_x) | int(direction_y)) == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	
		# Apply movement/deceleration
		if direction_x:
			velocity.x = direction_x * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			
		if direction_y:
			velocity.y = direction_y * SPEED
		else:
			velocity.y = move_toward(velocity.y, 0, SPEED)

		move_and_slide()

func _input(event):
	if Input.is_action_just_pressed("left_click"):
		# Start attack animation
		attack_animation_active = true
		animated_sprite.animation = "attack"
		collision_shape_2d_sword.disabled = false
		# DEBUG: Deal damage to player when using sword
		hp -+ 10
		current_level.update_ui_hp(-10)

# Update Health UI when player collides with enemy or vice versa
func on_enemy_collision(body):
	if body.is_in_group("enemy"):
		current_level.update_ui_hp(body.value)
