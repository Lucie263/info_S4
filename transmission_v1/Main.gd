extends Node2D
"""
================================================================================
GDscript
file main.gd
================================================================================
Authors : Lucie LEOPOLD, Julie PERE, Clément VIVIER
Date : 30/04/2021
================================================================================
This file contains all the functions needed to run the project entirely. 
It is a crowd simulation with two types of agent : a Dinosaure and a bus.
"""

export (PackedScene) var agent # import the scene of the agent
export (PackedScene) var bus


# Declare member variables here, they can be modified
var N = 40# number of agents
var M = 10 
var swarm = [] # variable to store all the  dinosaure agents
var bus_swarm = [] # variable to store all the buses
var mem_vitesse = [] # variable to  store agents' speed
var mem_vitesse_bus = [] # variable to  store bus's speed

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(10):
		var temp = agent.instance() # creation of each agents
		swarm.append(temp)
		add_child(temp)
		mem_vitesse.append(temp.vitesse)
	
	for i in range(2):	
		var temp = bus.instance() # creation of each agents
		bus_swarm.append(temp)
		add_child(temp)
		mem_vitesse_bus.append(temp.vitesse)
	
	set_process(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for agent in swarm:
		agent.rules(swarm,mem_vitesse) # running the crowd simulation's rules
	mem_vitesse = [] # erase the storage of the previous agents' speed
	for agent in swarm:
		mem_vitesse.append(agent.vitesse) # store the new agents's speed
	for bus in bus_swarm:
		bus.rules(bus_swarm,mem_vitesse_bus) # running the crowd simulation's rules
	mem_vitesse_bus = [] # erase the storage of the previous agents' speed
	for bus in bus_swarm:
		mem_vitesse_bus.append(bus.vitesse)
	update()
