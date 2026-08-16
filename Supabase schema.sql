-- جدول قائمة الانتظار
create table waitlist_signups (
  id uuid primary key default gen_random_uuid(),
  name text,
  email text unique not null,
  level text not null,
  goal text,
  created_at timestamptz default now()
);

alter table waitlist_signups enable row level security;

-- يسمح لأي زائر (anon) يضيف صف جديد بس، ما يقدر يقرأ البيانات
create policy "anon can insert waitlist"
on waitlist_signups
for insert
to anon
with check (true);

-- جدول الأحداث/الأنالتكس (صف لكل حدث، أبسط وأسلم من عدّاد يُقرأ ويُكتب)
create table analytics_events (
  id bigint generated always as identity primary key,
  event_key text not null,
  created_at timestamptz default now()
);

alter table analytics_events enable row level security;

create policy "anon can insert analytics"
on analytics_events
for insert
to anon
with check (true);

-- ملاحظة: ما فيه policy للـ select، يعني أي حد يفتح الصفحة ما يقدر يقرأ
-- بيانات المستخدمين الثانين مباشرة من المتصفح. أنت تشوف البيانات من
-- Supabase Dashboard (Table Editor) أو عن طريق service_role key من السيرفر.
