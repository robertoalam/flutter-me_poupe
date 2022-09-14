#cat semver.sh
#!/bin/sh

#Get the highest tag number
VERSION=`git describe --abbrev=0 --tags`
VERSION=${VERSION:-'0.0.0'}

#Get number parts
MAJOR="${VERSION%%.*}"; VERSION="${VERSION#*.}"
MINOR="${VERSION%%.*}"; VERSION="${VERSION#*.}"
PATCH="${VERSION%%.*}"; VERSION="${VERSION#*.}"

#Increase version
if [ "$1" = "bug" ]; then
  PATCH=$((PATCH+1))
elif [ "$1" = "att" ]; then
  MINOR=$((MINOR+1))
  PATCH=0
elif [ "$1" = "up" ]; then
  MAJOR=$((MAJOR+1))
  MINOR=0
  PATCH=0
fi

#Get current hash and see if it already has a tag
GIT_COMMIT=`git rev-parse HEAD`
NEEDS_TAG=`git describe --contains $GIT_COMMIT`

#Create new tag
NEW_TAG="$MAJOR.$MINOR.$PATCH"
echo "Atualizando para $NEW_TAG"

#Only tag if no tag already (would be better if the git describe command above could have a silent option)
if [ -z "$NEEDS_TAG" ]; then
  echo "Tag criada $NEW_TAG (Ignorando erro fatal:cannot describe - significa que o commit nao possui tag) "
  git tag -a $NEW_TAG
  git push origin main --tags
  rm assets/git/versao.txt
  echo -n $NEW_TAG >> assets/git/versao.txt
  git add assets/git/versao.txt
  git commit -m "."
  git push origin main
  #git commit --amend --no-edit
  #echo -n User:
  #read -s password
  #echo password | git push homologa master --tags
else
  echo "Ja existe uma tag neste commit"
fi  