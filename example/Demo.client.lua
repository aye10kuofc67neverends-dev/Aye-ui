local UI = require(game.ReplicatedStorage.AyeUI)

local Window = UI:CreateWindow({
	Title = "AyeUI"
})

local Main = Window:CreateTab("Main")

Main:Button("Button", function()
	print("clicked")
end)

Main:Toggle("Toggle", function(v)
	print(v)
end)

Main:Slider("Speed", 16, 100, function(v)
	print(v)
end)
