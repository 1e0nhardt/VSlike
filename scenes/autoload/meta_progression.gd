extends Node

const SAVE_FILE_PATH = "user://game.save"

var save_data: Dictionary = {
    "meta_upgrade_currency": 0,
    "meta_upgrades": {}
}


func _ready():
    GameEvents.experience_vial_collected.connect(on_vial_collected)
    load_save_file()
    print(save_data)


func add_meta_upgrade(upgrade: MetaUpgrade):
    if !save_data['meta_upgrades'].has(upgrade):
        save_data['meta_upgrades'][upgrade.id] = {
            "quantity": 0,            
        }
    
    save_data['meta_upgrades'][upgrade.id]["quantity"] += 1

    save()


func load_save_file():
    if FileAccess.file_exists(SAVE_FILE_PATH):
        var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
        save_data = file.get_var()


func save():
    var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
    file.store_var(save_data)


func on_vial_collected(number: float):
    save_data["meta_upgrade_currency"] += number
    save()