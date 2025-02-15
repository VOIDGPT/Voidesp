local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Настройки
local rainbowSpeed = 2 -- Скорость изменения цвета
local maxDistance = 1000 -- Максимальная дистанция видимости ESP
local textSize = 15 -- Размер текста (меньше значение = меньше текст)

-- Функция для создания ESP
local function createESP(player)
    local character = player.Character
    if not character then return end

    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end

    -- Создаем BillboardGui для отображения ника
    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = humanoidRootPart
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true

    local textLabel = Instance.new("TextLabel")
    textLabel.Parent = billboard
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.Text = player.Name
    textLabel.TextColor3 = Color3.new(1, 1, 1)
    textLabel.TextScaled = false
    textLabel.TextSize = textSize
    textLabel.BackgroundTransparency = 1
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextStrokeTransparency = 0.5

    billboard.Parent = player.Character

    -- Создаем хитбокс (рамку вокруг игрока)
    local box = Instance.new("BoxHandleAdornment")
    box.Size = Vector3.new(4, 6, 4)
    box.Adornee = humanoidRootPart
    box.AlwaysOnTop = true
    box.Transparency = 0.5
    box.ZIndex = 10
    box.Parent = player.Character

    -- Радужный эффект
    local hue = 0
    RunService.Heartbeat:Connect(function(deltaTime)
        if not character or not humanoidRootPart or not billboard or not billboard.Parent then
            billboard:Destroy()
            box:Destroy()
            return
        end

        -- Проверка дистанции
        local distance = (LocalPlayer.Character.HumanoidRootPart.Position - humanoidRootPart.Position).Magnitude
        if distance > maxDistance then
            billboard.Enabled = false
            box.Visible = false
        else
            billboard.Enabled = true
            box.Visible = true
        end

        -- Изменение цвета
        hue = (hue + rainbowSpeed * deltaTime) % 1
        local rainbowColor = Color3.fromHSV(hue, 1, 1)
        textLabel.TextColor3 = rainbowColor
        box.Color3 = rainbowColor
    end)
end

-- Обработка добавления игроков
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        createESP(player)
    end)
end)

-- Обработка уже подключенных игроков
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function()
            createESP(player)
        end)
        if player.Character then
            createESP(player)
        end
    end
end
