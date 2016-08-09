curbranch=$(git symbolic-ref --short HEAD)

git push github ${curbranch}
git checkout alpha-2.x
git merge -m "merge ${curbranch}" ${curbranch}
bash scripts/build.sh
git add repo/meta
git commit -m 'merge to alpha'
git push github alpha-2.x; git checkout ${curbranch}
