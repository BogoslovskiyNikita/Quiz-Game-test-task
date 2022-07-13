extends Node

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
const DB_PATH = "res://database/database.db"
var db


func _ready():
	db = SQLite.new()
	db.path = DB_PATH


func get_all_questions():
	db.open_db()
	db.query("SELECT * FROM questions")
	return db.query_result
