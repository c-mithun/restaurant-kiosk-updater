create table if not exists public.kiosk_menu_items (
    id          bigserial primary key,
    name        text        not null,
    description text        not null default '',
    price       numeric(6,2) not null check (price >= 0),
    available   boolean     not null default true,
    created_at  timestamptz not null default now(),
    updated_at  timestamptz not null default now()
);

comment on table  public.kiosk_menu_items is 'Menu items displayed on the Burgertory self-service kiosk';
comment on column public.kiosk_menu_items.name        is 'Display name of the menu item';
comment on column public.kiosk_menu_items.description is 'Short description shown to customers';
comment on column public.kiosk_menu_items.price       is 'Item price in AUD (excl. GST)';
comment on column public.kiosk_menu_items.available   is 'Whether the item is currently available for order';

-- Enable Row Level Security
alter table public.kiosk_menu_items enable row level security;

-- Allow anonymous read access (kiosk displays menu to everyone)
create policy "Public read access for menu items"
    on public.kiosk_menu_items
    for select
    using (true);

-- Allow authenticated inserts
create policy "Authenticated users can insert menu items"
    on public.kiosk_menu_items
    for insert
    with check (auth.role() = 'authenticated');

-- Allow authenticated updates
create policy "Authenticated users can update menu items"
    on public.kiosk_menu_items
    for update
    using (auth.role() = 'authenticated');

-- Allow authenticated deletes
create policy "Authenticated users can delete menu items"
    on public.kiosk_menu_items
    for delete
    using (auth.role() = 'authenticated');

-- Auto-update the updated_at timestamp on row modification
create or replace function public.handle_updated_at()
returns trigger as $$
begin
    new.updated_at = now();
    return new;
end;
$$ language plpgsql;

create trigger set_updated_at
    before update on public.kiosk_menu_items
    for each row
    execute function public.handle_updated_at();
