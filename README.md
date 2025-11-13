# 🎯 Cluster Visualizer - Multi-View Flutter App

Uma aplicação Flutter profissional e moderna para visualização de clusters de membros com múltiplas perspectivas interativas.

## 📁 Estrutura do Projeto

```
lib/
├── core/
│   └── constants/
│       └── colors.dart              # Cores da aplicação
├── data/
│   ├── datasources/
│   │   └── fake_clusters_data.dart  # Dados JSON fake
│   ├── models/
│   │   └── cluster_model.dart       # Modelos de Cluster e Member
│   └── repositories/
│       └── cluster_repository.dart  # Repository pattern
└── presentation/
    ├── pages/
    │   ├── home_page.dart                  # Menu principal
    │   ├── concentric_circles_view.dart    # Visualização orbital
    │   ├── grid_cluster_view.dart          # Visualização em grid
    │   ├── timeline_cluster_view.dart      # Visualização cronológica
    │   └── network_graph_view.dart         # Visualização em rede
    └── widgets/
        ├── cluster_circle_widget.dart      # Widget de círculo
        └── cluster_detail_page.dart        # Detalhes do cluster
```

## 🎨 Visualizações Disponíveis

### 1. **Concentric Circles** 🔵
- Círculos concêntricos interativos
- Transições fluidas entre clusters
- Swipe vertical para navegar
- Avatares dos membros na metade inferior

### 2. **Grid View** 📊
- Cards organizados em grade
- Filtro por categoria
- Animações de entrada
- Preview de membros em stack

### 3. **Timeline** ⏱️
- Visualização cronológica
- Linha do tempo vertical
- Ordenação por data de criação
- Gradientes e animações suaves

### 4. **Network Graph** 🕸️
- Nós conectados em rede
- Animação de conexões
- Tamanho baseado em membros
- Interação por toque

## 🚀 Instalação

### 1. Copie os arquivos para seu projeto

```bash
# Estrutura de diretórios
lib/
├── core/constants/colors.dart
├── data/
│   ├── datasources/fake_clusters_data.dart
│   ├── models/cluster_model.dart
│   └── repositories/cluster_repository.dart
└── presentation/
    ├── pages/
    │   ├── home_page.dart
    │   ├── concentric_circles_view.dart
    │   ├── grid_cluster_view.dart
    │   ├── timeline_cluster_view.dart
    │   └── network_graph_view.dart
    └── widgets/
        ├── cluster_circle_widget.dart
        └── cluster_detail_page.dart
```

### 2. Adicione a dependência do intl no pubspec.yaml

```yaml
dependencies:
  flutter:
    sdk: flutter
  intl: ^0.18.0  # Para formatação de datas
```

### 3. Instale as dependências

```bash
flutter pub get
```

### 4. Execute o projeto

```bash
flutter run
```

## 📊 Dados Fake

O projeto inclui 5 clusters pré-configurados:

1. **Design Team** (8 membros) - 🎨 Vermelho
2. **Engineering** (12 membros) - ⚙️ Turquesa
3. **Marketing Squad** (6 membros) - 📢 Amarelo
4. **Product Strategy** (5 membros) - 🎯 Verde
5. **Customer Success** (10 membros) - 💬 Rosa

Cada cluster contém:
- Nome, descrição e categoria
- Emoji e cor personalizada
- Lista completa de membros com:
  - Nome, role e avatar
  - Status online/offline
  - Data de entrada

## 🎨 Customização

### Adicionar novos clusters

Edite `data/datasources/fake_clusters_data.dart`:

```dart
{
  "id": "6",
  "name": "Seu Cluster",
  "description": "Descrição aqui",
  "category": "Categoria",
  "memberCount": 5,
  "iconEmoji": "🚀",
  "colorHex": "#FF5733",
  "createdAt": "2024-03-01T10:00:00Z",
  "members": [...]
}
```

### Alterar cores

Edite `core/constants/colors.dart`:

```dart
const Color kBackground = Color(0xFF0A0E27);
const Color kButtonBackground = Color(0xFF1E2749);
const Color kButtonTextColor = Colors.white;
```

## 🏗️ Arquitetura

O projeto segue **Clean Architecture** com:

- **Core**: Constantes e utilidades compartilhadas
- **Data**: Modelos, datasources e repositories
- **Presentation**: UI (pages e widgets)

### Padrões Utilizados

- ✅ Repository Pattern
- ✅ Stateful Widgets com AnimationController
- ✅ Hero Animations
- ✅ Custom Painters
- ✅ Gesture Detection
- ✅ Responsive Design

## 🎭 Animações

Todas as visualizações incluem:

- Animações de entrada (fade, slide, scale)
- Transições suaves entre estados
- Micro-interações
- Feedback visual

## 📱 Compatibilidade

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Desktop (Windows, macOS, Linux)

## 🔧 Próximos Passos

Sugestões de melhorias:

1. Adicionar busca e filtros avançados
2. Implementar API real
3. Adicionar testes unitários
4. Criar animações personalizadas
5. Adicionar modo escuro/claro
6. Implementar favoritos
7. Adicionar chat entre membros
8. Exportar visualizações como imagem

## 👨‍💻 Desenvolvido por

José Guilherme Alves - Flutter Developer 

---

**Nota**: Este projeto foi desenvolvido como teste de UI/UX para visualização de clusters de membros. Todos os dados são fictícios.