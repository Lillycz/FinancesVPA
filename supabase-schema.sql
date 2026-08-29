-- Schema do app "Meus Lucros" — rode este script no SQL Editor do Supabase
-- (Project > SQL Editor > New query > cole tudo > Run)

create table if not exists clientes (
  id text primary key,
  nome text not null,
  foto text default '',
  cor_index integer not null default 0,
  criado_em timestamptz not null default now()
);

create table if not exists lancamentos (
  id text primary key,
  cliente_id text not null references clientes(id) on delete cascade,
  valor numeric not null,
  moeda text not null check (moeda in ('BRL', 'USD')),
  data date not null,
  criado_em timestamptz not null default now()
);

create table if not exists cotacao (
  id integer primary key default 1,
  valor numeric not null,
  atualizado_em timestamptz
);

insert into cotacao (id, valor)
values (1, 5.40)
on conflict (id) do nothing;

alter table clientes enable row level security;
alter table lancamentos enable row level security;
alter table cotacao enable row level security;

-- O app não usa Supabase Auth (login foi trocado por uma senha fixa só na
-- interface), então a chave publishable usada no front-end precisa de acesso
-- direto às tabelas. Isso significa que qualquer pessoa com a chave (visível
-- no código-fonte da página) consegue ler e escrever os dados via API,
-- independente da senha da tela. Ok para uso pessoal, mas não é proteção real.
create policy "acesso total anon - clientes" on clientes
  for all to anon using (true) with check (true);

create policy "acesso total anon - lancamentos" on lancamentos
  for all to anon using (true) with check (true);

create policy "acesso total anon - cotacao" on cotacao
  for all to anon using (true) with check (true);
