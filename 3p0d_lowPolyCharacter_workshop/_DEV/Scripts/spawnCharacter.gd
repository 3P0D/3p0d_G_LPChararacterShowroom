extends Node3D

#ONREADY VARIABLES:
@onready var _characterName : Label = $"../_UI/Control_Headers/Control_LeftMenu/VBox_texts/Label_CharacterName"
@onready var _artistName : Label = $"../_UI/Control_Headers/Control_LeftMenu/VBox_texts/HBox_MadeByArtistName/Label_ArtistName"
@onready var _characterDescription : Label = $"../_UI/Control_Headers/Control_LeftMenu/VBox_texts/Label_Description"
@onready var _madeby : Label = $"../_UI/Control_Headers/Control_LeftMenu/VBox_texts/HBox_MadeByArtistName/Label_MadeBy"
@onready var _spt01text : Label = $"../_UI/Control_Headers/Control_RightMenu/VBox_sprites/HBox_sprite1/VBox_sprite1/Label_sprite1text"
@onready var _spt01title : Label = $"../_UI/Control_Headers/Control_RightMenu/VBox_sprites/HBox_sprite1/VBox_sprite1/Label_sprite1title"
@onready var _spt02text : Label = $"../_UI/Control_Headers/Control_RightMenu/VBox_sprites/HBox_sprite2/VBox_sprite2/Label_sprite2text"
@onready var _spt02title : Label = $"../_UI/Control_Headers/Control_RightMenu/VBox_sprites/HBox_sprite2/VBox_sprite2/Label_sprite2title"
@onready var _spt01 : TextureRect = $"../_UI/Control_Headers/Control_RightMenu/VBox_sprites/HBox_sprite1/TextureRect_sprite1"
@onready var _spt02 : TextureRect = $"../_UI/Control_Headers/Control_RightMenu/VBox_sprites/HBox_sprite2/TextureRect_sprite2"
@onready var _btnArrowL : Button = $"../_UI/Control_Arrows/Button_arrowLeft"
@onready var _btnArrowR : Button = $"../_UI/Control_Arrows/Button_arrowRight"
@onready var _btnMenu : Button = $"../_UI/Control_Menus/MarginContainer_Menu/Button_Menu"
@onready var _btnQuit : Button = $"../_UI/Control_Menus/MarginContainer_Quit/Button_Quit"
@onready var _stgpanel : Panel = $"../_UI/Control_Settings/Panel_Settings"

#PUBLIC VARIABLES:
@export var m_rotSpd = 3
@export var m_characters:Array[PackedScene]

@export var m_cylinder : MeshInstance3D
@export var m_background : WorldEnvironment

@export var m_settings : Control

#PRIVATE VARIABLES:
var current = 0

#---------------------------------GAMEPLAY SCRIPT---------------------------------:
func _ready():
	add_child(m_characters[current].instantiate())
	_updateCharModel(current)
	_updateInfos()

func _process(delta):
	rotate(Vector3(0, -m_rotSpd, 0).normalized(), delta)

func _updateCharModel(val):
	#---sets the min and max of the loop, and increment of the loop at each click.
	#---the values of the min and max have -1 and +1 to allow the loop to work.
	current += val
	current = min(current, m_characters.size())
	current = max(-1, current)

	#---infinite loop of choice to return to 0 or m_characters.size()-1 when you reach -1 or m_characters.size().
	if (current < 0):
		current = m_characters.size()-1
	if (current > m_characters.size()-1):
		current = 0

	#---remove all the previous models that is currently in the hierarchy of the object.
	for i in get_children():
		i.queue_free()
	
	#---adds the model of the current index of the m_characters.
	add_child(m_characters[current].instantiate())
	
	_updateInfos()

func _updateInfos():
	#set the character text infos.
	_characterName.text = str(get_child(1).get_meta('characterName'))
	_artistName.text = str(get_child(1).get_meta('artistName'))
	_characterDescription.text = str(get_child(1).get_meta('characterDescription'))
	
	#set the colours.
	_characterName.label_settings.font_color = get_child(1).get_meta('headersColor')
	_artistName.label_settings.font_color = get_child(1).get_meta('headersColor')
	m_background.environment.set_bg_color(get_child(1).get_meta('backgroundColor'))
	m_cylinder.mesh.surface_get_material(0).albedo_color = get_child(1).get_meta('backgroundColor')
	_spt01title.label_settings.font_color = get_child(1).get_meta('headersColor')
	
	_stgpanel.set("theme_override_styles/bg_color", get_child(1).get_meta('backgroundColor'))
	
	_btnArrowR.set("theme_override_colors/icon_hover_color", get_child(1).get_meta('headersColor'))
	_btnArrowL.set("theme_override_colors/icon_hover_color", get_child(1).get_meta('headersColor'))
	
	#set the sprites images.
	_spt01.set_texture(load(str(get_child(1).get_meta('image01'))))
	_spt02.set_texture(load(str(get_child(1).get_meta('image02'))))
	
	#set the sprites text infos.
	_spt01title.text = str(get_child(1).get_meta('img01title'))
	_spt01text.text = str(get_child(1).get_meta('img01text'))
	_spt02title.text = str(get_child(1).get_meta('img02title'))
	_spt02text.text = str(get_child(1).get_meta('img02text'))
	
	print("updated!")

func _on_button_arrow_right_pressed():
	_updateCharModel(1)

func _on_button_arrow_left_pressed():
	_updateCharModel(-1)

func _on_button_quit_pressed():
	get_tree().quit()
	
#---------------------------------SETTINGS SCRIPT---------------------------------:

func _on_button_menu_pressed():
	m_settings.set_visible(true)

func _on_button_quit_settings_pressed():
	m_settings.set_visible(false)
