-- Автоматическая очистка старых панелей при перезапуске скрипта
local plr = game.Players.LocalPlayer
local pGui = plr:WaitForChild("PlayerGui")
if pGui:FindFirstChild("VisualToolGui") then 
    pGui.VisualToolGui:Destroy() 
end

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- 1. СКРИПТ СОЗДАНИЯ ИНТЕРФЕЙСА
local sgui = Instance.new("ScreenGui")
sgui.Name = "VisualToolGui"
sgui.ResetOnSpawn = false
sgui.Parent = pGui

-- Главное красивое окно
local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 290, 0, 160)
frame.Position = UDim2.new(0.5, -145, 0.5, -80)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 28) -- Глубокий темный тон
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = sgui

-- Плавное закругление краев панели
local fCorner = Instance.new("UICorner")
fCorner.CornerRadius = UDim.new(0, 14)
fCorner.Parent = frame

-- Стильная неоновая обводка (UIStroke)
local fStroke = Instance.new("UIStroke")
fStroke.Color = Color3.fromRGB(0, 180, 216) -- Яркий неоновый голубой
fStroke.Thickness = 2
fStroke.Parent = frame

-- Заголовок панели
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 45)
title.BackgroundTransparency = 1
title.Text = "DUPE CONTROL PANEL"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = frame

-- Информационная строка состояния
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, 0, 0, 20)
status.Position = UDim2.new(0, 0, 0, 45)
status.BackgroundTransparency = 1
status.Text = "Возьмите предмет в руки"
status.TextColor3 = Color3.fromRGB(150, 150, 160)
status.Font = Enum.Font.Gotham
status.TextSize = 11
status.Parent = frame

-- Главная Кнопка
local btn = Instance.new("TextButton")
btn.Name = "DupeButton"
btn.Size = UDim2.new(0, 230, 0, 45)
btn.Position = UDim2.new(0.5, -115, 0, 85)
btn.BackgroundColor3 = Color3.fromRGB(0, 119, 182) -- Синий базовый цвет
btn.Text = "дюп"
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Font = Enum.Font.GothamSemibold
btn.TextSize = 14
btn.Parent = frame

-- Закругление краев кнопки
local bCorner = Instance.new("UICorner")
bCorner.CornerRadius = UDim.new(0, 10)
bCorner.Parent = btn

-- Кнопка закрытия (Крестик в верхнем углу)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -35, 0, 10)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 92, 141)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 15
closeBtn.Parent = frame

closeBtn.MouseButton1Click:Connect(function()
    sgui:Destroy()
end)

-- Плавная анимация изменения цвета кнопки
btn.MouseEnter:Connect(function()
    TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 180, 216)}):Play()
end)
btn.MouseLeave:Connect(function()
    TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 119, 182)}):Play()
end)

-- ========================================================
-- 2. КРОСС ПЛАТФОРМЕННЫЙ СКРИПТ ПЕРЕТАСКИВАНИЯ (ПК и Телефон)
-- ========================================================
local dragging, dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    -- Используем Tween для идеальной плавности движения панели за пальцем/мышкой
    TweenService:Create(frame, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    }):Play()
end

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- ========================================================
-- 3. ЛОГИКА СКОПИРОВАНИЯ ПРЕДМЕТА
-- ========================================================
btn.MouseButton1Click:Connect(function()
    local char = plr.Character
    if char then
        local currentTool = char:FindFirstChildOfClass("Tool")
        
        if currentTool then
            status.Text = "Успешно скопирован: " .. currentTool.Name
            status.TextColor3 = Color3.fromRGB(85, 239, 196)
            
          
           local visualCopy = currentTool:Clone()
            visualCopy.Parent = plr:WaitForChild("Backpack")
            
            print("[INFO] Предмет продублирован визуально: " .. currentTool.Name)
        else
            status.Text = "Ошибка: Предмет не у вас в руках!"
            status.TextColor3 = Color3.fromRGB(255, 118, 117)
        end
    end
end)

print("[INFO] Скрипт с поддержкой перетаскивания (Drag) загружен!")
