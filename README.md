# 🚀 Rust + GraphQL + Elm + Tailwind CSS Boilerplate

<div align="center">

[![Rust](https://img.shields.io/badge/rust-%23000000.svg?style=for-the-badge&logo=rust&logoColor=white)](https://www.rust-lang.org/)
[![GraphQL](https://img.shields.io/badge/-GraphQL-E10098?style=for-the-badge&logo=graphql&logoColor=white)](https://graphql.org/)
[![Elm](https://img.shields.io/badge/Elm-60B5CC?style=for-the-badge&logo=elm&logoColor=white)](https://elm-lang.org/)
[![Tailwind CSS](https://img.shields.io/badge/tailwindcss-%2338B2AC.svg?style=for-the-badge&logo=tailwind-css&logoColor=white)](https://tailwindcss.com/)

A modern, type-safe, and full-stack boilerplate for building robust web applications.

[Getting Started](#-getting-started) •
[Features](#-features) •
[Architecture](#-architecture) •
[Development](#-development) •
[Contributing](#-contributing)

</div>

https://github.com/user-attachments/assets/0ecdf162-2d72-4bd1-a9d3-8fb69424a974

## ✨ Features

- 🦀 **Rust Backend**
  - Fast, reliable, and memory-safe server implementation
  - GraphQL API using async-graphql
  - Built-in JWT authentication
  - In-memory database for rapid prototyping

- 🌳 **Elm Frontend**
  - Type-safe frontend development
  - Automatic GraphQL code generation
  - Zero runtime exceptions
  - Predictable state management

- 🎨 **Modern UI**
  - Tailwind CSS for utility-first styling
  - Responsive design out of the box
  - Dark mode support
  - Custom components

- 🛠 **Developer Experience**
  - Hot reloading for both frontend and backend
  - GraphQL Playground for API exploration
  - Type safety across the entire stack
  - Comprehensive documentation

## 🚦 Getting Started

### Prerequisites

Make sure you have the following installed:

- [Rust](https://rustup.rs/) (latest stable)
- [Node.js](https://nodejs.org/) (v16 or later)
- [Elm](https://guide.elm-lang.org/install/elm.html) (0.19.1)

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd rust-graphql-elm-tailwind-boilerplate
```

2. Install dependencies:
```bash
# Install root dependencies
npm install

# Install Elm frontend dependencies
cd src/elm && npm install && cd ../..
```

3. Set up your environment:
```bash
cp .env.example .env
# Edit .env with your JWT_SECRET and ADMIN_PASSWORD
```

4. Start the development servers:
```bash
npm run dev
```

Your application will be available at:
- 🌐 Frontend: http://localhost:8000
- 🔧 Backend API: http://localhost:8080
- 📝 GraphQL Playground: http://localhost:8080/playground

## 📐 Architecture

### Project Structure
```
.
├── src/
│   ├── main.rs              # Rust backend entry point
│   ├── graphql/             # GraphQL schema and resolvers
│   │   ├── schema.rs        # GraphQL schema definition
│   │   └── resolvers/       # Query and mutation resolvers
│   ├── db/                  # In-memory database implementation
│   └── elm/                 # Elm frontend application
│       ├── src/             # Elm source code
│       │   ├── Main.elm     # Application entry point
│       │   └── Api/         # Generated GraphQL types
│       └── styles/          # Tailwind CSS styles
├── Cargo.toml              # Rust dependencies
└── package.json           # Node.js dependencies
```

## 🔧 Development

### Available Commands

- `npm run dev` - Start development servers
- `npm run build` - Build for production
- `npm run test` - Run tests
- `npm run generate` - Generate GraphQL types for Elm

### GraphQL Development

The GraphQL Playground is available at http://localhost:8080/playground during development. Use it to:
- Explore the API schema
- Test queries and mutations
- View documentation

### Adding New Features

1. Define your GraphQL types in the Rust backend
2. Implement resolvers for your new types
3. Generate Elm types using `npm run generate`
4. Implement the frontend features in Elm

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
