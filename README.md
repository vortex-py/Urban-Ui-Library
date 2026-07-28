# 🌆 Urban UI Library (v2.5)

Uma biblioteca de interface gráfica moderna, fluida e altamente customizável para Roblox, inspirada no estilo *Wind UI*. Desenvolvida para ser simples de integrar e visualmente elegante.

> 👤 **Criado por:** `vortex_py`
obs: caso tiver bugado use o site: **[docs Urban ui library]https://urban-ui-docs.netlify.app/**
--

## ✨ Recursos Principais

* **Barra de Pesquisa de Abas:** Filtre suas abas em tempo real.
* **Perfil do Jogador Integrado:** Exibe automaticamente a foto de avatar e o nome do usuário no rodapé da UI.
* **Diálogos Modais estilo Pop-up:** Janelas de confirmação interativas.
* **Ícone Flutuante Redondo Customizável:** Ajuste o tamanho do ícone interno (`FloatIconSize`).
* **Notificações Toast Modernas:** Avisos flutuantes e temporizados.
* **Redimensionamento e Arraste:** Mova a UI livremente ou ajuste seu tamanho no canto inferior direito (`◢`).

---

## 🚀 Como Importar a Biblioteca

Para carregar a biblioteca no seu script, utilize a linha abaixo:

    local WIND = loadstring(game:HttpGet("https://raw.githubusercontent.com/jone-nunes/Urban-Ui-Library/refs/heads/main/load-ui.lua"))()

---

## 🛠️ Guia Completo de Funções e Elementos

### 1. Janela Principal (`CreateWindow`)
Cria o painel principal. Permite definir título, subtítulo, tamanhos e os ícones do menu e do botão redondo.

    local Window = WIND:CreateWindow({
        Title = "URBAN HUB",
        SubTitle = "by vortex_py",
        Size = UDim2.new(0, 520, 0, 350), -- Largura x Altura inicial
        Icon = "rbxassetid://80788381547970", -- Ícone ao lado do título
        FloatIcon = "rbxassetid://80788381547970", -- Ícone do botão redondo
        FloatIconSize = 36 -- Tamanho da imagem interna do botão flutuante
    })

---

### 2. Abas (`CreateTab`)
Cria uma nova aba no menu lateral da interface.

    local MainTab = Window:CreateTab("Principal")

---

### 3. Seções (`AddSection`)
Cria um bloco visual para agrupar elementos dentro de uma aba.

    local SecMain = MainTab:AddSection("Nome da Seção")

---

### 4. Elementos Interativos

#### 🔘 Botão (`AddButton`)
Executa uma função quando clicado pelo usuário.
* **Como usar:** `SecMain:AddButton("Texto do Botão", Callback)`

    SecMain:AddButton("Executar Função", function()
        print("O botão foi clicado!")
    end)

#### 🎚️ Toggle / Chave Liga-Desliga (`AddToggle`)
Chave de alternância para ligar (ON) ou desligar (OFF) funções. O estado atual é retornado como booleano (`true` para ON, `false` para OFF).
* **Como usar:** `SecMain:AddToggle("Texto", EstadoInicial, Callback)`

    SecMain:AddToggle("Auto Farm", false, function(state)
        if state then
            print("ON")
        else
            print("OFF")
        end
    end)

#### 🎛️ Slider / Barra Deslizante (`AddSlider`)
Permite ao usuário ajustar um valor numérico entre um mínimo e um máximo.
* **Como usar:** `SecMain:AddSlider("Texto", ValorMin, ValorMax, ValorInicial, Callback)`

    SecMain:AddSlider("Velocidade do Jogador", 16, 200, 16, function(value)
        print("Valor selecionado no Slider:", value)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = value
        end
    end)

#### 📑 Dropdown / Menu Suspenso (`AddDropdown`)
Menu para escolha de uma opção dentro de uma lista de opções.
* **Como usar:** `SecMain:AddDropdown("Texto", {"Opção1", "Opção2"}, Callback)`

    SecMain:AddDropdown("Selecionar Local", {"Zona 1", "Zona 2", "Zona 3"}, function(selected)
        print("Opção escolhida:", selected)
    end)

#### ⌨️ Keybind / Atalho de Tecla (`AddKeybind`)
Permite capturar uma tecla do teclado e executar uma ação quando ela for pressionada.
* **Como usar:** `SecMain:AddKeybind("Texto", TeclaPadrao, Callback)`

    SecMain:AddKeybind("Tecla de Ativação", Enum.KeyCode.E, function(key)
        print("Tecla pressionada:", key.Name)
    end)

#### 💬 TextBox / Caixa de Texto (`AddTextBox`)
Campo para inserção de textos ou valores customizados pelo usuário.
* **Como usar:** `SecMain:AddTextBox("Texto", "Placeholder", Callback)`

    SecMain:AddTextBox("Nome do Alvo", "Digite o nome...", function(text)
        print("Texto digitado:", text)
    end)

#### 📝 Paragraph / Parágrafo (`AddParagraph`)
Exibe blocos informativos e tutoriais dentro da biblioteca.
* **Como usar:** `SecMain:AddParagraph("Título", "Descrição")`

    SecMain:AddParagraph("Aviso Importante", "Este é um texto informativo sobre o uso da UI.")

---

### 5. Notificações (`Notify`)
Exibe um aviso flutuante temporário no canto da tela.

    WIND:Notify({
        Title = "Notificação",
        Content = "Esta é uma mensagem de aviso!",
        Duration = 4 -- Duração em segundos
    })

---

### 6. Janela de Diálogo (`Dialog`)
Abre uma caixa de diálogo estilo pop-up modal para confirmações de ações.

    Window:Dialog({
        Title = "Confirmar Ação",
        Content = "Deseja realmente executar esta função?",
        Buttons = {
            {
                Title = "Confirmar",
                Callback = function()
                    print("Confirmado!")
                end
            },
            {
                Title = "Cancelar",
                Callback = function()
                    print("Cancelado!")
                end
            }
        }
    })

---

## 📋 Script Exemplo Completo

Você pode conferir o script de exemplo completo pronto para teste acessando o arquivo direto no repositório:

🔗 **[Ver Exemplo no GitHub (example.lua)](https://github.com/jone-nunes/Urban-Ui-Library/blob/main/example.lua)**

---

## 👨‍💻 Créditos

Desenvolvido por **vortex_py**.
