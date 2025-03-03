extends DialogManager

var raw = "1:hi
2:hello
Wait[1]
1:yeet!
2:yeetusss,
1:Works,
Wait[.5]
  Yahhooo!!!
2:YIPPEEEE!!!!!!!!!!!
1:woah bro calm down.
2:NO.
1:...
1:Ok Then..
Wait[.5]
  bro,"


func _init() -> void:
	DialogManager.Wait(.1)
	DialogManager.SelectChar(1)
	await DialogManager.Say("hi")
	DialogManager.SelectChar(2)
	await DialogManager.Say("hello")
	await DialogManager.Wait(1)
	DialogManager.SelectChar(1)
	await DialogManager.Say("yeet!")
	DialogManager.SelectChar(2)
	await DialogManager.Say("yeetusss,")
	DialogManager.SelectChar(1)
	await DialogManager.Say("Works,")
	await DialogManager.Wait(.5)
	await DialogManager.Say("  Yahhooo!!!")
	DialogManager.SelectChar(2)
	await DialogManager.Say("YIPPEEEE!!!!!!!!!!!")
	DialogManager.SelectChar(1)
	await DialogManager.Say("woah bro calm down.")
	DialogManager.SelectChar(2)
	await DialogManager.Say("NO.")
	DialogManager.SelectChar(1)
	await DialogManager.Say("...")
	DialogManager.SelectChar(1)
	await DialogManager.Say("Ok Then..")
	await DialogManager.Wait(.5)
	await DialogManager.Say("  bro,")
