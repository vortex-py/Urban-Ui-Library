local WIND = loadstring(game:HttpGet("https://pastebin.com/raw/eD5xVjpf"))()

-- 1. Criar Janela Principal (Com a nova Tag amarela ao lado do título)
local Window = WIND:CreateWindow({
	Title = "URBAN HUB",
	SubTitle = "v2.5 Full Glass",
	Tag = "BETA", -- Tag amarela do lado do título
	Size = UDim2.new(0, 520, 0, 350),
	Icon = "rbxassetid://80788381547970",
	FloatIcon = "rbxassetid://80788381547970",
	FloatIconSize = 36 -- Aumenta o tamanho do ícone interno no botão redondo flutuante
})

-- Notificação de Boas-Vindas
WIND:Notify({
	Title = "Urban UI V2.5",
	Content = "Pesquisa, Diálogo e Perfil ativos!",
	Duration = 4
})

-- 2. Criar Abas
local MainTab = Window:CreateTab("Principal")
local CombatTab = Window:CreateTab("Combate")
local SettingsTab = Window:CreateTab("Ajustes")
local NewTab = Window:CreateTab("Recursos Novos") -- Nova Aba Criada

---------------------------------------------------------
-- ABA 1: PRINCIPAL (Testando o Diálogo)
---------------------------------------------------------
local SecDialog = MainTab:AddSection("Sistema de Diálogo")

SecDialog:AddButton("Testar Janela de Diálogo", function()
	Window:Dialog({
		Title = "Confirmar Ação",
		Content = "Deseja realmente ativar o Auto Farm com as configurações atuais?",
		Buttons = {
			{
				Title = "Confirmar",
				Callback = function()
					WIND:Notify({
						Title = "Sucesso!",
						Content = "Auto Farm iniciado com sucesso.",
						Duration = 3
					})
				end
			},
			{
				Title = "Cancelar",
				Callback = function()
					WIND:Notify({
						Title = "Cancelado",
						Content = "Ação de início cancelada.",
						Duration = 3
					})
				end
			}
		}
	})
end)

SecDialog:AddToggle("Ativar Auto Farm", false, function(state)
	print("Auto Farm:", state)
end)

---------------------------------------------------------
-- ABA 2: COMBATE
---------------------------------------------------------
local SecAimbot = CombatTab:AddSection("Aimbot & Keybinds")

SecAimbot:AddToggle("Ativar Lock", false, function(state)
	print("Lock:", state)
end)

SecAimbot:AddKeybind("Tecla de Ativação", Enum.KeyCode.E, function(key)
	print("Tecla pressionada:", key.Name)
end)

---------------------------------------------------------
-- ABA 3: AJUSTES
---------------------------------------------------------
local SecInfo = SettingsTab:AddSection("Recursos Ativos")

SecInfo:AddParagraph("O que há de novo?", "• Barra de Pesquisa no topo do menu lateral para filtrar abas.\n• Foto e nome do seu jogador exibidos na base da UI.\n• Tamanho do ícone no botão redondo flutuante configurado para 36px.")

SecInfo:AddSlider("Velocidade de Movimento", 16, 200, 16, function(value)
	local char = game.Players.LocalPlayer.Character
	if char and char:FindFirstChild("Humanoid") then
		char.Humanoid.WalkSpeed = value
	end
end)

---------------------------------------------------------
-- ABA 4: RECURSOS NOVOS (Demonstração das novas funções)
---------------------------------------------------------
local SecControl = NewTab:AddSection("Controle da UI")

-- Botão para Minimizar a Gui via script
SecControl:AddButton("Minimizar GUI", function()
	Window:Minimize()
end)

-- Botão para Destruir a Gui via script
SecControl:AddButton("Destruir GUI", function()
	Window:Destroy()
end)

local SecParagraph = NewTab:AddSection("Parágrafo Dinâmico & Servidor")

-- Parágrafo que muda texto e título via script (Modo Teste)
local DemoParagraph = SecParagraph:AddParagraph("Título Inicial", "Clique no botão abaixo para testar a alteração do texto!")

SecParagraph:AddButton("Mudar Texto do Parágrafo", function()
	DemoParagraph:Set("Título Alterado!", "O texto e o título do parágrafo foram atualizados com sucesso.")
end)

-- Parágrafo contador de segundos do servidor
local ServerTimeParagraph = SecParagraph:AddParagraph("Tempo de Servidor", "Carregando tempo...")

task.spawn(function()
	while task.wait(1) do
		local uptime = math.floor(workspace.DistributedGameTime)
		ServerTimeParagraph:Set("Tempo do Servidor", "O servidor está online há: " .. tostring(uptime) .. " segundos.")
	end
end)
