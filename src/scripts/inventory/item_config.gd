class_name ItemConfig
extends Resource

enum Rarity { WHITE, GREEN, BLUE, PURPLE, GOLD }
enum ItemType { WEAPON, AMMO, ARMOR, MEDICAL, JUNK, KEY }

@export var config_id: String = ""  ## stable id used in save files; must be unique
@export var display_name: String = ""
@export var rarity: int = Rarity.WHITE
@export var item_type: int = ItemType.JUNK
@export var weight_kg: float = 0.5
@export var sell_price: int = 100
@export var stack_max: int = 1
@export var icon: Texture2D
