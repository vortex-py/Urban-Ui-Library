-- ========================================================
-- URBAN UI LIBRARY v2.5 - EXEMPLO CORRIGIDO E FUNCIONAL
-- Desenvolvido por: vortex_py
-- ========================================================

-- 1. CARREGAR A BIBLIOTECA
local WIND = loadstring(game:HttpGet("https://raw.githubusercontent.com/vortex-py/Urban-Ui-Library/refs/heads/main/load-ui.lua"))()

-- 2. NOTIFICAÇÃO DE INÍCIO
WIND:Notify({
    Title = "Urban UI",
    Content = "Interface e Abas carregadas com sucesso!",
    Duration = 4
})

-- 3. CRIAR A JANELA PRINCIPAL
local Window = WIND:CreateWindow({
    Title = "URBAN HUB",
    SubTitle = "v2.5 Release • Todos os Elementos",
    Size = UDim2.new(0, 520, 0, 380),
    Icon = "rbxassetid://80788381547970",
    FloatIcon = "rbxassetid://80788381547970",
    FloatIconSize = 36
})

-- ========================================================
-- 1ª ABA: PRINCIPAL (Com Seção e Elementos)
-- ========================================================
local MainTab = Window:CreateTab("Principal")
local SecMain = MainTab:AddSection("Controles Gerais")

-- Parágrafo
SecMain:AddParagraph("Status do Hub", "Seja bem-vindo ao Urban Hub! Todos os recursos estão ativos.")

-- Botão Simples
SecMain:AddButton("Teleportar ao Spawn", function()
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(0, 10, 0)
        WIND:Notify({ Title = "Teleporte", Content = "Enviado ao Spawn!", Duration = 2 })
    end
end)

-- Toggle / Chave Liga/Desliga
local AutoFarm = SecMain:AddToggle("Auto Farm", false, function(state)
    print("Auto Farm status:", state)
end)

-- Slider / Controle Numérico
local SpeedSlider = SecMain:AddSlider("Velocidade do Personagem", 16, 200, 16, function(value)
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = value
    end
end)


-- ========================================================
-- 2ª ABA: SELEÇÕES E OPÇÕES
-- ========================================================
local OptionsTab = Window:CreateTab("Opções")
local SecOptions = OptionsTab:AddSection("Entradas e Seleções")

-- Dropdown Simples
SecOptions:AddDropdown("Selecionar Modo", {"Modo Seguro", "Modo Rápido", "Modo Turbo"}, function(selected)
    print("Modo escolhido:", selected)
end)

-- Multi-Dropdown
SecOptions:AddMultiDropdown("Alvos Automaticos", {"Monstros", "Players", "Bosses"}, {"Monstros"}, function(selectedTable)
    print("Alvos selecionados:")
    for option, state in pairs(selectedTable) do
        print(option, state)
    end
end)

-- Caixa de Texto / Input
SecOptions:AddTextBox("Nome do Jogador", "Digite o nome...", function(text)
    print("Texto inserido:", text)
end)

-- ColorPicker / Seletor de Cor
SecOptions:AddColorPicker("Cor do Efeito", Color3.fromRGB(99, 102, 241), function(color)
    print("Cor alterada:", color)
end)

-- Keybind / Tecla de Atalho
SecOptions:AddKeybind("Atalho de Ação", Enum.KeyCode.E, function(key)
    print("Tecla pressionada:", key.Name)
end)


-- ========================================================
-- 3ª ABA: SISTEMA E GERENCIAMENTO DE ABAS
-- ========================================================
local SettingsTab = Window:CreateTab("Configurações")
local SecSettings = SettingsTab:AddSection("Ações do Sistema")

-- Trocar de Aba via Código
SecSettings:AddButton("Voltar para Aba Principal", function()
    MainTab:Select() -- Força a troca para a primeira aba
end)

-- Abrir Popup / Diálogo Modal
SecSettings:AddButton("Abrir Confirmação (Dialog)", function()
    Window:Dialog({
        Title = "Resetar Opções",
        Content = "Deseja redefinir a velocidade do personagem?",
        Buttons = {
            {
                Title = "Sim, Resetar",
                Callback = function()
                    SpeedSlider:Set(16)
                    AutoFarm:Set(false)
                    WIND:Notify({ Title = "Reset", Content = "Velocidade resetada para 16!", Duration = 3 })
                end
            },
            {
                Title = "Cancelar",
                Callback = function() end
            }
        }
    })
end)

-- Minimizar e Descarregar UI
SecSettings:AddButton("Minimizar UI", function()
    Window:Toggle()
end)

SecSettings:AddButton("Fechar UI Completamente (Unload)", function()
    Window:Destroy()
end)
