local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

---------------------------------------------------------
-- Tema Inspirado na Wind UI (Amarelo / Dark Glass)
---------------------------------------------------------
local Theme = {
	Accent = Color3.fromRGB(255, 190, 0),
	AccentDark = Color3.fromRGB(200, 145, 0),
	Background = Color3.fromRGB(15, 16, 20),
	Sidebar = Color3.fromRGB(20, 22, 28),
	Section = Color3.fromRGB(25, 28, 36),
	Element = Color3.fromRGB(33, 37, 48),
	ElementHover = Color3.fromRGB(42, 47, 60),
	Text = Color3.fromRGB(240, 242, 248),
	TextDark = Color3.fromRGB(140, 145, 165),
	Border = Color3.fromRGB(45, 50, 65)
}

local Library = {}
local tweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

-- ScreenGui Global para Notificações
local notifyScreenGui = playerGui:FindFirstChild("WindUiNotifications")
if not notifyScreenGui then
	notifyScreenGui = Instance.new("ScreenGui")
	notifyScreenGui.Name = "WindUiNotifications"
	notifyScreenGui.ResetOnSpawn = false
	notifyScreenGui.Parent = playerGui
end

local notifyHolder = notifyScreenGui:FindFirstChild("NotifyHolder")
if not notifyHolder then
	notifyHolder = Instance.new("Frame")
	notifyHolder.Name = "NotifyHolder"
	notifyHolder.Size = UDim2.new(0, 240, 1, -20)
	notifyHolder.Position = UDim2.new(1, -250, 0, 10)
	notifyHolder.BackgroundTransparency = 1
	notifyHolder.Parent = notifyScreenGui

	local notifyLayout = Instance.new("UIListLayout")
	notifyLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	notifyLayout.Padding = UDim.new(0, 8)
	notifyLayout.Parent = notifyHolder
end

---------------------------------------------------------
-- Sistema Global de Toast Notifications
---------------------------------------------------------
function Library:Notify(notifConfig)
	notifConfig = notifConfig or {}
	local nTitle = notifConfig.Title or "Notificação"
	local nDesc = notifConfig.Content or ""
	local duration = notifConfig.Duration or 3

	local toast = Instance.new("Frame")
	toast.Size = UDim2.new(1, 0, 0, 50)
	toast.BackgroundColor3 = Theme.Section
	toast.BackgroundTransparency = 1
	toast.Parent = notifyHolder

	local tCorner = Instance.new("UICorner")
	tCorner.CornerRadius = UDim.new(0, 8)
	tCorner.Parent = toast

	local tStroke = Instance.new("UIStroke")
	tStroke.Color = Theme.Accent
	tStroke.Thickness = 1
	tStroke.Transparency = 1
	tStroke.Parent = toast

	local tTitle = Instance.new("TextLabel")
	tTitle.Size = UDim2.new(1, -16, 0, 18)
	tTitle.Position = UDim2.new(0, 10, 0, 6)
	tTitle.BackgroundTransparency = 1
	tTitle.Font = Enum.Font.GothamBold
	tTitle.Text = nTitle
	tTitle.TextColor3 = Theme.Accent
	tTitle.TextSize = 12
	tTitle.TextXAlignment = Enum.TextXAlignment.Left
	tTitle.TextTransparency = 1
	tTitle.Parent = toast

	local tDesc = Instance.new("TextLabel")
	tDesc.Size = UDim2.new(1, -16, 0, 18)
	tDesc.Position = UDim2.new(0, 10, 0, 24)
	tDesc.BackgroundTransparency = 1
	tDesc.Font = Enum.Font.Gotham
	tDesc.Text = nDesc
	tDesc.TextColor3 = Theme.Text
	tDesc.TextSize = 11
	tDesc.TextXAlignment = Enum.TextXAlignment.Left
	tDesc.TextTransparency = 1
	tDesc.Parent = toast

	TweenService:Create(toast, tweenInfo, {BackgroundTransparency = 0}):Play()
	TweenService:Create(tStroke, tweenInfo, {Transparency = 0.5}):Play()
	TweenService:Create(tTitle, tweenInfo, {TextTransparency = 0}):Play()
	TweenService:Create(tDesc, tweenInfo, {TextTransparency = 0}):Play()

	task.delay(duration, function()
		local close = TweenService:Create(toast, tweenInfo, {BackgroundTransparency = 1})
		TweenService:Create(tStroke, tweenInfo, {Transparency = 1}):Play()
		TweenService:Create(tTitle, tweenInfo, {TextTransparency = 1}):Play()
		TweenService:Create(tDesc, tweenInfo, {TextTransparency = 1}):Play()
		close:Play()
		close.Completed:Connect(function()
			toast:Destroy()
		end)
	end)
end

---------------------------------------------------------
-- Função Principal de Criar Janela
---------------------------------------------------------
function Library:CreateWindow(config)
	config = config or {}
	local title = config.Title or "URBAN UI"
	local subTitle = config.SubTitle or "v2.0 Premium"
	local windowIcon = config.Icon or "rbxassetid://80788381547970"
	local floatIconId = config.FloatIcon or "rbxassetid://80788381547970"
	
	-- Tamanho personalizável da imagem interna do botão flutuante
	local floatIconSize = config.FloatIconSize or 32 
	
	local MAIN_SIZE = config.Size or UDim2.new(0, 540, 0, 360)

	-- Container de Gui
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "UrbanUiLibrary"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = playerGui

	-- Efeito de Blur
	local blur = Instance.new("BlurEffect")
	blur.Name = "UrbanBlur"
	blur.Size = 0
	blur.Parent = Lighting

	-- Frame Principal
	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainFrame"
	mainFrame.Size = MAIN_SIZE
	mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	mainFrame.BackgroundColor3 = Theme.Background
	mainFrame.BorderSizePixel = 0
	mainFrame.ClipsDescendants = true
	mainFrame.Parent = screenGui

	local mainCorner = Instance.new("UICorner")
	mainCorner.CornerRadius = UDim.new(0, 14)
	mainCorner.Parent = mainFrame

	local mainStroke = Instance.new("UIStroke")
	mainStroke.Color = Theme.Border
	mainStroke.Thickness = 1
	mainStroke.Parent = mainFrame

	---------------------------------------------------------
	-- Drag & Resize
	---------------------------------------------------------
	local dragging, dragStart, startPos
	mainFrame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = mainFrame.Position
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	-- Alça de Redimensionamento no Canto Inferior Direito
	local resizeGrip = Instance.new("Frame")
	resizeGrip.Name = "ResizeGrip"
	resizeGrip.Size = UDim2.new(0, 16, 0, 16)
	resizeGrip.Position = UDim2.new(1, -16, 1, -16)
	resizeGrip.BackgroundTransparency = 1
	resizeGrip.ZIndex = 10
	resizeGrip.Parent = mainFrame

	local gripIcon = Instance.new("TextLabel")
	gripIcon.Size = UDim2.new(1, 0, 1, 0)
	gripIcon.BackgroundTransparency = 1
	gripIcon.Font = Enum.Font.GothamBold
	gripIcon.Text = "◢"
	gripIcon.TextColor3 = Theme.Accent
	gripIcon.TextSize = 12
	gripIcon.ZIndex = 10
	gripIcon.Parent = resizeGrip

	local resizing, resizeStart, startSize
	resizeGrip.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			resizing = true
			resizeStart = input.Position
			startSize = mainFrame.Size
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - resizeStart
			local newX = math.max(420, startSize.X.Offset + delta.X)
			local newY = math.max(280, startSize.Y.Offset + delta.Y)
			mainFrame.Size = UDim2.new(0, newX, 0, newY)
			MAIN_SIZE = mainFrame.Size
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			resizing = false
		end
	end)

	---------------------------------------------------------
	-- Sidebar (Lateral) Header, Pesquisa & Perfil do Player
	---------------------------------------------------------
	local sidebar = Instance.new("Frame")
	sidebar.Name = "Sidebar"
	sidebar.Size = UDim2.new(0, 160, 1, 0)
	sidebar.BackgroundColor3 = Theme.Sidebar
	sidebar.BorderSizePixel = 0
	sidebar.Parent = mainFrame

	local sideCorner = Instance.new("UICorner")
	sideCorner.CornerRadius = UDim.new(0, 14)
	sideCorner.Parent = sidebar

	local sideFix = Instance.new("Frame")
	sideFix.Size = UDim2.new(0, 10, 1, 0)
	sideFix.Position = UDim2.new(1, -10, 0, 0)
	sideFix.BackgroundColor3 = Theme.Sidebar
	sideFix.BorderSizePixel = 0
	sideFix.Parent = sidebar

	-- Ícone da UI (Esquerda do Título)
	local titleIcon = Instance.new("ImageLabel")
	titleIcon.Name = "TitleIcon"
	titleIcon.Size = UDim2.new(0, 20, 0, 20)
	titleIcon.Position = UDim2.new(0, 12, 0, 14)
	titleIcon.BackgroundTransparency = 1
	titleIcon.Image = windowIcon
	titleIcon.ImageColor3 = Theme.Accent
	titleIcon.Parent = sidebar

	-- Logo / Título
	local logoTitle = Instance.new("TextLabel")
	logoTitle.Size = UDim2.new(1, -42, 0, 18)
	logoTitle.Position = UDim2.new(0, 38, 0, 12)
	logoTitle.BackgroundTransparency = 1
	logoTitle.Font = Enum.Font.GothamBold
	logoTitle.Text = title
	logoTitle.TextColor3 = Theme.Accent
	logoTitle.TextSize = 13
	logoTitle.TextXAlignment = Enum.TextXAlignment.Left
	logoTitle.Parent = sidebar

	local logoSub = Instance.new("TextLabel")
	logoSub.Size = UDim2.new(1, -42, 0, 12)
	logoSub.Position = UDim2.new(0, 38, 0, 28)
	logoSub.BackgroundTransparency = 1
	logoSub.Font = Enum.Font.Gotham
	logoSub.Text = subTitle
	logoSub.TextColor3 = Theme.TextDark
	logoSub.TextSize = 9
	logoSub.TextXAlignment = Enum.TextXAlignment.Left
	logoSub.Parent = sidebar

	-- Barra de Pesquisa de Abas
	local searchFrame = Instance.new("Frame")
	searchFrame.Name = "SearchFrame"
	searchFrame.Size = UDim2.new(1, -16, 0, 24)
	searchFrame.Position = UDim2.new(0, 8, 0, 48)
	searchFrame.BackgroundColor3 = Theme.Section
	searchFrame.Parent = sidebar

	local searchCorner = Instance.new("UICorner")
	searchCorner.CornerRadius = UDim.new(0, 6)
	searchCorner.Parent = searchFrame

	local searchBox = Instance.new("TextBox")
	searchBox.Size = UDim2.new(1, -12, 1, 0)
	searchBox.Position = UDim2.new(0, 6, 0, 0)
	searchBox.BackgroundTransparency = 1
	searchBox.Font = Enum.Font.Gotham
	searchBox.PlaceholderText = "Pesquisar aba..."
	searchBox.Text = ""
	searchBox.TextColor3 = Theme.Text
	searchBox.TextSize = 10
	searchBox.TextXAlignment = Enum.TextXAlignment.Left
	searchBox.Parent = searchFrame

	-- Container das Abas
	local tabHolder = Instance.new("ScrollingFrame")
	tabHolder.Size = UDim2.new(1, 0, 1, -126)
	tabHolder.Position = UDim2.new(0, 0, 0, 78)
	tabHolder.BackgroundTransparency = 1
	tabHolder.ScrollBarThickness = 0
	tabHolder.Parent = sidebar

	local tabList = Instance.new("UIListLayout")
	tabList.Padding = UDim.new(0, 4)
	tabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
	tabList.Parent = tabHolder

	---------------------------------------------------------
	-- Card de Perfil do Jogador (Embaixo da Sidebar)
	---------------------------------------------------------
	local playerCard = Instance.new("Frame")
	playerCard.Name = "PlayerCard"
	playerCard.Size = UDim2.new(1, -16, 0, 38)
	playerCard.Position = UDim2.new(0, 8, 1, -44)
	playerCard.BackgroundColor3 = Theme.Section
	playerCard.Parent = sidebar

	local cardCorner = Instance.new("UICorner")
	cardCorner.CornerRadius = UDim.new(0, 8)
	cardCorner.Parent = playerCard

	local playerAvatar = Instance.new("ImageLabel")
	playerAvatar.Size = UDim2.new(0, 26, 0, 26)
	playerAvatar.Position = UDim2.new(0, 6, 0.5, -13)
	playerAvatar.BackgroundTransparency = 1
	playerAvatar.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
	playerAvatar.Parent = playerCard

	local avatarCorner = Instance.new("UICorner")
	avatarCorner.CornerRadius = UDim.new(1, 0)
	avatarCorner.Parent = playerAvatar

	local pName = Instance.new("TextLabel")
	pName.Size = UDim2.new(1, -42, 0, 14)
	pName.Position = UDim2.new(0, 38, 0, 6)
	pName.BackgroundTransparency = 1
	pName.Font = Enum.Font.GothamBold
	pName.Text = player.DisplayName
	pName.TextColor3 = Theme.Text
	pName.TextSize = 10
	pName.TextXAlignment = Enum.TextXAlignment.Left
	pName.Parent = playerCard

	local pUser = Instance.new("TextLabel")
	pUser.Size = UDim2.new(1, -42, 0, 12)
	pUser.Position = UDim2.new(0, 38, 0, 20)
	pUser.BackgroundTransparency = 1
	pUser.Font = Enum.Font.Gotham
	pUser.Text = "@" .. player.Name
	pUser.TextColor3 = Theme.TextDark
	pUser.TextSize = 8
	pUser.TextXAlignment = Enum.TextXAlignment.Left
	pUser.Parent = playerCard

	---------------------------------------------------------
	-- TopBar & Container de Conteúdo
	---------------------------------------------------------
	local topBar = Instance.new("Frame")
	topBar.Name = "TopBar"
	topBar.Size = UDim2.new(1, -160, 0, 40)
	topBar.Position = UDim2.new(0, 160, 0, 0)
	topBar.BackgroundTransparency = 1
	topBar.Parent = mainFrame

	-- Botão Minimizar
	local minBtn = Instance.new("TextButton")
	minBtn.Size = UDim2.new(0, 26, 0, 26)
	minBtn.Position = UDim2.new(1, -60, 0, 8)
	minBtn.BackgroundColor3 = Theme.Section
	minBtn.Font = Enum.Font.GothamBold
	minBtn.Text = "—"
	minBtn.TextColor3 = Theme.Text
	minBtn.TextSize = 11
	minBtn.AutoButtonColor = false
	minBtn.Parent = topBar

	local minCorner = Instance.new("UICorner")
	minCorner.CornerRadius = UDim.new(0, 6)
	minCorner.Parent = minBtn

	-- Botão Fechar
	local closeBtn = Instance.new("TextButton")
	closeBtn.Size = UDim2.new(0, 26, 0, 26)
	closeBtn.Position = UDim2.new(1, -30, 0, 8)
	closeBtn.BackgroundColor3 = Theme.Section
	closeBtn.Font = Enum.Font.GothamBold
	closeBtn.Text = "✕"
	closeBtn.TextColor3 = Theme.Text
	closeBtn.TextSize = 11
	closeBtn.AutoButtonColor = false
	closeBtn.Parent = topBar

	local closeCorner = Instance.new("UICorner")
	closeCorner.CornerRadius = UDim.new(0, 6)
	closeCorner.Parent = closeBtn

	-- Container de Páginas
	local container = Instance.new("Frame")
	container.Name = "Container"
	container.Size = UDim2.new(1, -160, 1, -40)
	container.Position = UDim2.new(0, 160, 0, 40)
	container.BackgroundTransparency = 1
	container.Parent = mainFrame

	---------------------------------------------------------
	-- Botão Flutuante Redondo (Toggle Icon Customizável)
	---------------------------------------------------------
	local toggleButton = Instance.new("ImageButton")
	toggleButton.Size = UDim2.new(0, 50, 0, 50)
	toggleButton.Position = UDim2.new(0.05, 0, 0.8, 0)
	toggleButton.BackgroundColor3 = Theme.Background
	toggleButton.Parent = screenGui

	local floatCorner = Instance.new("UICorner")
	floatCorner.CornerRadius = UDim.new(1, 0)
	floatCorner.Parent = toggleButton

	local floatStroke = Instance.new("UIStroke")
	floatStroke.Color = Theme.Accent
	floatStroke.Thickness = 1.5
	floatStroke.Parent = toggleButton

	local floatIcon = Instance.new("ImageLabel")
	floatIcon.Size = UDim2.new(0, floatIconSize, 0, floatIconSize)
	floatIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
	floatIcon.AnchorPoint = Vector2.new(0.5, 0.5)
	floatIcon.BackgroundTransparency = 1
	floatIcon.Image = floatIconId
	floatIcon.ImageColor3 = Theme.Accent
	floatIcon.Parent = toggleButton

	-- Arrastar Botão Flutuante
	local floatDrag, floatStart, floatPosStart
	toggleButton.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			floatDrag = true
			floatStart = input.Position
			floatPosStart = toggleButton.Position
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if floatDrag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - floatStart
			toggleButton.Position = UDim2.new(floatPosStart.X.Scale, floatPosStart.X.Offset + delta.X, floatPosStart.Y.Scale, floatPosStart.Y.Offset + delta.Y)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			floatDrag = false
		end
	end)

	-- Lógica de Minimizar e Abrir
	local isOpen = true
	local function toggleUI()
		isOpen = not isOpen
		TweenService:Create(blur, tweenInfo, {Size = isOpen and 15 or 0}):Play()
		if isOpen then
			mainFrame.Visible = true
			TweenService:Create(mainFrame, tweenInfo, {Size = MAIN_SIZE, BackgroundTransparency = 0}):Play()
		else
			local tween = TweenService:Create(mainFrame, tweenInfo, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1})
			tween:Play()
			tween.Completed:Connect(function()
				if not isOpen then mainFrame.Visible = false end
			end)
		end
	end

	minBtn.MouseButton1Click:Connect(toggleUI)
	toggleButton.MouseButton1Click:Connect(toggleUI)

	closeBtn.MouseButton1Click:Connect(function()
		screenGui:Destroy()
		blur:Destroy()
	end)

	TweenService:Create(blur, tweenInfo, {Size = 15}):Play()

	---------------------------------------------------------
	-- API do Window, Diálogo e Tabs
	---------------------------------------------------------
	local WindowAPI = {}
	local tabs = {}

	-- Função de Janela de Diálogo / Modal
	function WindowAPI:Dialog(dialogConfig)
		dialogConfig = dialogConfig or {}
		local dTitle = dialogConfig.Title or "Confirmação"
		local dContent = dialogConfig.Content or "Tem certeza que deseja prosseguir?"
		local buttons = dialogConfig.Buttons or {
			{Title = "Confirmar", Callback = function() end},
			{Title = "Cancelar", Callback = function() end}
		}

		local overlay = Instance.new("Frame")
		overlay.Size = UDim2.new(1, 0, 1, 0)
		overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		overlay.BackgroundTransparency = 1
		overlay.ZIndex = 20
		overlay.Parent = mainFrame

		local dialogBox = Instance.new("Frame")
		dialogBox.Size = UDim2.new(0, 280, 0, 140)
		dialogBox.Position = UDim2.new(0.5, 0, 0.5, 0)
		dialogBox.AnchorPoint = Vector2.new(0.5, 0.5)
		dialogBox.BackgroundColor3 = Theme.Sidebar
		dialogBox.ZIndex = 21
		dialogBox.Parent = overlay

		local dCorner = Instance.new("UICorner")
		dCorner.CornerRadius = UDim.new(0, 10)
		dCorner.Parent = dialogBox

		local dStroke = Instance.new("UIStroke")
		dStroke.Color = Theme.Accent
		dStroke.Thickness = 1
		dStroke.Parent = dialogBox

		local titleLb = Instance.new("TextLabel")
		titleLb.Size = UDim2.new(1, -20, 0, 20)
		titleLb.Position = UDim2.new(0, 10, 0, 10)
		titleLb.BackgroundTransparency = 1
		titleLb.Font = Enum.Font.GothamBold
		titleLb.Text = dTitle
		titleLb.TextColor3 = Theme.Accent
		titleLb.TextSize = 12
		titleLb.ZIndex = 22
		titleLb.Parent = dialogBox

		local contentLb = Instance.new("TextLabel")
		contentLb.Size = UDim2.new(1, -20, 0, 40)
		contentLb.Position = UDim2.new(0, 10, 0, 32)
		contentLb.BackgroundTransparency = 1
		contentLb.Font = Enum.Font.Gotham
		contentLb.Text = dContent
		contentLb.TextColor3 = Theme.Text
		contentLb.TextSize = 10
		contentLb.TextWrapped = true
		contentLb.ZIndex = 22
		contentLb.Parent = dialogBox

		local btnContainer = Instance.new("Frame")
		btnContainer.Size = UDim2.new(1, -20, 0, 30)
		btnContainer.Position = UDim2.new(0, 10, 1, -40)
		btnContainer.BackgroundTransparency = 1
		btnContainer.ZIndex = 22
		btnContainer.Parent = dialogBox

		local btnLayout = Instance.new("UIListLayout")
		btnLayout.FillDirection = Enum.FillDirection.Horizontal
		btnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
		btnLayout.Padding = UDim.new(0, 8)
		btnLayout.Parent = btnContainer

		TweenService:Create(overlay, tweenInfo, {BackgroundTransparency = 0.5}):Play()

		for _, btnData in ipairs(buttons) do
			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(0, 80, 1, 0)
			btn.BackgroundColor3 = Theme.Element
			btn.Font = Enum.Font.GothamMedium
			btn.Text = btnData.Title
			btn.TextColor3 = Theme.Text
			btn.TextSize = 10
			btn.ZIndex = 23
			btn.Parent = btnContainer

			local bCorner = Instance.new("UICorner")
			bCorner.CornerRadius = UDim.new(0, 6)
			bCorner.Parent = btn

			btn.MouseButton1Click:Connect(function()
				TweenService:Create(overlay, tweenInfo, {BackgroundTransparency = 1}):Play()
				task.wait(0.2)
				overlay:Destroy()
				if btnData.Callback then btnData.Callback() end
			end)
		end
	end

	-- Lógica da Barra de Pesquisa de Abas
	searchBox:GetPropertyChangedSignal("Text"):Connect(function()
		local text = searchBox.Text:lower()
		for _, tab in ipairs(tabs) do
			if text == "" or tab.Name:lower():find(text) then
				tab.Button.Visible = true
			else
				tab.Button.Visible = false
			end
		end
	end)

	function WindowAPI:CreateTab(tabName)
		local tabBtn = Instance.new("TextButton")
		tabBtn.Size = UDim2.new(1, -16, 0, 30)
		tabBtn.BackgroundColor3 = Theme.Section
		tabBtn.BackgroundTransparency = 1
		tabBtn.Font = Enum.Font.GothamMedium
		tabBtn.Text = " " .. tabName
		tabBtn.TextColor3 = Theme.TextDark
		tabBtn.TextSize = 11
		tabBtn.TextXAlignment = Enum.TextXAlignment.Left
		tabBtn.AutoButtonColor = false
		tabBtn.Parent = tabHolder

		local tabCorner = Instance.new("UICorner")
		tabCorner.CornerRadius = UDim.new(0, 6)
		tabCorner.Parent = tabBtn

		local page = Instance.new("ScrollingFrame")
		page.Size = UDim2.new(1, -16, 1, -10)
		page.Position = UDim2.new(0, 8, 0, 0)
		page.BackgroundTransparency = 1
		page.ScrollBarThickness = 2
		page.ScrollBarImageColor3 = Theme.Accent
		page.Visible = false
		page.Parent = container

		local pageLayout = Instance.new("UIListLayout")
		pageLayout.Padding = UDim.new(0, 8)
		pageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		pageLayout.Parent = page

		pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			page.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y + 15)
		end)

		local function selectTab()
			for _, t in pairs(tabs) do
				t.Page.Visible = false
				TweenService:Create(t.Button, TweenInfo.new(0.2), {BackgroundTransparency = 1, TextColor3 = Theme.TextDark}):Play()
			end
			page.Visible = true
			TweenService:Create(tabBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0, TextColor3 = Theme.Accent}):Play()
		end

		tabBtn.MouseButton1Click:Connect(selectTab)
		table.insert(tabs, {Name = tabName, Button = tabBtn, Page = page})

		if #tabs == 1 then selectTab() end

		---------------------------------------------------------
		-- API de Seções e Elementos
		---------------------------------------------------------
		local TabAPI = {}

		function TabAPI:AddSection(sectionTitle)
			local sectionFrame = Instance.new("Frame")
			sectionFrame.Size = UDim2.new(1, 0, 0, 30)
			sectionFrame.BackgroundColor3 = Theme.Section
			sectionFrame.Parent = page

			local secCorner = Instance.new("UICorner")
			secCorner.CornerRadius = UDim.new(0, 8)
			secCorner.Parent = sectionFrame

			local secStroke = Instance.new("UIStroke")
			secStroke.Color = Theme.Border
			secStroke.Thickness = 1
			secStroke.Parent = sectionFrame

			local secTitle = Instance.new("TextLabel")
			secTitle.Size = UDim2.new(1, -20, 0, 24)
			secTitle.Position = UDim2.new(0, 10, 0, 4)
			secTitle.BackgroundTransparency = 1
			secTitle.Font = Enum.Font.GothamBold
			secTitle.Text = sectionTitle
			secTitle.TextColor3 = Theme.Accent
			secTitle.TextSize = 11
			secTitle.TextXAlignment = Enum.TextXAlignment.Left
			secTitle.Parent = sectionFrame

			local secContainer = Instance.new("Frame")
			secContainer.Size = UDim2.new(1, -16, 1, -30)
			secContainer.Position = UDim2.new(0, 8, 0, 28)
			secContainer.BackgroundTransparency = 1
			secContainer.Parent = sectionFrame

			local secLayout = Instance.new("UIListLayout")
			secLayout.Padding = UDim.new(0, 6)
			secLayout.Parent = secContainer

			local function updateSecSize()
				sectionFrame.Size = UDim2.new(1, 0, 0, secLayout.AbsoluteContentSize.Y + 34)
			end
			secLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateSecSize)

			local SectionAPI = {}

			function SectionAPI:AddButton(text, callback)
				callback = callback or function() end
				local btn = Instance.new("TextButton")
				btn.Size = UDim2.new(1, 0, 0, 30)
				btn.BackgroundColor3 = Theme.Element
				btn.Font = Enum.Font.GothamMedium
				btn.Text = text
				btn.TextColor3 = Theme.Text
				btn.TextSize = 11
				btn.AutoButtonColor = false
				btn.Parent = secContainer

				local corner = Instance.new("UICorner")
				corner.CornerRadius = UDim.new(0, 6)
				corner.Parent = btn

				btn.MouseButton1Click:Connect(function()
					TweenService:Create(btn, TweenInfo.new(0.08), {BackgroundColor3 = Theme.AccentDark}):Play()
					task.wait(0.08)
					TweenService:Create(btn, TweenInfo.new(0.08), {BackgroundColor3 = Theme.Element}):Play()
					callback()
				end)
			end

			function SectionAPI:AddToggle(text, default, callback)
				callback = callback or function() end
				local toggled = default or false

				local frame = Instance.new("Frame")
				frame.Size = UDim2.new(1, 0, 0, 30)
				frame.BackgroundColor3 = Theme.Element
				frame.Parent = secContainer

				local corner = Instance.new("UICorner")
				corner.CornerRadius = UDim.new(0, 6)
				corner.Parent = frame

				local label = Instance.new("TextLabel")
				label.Size = UDim2.new(1, -50, 1, 0)
				label.Position = UDim2.new(0, 10, 0, 0)
				label.BackgroundTransparency = 1
				label.Font = Enum.Font.GothamMedium
				label.Text = text
				label.TextColor3 = Theme.Text
				label.TextSize = 11
				label.TextXAlignment = Enum.TextXAlignment.Left
				label.Parent = frame

				local switch = Instance.new("TextButton")
				switch.Size = UDim2.new(0, 34, 0, 18)
				switch.Position = UDim2.new(1, -40, 0.5, -9)
				switch.BackgroundColor3 = toggled and Theme.Accent or Theme.Border
				switch.Text = ""
				switch.AutoButtonColor = false
				switch.Parent = frame

				local swCorner = Instance.new("UICorner")
				swCorner.CornerRadius = UDim.new(1, 0)
				swCorner.Parent = switch

				local dot = Instance.new("Frame")
				dot.Size = UDim2.new(0, 14, 0, 14)
				dot.Position = toggled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
				dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				dot.Parent = switch

				local dotCorner = Instance.new("UICorner")
				dotCorner.CornerRadius = UDim.new(1, 0)
				dotCorner.Parent = dot

				switch.MouseButton1Click:Connect(function()
					toggled = not toggled
					TweenService:Create(switch, TweenInfo.new(0.2), {BackgroundColor3 = toggled and Theme.Accent or Theme.Border}):Play()
					TweenService:Create(dot, TweenInfo.new(0.2), {Position = toggled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)}):Play()
					callback(toggled)
				end)
			end

			function SectionAPI:AddSlider(text, min, max, default, callback)
				callback = callback or function() end
				local val = math.clamp(default or min, min, max)

				local frame = Instance.new("Frame")
				frame.Size = UDim2.new(1, 0, 0, 38)
				frame.BackgroundColor3 = Theme.Element
				frame.Parent = secContainer

				local corner = Instance.new("UICorner")
				corner.CornerRadius = UDim.new(0, 6)
				corner.Parent = frame

				local label = Instance.new("TextLabel")
				label.Size = UDim2.new(1, -50, 0, 18)
				label.Position = UDim2.new(0, 10, 0, 2)
				label.BackgroundTransparency = 1
				label.Font = Enum.Font.GothamMedium
				label.Text = text
				label.TextColor3 = Theme.Text
				label.TextSize = 11
				label.TextXAlignment = Enum.TextXAlignment.Left
				label.Parent = frame

				local valLabel = Instance.new("TextLabel")
				valLabel.Size = UDim2.new(0, 40, 0, 18)
				valLabel.Position = UDim2.new(1, -48, 0, 2)
				valLabel.BackgroundTransparency = 1
				valLabel.Font = Enum.Font.GothamBold
				valLabel.Text = tostring(val)
				valLabel.TextColor3 = Theme.Accent
				valLabel.TextSize = 10
				valLabel.TextXAlignment = Enum.TextXAlignment.Right
				valLabel.Parent = frame

				local track = Instance.new("TextButton")
				track.Size = UDim2.new(1, -20, 0, 4)
				track.Position = UDim2.new(0, 10, 0, 26)
				track.BackgroundColor3 = Theme.Border
				track.Text = ""
				track.AutoButtonColor = false
				track.Parent = frame

				local trCorner = Instance.new("UICorner")
				trCorner.CornerRadius = UDim.new(1, 0)
				trCorner.Parent = track

				local fill = Instance.new("Frame")
				fill.Size = UDim2.new((val - min)/(max - min), 0, 1, 0)
				fill.BackgroundColor3 = Theme.Accent
				fill.Parent = track

				local fillCorner = Instance.new("UICorner")
				fillCorner.CornerRadius = UDim.new(1, 0)
				fillCorner.Parent = fill

				local sliding = false
				local function update(input)
					local percent = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
					val = math.floor(min + (max - min) * percent)
					fill.Size = UDim2.new(percent, 0, 1, 0)
					valLabel.Text = tostring(val)
					callback(val)
				end

				track.InputBegan:Connect(function(inp)
					if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
						sliding = true
						update(inp)
					end
				end)

				UserInputService.InputEnded:Connect(function(inp)
					if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then sliding = false end
				end)

				UserInputService.InputChanged:Connect(function(inp)
					if sliding and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then update(inp) end
				end)
			end

			function SectionAPI:AddTextBox(text, placeholder, callback)
				callback = callback or function() end

				local frame = Instance.new("Frame")
				frame.Size = UDim2.new(1, 0, 0, 30)
				frame.BackgroundColor3 = Theme.Element
				frame.Parent = secContainer

				local corner = Instance.new("UICorner")
				corner.CornerRadius = UDim.new(0, 6)
				corner.Parent = frame

				local label = Instance.new("TextLabel")
				label.Size = UDim2.new(0.5, 0, 1, 0)
				label.Position = UDim2.new(0, 10, 0, 0)
				label.BackgroundTransparency = 1
				label.Font = Enum.Font.GothamMedium
				label.Text = text
				label.TextColor3 = Theme.Text
				label.TextSize = 11
				label.TextXAlignment = Enum.TextXAlignment.Left
				label.Parent = frame

				local box = Instance.new("TextBox")
				box.Size = UDim2.new(0.45, -10, 0, 20)
				box.Position = UDim2.new(0.55, 0, 0.5, -10)
				box.BackgroundColor3 = Theme.Background
				box.Font = Enum.Font.Gotham
				box.PlaceholderText = placeholder or "Digite..."
				box.Text = ""
				box.TextColor3 = Theme.Text
				box.TextSize = 10
				box.Parent = frame

				local boxCorner = Instance.new("UICorner")
				boxCorner.CornerRadius = UDim.new(0, 4)
				boxCorner.Parent = box

				box.FocusLost:Connect(function(enter)
					if enter then callback(box.Text) end
				end)
			end

			function SectionAPI:AddDropdown(text, list, callback)
				callback = callback or function() end
				local opened = false

				local frame = Instance.new("Frame")
				frame.Size = UDim2.new(1, 0, 0, 30)
				frame.BackgroundColor3 = Theme.Element
				frame.ClipsDescendants = true
				frame.Parent = secContainer

				local corner = Instance.new("UICorner")
				corner.CornerRadius = UDim.new(0, 6)
				corner.Parent = frame

				local label = Instance.new("TextLabel")
				label.Size = UDim2.new(1, -40, 0, 30)
				label.Position = UDim2.new(0, 10, 0, 0)
				label.BackgroundTransparency = 1
				label.Font = Enum.Font.GothamMedium
				label.Text = text .. ": " .. (list[1] or "Nenhum")
				label.TextColor3 = Theme.Text
				label.TextSize = 11
				label.TextXAlignment = Enum.TextXAlignment.Left
				label.Parent = frame

				local arrow = Instance.new("TextButton")
				arrow.Size = UDim2.new(0, 30, 0, 30)
				arrow.Position = UDim2.new(1, -30, 0, 0)
				arrow.BackgroundTransparency = 1
				arrow.Font = Enum.Font.GothamBold
				arrow.Text = "▼"
				arrow.TextColor3 = Theme.Accent
				arrow.TextSize = 9
				arrow.Parent = frame

				local dropHolder = Instance.new("Frame")
				dropHolder.Size = UDim2.new(1, -16, 0, 0)
				dropHolder.Position = UDim2.new(0, 8, 0, 30)
				dropHolder.BackgroundTransparency = 1
				dropHolder.Parent = frame

				local dropLayout = Instance.new("UIListLayout")
				dropLayout.Padding = UDim.new(0, 4)
				dropLayout.Parent = dropHolder

				for _, item in ipairs(list) do
					local itemBtn = Instance.new("TextButton")
					itemBtn.Size = UDim2.new(1, 0, 0, 22)
					itemBtn.BackgroundColor3 = Theme.Background
					itemBtn.Font = Enum.Font.Gotham
					itemBtn.Text = item
					itemBtn.TextColor3 = Theme.TextDark
					itemBtn.TextSize = 10
					itemBtn.Parent = dropHolder

					local itemCorner = Instance.new("UICorner")
					itemCorner.CornerRadius = UDim.new(0, 4)
					itemCorner.Parent = itemBtn

					itemBtn.MouseButton1Click:Connect(function()
						label.Text = text .. ": " .. item
						opened = false
						TweenService:Create(frame, tweenInfo, {Size = UDim2.new(1, 0, 0, 30)}):Play()
						arrow.Text = "▼"
						callback(item)
					end)
				end

				arrow.MouseButton1Click:Connect(function()
					opened = not opened
					local targetH = opened and (36 + dropLayout.AbsoluteContentSize.Y) or 30
					TweenService:Create(frame, tweenInfo, {Size = UDim2.new(1, 0, 0, targetH)}):Play()
					arrow.Text = opened and "▲" or "▼"
				end)
			end

			function SectionAPI:AddKeybind(text, defaultKey, callback)
				callback = callback or function() end
				local currKey = defaultKey or Enum.KeyCode.E

				local frame = Instance.new("Frame")
				frame.Size = UDim2.new(1, 0, 0, 30)
				frame.BackgroundColor3 = Theme.Element
				frame.Parent = secContainer

				local corner = Instance.new("UICorner")
				corner.CornerRadius = UDim.new(0, 6)
				corner.Parent = frame

				local label = Instance.new("TextLabel")
				label.Size = UDim2.new(1, -80, 1, 0)
				label.Position = UDim2.new(0, 10, 0, 0)
				label.BackgroundTransparency = 1
				label.Font = Enum.Font.GothamMedium
				label.Text = text
				label.TextColor3 = Theme.Text
				label.TextSize = 11
				label.TextXAlignment = Enum.TextXAlignment.Left
				label.Parent = frame

				local kBtn = Instance.new("TextButton")
				kBtn.Size = UDim2.new(0, 60, 0, 18)
				kBtn.Position = UDim2.new(1, -68, 0.5, -9)
				kBtn.BackgroundColor3 = Theme.Background
				kBtn.Font = Enum.Font.GothamBold
				kBtn.Text = currKey.Name
				kBtn.TextColor3 = Theme.Accent
				kBtn.TextSize = 9
				kBtn.Parent = frame

				local kCorner = Instance.new("UICorner")
				kCorner.CornerRadius = UDim.new(0, 4)
				kCorner.Parent = kBtn

				local listening = false
				kBtn.MouseButton1Click:Connect(function()
					listening = true
					kBtn.Text = "..."
				end)

				UserInputService.InputBegan:Connect(function(input, gpe)
					if listening and input.UserInputType == Enum.UserInputType.Keyboard then
						currKey = input.KeyCode
						kBtn.Text = currKey.Name
						listening = false
					elseif not gpe and input.KeyCode == currKey then
						callback(currKey)
					end
				end)
			end

			function SectionAPI:AddParagraph(titleText, contentText)
				local frame = Instance.new("Frame")
				frame.Size = UDim2.new(1, 0, 0, 46)
				frame.BackgroundColor3 = Theme.Element
				frame.Parent = secContainer

				local corner = Instance.new("UICorner")
				corner.CornerRadius = UDim.new(0, 6)
				corner.Parent = frame

				local pTitle = Instance.new("TextLabel")
				pTitle.Size = UDim2.new(1, -16, 0, 16)
				pTitle.Position = UDim2.new(0, 8, 0, 4)
				pTitle.BackgroundTransparency = 1
				pTitle.Font = Enum.Font.GothamBold
				pTitle.Text = titleText
				pTitle.TextColor3 = Theme.Accent
				pTitle.TextSize = 10
				pTitle.TextXAlignment = Enum.TextXAlignment.Left
				pTitle.Parent = frame

				local pDesc = Instance.new("TextLabel")
				pDesc.Size = UDim2.new(1, -16, 0, 22)
				pDesc.Position = UDim2.new(0, 8, 0, 20)
				pDesc.BackgroundTransparency = 1
				pDesc.Font = Enum.Font.Gotham
				pDesc.Text = contentText
				pDesc.TextColor3 = Theme.TextDark
				pDesc.TextSize = 9
				pDesc.TextWrapped = true
				pDesc.TextXAlignment = Enum.TextXAlignment.Left
				pDesc.Parent = frame
			end

			return SectionAPI
		end

		return TabAPI
	end

	return WindowAPI
end

return Library
