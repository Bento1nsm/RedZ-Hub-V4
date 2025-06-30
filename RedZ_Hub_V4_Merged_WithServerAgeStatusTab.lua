
-- ✅ RedZ Hub V4 - Final Version with Real Server Age in Status Tab
-- [Includes FPS boost, Anti AFK, Auto Rejoin, Auto Restart, Server Age UI inside Status Tab]

-- FPS BOOST
pcall(function()
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    game:GetService("Lighting").GlobalShadows = false
    game:GetService("Lighting").FogEnd = 1e10
    game:GetService("Lighting").Brightness = 1
    setfpscap(30)
end)

-- ANTI AFK
pcall(function()
    local vu = game:GetService("VirtualUser")
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        wait(1)
        vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end)

-- AUTO REJOIN
pcall(function()
    game:GetService("Players").LocalPlayer.OnTeleport:Connect(function(state)
        if state == Enum.TeleportState.Failed then
            wait(5)
            game:GetService("TeleportService"):Teleport(game.PlaceId)
        end
    end)
    game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
        if child.Name == "ErrorPrompt" then
            wait(3)
            game:GetService("TeleportService"):Teleport(game.PlaceId)
        end
    end)
end)

-- AUTO RESTART AFTER 2 HOURS
pcall(function()
    task.spawn(function()
        wait(7200)
        local ts = game:GetService("TeleportService")
        local plr = game:GetService("Players").LocalPlayer
        ts:TeleportToPlaceInstance(game.PlaceId, game.JobId, plr)
    end)
end)

-- ✅ Real Server Age Display (Inside Status Tab)
pcall(function()
    local function getRealServerAge()
        local age = os.time() - game:GetService("Workspace"):GetServerTimeNow()
        local hrs = math.floor(age / 3600)
        local mins = math.floor((age % 3600) / 60)
        return string.format("Server Age: %dh %dm", hrs, mins)
    end

    task.spawn(function()
        repeat wait() until game:GetService("CoreGui"):FindFirstChild("RedzHub") or game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
        local gui = game:GetService("CoreGui"):FindFirstChild("RedzHub") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("RedzHub")
        if gui then
            local statusTab = gui:FindFirstChild("Tabs", true)
            if statusTab then
                local label = Instance.new("TextLabel")
                label.Name = "ServerAgeLabel"
                label.Size = UDim2.new(1, -10, 0, 20)
                label.Position = UDim2.new(0, 5, 1, -25)
                label.BackgroundTransparency = 1
                label.TextColor3 = Color3.fromRGB(255, 255, 255)
                label.TextStrokeTransparency = 0
                label.Font = Enum.Font.SourceSansSemibold
                label.TextSize = 14
                label.Text = getRealServerAge()
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Parent = statusTab

                while label and label.Parent do
                    label.Text = getRealServerAge()
                    wait(60)
                end
            end
        end
    end)
end)

-- REDZ HUB CORE LOADER
local Scripts = {
    {
        PlacesIds = {2753915549, 4442272183, 7449423635},
        Path = "BloxFruits.luau"
    },
    {
        PlacesIds = {10260193230},
        Path = "MemeSea.luau"
    }
}

local fetcher, urls = {}, {}
urls.Owner = "https://raw.githubusercontent.com/tlredz/"
urls.Repository = urls.Owner .. "Scripts/main/"
urls.Translator = urls.Repository .. "Translator/"
urls.Utils = urls.Repository .. "Utils/"

do
    local _ENV = (getgenv or getrenv or getfenv)()
    if _ENV.rz_error_message then _ENV.rz_error_message:Destroy() end

    local identifyexecutor = identifyexecutor or function() return "Unknown" end

    local function CreateMessageError(Text)
        _ENV.loadedFarm = nil
        _ENV.OnFarm = false
        local Message = Instance.new("Message", workspace)
        Message.Text = string.gsub(Text, urls.Owner, "")
        _ENV.rz_error_message = Message
        task.delay(10, function()
            if Message then Message:Destroy() end
        end)
        error(Text, 2)
    end

    local function formatUrl(Url)
        for key, path in pairs(urls) do
            Url = Url:gsub("{" .. key .. "}", path)
        end
        return Url
    end

    function fetcher.get(Url)
        local success, response = pcall(function()
            return game:HttpGet(formatUrl(Url))
        end)
        if success then
            return response
        else
            warn("❌ Failed to fetch URL, retrying in 5s...")
            wait(5)
            return fetcher.get(Url)
        end
    end

    function fetcher.load(Url, concat)
        local raw = fetcher.get(Url) .. (concat or "")
        local func, err = loadstring(raw)
        if type(func) ~= "function" then
            CreateMessageError(string.format("[2] [%s] syntax error: %s\n>>%s<<", identifyexecutor(), Url, err))
        end
        return func
    end
end

local function IsPlace(Data)
    if type(Data) ~= "table" then return false end
    if Data.PlacesIds and table.find(Data.PlacesIds, game.PlaceId) then
        return true
    elseif Data.GameId and game.GameId == Data.GameId then
        return true
    end
    return false
end

local loaded = false
for _, Data in ipairs(Scripts) do
    if IsPlace(Data) and not loaded then
        loaded = true
        local loadedScript = fetcher.load("{Repository}Games/" .. Data.Path)
        if type(loadedScript) == "function" then
            local success, err = pcall(function()
                loadedScript(fetcher)
            end)
            if not success then
                warn("⚠️ Redz crashed, retrying in 3s...\nError: " .. tostring(err))
                wait(3)
                pcall(function()
                    loadedScript(fetcher)
                end)
            end
        else
            warn("❌ Failed to load Redz module correctly.")
        end
    end
end
