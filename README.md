# AyeUI

A simple Roblox UI library.

---

## 📦 What it does
AyeUI lets you create:
- Windows
- Tabs
- Buttons
- Toggles
- Sliders

---

## ⚙️ Installation

### 1. Add Module
Put `AyeUI.lua` into: ReplicatedStorage
---

### 2. Require it
```lua
local UI = require(game.ReplicatedStorage.AyeUI)
OR

Create
UIlocal Window = UI:CreateWindow({
Title = "Ayeui"
})

Create Tab
local Main = Window:CreateTab("Main")

Button
Main:Button("Click Me", function()
	print("Clicked")
end)

Toggle
Main:Toggle("Enable", function(state)
	print(state)
end)

Slider
Main:Slider("Speed", 16, 100, function(value)
	print(value)
end)

HTTP Load
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/USER/AyeUI/main/src/AyeUI.lua"))()
