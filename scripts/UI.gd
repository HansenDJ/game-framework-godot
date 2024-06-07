extends CanvasLayer
class_name UI

# Instantiate nodes
@onready var hp_label = %HPLabel
@onready var game_over_ui = %GameOverUI
@onready var player = $"../Player"

# Add value to player's HP and play death animation if out of health
func update_hp(value):
	player.hp += value
	update_hp_label()
	
	if player.hp <= 0:
		player.animated_sprite.animation = "dead"
		game_over_ui.visible = true
		hp_label.visible = false

# Update HP UI string
func update_hp_label():
	hp_label.text = "HP: " + str(player.hp) + "/" + str(player.max_hp)

# Restart level when retry button pressed in Game Over screen
func _on_retry_button_pressed():
	get_tree().reload_current_scene()

func _on_next_lvl_button_pressed():
	# Change to level 2
	get_tree().change_scene_to_file("res://scenes/level_2.tscn")
