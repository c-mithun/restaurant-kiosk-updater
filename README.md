# restaurant-kiosk-updater

Self-learning pipeline project for the **Burgertory Express** self-service kiosk application.

## Overview

This repository contains the infrastructure and application code for a restaurant self-service kiosk system:

| Layer | Technology |
|-------|-----------|
| Frontend | Static HTML kiosk UI |
| Database | Supabase (PostgreSQL + Row Level Security) |
| Container | Docker (nginx:alpine) |
| Infrastructure | Terraform (AWS EC2) |
| CI/CD | GitHub Actions |

## Project Structure

```
├── .github/workflows/   # CI/CD pipeline (lint, validate, build)
├── src/                 # Kiosk frontend application
├── supabase/            # Database migrations, seeds, and config
├── terraform/           # AWS infrastructure blueprints
├── Dockerfile           # Container build definition
└── README.md
```

## Getting Started

### Prerequisites

- [Docker](https://docs.docker.com/get-docker/)
- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.9.0
- [Supabase CLI](https://supabase.com/docs/guides/cli) (via `npx supabase`)
- A free [Supabase](https://supabase.com) account

### Database Setup

1. **Create a new Supabase project** at [supabase.com/dashboard](https://supabase.com/dashboard) (free tier is fine).

2. **Link the project** (you will need your project reference ID from the Supabase dashboard under Project Settings > General):
   ```bash
   npx supabase link --project-ref <YOUR_PROJECT_REF>
   ```

3. **Push the schema and seed data** to your hosted database:
   ```bash
   npx supabase db push
   ```

   This runs the migrations in `supabase/migrations/` and applies the seed data in `supabase/seed.sql`.

### Local Development (Docker required)

Spin up a local Supabase stack (PostgreSQL, API, Studio, Auth, Storage):

```bash
npx supabase start
```

On first run this downloads Docker images and seeds the database automatically. Studio will be available at `http://localhost:54323`.

### Running the Kiosk UI Locally

```bash
docker build -t restaurant-kiosk .
docker run -p 8080:80 restaurant-kiosk
```

Open `http://localhost:8080` in your browser.

## Database Schema

See [supabase/README.md](supabase/README.md) for full schema details and RLS policies.

## CI/CD Pipeline

Pushes to `main` automatically trigger the GitHub Actions workflow which:

1. Formats and validates Terraform blueprints
2. Lints the Dockerfile with Hadolint
3. Builds and verifies the Docker image

## Useful Commands

| Command | Description |
|---------|-------------|
| `npx supabase start` | Start local Supabase stack |
| `npx supabase stop` | Stop local Supabase stack |
| `npx supabase db push` | Push migrations to remote project |
| `npx supabase db reset` | Reset local database and re-seed |
| `npx supabase migration new <name>` | Create a new migration file |
| `npx supabase status` | Show local/linked project status |
