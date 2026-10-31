-- Nexus Script Hub

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

local function getTargetParent()
	if typeof(gethui) == "function" then
		local ok, result = pcall(gethui)
		if ok and result then return result end
	end
	if pcall(function() return CoreGui.Name end) then return CoreGui end
	return LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui")
end
local TargetParent = getTargetParent()

local UI_NAME = "NexusScriptHub"
local previous = TargetParent:FindFirstChild(UI_NAME)
if previous then previous:Destroy() end

local Janitor = { Connections = {}, Instances = {} }
function Janitor:Connect(signal, fn)
	local conn = signal:Connect(fn)
	table.insert(self.Connections, conn)
	return conn
end
function Janitor:Track(inst) table.insert(self.Instances, inst) return inst end
function Janitor:Clean()
	for _, c in ipairs(self.Connections) do pcall(function() c:Disconnect() end) end
	for _, i in ipairs(self.Instances) do pcall(function() i:Destroy() end) end
	table.clear(self.Connections)
	table.clear(self.Instances)
end

-- Scripts ---------------------------------------------------------------------

local Scripts = {
	{ Name = "Infinite Yield", Source = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()' },
	{ Name = "Novoline", Source = 'loadstring(game:HttpGet("https://scriptblox.com/raw/Universal-Script-Novoline-204721"))()' },
	{ Name = "Fly", Source = 'loadstring(game:HttpGet("https://scriptblox.com/raw/Universal-Script-fly-v3-by-hibatzzz-243731"))()' },
	{ Name = "Moondiety MM2", Source = 'loadstring(game:HttpGet("https://scriptblox.com/raw/Murder-Mystery-2-KEYLESS-InstaWin-AutoFarm-Kill-all-XRay-nd-more-by-Moondiety-48644"))()' },
	{ Name = "Foxname MM2", Source = 'loadstring(game:HttpGet("https://scriptblox.com/raw/Universal-Script-Foxname-241528"))()' },
	{ Name = "YARHM", Source = 'loadstring(game:HttpGet("https://scriptblox.com/raw/Universal-Script-YARHM-12403"))()' },
	{ Name = "My MM2 Autofarm", Source = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/wvahub/mm2/refs/heads/main/autofarm"))()' },
}

-- Theme -----------------------------------------------------------------------

local C = {
	Window   = Color3.fromRGB(17, 17, 20),
	Panel    = Color3.fromRGB(23, 23, 27),
	Row      = Color3.fromRGB(26, 26, 31),
	RowHover = Color3.fromRGB(32, 32, 38),
	Border   = Color3.fromRGB(42, 42, 50),
	Text     = Color3.fromRGB(232, 232, 236),
	Dim      = Color3.fromRGB(122, 122, 134),
	Accent   = Color3.fromRGB(96, 165, 250),
	Running  = Color3.fromRGB(234, 179, 8),
	Success  = Color3.fromRGB(74, 222, 128),
	Error    = Color3.fromRGB(248, 113, 113),
}

local FONT = Enum.Font.BuilderSans
local FONT_MED = Enum.Font.BuilderSansMedium
local FONT_BOLD = Enum.Font.BuilderSansBold

-- Helpers ---------------------------------------------------------------------

local function new(class, props, children)
	local inst = Instance.new(class)
	local parent = props.Parent
	props.Parent = nil
	for k, v in pairs(props) do inst[k] = v end
	for _, child in ipairs(children or {}) do child.Parent = inst end
	inst.Parent = parent
	return inst
end

local function corner(r) return new("UICorner", { CornerRadius = UDim.new(0, r) }) end
local function stroke(color, transparency)
	return new("UIStroke", {
		Color = color or C.Border,
		Thickness = 1,
		Transparency = transparency or 0,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	})
end

local function tween(inst, props, duration)
	TweenService:Create(inst, TweenInfo.new(duration or 0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

-- Window ----------------------------------------------------------------------

local WIDTH, HEIGHT = 480, 400
local CENTER = UDim2.new(0.5, -WIDTH / 2, 0.5, -HEIGHT / 2)

local ScreenGui = Janitor:Track(new("ScreenGui", {
	Name = UI_NAME,
	ResetOnSpawn = false,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}))

local Main = new("Frame", {
	Name = "Main",
	Size = UDim2.fromOffset(WIDTH, HEIGHT),
	Position = CENTER,
	BackgroundColor3 = C.Window,
	BorderSizePixel = 0,
	ClipsDescendants = true,
	Parent = ScreenGui,
}, { corner(8), stroke(C.Border) })

-- Header
local Header = new("Frame", {
	Name = "Header",
	Size = UDim2.new(1, 0, 0, 46),
	BackgroundTransparency = 1,
	Parent = Main,
})

new("TextLabel", {
	Size = UDim2.new(1, -120, 1, 0),
	Position = UDim2.fromOffset(16, 0),
	BackgroundTransparency = 1,
	RichText = true,
	Text = 'Nexus <font color="rgb(122,122,134)">Script Hub</font>',
	TextColor3 = C.Text,
	Font = FONT_BOLD,
	TextSize = 15,
	TextXAlignment = Enum.TextXAlignment.Left,
	Parent = Header,
})

new("Frame", {
	Size = UDim2.new(1, 0, 0, 1),
	Position = UDim2.new(0, 0, 1, -1),
	BackgroundColor3 = C.Border,
	BorderSizePixel = 0,
	Parent = Header,
})

local Controls = new("Frame", {
	Size = UDim2.fromOffset(64, 28),
	AnchorPoint = Vector2.new(1, 0.5),
	Position = UDim2.new(1, -10, 0.5, 0),
	BackgroundTransparency = 1,
	Parent = Header,
}, {
	new("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Right,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		Padding = UDim.new(0, 4),
		SortOrder = Enum.SortOrder.LayoutOrder,
	}),
})

local function controlButton(text, order, hoverColor)
	local btn = new("TextButton", {
		Size = UDim2.fromOffset(28, 28),
		BackgroundColor3 = C.Row,
		BackgroundTransparency = 1,
		Text = text,
		TextColor3 = C.Dim,
		Font = FONT_MED,
		TextSize = 18,
		AutoButtonColor = false,
		BorderSizePixel = 0,
		LayoutOrder = order,
		Parent = Controls,
	}, { corner(6) })
	Janitor:Connect(btn.MouseEnter, function()
		tween(btn, { BackgroundTransparency = 0, TextColor3 = hoverColor })
	end)
	Janitor:Connect(btn.MouseLeave, function()
		tween(btn, { BackgroundTransparency = 1, TextColor3 = C.Dim })
	end)
	return btn
end

local MinimizeBtn = controlButton("–", 1, C.Text)
local CloseBtn = controlButton("×", 2, C.Error)

-- Search
local Search = new("TextBox", {
	Size = UDim2.new(1, -32, 0, 34),
	Position = UDim2.fromOffset(16, 58),
	BackgroundColor3 = C.Panel,
	BorderSizePixel = 0,
	ClearTextOnFocus = false,
	PlaceholderText = "Search scripts",
	PlaceholderColor3 = C.Dim,
	Text = "",
	TextColor3 = C.Text,
	Font = FONT,
	TextSize = 14,
	TextXAlignment = Enum.TextXAlignment.Left,
	Parent = Main,
}, {
	corner(6),
	new("UIPadding", { PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12) }),
})
local SearchStroke = stroke(C.Border)
SearchStroke.Parent = Search
Janitor:Connect(Search.Focused, function() tween(SearchStroke, { Color = C.Accent }) end)
Janitor:Connect(Search.FocusLost, function() tween(SearchStroke, { Color = C.Border }) end)

-- List
local List = new("ScrollingFrame", {
	Name = "List",
	Size = UDim2.new(1, -16, 1, -142),
	Position = UDim2.fromOffset(8, 104),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ScrollBarThickness = 3,
	ScrollBarImageColor3 = C.Border,
	CanvasSize = UDim2.new(),
	AutomaticCanvasSize = Enum.AutomaticSize.Y,
	Parent = Main,
}, {
	new("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }),
	new("UIPadding", { PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8) }),
})

-- Footer
new("Frame", {
	Size = UDim2.new(1, 0, 0, 1),
	Position = UDim2.new(0, 0, 1, -34),
	BackgroundColor3 = C.Border,
	BorderSizePixel = 0,
	Parent = Main,
})

local CountLabel = new("TextLabel", {
	Size = UDim2.new(1, -32, 0, 34),
	Position = UDim2.new(0, 16, 1, -34),
	BackgroundTransparency = 1,
	Text = "",
	TextColor3 = C.Dim,
	Font = FONT,
	TextSize = 12,
	TextXAlignment = Enum.TextXAlignment.Left,
	Parent = Main,
})

-- Restore pill
local RESTORE_HIDDEN = UDim2.new(0.5, -50, 1, 50)
local RESTORE_SHOWN = UDim2.new(0.5, -50, 1, -52)

local RestoreBtn = new("TextButton", {
	Name = "Restore",
	Size = UDim2.fromOffset(100, 32),
	Position = RESTORE_HIDDEN,
	BackgroundColor3 = C.Window,
	Text = "Nexus",
	TextColor3 = C.Text,
	Font = FONT_MED,
	TextSize = 13,
	AutoButtonColor = false,
	BorderSizePixel = 0,
	Visible = false,
	Parent = ScreenGui,
}, { corner(16), stroke(C.Border) })

-- Rows ------------------------------------------------------------------------

local Rows = {}

local function updateCount()
	local visible = 0
	for _, row in ipairs(Rows) do
		if row.Frame.Visible then visible += 1 end
	end
	if visible == #Rows then
		CountLabel.Text = ("%d scripts"):format(#Rows)
	else
		CountLabel.Text = ("%d of %d scripts"):format(visible, #Rows)
	end
end

for index, item in ipairs(Scripts) do
	local Row = new("Frame", {
		Name = item.Name,
		Size = UDim2.new(1, 0, 0, 52),
		BackgroundColor3 = C.Row,
		BorderSizePixel = 0,
		LayoutOrder = index,
		Parent = List,
	}, { corner(6), stroke(C.Border, 0.5) })

	new("TextLabel", {
		Size = UDim2.new(1, -120, 0, 18),
		Position = UDim2.fromOffset(14, 9),
		BackgroundTransparency = 1,
		Text = item.Name,
		TextColor3 = C.Text,
		Font = FONT_MED,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = Row,
	})

	local Dot = new("Frame", {
		Size = UDim2.fromOffset(6, 6),
		Position = UDim2.fromOffset(14, 33),
		BackgroundColor3 = C.Dim,
		BorderSizePixel = 0,
		Parent = Row,
	}, { corner(3) })

	local Status = new("TextLabel", {
		Size = UDim2.new(1, -140, 0, 14),
		Position = UDim2.fromOffset(26, 29),
		BackgroundTransparency = 1,
		Text = "Ready",
		TextColor3 = C.Dim,
		Font = FONT,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = Row,
	})

	local Run = new("TextButton", {
		Size = UDim2.fromOffset(68, 28),
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -12, 0.5, 0),
		BackgroundColor3 = C.Accent,
		BackgroundTransparency = 0.88,
		Text = "Run",
		TextColor3 = C.Accent,
		Font = FONT_MED,
		TextSize = 13,
		AutoButtonColor = false,
		BorderSizePixel = 0,
		Parent = Row,
	}, { corner(6) })

	local function setStatus(text, color)
		Status.Text = text
		Status.TextColor3 = (color == C.Dim) and C.Dim or color
		tween(Dot, { BackgroundColor3 = color })
	end

	Janitor:Connect(Row.MouseEnter, function() tween(Row, { BackgroundColor3 = C.RowHover }) end)
	Janitor:Connect(Row.MouseLeave, function() tween(Row, { BackgroundColor3 = C.Row }) end)
	Janitor:Connect(Run.MouseEnter, function() tween(Run, { BackgroundTransparency = 0.72 }) end)
	Janitor:Connect(Run.MouseLeave, function() tween(Run, { BackgroundTransparency = 0.88 }) end)

	local busy = false
	Janitor:Connect(Run.MouseButton1Click, function()
		if busy then return end
		busy = true
		Run.Text = "..."
		setStatus("Running", C.Running)

		task.spawn(function()
			local ok, err = pcall(function()
				if typeof(loadstring) ~= "function" then
					error("loadstring is unavailable in this environment", 0)
				end
				local fn, compileError = loadstring(item.Source)
				if not fn then error(compileError, 0) end
				fn()
			end)

			if ok then
				setStatus("Executed", C.Success)
			else
				setStatus(tostring(err):sub(1, 60), C.Error)
			end
			Run.Text = "Run"

			task.wait(2)
			if Row.Parent then setStatus("Ready", C.Dim) end
			busy = false
		end)
	end)

	table.insert(Rows, { Frame = Row, Name = item.Name:lower() })
end

updateCount()

Janitor:Connect(Search:GetPropertyChangedSignal("Text"), function()
	local query = Search.Text:lower()
	for _, row in ipairs(Rows) do
		row.Frame.Visible = query == "" or row.Name:find(query, 1, true) ~= nil
	end
	updateCount()
end)

-- Minimize / restore / close --------------------------------------------------

local minimized = false

local function minimize()
	if minimized then return end
	minimized = true
	Main.Visible = false
	RestoreBtn.Visible = true
	tween(RestoreBtn, { Position = RESTORE_SHOWN }, 0.15)
end

local function restore()
	if not minimized then return end
	minimized = false
	RestoreBtn.Visible = false
	RestoreBtn.Position = RESTORE_HIDDEN
	Main.Visible = true
end

Janitor:Connect(MinimizeBtn.MouseButton1Click, minimize)
Janitor:Connect(RestoreBtn.MouseButton1Click, restore)
Janitor:Connect(CloseBtn.MouseButton1Click, function() Janitor:Clean() end)

-- Dragging --------------------------------------------------------------------

local dragging, dragStart, startPos = false, nil, nil

Janitor:Connect(Header.InputBegan, function(input)
	local t = input.UserInputType
	if t == Enum.UserInputType.MouseButton1 or t == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = Main.Position
	end
end)

Janitor:Connect(UserInputService.InputChanged, function(input)
	if not dragging then return end
	local t = input.UserInputType
	if t == Enum.UserInputType.MouseMovement or t == Enum.UserInputType.Touch then
		local d = input.Position - dragStart
		Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
	end
end)

Janitor:Connect(UserInputService.InputEnded, function(input)
	local t = input.UserInputType
	if t == Enum.UserInputType.MouseButton1 or t == Enum.UserInputType.Touch then
		dragging = false
	end
end)

-- Everything is built off-screen; parenting once keeps startup instant.
ScreenGui.Parent = TargetParent
