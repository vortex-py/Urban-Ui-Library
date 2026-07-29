-- ========================================================
-- URBAN UI LIBRARY v2.5 - EXEMPLO COMPLETO DE ABAS & ELEMENTOS
-- Desenvolvido por: vortex_py
-- ========================================================

-- 1. CARREGAMENTO DA BIBLIOTECA
local WIND = loadstring(game:HttpGet("https://raw.githubusercontent.com/vortex-py/Urban-Ui-Library/refs/heads/main/load-ui.lua"))()

-- 2. NOTIFICAÇÃO INICIAL
WIND:Notify({
    Title = "Urban UI",
    Content = "Biblioteca carregada com todas as opções de Abas!",
    Duration = 4
})

-- 3. CRIAR JANELA PRINCIPAL
local Window = WIND:CreateWindow({
    Title = "URBAN HUB",
    SubTitle = "v2.5 Release • Gerenciamento Completo",
    Size = UDim2.new(0, 520, 0, 380),
    Icon = "rbxassetid://80788381547970",
    FloatIcon = "rbxassetid://80788381547970",
    FloatIconSize = 36
})

-- ========================================================
-- TODAS AS FORMAS E RECURSOS DE ABAS (TABS)
-- ========================================================

-- A) Criar Aba Simples
local MainTab = Window:CreateTab("Principal")

-- B) Criar Aba com Ícone Personalizado
local CombatTab = Window:CreateTab({
    Title = "Combate",
    Icon = "rbxassetid://10723415903" -- Suporta Asset IDs do Roblox
})

-- C) Criar Aba Oculta/Dinâmica (Será mostrada via código depois)
local SecretTab = Window:CreateTab({
    Title = "Aba Secreta",
    Icon = "rbxassetid://10723415903",
    Visible = false -- Começa oculta
})

-- D) Criar Aba de Configurações da UI
local SettingsTab = Window:CreateTab("Configurações")


-- ========================================================
-- CONTEÚDO DA ABA PRINCIPAL (Gerenciador de Abas)
-- ========================================================
local SecTabManager = MainTab:AddSection("Controle Dinâmico de Abas")

-- Trocar de Aba via Código (SelectTab)
SecTabManager:AddButton("Ir para Aba de Combate", function()
    CombatTab:Select() -- Força a navegação automática para a Aba Combate
end)

-- Exibir Aba Oculta em Tempo Real
SecTabManager:AddButton("Revelar Aba Secreta", function()
    SecretTab:SetVisible(true) -- Torna a aba visível na barra lateral
    WIND:Notify({ Title = "Abas", Content = "Aba Secreta agora está visível!", Duration = 3 })
end)

-- Esconder Aba Secreta Novamente
SecTabManager:AddButton("Esconder Aba Secreta", function()
    SecretTab:SetVisible(false) -- Oculta a aba da barra lateral
end)

-- Seção de Elementos Padrão da Aba Principal
local SecMainElements = MainTab:AddSection("Elementos Básicos")

SecMainElements:AddParagraph("Nota sobre Pesquisa", "Você pode usar a barra de busca no topo para filtrar todas as abas criadas em tempo real.")

local WalkSpeedSlider = SecMainElements:AddSlider("Velocidade", 16, 200, 16, function(value)
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = value
    end
end)

local AutoFarmToggle = SecMainElements:AddToggle("Auto Farm", false, function(state)
    print("Auto Farm:", state)
end)


-- ========================================================
-- CONTEÚDO DA ABA DE COMBATE
-- ========================================================
local SecCombat = CombatTab:AddSection("Funções de Aimbot & ESP")

SecCombat:AddDropdown("Tipo de MIRA", {"Cabeça", "Torso", "Aleatório"}, function(selected)
    print("Alvo selecionado:", selected)
end)

SecCombat:AddMultiDropdown("Inimigos Afetados", {"Players", "NPCs", "Bosses"}, {"Players"}, function(selectedTable)
    print("Tabela de alvos atualizada!")
end)

SecCombat:AddColorPicker("Cor da Caixa ESP", Color3.fromRGB(255, 0, 85), function(color)
    print("Cor selecionada:", color)
end)

SecCombat:AddKeybind("Tecla de Ativação", Enum.KeyCode.E, function(key)
    print("Atalho pressionado:", key.Name)
end)


-- ========================================================
-- CONTEÚDO DA ABA SECRETA
-- ========================================================
local SecSecret = SecretTab:AddSection("Recursos Especiais Ocultos")

SecSecret:AddParagraph("Acesso Concedido", "Você liberou o conteúdo da aba secreta dinamicamente!")

SecSecret:AddTextBox("Executar Comando Especial", "Digite aqui...", function(txt)
    print("Comando recebido:", txt)
end)


-- ========================================================
-- CONTEÚDO DA ABA DE CONFIGURAÇÕES & MODAIS
-- ========================================================
local SecSystem = SettingsTab:AddSection("Opções e Janelas Pop-up")

-- Pop-up / Diálogo Modal de Confirmação (Window:Dialog)
SecSystem:AddButton("Abrir Confirmação (Dialog)", function()
    Window:Dialog({
        Title = "Confirmar Reset",
        Content = "Deseja restaurar as configurações da interface para o padrão?",
        Buttons = {
            {
                Title = "Confirmar",
                Callback = function()
                    WalkSpeedSlider:Set(16)
                    AutoFarmToggle:Set(false)
                    WIND:Notify({ Title = "Reset", Content = "Configurações restauradas!", Duration = 3 })
                end
            },
            {
                Title = "Cancelar",
                Callback = function() end
            }
        }
    })
end)

-- Minimizador e Fechamento
SecSystem:AddButton("Ocultar / Minimizar UI", function()
    Window:Toggle()
end)

SecSystem:AddButton("Destruir Interface (Unload)", function()
    Window:Destroy()
end)
