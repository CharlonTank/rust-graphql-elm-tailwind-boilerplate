# MyStuff

A social platform where people can share their gear, tools, and equipment based on their profession or hobbies. Whether you're a photographer showing your camera setup, a developer sharing your workstation, or a reader displaying your book collection - MyStuff is your digital open house.

## Features

- User authentication with JWT
- Profile customization
- Share your equipment and collections
- Categorized items based on profession/hobby
- Modern, responsive UI with Tailwind CSS
- GraphQL API with Rust backend
- Type-safe frontend with Elm

## Prerequisites

Before you begin, ensure you have installed:
- [Rust](https://rustup.rs/) (latest stable)
- [Node.js](https://nodejs.org/) (v16 or later)
- [npm](https://www.npmjs.com/) (comes with Node.js)
- [Elm](https://guide.elm-lang.org/install/elm.html) (0.19.1)

## Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd mystuff
```

2. Install dependencies:
```bash
# Install Rust development tools
cargo install cargo-watch

# Install global Elm tools
npm install -g elm elm-live @dillonkearns/elm-graphql

# Install root project dependencies
npm install

# Install frontend dependencies
cd src/elm && npm install && cd ../..
```

3. Set up environment variables:
```bash
# Copy the example env file
cp .env.example .env

# Edit .env and set your values
# Required variables:
# - JWT_SECRET: Secret key for JWT tokens
# - ADMIN_PASSWORD: Password for admin access
```

4. Generate Elm GraphQL code:
```bash
./generate-elm-graphql.sh
```

## Development

You can run both frontend and backend concurrently with:
```bash
npm run dev
```

This will start:
- Backend server at `http://localhost:8080`
- Frontend dev server at `http://localhost:8000`
- GraphQL Playground at `http://localhost:8080/playground`
- Auto-regeneration of Elm GraphQL code on schema changes

### Database Management

The application uses an in-memory database that can be reset and reseeded:
```bash
# Reset and reseed the database
curl http://localhost:8080/reset-db

# Default users created:
# - Regular user: test_user/test123
# - Admin user: admin_user/admin123
```

## Project Structure

```
.
├── src/
│   ├── main.rs              # Server setup and configuration
│   ├── bin/                 # Additional binaries
│   │   └── generate_hash.rs # Password hash generation utility
│   ├── graphql/            # GraphQL implementation
│   │   ├── schema/         # GraphQL schema definitions
│   │   └── users/          # User-related types and resolvers
│   ├── db/                 # Database management
│   │   └── database.rs     # In-memory database implementation
│   └── elm/                # Elm frontend
│       ├── src/
│       │   ├── Main.elm    # Main Elm application
│       │   └── Api/        # Generated GraphQL code
│       ├── styles/         # Tailwind CSS styles
│       └── index.html      # HTML template
├── Cargo.toml              # Rust dependencies
├── package.json           # Root dependencies and scripts
├── generate-elm-graphql.sh # GraphQL code generation script
└── .env                   # Environment variables
```

## Development Workflow

1. Backend changes:
   - Modify Rust files in `src/`
   - Changes will automatically reload
   - GraphQL schema changes will trigger Elm code regeneration

2. Frontend changes:
   - Modify Elm files in `src/elm/src/`
   - Changes will automatically reload
   - Tailwind CSS changes in `src/elm/styles/input.css` will auto-compile

3. Database changes:
   - Modify `src/db/database.rs` for schema changes
   - Use `/reset-db` endpoint to apply changes
   - Use `generate_hash` binary for new password hashes:
     ```bash
     cargo run --bin generate_hash
     ```
