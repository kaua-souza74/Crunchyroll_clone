🎌  AniStream
Clone Crunchyroll — Aplicativo Flutter + Supabase
──────────────────────────────────────────
Flutter
Framework	Supabase
Backend	Dart
Linguagem	setState
Estado

👥  Autores
Nome	Kauã de Souza Oliveira
Número	N13
Nome	Lucas Lima Silva
Número	N16
Disciplina	Desenvolvimento Mobile
Projeto	Clone Crunchyroll — AniStream


📱  Sobre o Projeto
AniStream é um aplicativo mobile desenvolvido em Flutter que replica as principais funcionalidades da Crunchyroll. O app permite que fãs de anime e mangá explorem títulos, acompanhem lançamentos da temporada e gerenciem sua lista pessoal de favoritos.

O projeto foi desenvolvido com foco em:
•	Organização de código com componentes reutilizáveis (widgets)
•	Gerenciamento de estado com StatefulWidget e setState
•	Integração com Supabase para autenticação e persistência de dados
•	Navegação entre telas com BottomNavigationBar
•	Interface visual rica com tema escuro inspirado na Crunchyroll

✨  Funcionalidades
🏠  Tela de Início
•	AppBar com logotipo AniStream e ícone de notificações
◦	Lançamentos da temporada em scroll horizontal
◦	Lista de episódios recentes em scroll vertical
◦	Favoritar/desfavoritar com contador em tempo real
🔍  Tela de Explorar
•	Campo de busca com filtro em tempo real (debounce 400ms)
◦	Grade de animes em 3 colunas
◦	Resultados carregados direto do Supabase
👤  Tela de Perfil
•	Foto de perfil, nome de usuário e bio
◦	Indicadores: títulos assistidos, seguidores, seguindo
◦	Edição de perfil via modal bottom sheet
◦	Grade com a lista pessoal do usuário
◦	Botão de logout
🔐  Autenticação
•	Login e cadastro com e-mail e senha via Supabase Auth
◦	Roteamento automático baseado na sessão (StreamBuilder)
◦	Criação automática de perfil no cadastro

🛠️  Tecnologias Utilizadas
Tecnologia	Versão	Uso
Flutter	^3.x	Framework mobile
Dart	^3.x	Linguagem de programação
Supabase Flutter	^2.3.0	Backend / Auth / DB
PostgreSQL	via Supabase	Banco de dados
setState	nativo Flutter	Gerência de estado

🗄️  Estrutura do Banco de Dados (Supabase)
Crie as seguintes tabelas no painel do Supabase (SQL Editor):
Tabela: animes
id            UUID PRIMARY KEY DEFAULT gen_random_uuid()
title         TEXT NOT NULL
cover_url     TEXT
description   TEXT
episode_number     INTEGER DEFAULT 1
favorite_count     INTEGER DEFAULT 0
is_season_highlight BOOLEAN DEFAULT FALSE
created_at    TIMESTAMP WITH TIME ZONE DEFAULT NOW()
Tabela: profiles
id            UUID REFERENCES auth.users(id) PRIMARY KEY
username      TEXT UNIQUE
bio           TEXT
avatar_url    TEXT
followers     INTEGER DEFAULT 0
following     INTEGER DEFAULT 0
updated_at    TIMESTAMP WITH TIME ZONE DEFAULT NOW()
Tabela: user_favorites
id            UUID PRIMARY KEY DEFAULT gen_random_uuid()
user_id       UUID REFERENCES auth.users(id) ON DELETE CASCADE
anime_id      UUID REFERENCES animes(id) ON DELETE CASCADE
created_at    TIMESTAMP WITH TIME ZONE DEFAULT NOW()
UNIQUE(user_id, anime_id)
Tabela: my_list
id            UUID PRIMARY KEY DEFAULT gen_random_uuid()
user_id       UUID REFERENCES auth.users(id) ON DELETE CASCADE
anime_id      UUID REFERENCES animes(id) ON DELETE CASCADE
created_at    TIMESTAMP WITH TIME ZONE DEFAULT NOW()
UNIQUE(user_id, anime_id)

📁  Estrutura do Projeto
lib/
├── main.dart                  # Inicialização + Supabase.initialize()
├── app.dart                   # MaterialApp + roteamento por sessão
├── models/
│   ├── anime.dart             # Model Anime com fromJson/toJson
│   └── user_profile.dart      # Model UserProfile
├── data/
│   └── mock_data.dart         # Dados estáticos de fallback
├── services/
│   ├── anime_service.dart     # CRUD animes via Supabase
│   ├── auth_service.dart      # Login / Signup / Logout
│   └── profile_service.dart   # Leitura e edição de perfil
├── screens/
│   ├── login_screen.dart      # Tela de autenticação
│   ├── home_screen.dart       # Tela Início
│   ├── explore_screen.dart    # Tela Explorar
│   └── profile_screen.dart    # Tela Perfil
└── widgets/
    ├── bottom_nav_bar.dart    # Barra de navegação inferior
    ├── season_card.dart       # Card da temporada (horizontal)
    ├── episode_card.dart      # Card de episódio com favorito
    ├── anime_grid_item.dart   # Item da grade (Explorar/Perfil)
    └── profile_header.dart    # Cabeçalho do perfil

🚀  Como Executar
Pré-requisitos
•	Flutter SDK 3.x instalado
•	Dart SDK 3.x
•	Conta no Supabase (supabase.com)
•	Android Studio / VS Code com extensão Flutter
Passo a Passo
•	Clone o repositório
git clone https://github.com/seu-usuario/anistream.git
cd anistream
•	Instale as dependências
flutter pub get
•	Configure o Supabase em main.dart
await Supabase.initialize(
  url: 'SUA_SUPABASE_URL',
  anonKey: 'SUA_SUPABASE_ANON_KEY',
);
•	Crie as tabelas no Supabase
Execute os SQLs da seção 'Estrutura do Banco de Dados' no SQL Editor do Supabase.
•	Execute o aplicativo
flutter run

📦  pubspec.yaml
dependencies:
  flutter:
    sdk: flutter
  supabase_flutter: ^2.3.0

📄  Licença
Projeto acadêmico desenvolvido para fins educacionais. Todos os direitos reservados aos autores.

Por Kauã de Souza Oliveira (N13) e Lucas Lima Silva (N16)
AniStream  •  Flutter + Supabase  •  2026
