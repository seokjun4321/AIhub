-- Recalculate and sync ai_models.average_rating and ai_models.rating_count
-- when rows change in public.ratings

create schema if not exists public;

-- Helper: recompute stats for a single model
create or replace function public.recalculate_ai_model_rating(model_id integer)
returns void
language plpgsql
security definer
as $$
declare
  v_avg numeric;
  v_cnt integer;
begin
  select coalesce(avg(r.rating), 0), coalesce(count(*), 0)
    into v_avg, v_cnt
  from public.ratings r
  where r.ai_model_id = model_id;

  update public.ai_models a
     set average_rating = coalesce(v_avg, 0),
         rating_count   = coalesce(v_cnt, 0),
         updated_at     = now()
   where a.id = model_id;
end;
$$;

-- Trigger function handling INSERT/UPDATE/DELETE
create or replace function public.handle_ratings_change()
returns trigger
language plpgsql
security definer
as $$
begin
  if tg_op = 'INSERT' then
    perform public.recalculate_ai_model_rating(new.ai_model_id);
  elsif tg_op = 'UPDATE' then
    if new.ai_model_id is distinct from old.ai_model_id then
      perform public.recalculate_ai_model_rating(old.ai_model_id);
      perform public.recalculate_ai_model_rating(new.ai_model_id);
    else
      perform public.recalculate_ai_model_rating(new.ai_model_id);
    end if;
  elsif tg_op = 'DELETE' then
    perform public.recalculate_ai_model_rating(old.ai_model_id);
  end if;
  return null;
end;
$$;

-- Only drop trigger if table exists
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'ratings' AND table_schema = 'public') THEN
    DROP TRIGGER IF EXISTS ratings_after_change ON public.ratings;
  END IF;
END $$;

-- Only create trigger if table exists
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'ratings' AND table_schema = 'public') THEN
    CREATE TRIGGER ratings_after_change
    AFTER INSERT OR UPDATE OR DELETE ON public.ratings
    FOR EACH ROW EXECUTE PROCEDURE public.handle_ratings_change();
  END IF;
END $$;

-- Backfill existing data so ui shows correct values immediately
-- Only update if ratings table exists
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'ratings' AND table_schema = 'public') THEN
    -- Update models that have ratings
    UPDATE public.ai_models a
       SET average_rating = sub.avg,
           rating_count   = sub.cnt,
           updated_at     = now()
      FROM (
        SELECT ai_model_id, coalesce(avg(rating),0)::numeric as avg, count(*)::int as cnt
        FROM public.ratings
        GROUP BY ai_model_id
      ) sub
     WHERE a.id = sub.ai_model_id;

    -- Set zero for models without any ratings
    UPDATE public.ai_models a
       SET average_rating = 0,
           rating_count   = 0,
           updated_at     = now()
     WHERE NOT EXISTS (
       SELECT 1 FROM public.ratings r WHERE r.ai_model_id = a.id
     );
  END IF;
END $$;


