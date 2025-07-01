
--// Updated July 2025 — Blox Fruits 'On-the-Spot' Roll Simulation (No animation, shows image + name)
--// GUI appears instantly showing the rolled fruit image and name based on updated fruit pool

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Fruit icons (replace with actual uploaded asset IDs)
local fruitIcons = {
    ["Rocket"] = "rbxassetid://1234567890",
    ["Spin"] = "rbxassetid://1234567891",
    ["Blade"] = "rbxassetid://1234567892",
    ["Spring"] = "rbxassetid://1234567893",
    ["Bomb"] = "rbxassetid://1234567894",
    ["Spike"] = "rbxassetid://1234567895",
    ["Smoke"] = "rbxassetid://1234567896",
    ["Flame"] = "rbxassetid://1234567897",
    ["Ice"] = "rbxassetid://1234567898",
    ["Sand"] = "rbxassetid://1234567899",
    ["Dark"] = "rbxassetid://1234567900",
    ["Diamond"] = "rbxassetid://1234567901",
    ["Eagle"] = "rbxassetid://1234567902",
    ["Light"] = "rbxassetid://1234567903",
    ["Magma"] = "rbxassetid://1234567904",
    ["Rubber"] = "rbxassetid://1234567905",
    ["Ghost"] = "rbxassetid://1234567906",
    ["Love"] = "rbxassetid://1234567907",
    ["Quake"] = "rbxassetid://1234567908",
    ["Creation"] = "rbxassetid://1234567909",
    ["Spider"] = "rbxassetid://1234567910",
    ["Sound"] = "rbxassetid://1234567911",
    ["Portal"] = "rbxassetid://1234567912",
    ["Phoenix"] = "rbxassetid://1234567913",
    ["Buddha"] = "rbxassetid://1234567914",
    ["Rumble"] = "rbxassetid://1234567915",
    ["Blizzard"] = "rbxassetid://1234567916",
    ["Pain"] = "rbxassetid://1234567917",
    ["Dough"] = "rbxassetid://1234567918",
    ["Gas"] = "rbxassetid://1234567919",
    ["Shadow"] = "rbxassetid://1234567920",
    ["Venom"] = "rbxassetid://1234567921",
    ["Control"] = "rbxassetid://1234567922",
    ["Spirit"] = "rbxassetid://1234567923",
    ["Gravity"] = "rbxassetid://1234567924",
    ["Dragon (Eastern)"] = "rbxassetid://1234567925",
    ["Dragon (Western)"] = "rbxassetid://1234567926",
    ["Leopard"] = "rbxassetid://1234567927",
    ["Yeti"] = "rbxassetid://1234567928",
    ["Kitsune"] = "rbxassetid://1234567929",
}

-- Fruit rarities
local fruits = {
    Common = {"Rocket", "Spin", "Blade", "Spring", "Bomb", "Spike", "Smoke"},
    Uncommon = {"Flame", "Ice", "Sand", "Dark", "Diamond", "Eagle"},
    Rare = {"Light", "Magma", "Rubber", "Ghost"},
    Legendary = {"Love", "Quake", "Creation", "Spider", "Sound", "Portal", "Phoenix", "Buddha", "Rumble", "Blizzard", "Pain"},
    Mythical = {"Dough", "Gas", "Shadow", "Venom", "Control", "Spirit", "Gravity", "Dragon (Eastern)", "Dragon (Western)", "Leopard", "Yeti", "Kitsune"}
}

local rarityChances = {
    {type = "Common", chance = 60},
    {type = "Uncommon", chance = 26},
    {type = "Rare", chance = 10},
    {type = "Legendary", chance = 4},
    {type = "Mythical", chance = 0.1},
}

-- Generate weighted pool
local weightedPool = {}
for _, r in ipairs(rarityChances) do
    for _, fruit in ipairs(fruits[r.type]) do
        table.insert(weightedPool, {
            name = fruit,
            rarity = r.type,
            weight = r.chance / #fruits[r.type]
        })
    end
end

local function rollFruit()
    local total = 0
    for _, f in ipairs(weightedPool) do total += f.weight end
    local roll = math.random() * total
    local acc = 0
    for _, f in ipairs(weightedPool) do
        acc += f.weight
        if roll <= acc then return f end
    end
end

-- Build GUI
local function showFruitResult(fruit)
    if PlayerGui:FindFirstChild("FruitResult") then
        PlayerGui.FruitResult:Destroy()
    end

    local gui = Instance.new("ScreenGui", PlayerGui)
    gui.Name = "FruitResult"

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 300, 0, 300)
    frame.Position = UDim2.new(0.5, -150, 0.5, -150)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    frame.BorderSizePixel = 0
    frame.BackgroundTransparency = 0.2

    local icon = Instance.new("ImageLabel", frame)
    icon.Size = UDim2.new(0.8, 0, 0.8, 0)
    icon.Position = UDim2.new(0.1, 0, 0.05, 0)
    icon.BackgroundTransparency = 1
    icon.Image = fruitIcons[fruit.name] or "rbxassetid://0"

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, 0, 0.15, 0)
    label.Position = UDim2.new(0, 0, 0.85, 0)
    label.Text = fruit.name
    label.Font = Enum.Font.GothamBold
    label.TextScaled = true
    label.TextColor3 = Color3.new(1, 1, 1)
    label.BackgroundTransparency = 1
end

-- Run
local rolled = rollFruit()
showFruitResult(rolled)
print("[RESULT] You rolled:", rolled.rarity, "→", rolled.name)
