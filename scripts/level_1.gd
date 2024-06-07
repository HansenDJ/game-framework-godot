extends Node2D

@onready var tile_map : TileMap = $TileMap
@onready var ui = $UI

var ground_layer = 1
var environment_layer = 2

func update_ui_hp(value):
	ui.update_hp(value)
