extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var boyd_scene = preload("res://boyd.tscn")
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	for n in 20:
		var boyd_node = boyd_scene.instance()
		boyd_node.position = Vector2(rng.randf_range(0,1000), rng.randf_range(0,600))
		add_child(boyd_node)
	pass # Replace with function body.
