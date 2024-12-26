# Rust + GraphQL + Elm + Tailwind CSS Boilerplate

https://github.com/user-attachments/assets/f2692883-16d7-4b09-8a1b-8ff543f1d316

A modern full-stack boilerplate combining:
- Rust backend with GraphQL API
- Elm frontend with type-safe GraphQL integration
- Tailwind CSS for styling
- JWT authentication included

## Prerequisites

- [Rust](https://rustup.rs/) (latest stable)
- [Node.js](https://nodejs.org/) (v16 or later)
- [Elm](https://guide.elm-lang.org/install/elm.html) (0.19.1)

## Quick Start

1. Clone and install dependencies:
```bash
git clone <repository-url>
cd rust-graphql-elm-tailwind-boilerplate
npm install
cd src/elm && npm install && cd ../..
```

2. Set up environment:
```bash
cp .env.example .env
# Edit .env with your JWT_SECRET and ADMIN_PASSWORD
```

3. Start development servers:
```bash
npm run dev
```

This will run:
- Backend: http://localhost:8080
- Frontend: http://localhost:8000
- GraphQL Playground: http://localhost:8080/playground

## Project Structure

```
.
├── src/
│   ├── main.rs              # Rust backend server
│   ├── graphql/             # GraphQL schema and resolvers
│   ├── db/                  # In-memory database
│   └── elm/                 # Elm frontend
│       ├── src/             # Elm source code
│       └── styles/          # Tailwind CSS
├── Cargo.toml              # Rust dependencies
└── package.json           # Node.js dependencies
```

## Features

- ✅ GraphQL API with Rust (using async-graphql)
- ✅ Type-safe Elm frontend with GraphQL code generation
- ✅ JWT authentication built-in
- ✅ Modern UI with Tailwind CSS
- ✅ Hot reloading for both frontend and backend
- ✅ In-memory database for quick prototyping
