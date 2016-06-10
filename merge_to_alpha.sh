curbranch=$(git symbolic-ref --short HEAD)

git checkout alpha-2.x
git merge -m "merge ${curbranch}" ${curbranch}
bash scripts/build.sh
git add repo/meta
git commit -m 'merge to alpha'
git push; git checkout ${curbranch}
