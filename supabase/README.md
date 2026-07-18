# Supabase — Database Layer

This directory contains all Supabase configuration for the Burgertory kiosk backend.

## Contents

| File / Directory | Purpose |
|------------------|---------|
| `config.toml` | Supabase CLI project configuration |
| `migrations/` | Versioned SQL migration files |
| `seed.sql` | Sample menu data applied on `db reset` |

## Schema: `kiosk_menu_items`

The primary table stores every item available on the kiosk menu.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `id` | `bigserial` | Primary key | Auto-incrementing row identifier |
| `name` | `text` | `not null` | Display name of the menu item |
| `description` | `text` | `not null default ''` | Short customer-facing description |
| `price` | `numeric(6,2)` | `not null`, `check >= 0` | Price in AUD (excl. GST) |
| `available` | `boolean` | `not null default true` | Toggle for item availability |
| `created_at` | `timestamptz` | `not null default now()` | Row creation timestamp |
| `updated_at` | `timestamptz` | `not null default now()` | Auto-updated on row change |

### Row Level Security (RLS) Policies

| Policy | Operation | Condition |
|--------|-----------|-----------|
| Public read access | `SELECT` | Any role (including anonymous) |
| Authenticated insert | `INSERT` | `auth.role() = 'authenticated'` |
| Authenticated update | `UPDATE` | `auth.role() = 'authenticated'` |
| Authenticated delete | `DELETE` | `auth.role() = 'authenticated'` |

This means:
- The kiosk UI (anonymous) can **read** all menu items.
- Only authenticated users (admin / backend service) can **create**, **edit**, or **remove** items.

### Trigger

A `set_updated_at` trigger automatically refreshes the `updated_at` column on every `UPDATE`, ensuring timestamps stay accurate without application-level logic.

## Migrations

Migrations are applied in timestamp order. To create a new migration:

```bash
npx supabase migration new <descriptive_name>
```

Then write your SQL in the generated file under `migrations/`.

To apply to the remote database:

```bash
npx supabase db push
```

To reset the local database (re-runs all migrations + seed):

```bash
npx supabase db reset
```
