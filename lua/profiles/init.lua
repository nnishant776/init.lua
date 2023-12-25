local M = {}

local feature_list = {
  default = true,
  minimal = false,
  ide = false,
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
        feature_list.minimal = true
        feature_list.default = false
        feature_list.ide = false
      elseif feat == 'ide' then
        feature_list.ide = true
        feature_list.default = false
        feature_list.minimal = false
      end
    end
  end
  return feature_list
end

return M