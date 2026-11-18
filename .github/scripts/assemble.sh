set -euo pipefail
rm -rf _site && mkdir _site
cp -a ga/. _site/
for env in uat beta; do mkdir -p "_site/$env"; cp -a "$env/." "_site/$env/"; done
find _site -name .git -prune -exec rm -rf {} + ; find _site -name .github -prune -exec rm -rf {} +
python3 ga/.github/scripts/label.py _site
printf 'User-agent: *\nDisallow: /uat/\nDisallow: /beta/\n' > _site/robots.txt
touch _site/.nojekyll
