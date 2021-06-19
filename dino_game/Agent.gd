extends Area2D

"""
================================================================================
GDscript
file agent.gd
================================================================================
Authors : Lucie LEOPOLD, Julie PERE, Clément VIVIER
Date : 19/06/2021
================================================================================
This file contains all the agent's functions. The agent is a dinosaur
"""

# Declare member variables here, they can be modified 
var vitesse # agent's speed
var gather_sight = 200 # agent's gathering sight
var separation_sight = 50 # agent's separation sight
var align_sight = 180 # agent's alignement sight
var gather_coef = 2.5 # agent's gathering coefficient
var separation_coef = 3 # agent's separation coefficient
var alignment_coef = 0.4 # agent's alignment coefficient
var screen_size
var emotion # variable which depicts the emotion scale
var angry = false
var scared = false
var focus_coef = 1
var emo_sight = 100 # emotion sight
var rng = RandomNumberGenerator.new()
var near = []

const gameOverScreen = preload("res://UI.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	screen_size = get_viewport_rect().size
	emotion = rng.randi_range(6,15) # neutral emotion, green
	position = Vector2(rng.randi_range(20,screen_size.x-20),rng.randi_range(20,screen_size.y-20 )) # screen-size-20 so that wanis stays in the window
	vitesse = Vector2(rng.randi_range(-1,1),rng.randi_range(-1,1)) # initialization of the agent's speed
	vitesse.normalized() 
	set_process(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	bordure() 
	position += vitesse*delta # making the agent move at each frame
	if angry:
		if vitesse.x >= 0 :
			$AnimatedSprite.animation = "bad_droite"
		if vitesse.x <= 0 :
			$AnimatedSprite.animation = "bad_gauche"
	elif scared:
		if vitesse.x >= 0 :
			$AnimatedSprite.animation = "scared_droite"
		if vitesse.x <= 0 :
			$AnimatedSprite.animation = "scared_gauche"
	else:
		if vitesse.x >= 0 :
			$AnimatedSprite.animation = "droite"
		if vitesse.x <= 0 :
			$AnimatedSprite.animation = "gauche"
	update()


# Checking if the agent is still in the window
func bordure():
	# speed indicates also the direction ( positive = to the right, negative = to the left)
	if position.x >= screen_size.x-20:
		vitesse.x = rng.randi_range(-1,0) #changing the agent's direction to go to opposite way
	if position.y >= screen_size.y-20:
		vitesse.y = rng.randi_range(-1,0)
	if position.y <= 20:
		vitesse.y = rng.randi_range(0,1)
	if position.x <= 20:
		vitesse.x = rng.randi_range(0,1)


#draw green wanis dinosaure
func _draw():
	$AnimatedSprite.play()


#Calculate the distance between the agent
func dist(agent):
	return position.distance_to(agent.position)


#Contains the application of gather, separate and alignement
func rules(swarm,mem,bus_swarm):
	var temp 
	temp = focus_bus(bus_swarm)
	vitesse += temp
	temp = gather(swarm)
	vitesse += temp # modify the agent's speed with the result of gather 
	temp = separation(swarm)
	vitesse += temp # modify the agent's speed with the result of separation
	temp = alignment(swarm,mem)
	vitesse += temp # modify the agent's speed with the result of alignement
	modif_emo(swarm)
	# print(emotion)
	
# Calculate the direction needed to get closer to other agents
func gather(swarm):
	var centroid = Vector2(0,0)
	var N = 0
	for agent in swarm:
		var d = dist(agent) 
		if d < gather_sight: #Verify if the agents are in the gather sight
			N += 1
			centroid += agent.position 
	centroid /= N # Calculate the centroid of the gather sight
	var result = gather_coef*(centroid-position).normalized() 
	return result # return a vector pointing to the centroid


# Calculate the direction needed to move away from the other agents
func separation(swarm):
	var neigbor_pos = Vector2(0,0)
	var N = 0
	for agent in swarm:
		var d = dist(agent)
		if d < separation_sight:
			N += 1
			neigbor_pos += agent.position
	neigbor_pos /= N
	return separation_coef*(position-neigbor_pos).normalized() # return a vecteur which permits to stay away from the other agent


# Calculate the direction needed to have the same one as the agent's neighbours
func alignment(swarm,mem):
	var N = 0
	var sum = Vector2(0,0)
	var mean = Vector2(0,0)
	for agent in swarm:
		var d = dist(agent)
		if d <= align_sight:
			sum += mem[N] # sum the agent's speed only if in the align sight
			N += 1
		mean = sum / N
	return alignment_coef*mean.normalized() # return a vector which is the mean all of neighbours' speed

# Modify the emotion level of the dinosaurs depending on the number of neighbours around
func modif_emo(swarm):
	for wanis in swarm:
		if emotion >= 0: # The emotion level is set between 0 and 20
			if emotion <= 20:
				if wanis != self:
					if dist(wanis) <= emo_sight: # Couting the nearest neighbours
						if !(near.has(wanis)): # if not already in the list put it in it
							near.append(wanis) # list of the nearest neighbours
					elif near.has(wanis): #if not close to the others, change his anger and remove it of the list if in it
						near.erase(wanis)
						wanis.near.erase(self)
				emo_analyse()
				# 3 neighbours make the emotion rise no matter what
				if near.size() + 1 >= 4: # +1 to count the actual wanis
					if emotion < 20:
						emotion += 1
					for i in near.size():
						if emotion < 20:
							near[i].emotion += 1
				# 2 neighbours make decrease the anger and rise the loneliness
				elif near.size() + 1 <= 3 and near.size() + 1 > 1:
					if angry :
						emotion += -1
					elif scared:
						emotion += 1
					for i in near.size():
						if angry:
							near[i].emotion += -1
						elif scared:
							emotion += 1
				# No neighbour makes the emotion decrease, it is abled to go in the loneliness range
				elif near.size() + 1 == 1:
					if emotion > 0:
						emotion += -1
					for i in near.size():
						if emotion > 0:
							near[i].emotion += -1
			else:
				emotion = 20 # extremum numbers of the emotion scale
		else:
			emotion = 0

# Analyse the emotion level of the dinos to modify their comportement and to set their emotion 
func emo_analyse():
	if emotion > 15: # modifie the comportement of the dino
		angry = true
		gather_coef = 2 # They stay as well gathered than separate
		separation_coef = 2
		alignment_coef = 0
	elif emotion < 5:
		scared = true # They want to gather mich more than to separate and find friends
		gather_coef = 4
		separation_coef = 2
		alignment_coef = 1.5
	else:
		angry = false # default comportement
		scared = false
		gather_coef = 2.5 
		separation_coef = 3 
		alignment_coef = 0.4

# Orientate the dino in the nearest bus' direction
func focus_bus(bus_swarm):
	if angry:
		var bus_not_broken = count_bus_not_broken(bus_swarm)
		var idx_bus = min_bus(bus_not_broken)
		if idx_bus == -1:
			add_child(gameOverScreen.instance()) #display to game over screen
			get_tree().paused = true # pause the "game"
			return Vector2(0, 0)
		else:
			var focused_bus = bus_not_broken[idx_bus]
			var pos = (focused_bus.position - position).normalized()
			for wanis in near: # orientate all the nearest angry dino in the direction of the bus
				wanis.position += focus_coef*(focused_bus.position - wanis.position).normalized()
			return pos 
	else:
		return Vector2(0, 0) # not angry so don't need to focus bus. so no modification

# Find de nearest bus
func min_bus(bus_not_broken):
		if not bus_not_broken.empty():
			var idx_bus = 0
			var min_dist = dist(bus_not_broken[0])
	
			for i in bus_not_broken.size(): # select the closest bus to the current wanis
				var d = dist(bus_not_broken[i])
				min_dist = min(min_dist, d)
				if min_dist == d:
					idx_bus = i
	
			return idx_bus
		else:
			return -1

# Count the buses not broken
func count_bus_not_broken(bus_swarm):
	var bus_not_broken = []
	for bus in bus_swarm:
		if bus.broken == false:
			bus_not_broken.append(bus)
	return bus_not_broken

# When a body entered in the dino area, it breaks the bus
func _on_Area2D_body_entered(body):
	if "Bus" in body.name and angry:
		body.broken = true
