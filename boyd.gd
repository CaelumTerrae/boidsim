extends Node2D

# Called when the node enters the scene tree for the first time.
export(float) var xDirection;
export(float) var yDirection;
export(float) var MAX_SPEED = 350;
export var Rule1Weight = 0.1;
export var Rule2Weight = 0.3;
export var Rule3Weight = 0.1;
onready var vision_area = get_node("VisionArea2D");
onready var boyd_area = get_child(0);
onready var sprite = get_node("BoydArea2D/Sprite");
var kicked_off = false;
var movement_vector = Vector2(0, 0);

func _ready():
	print(boyd_area);
	movement_vector = Vector2(xDirection * MAX_SPEED, yDirection*MAX_SPEED)
	return

func get_overlapping_boyds():
	var all_children = vision_area.get_overlapping_areas();
	var boyd_children = [];
	for child in all_children:
		if child != boyd_area and "BoydArea2D" in child.name:
			boyd_children.append(child.get_parent())
	return boyd_children;

func rule1_adhesion(boyd_lst: Array):
	var rule_1_vec = Vector2(0,0)
	if boyd_lst.size() == 0:
		return rule_1_vec
	for boyd in boyd_lst:
		rule_1_vec += boyd.position;
	rule_1_vec /= boyd_lst.size();
	rule_1_vec -= position;
	rule_1_vec *= Rule1Weight;
	return rule_1_vec;
	
func rule2_avoidance(boyd_lst: Array):
	var rule_2_vec = Vector2(0,0)
	if boyd_lst.size() == 0:
		return rule_2_vec;
	for boyd in boyd_lst:
		rule_2_vec += (position - boyd.position)
	rule_2_vec *= Rule2Weight;
	return rule_2_vec

func rule3_cohesion(boyd_lst: Array):
	var rule_3_vec = Vector2(0,0)
	if boyd_lst.size() == 0:
		return rule_3_vec;
	for boyd in boyd_lst:
		rule_3_vec += boyd.movement_vector
	
	rule_3_vec /= boyd_lst.size();
	rule_3_vec *= Rule3Weight;
	return rule_3_vec;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var boyds_seen = get_overlapping_boyds();
	var rule_1_vec = rule1_adhesion(boyds_seen);
	var rule_2_vec = rule2_avoidance(boyds_seen);
	var rule_3_vec = rule3_cohesion(boyds_seen);
	movement_vector += (rule_1_vec + rule_2_vec + rule_3_vec);
	
	if movement_vector.length() > MAX_SPEED:
		movement_vector /= float(movement_vector.length())
		movement_vector *= MAX_SPEED
	
	
	# sum all boid rules
	position += (movement_vector * delta);
	
	# update the sprite rotation
	self.rotation_degrees = rad2deg(movement_vector.angle()) - 90
	
	# map wrapping
	var x_component = position.x;
	var y_component = position.y;
	if position.x < -10:
		x_component = 1024 + 10;
	elif position.x > 1024 + 10:
		x_component = - 10;

	if position.y < -10:
		y_component = 600 + 10;
	elif position.y > 600 + 10:
		y_component = - 10;

	position = Vector2(x_component, y_component);
