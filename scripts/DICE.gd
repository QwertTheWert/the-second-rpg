extends Node


func d4(amount):
	var rolls = []
	for i in amount:
		rolls.append(randi_range(1,4))
	return rolls

func d6(amount):
	var rolls = []
	for i in amount:
		rolls.append(randi_range(1,6))
	return rolls

func d8(amount):
	var rolls = []
	for i in amount:
		rolls.append(randi_range(1,8))
	return rolls

func d10(amount):
	var rolls = []
	for i in amount:
		rolls.append(randi_range(1,10))
	return rolls


func d12(amount):
	var rolls = []
	for i in amount:
		rolls.append(randi_range(1,12))
	return rolls

func d20(amount):
	var rolls = []
	for i in amount:
		rolls.append(randi_range(1,20))
	return rolls
