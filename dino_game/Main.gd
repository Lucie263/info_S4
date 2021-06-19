extends Node2D
"""
================================================================================
GDscript
file main.gd
================================================================================
Authors : Lucie LEOPOLD, Julie PERE, Clément VIVIER
Date : 19/06/2021
================================================================================
This file contains all the functions needed to run the project entirely. 
It is a crowd simulation with two types of agent : a Dinosaure and a bus.
"""

export (PackedScene) var agent # import the scene of the dinosaur
export (PackedScene) var bus  # import the scene of the bus

# Declare member variables here, they can be modified
var N = 10 # number of dinos
var M = 10 # number of buses
var swarm = [] # variable to store all the  dinosaure agents
var bus_swarm = [] # variable to store all the buses
var mem_vitesse = [] # variable to  store agents' speed
var mem_vitesse_bus = [] # variable to  store bus's speed

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = false # relaunch "game" after restart
	
	for i in range(N):
		var temp = agent.instance() # creation of each dinosaur
		swarm.append(temp)
		add_child(temp)
		mem_vitesse.append(temp.vitesse)
	
	for i in range(M):
		var temp = bus.instance() # creation of each bus
		bus_swarm.append(temp)
		add_child(temp)
		mem_vitesse_bus.append(temp.vitesse)
	
	set_process(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for agent in swarm:
		agent.rules(swarm,mem_vitesse,bus_swarm) # running the crowd simulation's rules
	mem_vitesse = [] # erase the storage of the previous agents' speed
	for agent in swarm:
		mem_vitesse.append(agent.vitesse) # store the new agents's speed
	for bus in bus_swarm:
		bus.rules(bus_swarm,mem_vitesse_bus) # running the crowd simulation's rules
	mem_vitesse_bus = [] # erase the storage of the previous agents' speed
	for bus in bus_swarm:
		mem_vitesse_bus.append(bus.vitesse)
	update()
