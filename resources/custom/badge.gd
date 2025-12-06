extends Resource
class_name Badge
##The Badge Class Used For Storing Data About Badges, Utilized By BadgeManager.

##The ID Used By Logic Handled By The BadgeManager
@export var id : String
##Badge Icon.
@export var icon : Texture2D
##Badge Display Name.
@export_multiline var display_name : String
##Badge Desciption.
@export_multiline var description : String
##The Color Used As The Border Aroung The [member con].
@export var border_color : Color = "cc3795"
##The Color Used As The Background For The Badge Card
@export var background_color : Color = "e53da8"
##What Is Visible To The Player When The Badge Is Locked,
@export_enum("Icon Name & Description","Icon & Name","Name","Icon","None") var locked_visibility = "Icon Name & Description"
