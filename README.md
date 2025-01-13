# Rust GraphQL + Elm + Tailwind Boilerplate

A full-stack web application boilerplate using Rust for the backend (with async-graphql) and Elm for the frontend.

## Project Structure

```
.
├── backend/           # Rust GraphQL server
│   ├── src/          # Rust source code
│   └── Cargo.toml    # Rust dependencies
│
└── frontend/         # Elm frontend
    ├── src/         # Elm source code
    └── package.json # Node.js dependencies
```

## Prerequisites

- Rust (latest stable)
- Node.js (latest LTS)
- PostgreSQL
- cargo-watch (`cargo install cargo-watch`)

## Setup

1. Clone the repository
2. Copy `.env.example` to `.env` in the backend directory and configure your database settings
3. Install dependencies:
   ```bash
   # Install frontend dependencies
   npm install
   
   # Install backend dependencies
   cd backend && cargo build
   ```

## Development

Run both backend and frontend in development mode:

```bash
npm start
```

This will start:
- Backend at http://localhost:8000 (with hot reloading via cargo-watch)
- Frontend at http://localhost:3000 (with hot reloading)

## Building for Production

```bash
npm run build
```

This will:
1. Build the Elm frontend
2. Build the Rust backend in release mode

## License

MIT
