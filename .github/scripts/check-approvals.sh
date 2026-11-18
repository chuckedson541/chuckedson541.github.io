# Stops promotion unless both "uat" and "ga" environments require a reviewer.
set -u
for e in uat ga; do
  n=$(gh api "repos/$GITHUB_REPOSITORY/environments/$e" --jq '[.protection_rules[]? | select(.type=="required_reviewers")] | length' 2>/dev/null \
      || curl -fsS "https://api.github.com/repos/$GITHUB_REPOSITORY/environments/$e" | python3 -c 'import sys,json;print(sum(r.get("type")=="required_reviewers" for r in json.load(sys.stdin).get("protection_rules",[])))' 2>/dev/null \
      || echo 0)
  if [ "${n:-0}" -lt 1 ]; then
    echo "::error::Approvals are not switched on for '$e'. In GitHub: Settings > Environments > $e > Required reviewers > add chuckedson541. Nothing was promoted."
    exit 1
  fi
done
echo "Approvals are on for uat and ga."
