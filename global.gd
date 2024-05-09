extends Node

var data = []

# Called when the node enters the scene tree for the first time.
func _ready():
	var arrayofdata = loaddata()
	#prints (arrayofdata)
	#write the array to a file in the user's accessible storage area.
	#for my system, this is in C:\Users\warin\AppData\Roaming\Godot\app_userdata\Read File and Graph
	writecsv("user://data.csv", arrayofdata)
	var ac = readcsv("user://data.csv")
	#prints("csv read", ac, ac[0][1] )
	data = ac
	#prints (data)

func writecsv(filename, array):
	var arraylen = len(array)
	#var arraywidth = len(array[0])
	var file = File.new()
	var error = file.open(filename, File.WRITE)
	if error == OK:
		#all data is converted to strings
		var arr
		for i in range(arraylen): #one row of the 2D array at a time
			arr = array[i]
			file.store_csv_line(Array(arr))
	else:
		print ("Error opening flile")
	file.close()

func readcsv(filename):
	var file = File.new()
	var error = file.open(filename, File.READ)
	var lne
	if error == OK:
		while !file.eof_reached():
			lne = Array(file.get_csv_line())
			if lne[0] != "": #checks for a blank row
				data.append(lne)  
	else:
		print ("Error opening flile")
	file.close()
	return data

func loaddata(): 
	# here is a 2D array
	var arrayofdata = [
		["Hydrogen", 2.02, 0.0887], 
		["Air", 28.96, 1.274], 
		["Oxygen", 32, 1.4076], 
		["Propane", 44.1, 1.9397],
		]
	return arrayofdata
