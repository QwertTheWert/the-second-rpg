class_name DICE
extends Node


func D4(amount):
	var rolls = []
	for i in amount:
		rolls.append(randi_range(1,4))
	return rolls

func D6(amount):
	var rolls = []
	for i in amount:
		rolls.append(randi_range(1,6))
	return rolls

func D8(amount):
	var rolls = []
	for i in amount:
		rolls.append(randi_range(1,8))
	return rolls

func D10(amount):
	var rolls = []
	for i in amount:
		rolls.append(randi_range(1,10))
	return rolls


func D12(amount):
	var rolls = []
	for i in amount:
		rolls.append(randi_range(1,12))
	return rolls

func D20(amount):
	var rolls = []
	for i in amount:
		rolls.append(randi_range(1,20))
	return rolls
