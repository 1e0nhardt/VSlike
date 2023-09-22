extends Node

signal  experience_update(current_experience: float, target_experience: float)

const EXPERIENCE_GROWTH = 5

var current_experience = 0
var current_level = 1
var target_experience = 5


func _ready():
    GameEvents.experience_vial_collected.connect(on_experience_vial_collected)


func increment_experience(number: float):
    current_experience = min(current_experience + number, target_experience)
    experience_update.emit(current_experience, target_experience)
    if current_experience == target_experience:
        current_experience = 0
        current_level += 1
        target_experience += EXPERIENCE_GROWTH
        experience_update.emit(current_experience, target_experience)


func on_experience_vial_collected(number: float):
    increment_experience(number)
