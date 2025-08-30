-- Add bigint-compatible overload for recalculate function to fix
-- ERROR: function public.recalculate_ai_model_rating(bigint) does not exist

create or replace function public.recalculate_ai_model_rating(model_id bigint)
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


