CREATE OR REPLACE FUNCTION rate_model(model_id integer, user_id uuid, new_rating integer)
RETURNS void AS $$
BEGIN
  INSERT INTO ratings (ai_model_id, user_id, rating, created_at)
  VALUES (model_id, user_id, new_rating, NOW())
  ON CONFLICT (ai_model_id, user_id)
  DO UPDATE SET 
    rating = new_rating,
    updated_at = NOW();
    
  -- Update the AI model's average rating
  UPDATE ai_models 
  SET 
    average_rating = (
      SELECT AVG(r.rating)::numeric(3,2) 
      FROM ratings r 
      WHERE r.ai_model_id = model_id
    ),
    rating_count = (
      SELECT COUNT(*) 
      FROM ratings r 
      WHERE r.ai_model_id = model_id
    )
  WHERE ai_models.id = model_id;
END;
$$ LANGUAGE plpgsql;
