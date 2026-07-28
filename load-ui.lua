local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

---------------------------------------------------------
-- Paleta de Cores (Tema Amarelo Premium)
---------------------------------------------------------
local YELLOW_MAIN  = Color3.fromRGB(255, 200, 0)
local YELLOW_LIGHT = Color3.fromRGB(255, 225, 100)
local YELLOW_DARK  = Color3.fromRGB(180, 130, 0)
local BG_DARK      = Color3.fromRGB(18, 18, 22)
local BG_SIDEBAR   = Color3.fromRGB(13, 13, 16)
local ELEMENT_BG   = Color3.fromRGB(26, 26, 32)
local TEXT_MAIN    = Color3.fromRGB(245, 245, 250)
local TEXT_DARK    = Color3.fromRGB(160, 160, 175)

---------------------------------------------------------
-- Módulos da UI Library
---------------------------------------------------------
local Library = {}

function Library:CreateWindow(hubTitle)
	hubTitle = hubTitle or "URBAN HUB"
	
	-- 1. ScreenGui & Blur
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "UrbanHubGuiLibrary"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = playerGui

	local blur = Instance.new("BlurEffect")
	blur.Name = "HubBlur"
	blur.Size = 0
	blur.Parent = Lighting

	local tweenInfo = TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

	-- 2. Janela Principal
	local MAIN_SIZE = UDim2.new(0, 560, 0, 360)
	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainFrame"
	mainFrame.Size = MAIN_SIZE
	mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	mainFrame.BackgroundColor3 = BG_DARK
	mainFrame.BorderSizePixel = 0
	mainFrame.ClipsDescendants = true
	mainFrame.Parent = screenGui

	local mainCorner = Instance.new("UICorner")
	mainCorner.CornerRadius = UDim.new(0, 16)
	mainCorner.Parent = mainFrame

	local mainStroke = Instance.new("UIStroke")
	mainStroke.Color = YELLOW_MAIN
	mainStroke.Thickness = 1.5
	mainStroke.Transparency = 0.2
	mainStroke.Parent = mainFrame

	---------------------------------------------------------
	-- Sistema para Arrastar a Janela (Window Drag)
	---------------------------------------------------------
	local windowDragging, windowDragStart, windowStartPos
	local function makeWindowDraggable(frame)
		frame.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				windowDragging = true
				windowDragStart = input.Position
				windowStartPos = frame.Position
				
				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						windowDragging = false
					end
				end)
			end
		end)
		
		frame.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				if windowDragging then
					local delta = input.Position - windowDragStart
					frame.Position = UDim2.new(
						windowStartPos.X.Scale, windowStartPos.X.Offset + delta.X,
						windowStartPos.Y.Scale, windowStartPos.Y.Offset + delta.Y
					)
				end
			end
		end)
	end
	makeWindowDraggable(mainFrame)

	---------------------------------------------------------
	-- TopBar / Cabeçalho (Título, Minimizar '-' e Fechar 'X')
	---------------------------------------------------------
	local topBar = Instance.new("Frame")
	topBar.Name = "TopBar"
	topBar.Size = UDim2.new(1, 0, 0, 42)
	topBar.BackgroundColor3 = BG_SIDEBAR
	topBar.BorderSizePixel = 0
	topBar.Parent = mainFrame

	local topCorner = Instance.new("UICorner")
	topCorner.CornerRadius = UDim.new(0, 16)
	topCorner.Parent = topBar

	local topBarFix = Instance.new("Frame")
	topBarFix.Size = UDim2.new(1, 0, 0, 10)
	topBarFix.Position = UDim2.new(0, 0, 1, -10)
	topBarFix.BackgroundColor3 = BG_SIDEBAR
	topBarFix.BorderSizePixel = 0
	topBarFix.Parent = topBar

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "TitleLabel"
	titleLabel.Size = UDim2.new(1, -100, 1, 0)
	titleLabel.Position = UDim2.new(0, 16, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.Text = hubTitle
	titleLabel.TextColor3 = YELLOW_MAIN
	titleLabel.TextSize = 16
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Parent = topBar

	-- Botão Minimizar (-)
	local minimizeBtn = Instance.new("TextButton")
	minimizeBtn.Name = "MinimizeButton"
	minimizeBtn.Size = UDim2.new(0, 28, 0, 28)
	minimizeBtn.Position = UDim2.new(1, -68, 0, 7)
	minimizeBtn.BackgroundColor3 = ELEMENT_BG
	minimizeBtn.Font = Enum.Font.GothamBold
	minimizeBtn.Text = "—"
	minimizeBtn.TextColor3 = TEXT_MAIN
	minimizeBtn.TextSize = 12
	minimizeBtn.AutoButtonColor = false
	minimizeBtn.Parent = topBar

	local minCorner = Instance.new("UICorner")
	minCorner.CornerRadius = UDim.new(0, 8)
	minCorner.Parent = minimizeBtn

	-- Botão Fechar (X)
	local closeBtn = Instance.new("TextButton")
	closeBtn.Name = "CloseButton"
	closeBtn.Size = UDim2.new(0, 28, 0, 28)
	closeBtn.Position = UDim2.new(1, -34, 0, 7)
	closeBtn.BackgroundColor3 = ELEMENT_BG
	closeBtn.Font = Enum.Font.GothamBold
	closeBtn.Text = "✕"
	closeBtn.TextColor3 = TEXT_MAIN
	closeBtn.TextSize = 13
	closeBtn.AutoButtonColor = false
	closeBtn.Parent = topBar

	local closeCorner = Instance.new("UICorner")
	closeCorner.CornerRadius = UDim.new(0, 8)
	closeCorner.Parent = closeBtn

	---------------------------------------------------------
	-- Botão Flutuante Redondo (Toggle/Drag)
	---------------------------------------------------------
	local toggleButton = Instance.new("ImageButton")
	toggleButton.Name = "ToggleButton"
	toggleButton.Size = UDim2.new(0, 52, 0, 52)
	toggleButton.Position = UDim2.new(0.08, 0, 0.8, 0)
	toggleButton.BackgroundColor3 = BG_DARK
	toggleButton.AnchorPoint = Vector2.new(0.5, 0.5)
	toggleButton.Parent = screenGui

	local toggleCorner = Instance.new("UICorner")
	toggleCorner.CornerRadius = UDim.new(1, 0)
	toggleCorner.Parent = toggleButton

	local toggleStroke = Instance.new("UIStroke")
	toggleStroke.Color = YELLOW_MAIN
	toggleStroke.Thickness = 2
	toggleStroke.Transparency = 0.2
	toggleStroke.Parent = toggleButton

	local toggleIcon = Instance.new("ImageLabel")
	toggleIcon.Size = UDim2.new(0, 28, 0, 28)
	toggleIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
	toggleIcon.AnchorPoint = Vector2.new(0.5, 0.5)
	toggleIcon.BackgroundTransparency = 1
	toggleIcon.Image = "rbxassetid://80788381547970"
	toggleIcon.ScaleType = Enum.ScaleType.Fit
	toggleIcon.Parent = toggleButton

	-- Arrastar o Botão Redondo
	local floatDragging, floatDragStart, floatStartPos
	toggleButton.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			floatDragging = true
			floatDragStart = input.Position
			floatStartPos = toggleButton.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then floatDragging = false end
			end)
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if floatDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - floatDragStart
			toggleButton.Position = UDim2.new(floatStartPos.X.Scale, floatStartPos.X.Offset + delta.X, floatStartPos.Y.Scale, floatStartPos.Y.Offset + delta.Y)
		end
	end)

	---------------------------------------------------------
	-- Lógica de Minimizar, Restaurar e Fechar com Blur
	---------------------------------------------------------
	local isOpen = true
	local isClosingForever = false

	local function setBlur(state)
		TweenService:Create(blur, tweenInfo, {Size = state and 20 or 0}):Play()
	end

	local function minimize()
		if not isOpen or isClosingForever then return end
		isOpen = false
		setBlur(false)
		local tween = TweenService:Create(mainFrame, tweenInfo, {
			Size = UDim2.new(0, 0, 0, 0),
			Position = toggleButton.Position,
			BackgroundTransparency = 1
		})
		tween:Play()
		tween.Completed:Connect(function()
			if not isOpen then mainFrame.Visible = false end
		end)
	end

	local function restore()
		if isOpen or isClosingForever then return end
		isOpen = true
		mainFrame.Position = toggleButton.Position
		mainFrame.Size = UDim2.new(0, 0, 0, 0)
		mainFrame.Visible = true
		setBlur(true)
		TweenService:Create(mainFrame, tweenInfo, {
			Size = MAIN_SIZE,
			Position = UDim2.new(0.5, 0, 0.5, 0),
			BackgroundTransparency = 0
		}):Play()
	end

	local function closeForever()
		if isClosingForever then return end
		isClosingForever = true
		isOpen = false
		setBlur(false)
		
		local tween = TweenService:Create(mainFrame, tweenInfo, {
			Size = UDim2.new(0, 0, 0, 0),
			Position = toggleButton.Position,
			BackgroundTransparency = 1
		})
		tween:Play()
		tween.Completed:Connect(function()
			mainFrame.Visible = false
			local hideBtn = TweenService:Create(toggleButton, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
				Size = UDim2.new(0, 0, 0, 0),
				BackgroundTransparency = 1
			})
			hideBtn:Play()
			hideBtn.Completed:Connect(function()
				screenGui:Destroy()
				blur:Destroy()
			end)
		end)
	end

	minimizeBtn.MouseButton1Click:Connect(minimize)
	closeBtn.MouseButton1Click:Connect(closeForever)

	local floatClickTime = 0
	toggleButton.MouseButton1Down:Connect(function() floatClickTime = tick() end)
	toggleButton.MouseButton1Up:Connect(function()
		if tick() - floatClickTime < 0.25 then
			if isOpen then minimize() else restore() end
		end
	end)

	-- Entrada Inicial
	mainFrame.Size = UDim2.new(0, 0, 0, 0)
	setBlur(true)
	TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Size = MAIN_SIZE
	}):Play()

	---------------------------------------------------------
	-- Container de Abas (Tabs Lateral) e Conteúdo
	---------------------------------------------------------
	local sidebar = Instance.new("Frame")
	sidebar.Name = "Sidebar"
	sidebar.Size = UDim2.new(0, 140, 1, -42)
	sidebar.Position = UDim2.new(0, 0, 0, 42)
	sidebar.BackgroundColor3 = BG_SIDEBAR
	sidebar.BorderSizePixel = 0
	sidebar.Parent = mainFrame

	local tabListLayout = Instance.new("UIListLayout")
	tabListLayout.Padding = UDim.new(0, 6)
	tabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	tabListLayout.Parent = sidebar

	local tabPadding = Instance.new("UIPadding")
	tabPadding.PaddingTop = UDim.new(0, 10)
	tabPadding.Parent = sidebar

	local container = Instance.new("Frame")
	container.Name = "Container"
	container.Size = UDim2.new(1, -140, 1, -42)
	container.Position = UDim2.new(0, 140, 0, 42)
	container.BackgroundTransparency = 1
	container.Parent = mainFrame

	---------------------------------------------------------
	-- API da Janela / Abas
	---------------------------------------------------------
	local WindowAPI = {}
	local tabs = {}

	function WindowAPI:CreateTab(tabName)
		local tabButton = Instance.new("TextButton")
		tabButton.Name = tabName .. "Button"
		tabButton.Size = UDim2.new(1, -16, 0, 32)
		tabButton.BackgroundColor3 = ELEMENT_BG
		tabButton.BackgroundTransparency = 0.6
		tabButton.Font = Enum.Font.GothamMedium
		tabButton.Text = tabName
		tabButton.TextColor3 = TEXT_DARK
		tabButton.TextSize = 13
		tabButton.AutoButtonColor = false
		tabButton.Parent = sidebar

		local tabBtnCorner = Instance.new("UICorner")
		tabBtnCorner.CornerRadius = UDim.new(0, 8)
		tabBtnCorner.Parent = tabButton

		local tabContent = Instance.new("ScrollingFrame")
		tabContent.Name = tabName .. "Content"
		tabContent.Size = UDim2.new(1, 0, 1, 0)
		tabContent.BackgroundTransparency = 1
		tabContent.ScrollBarThickness = 3
		tabContent.ScrollBarImageColor3 = YELLOW_MAIN
		tabContent.Visible = false
		tabContent.Parent = container

		local contentLayout = Instance.new("UIListLayout")
		contentLayout.Padding = UDim.new(0, 8)
		contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
		contentLayout.Parent = tabContent

		local contentPadding = Instance.new("UIPadding")
		contentPadding.PaddingTop = UDim.new(0, 10)
		contentPadding.PaddingBottom = UDim.new(0, 10)
		contentPadding.Parent = tabContent

		contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			tabContent.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
		end)

		local function selectTab()
			for _, tab in pairs(tabs) do
				tab.Content.Visible = false
				TweenService:Create(tab.Button, TweenInfo.new(0.2), {
					BackgroundTransparency = 0.6,
					TextColor3 = TEXT_DARK,
					BackgroundColor3 = ELEMENT_BG
				}):Play()
			end
			tabContent.Visible = true
			TweenService:Create(tabButton, TweenInfo.new(0.2), {
				BackgroundTransparency = 0,
				TextColor3 = YELLOW_MAIN,
				BackgroundColor3 = ELEMENT_BG
			}):Play()
		end

		tabButton.MouseButton1Click:Connect(selectTab)
		table.insert(tabs, {Button = tabButton, Content = tabContent})

		if #tabs == 1 then selectTab() end

		---------------------------------------------------------
		-- API dos Elementos da Aba
		---------------------------------------------------------
		local TabAPI = {}

		-- Button
		function TabAPI:AddButton(text, callback)
			callback = callback or function() end
			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1, -24, 0, 36)
			btn.BackgroundColor3 = ELEMENT_BG
			btn.Font = Enum.Font.GothamMedium
			btn.Text = text
			btn.TextColor3 = TEXT_MAIN
			btn.TextSize = 13
			btn.AutoButtonColor = false
			btn.Parent = tabContent

			local corner = Instance.new("UICorner")
			corner.CornerRadius = UDim.new(0, 8)
			corner.Parent = btn

			local stroke = Instance.new("UIStroke")
			stroke.Color = YELLOW_MAIN
			stroke.Thickness = 1
			stroke.Transparency = 0.8
			stroke.Parent = btn

			btn.MouseEnter:Connect(function()
				TweenService:Create(stroke, TweenInfo.new(0.2), {Transparency = 0.2}):Play()
			end)
			btn.MouseLeave:Connect(function()
				TweenService:Create(stroke, TweenInfo.new(0.2), {Transparency = 0.8}):Play()
			end)
			btn.MouseButton1Click:Connect(function()
				TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(1, -28, 0, 34)}):Play()
				task.wait(0.1)
				TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(1, -24, 0, 36)}):Play()
				callback()
			end)
		end

		-- Toggle
		function TabAPI:AddToggle(text, default, callback)
			callback = callback or function() end
			local toggled = default or false

			local frame = Instance.new("Frame")
			frame.Size = UDim2.new(1, -24, 0, 38)
			frame.BackgroundColor3 = ELEMENT_BG
			frame.Parent = tabContent

			local corner = Instance.new("UICorner")
			corner.CornerRadius = UDim.new(0, 8)
			corner.Parent = frame

			local label = Instance.new("TextLabel")
			label.Size = UDim2.new(1, -60, 1, 0)
			label.Position = UDim2.new(0, 12, 0, 0)
			label.BackgroundTransparency = 1
			label.Font = Enum.Font.GothamMedium
			label.Text = text
			label.TextColor3 = TEXT_MAIN
			label.TextSize = 13
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.Parent = frame

			local switch = Instance.new("TextButton")
			switch.Size = UDim2.new(0, 40, 0, 20)
			switch.Position = UDim2.new(1, -50, 0.5, -10)
			switch.BackgroundColor3 = toggled and YELLOW_MAIN or Color3.fromRGB(45, 45, 55)
			switch.Text = ""
			switch.AutoButtonColor = false
			switch.Parent = frame

			local switchCorner = Instance.new("UICorner")
			switchCorner.CornerRadius = UDim.new(1, 0)
			switchCorner.Parent = switch

			local dot = Instance.new("Frame")
			dot.Size = UDim2.new(0, 16, 0, 16)
			dot.Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
			dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			dot.Parent = switch

			local dotCorner = Instance.new("UICorner")
			dotCorner.CornerRadius = UDim.new(1, 0)
			dotCorner.Parent = dot

			local function updateToggle()
				toggled = not toggled
				TweenService:Create(switch, TweenInfo.new(0.2), {
					BackgroundColor3 = toggled and YELLOW_MAIN or Color3.fromRGB(45, 45, 55)
				}):Play()
				TweenService:Create(dot, TweenInfo.new(0.2), {
					Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
				}):Play()
				callback(toggled)
			end

			switch.MouseButton1Click:Connect(updateToggle)
		end

		-- Slider
		function TabAPI:AddSlider(text, min, max, default, callback)
			callback = callback or function() end
			local value = math.clamp(default or min, min, max)

			local frame = Instance.new("Frame")
			frame.Size = UDim2.new(1, -24, 0, 48)
			frame.BackgroundColor3 = ELEMENT_BG
			frame.Parent = tabContent

			local corner = Instance.new("UICorner")
			corner.CornerRadius = UDim.new(0, 8)
			corner.Parent = frame

			local label = Instance.new("TextLabel")
			label.Size = UDim2.new(1, -60, 0, 22)
			label.Position = UDim2.new(0, 12, 0, 4)
			label.BackgroundTransparency = 1
			label.Font = Enum.Font.GothamMedium
			label.Text = text
			label.TextColor3 = TEXT_MAIN
			label.TextSize = 13
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.Parent = frame

			local valLabel = Instance.new("TextLabel")
			valLabel.Size = UDim2.new(0, 50, 0, 22)
			valLabel.Position = UDim2.new(1, -62, 0, 4)
			valLabel.BackgroundTransparency = 1
			valLabel.Font = Enum.Font.GothamBold
			valLabel.Text = tostring(value)
			valLabel.TextColor3 = YELLOW_MAIN
			valLabel.TextSize = 13
			valLabel.TextXAlignment = Enum.TextXAlignment.Right
			valLabel.Parent = frame

			local sliderTrack = Instance.new("TextButton")
			sliderTrack.Size = UDim2.new(1, -24, 0, 6)
			sliderTrack.Position = UDim2.new(0, 12, 0, 32)
			sliderTrack.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
			sliderTrack.Text = ""
			sliderTrack.AutoButtonColor = false
			sliderTrack.Parent = frame

			local trackCorner = Instance.new("UICorner")
			trackCorner.CornerRadius = UDim.new(1, 0)
			trackCorner.Parent = sliderTrack

			local sliderFill = Instance.new("Frame")
			sliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
			sliderFill.BackgroundColor3 = YELLOW_MAIN
			sliderFill.BorderSizePixel = 0
			sliderFill.Parent = sliderTrack

			local fillCorner = Instance.new("UICorner")
			fillCorner.CornerRadius = UDim.new(1, 0)
			fillCorner.Parent = sliderFill

			local sliding = false
			local function updateSlider(input)
				local percent = math.clamp((input.Position.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X, 0, 1)
				value = math.floor(min + (max - min) * percent)
				sliderFill.Size = UDim2.new(percent, 0, 1, 0)
				valLabel.Text = tostring(value)
				callback(value)
			end

			sliderTrack.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					sliding = true
					updateSlider(input)
				end
			end)

			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					sliding = false
				end
			end)

			UserInputService.InputChanged:Connect(function(input)
				if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
					updateSlider(input)
				end
			end)
		end

		-- Paragraph
		function TabAPI:AddParagraph(title, text)
			local frame = Instance.new("Frame")
			frame.Size = UDim2.new(1, -24, 0, 60)
			frame.BackgroundColor3 = ELEMENT_BG
			frame.Parent = tabContent

			local corner = Instance.new("UICorner")
			corner.CornerRadius = UDim.new(0, 8)
			corner.Parent = frame

			local pTitle = Instance.new("TextLabel")
			pTitle.Size = UDim2.new(1, -24, 0, 20)
			pTitle.Position = UDim2.new(0, 12, 0, 6)
			pTitle.BackgroundTransparency = 1
			pTitle.Font = Enum.Font.GothamBold
			pTitle.Text = title
			pTitle.TextColor3 = YELLOW_MAIN
			pTitle.TextSize = 13
			pTitle.TextXAlignment = Enum.TextXAlignment.Left
			pTitle.Parent = frame

			local pText = Instance.new("TextLabel")
			pText.Size = UDim2.new(1, -24, 0, 30)
			pText.Position = UDim2.new(0, 12, 0, 24)
			pText.BackgroundTransparency = 1
			pText.Font = Enum.Font.Gotham
			pText.Text = text
			pText.TextColor3 = TEXT_DARK
			pText.TextSize = 12
			pText.TextWrapped = true
			pText.TextXAlignment = Enum.TextXAlignment.Left
			pText.TextYAlignment = Enum.TextYAlignment.Top
			pText.Parent = frame
		end

		-- Keybind
		function TabAPI:AddKeybind(text, defaultKey, callback)
			callback = callback or function() end
			local currentKey = defaultKey or Enum.KeyCode.E

			local frame = Instance.new("Frame")
			frame.Size = UDim2.new(1, -24, 0, 38)
			frame.BackgroundColor3 = ELEMENT_BG
			frame.Parent = tabContent

			local corner = Instance.new("UICorner")
			corner.CornerRadius = UDim.new(0, 8)
			corner.Parent = frame

			local label = Instance.new("TextLabel")
			label.Size = UDim2.new(1, -100, 1, 0)
			label.Position = UDim2.new(0, 12, 0, 0)
			label.BackgroundTransparency = 1
			label.Font = Enum.Font.GothamMedium
			label.Text = text
			label.TextColor3 = TEXT_MAIN
			label.TextSize = 13
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.Parent = frame

			local bindBtn = Instance.new("TextButton")
			bindBtn.Size = UDim2.new(0, 75, 0, 24)
			bindBtn.Position = UDim2.new(1, -85, 0.5, -12)
			bindBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
			bindBtn.Font = Enum.Font.GothamBold
			bindBtn.Text = currentKey.Name
			bindBtn.TextColor3 = YELLOW_MAIN
			bindBtn.TextSize = 12
			bindBtn.Parent = frame

			local bindCorner = Instance.new("UICorner")
			bindCorner.CornerRadius = UDim.new(0, 6)
			bindCorner.Parent = bindBtn

			local listening = false
			bindBtn.MouseButton1Click:Connect(function()
				listening = true
				bindBtn.Text = "..."
			end)

			UserInputService.InputBegan:Connect(function(input, gameProcessed)
				if listening then
					if input.UserInputType == Enum.UserInputType.Keyboard then
						currentKey = input.KeyCode
						bindBtn.Text = currentKey.Name
						listening = false
					end
				elseif not gameProcessed and input.KeyCode == currentKey then
					callback(currentKey)
				end
			end)
		end

		return TabAPI
	end

	return WindowAPI
end

-- RETORNA A BIBLIOTECA PARA O LOADSTRING
return Library
