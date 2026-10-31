-- =============================================================================
-- NEXUS SCRIPT HUB - Dark themed UI (versión corregida)
-- =============================================================================

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

-- Contenedor padre seguro: gethui -> CoreGui -> PlayerGui
local function getTargetParent()
	if typeof(gethui) == "function" then
		local ok, result = pcall(gethui)
		if ok and result then return result end
	end
	local ok = pcall(function() return CoreGui.Name end)
	if ok then return CoreGui end
	return LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui")
end
local TargetParent = getTargetParent()

-- Nombre fijo: así se detecta y elimina una instancia anterior
local UI_NAME = "NexusScriptHub"
local old = TargetParent:FindFirstChild(UI_NAME)
if old then old:Destroy() end

-- Limpieza de eventos e instancias
local Janitor = { Connections = {}, Instances = {} }
function Janitor:AddConnection(conn) table.insert(self.Connections, conn) return conn end
function Janitor:AddInstance(inst) table.insert(self.Instances, inst) return inst end
function Janitor:Clean()
	for _, conn in ipairs(self.Connections) do pcall(function() conn:Disconnect() end) end
	for _, inst in ipairs(self.Instances) do pcall(function() inst:Destroy() end) end
	table.clear(self.Connections)
	table.clear(self.Instances)
end

-- =============================================================================
-- DATOS
-- =============================================================================
local ScriptsData = {
	{ Name = "Infinite Yield", Source = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()' },
	{ Name = "Novoline", Source = 'loadstring(game:HttpGet("https://scriptblox.com/raw/Universal-Script-Novoline-204721"))()' },
	{ Name = "Fly", Source = 'loadstring(game:HttpGet("https://scriptblox.com/raw/Universal-Script-fly-v3-by-hibatzzz-243731"))()' },
	{ Name = "Moondiety MM2", Source = 'loadstring(game:HttpGet("https://scriptblox.com/raw/Murder-Mystery-2-KEYLESS-InstaWin-AutoFarm-Kill-all-XRay-nd-more-by-Moondiety-48644"))()' },
	{ Name = "Foxname MM2", Source = 'loadstring(game:HttpGet("https://scriptblox.com/raw/Universal-Script-Foxname-241528"))()' },
	{ Name = "YARHM", Source = 'loadstring(game:HttpGet("https://scriptblox.com/raw/Universal-Script-YARHM-12403"))()' },
	{ Name = "My MM2 Autofarm", Source = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/wvahub/mm2/refs/heads/main/autofarm"))()' },
}

-- =============================================================================
-- TEMA
-- =============================================================================
local Theme = {
	Background = Color3.fromRGB(24, 24, 26),
	Container = Color3.fromRGB(32, 32, 36),
	RowBg = Color3.fromRGB(40, 40, 44),
	Text = Color3.fromRGB(245, 245, 245),
	TextDim = Color3.fromRGB(150, 150, 160),
	PurpleAccent = Color3.fromRGB(130, 80, 220),
	BlueAccent = Color3.fromRGB(40, 140, 240),
	StatusRunning = Color3.fromRGB(230, 160, 40),
	StatusSuccess = Color3.fromRGB(40, 200, 100),
	StatusError = Color3.fromRGB(220, 60, 60),
}

local function corner(parent, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius)
	c.Parent = parent
	return c
end

-- =============================================================================
-- UI
-- =============================================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = UI_NAME
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Janitor:AddInstance(ScreenGui)

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 460, 0, 360)
MainFrame.Position = UDim2.new(0.5, -230, 0.5, -180)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
corner(MainFrame, 10)

-- Barra de título
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Theme.Container
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame
corner(TitleBar, 10)

-- Parche para cuadrar las esquinas inferiores de la barra
local Patch = Instance.new("Frame")
Patch.Name = "Patch"
Patch.Size = UDim2.new(1, 0, 0, 10)
Patch.Position = UDim2.new(0, 0, 1, -10)
Patch.BackgroundColor3 = Theme.Container
Patch.BorderSizePixel = 0
Patch.ZIndex = 1
Patch.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0, 200, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Nexus Script Hub"
TitleLabel.TextColor3 = Theme.Text
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 16
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex = 2
TitleLabel.Parent = TitleBar

-- Línea de acento (el degradado necesita un fondo blanco para verse bien)
local AccentLine = Instance.new("Frame")
AccentLine.Size = UDim2.new(1, 0, 0, 2)
AccentLine.Position = UDim2.new(0, 0, 0, 40)
AccentLine.BackgroundColor3 = Color3.new(1, 1, 1)
AccentLine.BorderSizePixel = 0
AccentLine.Parent = MainFrame

local LineGradient = Instance.new("UIGradient")
LineGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Theme.BlueAccent),
	ColorSequenceKeypoint.new(1, Theme.PurpleAccent),
})
LineGradient.Parent = AccentLine

-- Controles de ventana
local ControlsContainer = Instance.new("Frame")
ControlsContainer.Size = UDim2.new(0, 70, 1, 0)
ControlsContainer.Position = UDim2.new(1, -75, 0, 0)
ControlsContainer.BackgroundTransparency = 1
ControlsContainer.ZIndex = 2
ControlsContainer.Parent = TitleBar

local UIListControls = Instance.new("UIListLayout")
UIListControls.FillDirection = Enum.FillDirection.Horizontal
UIListControls.HorizontalAlignment = Enum.HorizontalAlignment.Right
UIListControls.VerticalAlignment = Enum.VerticalAlignment.Center
UIListControls.SortOrder = Enum.SortOrder.LayoutOrder
UIListControls.Padding = UDim.new(0, 8)
UIListControls.Parent = ControlsContainer

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 24, 0, 24)
MinimizeBtn.BackgroundColor3 = Theme.RowBg
MinimizeBtn.Text = "−"
MinimizeBtn.TextColor3 = Theme.Text
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 14
MinimizeBtn.BorderSizePixel = 0
MinimizeBtn.AutoButtonColor = true
MinimizeBtn.LayoutOrder = 1
MinimizeBtn.ZIndex = 2
MinimizeBtn.Parent = ControlsContainer
corner(MinimizeBtn, 6)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 24, 0, 24)
CloseBtn.BackgroundColor3 = Color3.fromRGB(50, 35, 40)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Theme.StatusError
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 12
CloseBtn.BorderSizePixel = 0
CloseBtn.LayoutOrder = 2
CloseBtn.ZIndex = 2
CloseBtn.Parent = ControlsContainer
corner(CloseBtn, 6)

-- Lista con scroll
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Name = "ScriptsList"
ScrollFrame.Size = UDim2.new(1, -20, 1, -60)
ScrollFrame.Position = UDim2.new(0, 10, 0, 50)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.ScrollBarImageColor3 = Theme.PurpleAccent
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollFrame.Parent = MainFrame

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 8)
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Parent = ScrollFrame

local ListPadding = Instance.new("UIPadding")
ListPadding.PaddingRight = UDim.new(0, 8)
ListPadding.PaddingBottom = UDim.new(0, 6)
ListPadding.Parent = ScrollFrame

-- Botón flotante de restauración
local RESTORE_HIDDEN = UDim2.new(0.5, -65, 1, 50)
local RESTORE_SHOWN = UDim2.new(0.5, -65, 1, -60)

local RestoreBtn = Instance.new("TextButton")
RestoreBtn.Name = "RestoreButton"
RestoreBtn.Size = UDim2.new(0, 130, 0, 40)
RestoreBtn.Position = RESTORE_HIDDEN
RestoreBtn.BackgroundColor3 = Theme.Container
RestoreBtn.Text = "Abrir Hub ⇡"
RestoreBtn.TextColor3 = Theme.Text
RestoreBtn.Font = Enum.Font.GothamBold
RestoreBtn.TextSize = 14
RestoreBtn.BorderSizePixel = 0
RestoreBtn.Visible = false
RestoreBtn.Parent = ScreenGui
corner(RestoreBtn, 8)

local RestoreStroke = Instance.new("UIStroke")
RestoreStroke.Color = Theme.BlueAccent
RestoreStroke.Thickness = 1.5
RestoreStroke.Parent = RestoreBtn

-- =============================================================================
-- FILAS DE SCRIPTS
-- =============================================================================
local function setStatus(label, text, color)
	label.Text = text
	label.TextColor3 = color
end

for index, item in ipairs(ScriptsData) do
	local RowFrame = Instance.new("Frame")
	RowFrame.Name = "Row_" .. item.Name
	RowFrame.Size = UDim2.new(1, 0, 0, 46)
	RowFrame.BackgroundColor3 = Theme.RowBg
	RowFrame.BorderSizePixel = 0
	RowFrame.LayoutOrder = index
	RowFrame.Parent = ScrollFrame
	corner(RowFrame, 8)

	local NameLabel = Instance.new("TextLabel")
	NameLabel.Size = UDim2.new(1, -170, 0, 22)
	NameLabel.Position = UDim2.new(0, 12, 0, 5)
	NameLabel.BackgroundTransparency = 1
	NameLabel.Text = item.Name
	NameLabel.TextColor3 = Theme.Text
	NameLabel.Font = Enum.Font.GothamMedium
	NameLabel.TextSize = 14
	NameLabel.TextXAlignment = Enum.TextXAlignment.Left
	NameLabel.TextTruncate = Enum.TextTruncate.AtEnd
	NameLabel.Parent = RowFrame

	local StatusLabel = Instance.new("TextLabel")
	StatusLabel.Size = UDim2.new(1, -170, 0, 14)
	StatusLabel.Position = UDim2.new(0, 12, 0, 27)
	StatusLabel.BackgroundTransparency = 1
	StatusLabel.Text = "Listo"
	StatusLabel.TextColor3 = Theme.TextDim
	StatusLabel.Font = Enum.Font.Gotham
	StatusLabel.TextSize = 11
	StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
	StatusLabel.Parent = RowFrame

	local RunBtn = Instance.new("TextButton")
	RunBtn.Size = UDim2.new(0, 90, 0, 28)
	RunBtn.Position = UDim2.new(1, -102, 0.5, -14)
	RunBtn.BackgroundColor3 = Theme.PurpleAccent
	RunBtn.Text = "Ejecutar"
	RunBtn.TextColor3 = Theme.Text
	RunBtn.Font = Enum.Font.GothamBold
	RunBtn.TextSize = 13
	RunBtn.BorderSizePixel = 0
	RunBtn.Parent = RowFrame
	corner(RunBtn, 6)

	local running = false
	Janitor:AddConnection(RunBtn.MouseButton1Click:Connect(function()
		if running then return end
		running = true
		setStatus(StatusLabel, "Ejecutando...", Theme.StatusRunning)

		task.spawn(function()
			local ok, err = pcall(function()
				if typeof(loadstring) ~= "function" then
					error("loadstring no disponible en este entorno")
				end
				local fn, compileErr = loadstring(item.Source)
				if not fn then error(compileErr) end
				fn()
			end)

			if ok then
				setStatus(StatusLabel, "Ejecutado correctamente", Theme.StatusSuccess)
			else
				local msg = tostring(err):sub(1, 40)
				setStatus(StatusLabel, "Error: " .. msg, Theme.StatusError)
			end

			task.wait(1.5)
			if StatusLabel.Parent then
				setStatus(StatusLabel, "Listo", Theme.TextDim)
			end
			running = false
		end)
	end))
end

-- =============================================================================
-- MINIMIZAR / RESTAURAR / CERRAR
-- =============================================================================
local tweenInfo = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local minimized = false

local function minimize()
	if minimized then return end
	minimized = true
	MainFrame.Visible = false
	RestoreBtn.Visible = true
	TweenService:Create(RestoreBtn, tweenInfo, { Position = RESTORE_SHOWN }):Play()
end

local function restore()
	if not minimized then return end
	minimized = false
	RestoreBtn.Visible = false
	RestoreBtn.Position = RESTORE_HIDDEN
	MainFrame.Visible = true
end

Janitor:AddConnection(MinimizeBtn.MouseButton1Click:Connect(minimize))
Janitor:AddConnection(RestoreBtn.MouseButton1Click:Connect(restore))
Janitor:AddConnection(CloseBtn.MouseButton1Click:Connect(function() Janitor:Clean() end))

-- =============================================================================
-- ARRASTRAR VENTANA
-- =============================================================================
local dragging, dragStart, startPos = false, nil, nil

Janitor:AddConnection(TitleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position
	end
end))

Janitor:AddConnection(UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		MainFrame.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y
		)
	end
end))

Janitor:AddConnection(UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end))

-- Se muestra todo de golpe: un único render en lugar de cientos de recalculos
ScreenGui.Parent = TargetParent
