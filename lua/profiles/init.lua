local M = {}

-- Level 0 -> No custom features
-- Level 1 -> Minimal features
-- Level 2 -> Default features
-- Level 3 -> IDE features
local feature_level = {
  level = 0
}

function M.init()
  return M.parse_feature()
end

function M.parse_feature()
  local env_features = os.getenv 'features'
  if env_features ~= nil and env_features ~= '' then
    local features = vim.split(env_features, ',')
    for _, feat in ipairs(features) do
      if feat == 'minimal' then
        feature_level.level = 1
      elseif feat == 'ide' then
        feature_level.level = 3
      elseif feat == 'default' then
        feature_level.level = 2
      end
    end
    return feature_level
  else
    return nil
  end
end

return M
