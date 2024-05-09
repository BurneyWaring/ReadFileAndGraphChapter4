#From the Book:
#Create Compeling Science and Engineering Simulations Using the Godot Engine, Copyright 2024 Burney Waring, ThankGod Egbe, Lateef Kareem 
#Chapter 4

extends Node2D

var scalex
var scaley
var xorigin
var yorigin
var screenwidth
var screenheight
var pixelswide 
var pixelstall 
var maxx
var maxy
var datax = []
var datay = []
var datatext = []
var xaxistitle = "molar mass"
var yaxistitle = "density kg/m3"
var graphtitle = "A Plot Example"

func _ready():
	$CanvasLayer.layer = -1

	$CanvasLayer/ColorRect.rect_size = get_viewport().size
	screenwidth = get_viewport().size.x #width of the whole app in pixels
	screenheight = get_viewport().size.y #height of the whole app  in pixels
	xorigin = screenwidth/10 #100 #pixels from the edges
	yorigin = screenheight/6 #100

	$title.text = graphtitle
	$title.rect_position = Vector2((screenwidth-xorigin)/2, screenheight/10)
	$yaxislabel.text = yaxistitle
	$yaxislabel.rect_rotation = -90
	$yaxislabel.rect_position = Vector2(xorigin * 0.7, screenheight/2)
	$xaxislabel.text = xaxistitle
	$xaxislabel.rect_position = Vector2((screenwidth-xorigin)/2, 
	(screenheight - yorigin)*1.00)
	$mouseposition.rect_position = Vector2(5,5)
	$Button.rect_position = Vector2(screenwidth*0.05,screenheight*0.90)

	for row in Global.data:
#		prints(row)
#		prints(row[0], row[1], row[2])
		datax.append(float(row[1]))
		datay.append(float(row[2]))
		datatext.append(row[0])
	
#	prints(datax, datay)


	#find the maximums of the data so that the graph will be sized correctly (assuming that graph always starts at zero).
	maxx = datax.max() 
	maxy = datay.max() 

	pixelswide = screenwidth - xorigin*2 #graph width in pixels 
	pixelstall = screenheight - yorigin*2 #graph height in pixels

	#find the scaling factor
	scalex = (pixelswide)/maxx #pixels per unit to be graphed
	scaley = (pixelstall)/maxy 


func _process(delta):
	#update() is necessary to keep updating the graph, IF the values change
	#they don't really change here
	update() 
	#here is a way to read the graph values
	var x = (get_global_mouse_position().x - xorigin) *maxx/pixelswide
	var y = maxy - ((get_global_mouse_position().y - yorigin) *maxy /pixelstall)
	$mouseposition.text = str(stepify(x, 0.01) )+ xaxistitle + ", " + str(stepify(y, 0.01)) + yaxistitle

func _draw():    
	#draw the axes
	#x axis
	var col = Color(0,0,0,1) #line color
	var x0 = 0 * scalex + xorigin
	var x1 = maxx * scalex + xorigin
	var y0 = screenheight - (0 * scaley + yorigin)
	var y1 = y0
	#the width is 3 pixels
	draw_line(Vector2(x0,y0), Vector2(x1,y1), col, 3, true)
	#y axis
	x0 = 0 * scalex + xorigin
	x1 = x0
	y0 = screenheight - (0 * scaley + yorigin)
	y1 = screenheight - (maxy * scaley + yorigin)
	draw_line(Vector2(x0,y0), Vector2(x1,y1), col, 3, true)	
	
	#draw the lines connecting the data
	col = Color(1,0,0,1) #line color 
	var numpts = len(datax)
	for i in range(numpts-1):
		x0 = datax[i] * scalex + xorigin
		x1 = datax[i+1] * scalex + xorigin
		y0 = screenheight - (datay[i] * scaley + yorigin)
		y1 = screenheight - (datay[i+1] * scaley + yorigin)
		#the width is 2 pixels
		draw_line(Vector2(x0,y0), Vector2(x1,y1), col, 2, true)

	#add the data points
	for i in range(numpts):
		x1 = datax[i] * scalex + xorigin		
		y1 = screenheight - (datay[i] * scaley + yorigin)
		draw_circle(Vector2(x1, y1), 10.0, Color(0,1,0))
		var lbe = Label.new()
		add_child(lbe)
		lbe.rect_position = Vector2(x1, y1)
		lbe.text = datatext[i]+ ", "+ str(datax[i])+", "+str(datay[i])
		lbe.add_color_override("font_color", Color(0,0,0,1))

func _on_Button_pressed():
	$Button.visible = false
	$mouseposition.visible = false
	yield(get_tree().create_timer(1.0), "timeout") #waits 1 second to get a screenshot to make sure button is not visible
	saveimg() #get screenshot
	get_tree().change_scene("res://displaydata.tscn") #change scenes
	
#gets a screenshot
func saveimg(): 
	var target_viewport = get_tree().root.get_viewport()
	var img = target_viewport.get_texture().get_data()
	img.flip_y()
	img.save_png("user://graphimage.png")
