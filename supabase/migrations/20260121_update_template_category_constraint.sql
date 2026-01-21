-- Drop existing constraint
ALTER TABLE preset_templates DROP CONSTRAINT IF EXISTS preset_templates_category_check;

-- Add new constraint with expanded values
ALTER TABLE preset_templates ADD CONSTRAINT preset_templates_category_check 
  CHECK (category IN ('Notion', 'Sheets', 'Excel', 'Figma', 'Other'));
