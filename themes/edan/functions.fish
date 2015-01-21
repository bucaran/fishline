# Environment variable switch

function edan-remote
  set -U EDAN_HOST_TYPE 'remote'
end

function edan-local
  set -eU EDAN_HOST_TYPE
end
