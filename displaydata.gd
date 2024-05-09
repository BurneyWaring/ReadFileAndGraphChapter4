extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$RichTextLabel.add_color_override("default_color", Color(0,0,0))
	$RichTextLabel.text += str(Global.data)
	$ColorRect.rect_size = get_viewport().size
	$ColorRect.color = Color(1,1,0.8)
	$Button.rect_position = Vector2(get_viewport().size.x*0.05,get_viewport().size.y*0.90)


func _on_Button_pressed():
	get_tree().change_scene("res://linegraph.tscn")
