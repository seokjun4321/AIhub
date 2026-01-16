-- Enable INSERT for preset_prompt_templates
CREATE POLICY "Allow specific users to insert prompts" ON preset_prompt_templates
  FOR INSERT WITH CHECK (auth.role() = 'authenticated');

-- Enable INSERT for preset_agents
CREATE POLICY "Allow specific users to insert agents" ON preset_agents
  FOR INSERT WITH CHECK (auth.role() = 'authenticated');

-- Enable INSERT for preset_workflows
CREATE POLICY "Allow specific users to insert workflows" ON preset_workflows
  FOR INSERT WITH CHECK (auth.role() = 'authenticated');

-- Enable INSERT for preset_designs
CREATE POLICY "Allow specific users to insert designs" ON preset_designs
  FOR INSERT WITH CHECK (auth.role() = 'authenticated');

-- Enable INSERT for preset_templates
CREATE POLICY "Allow specific users to insert templates" ON preset_templates
  FOR INSERT WITH CHECK (auth.role() = 'authenticated');
