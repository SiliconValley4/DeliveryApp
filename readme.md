# Git Commands!!
------------

git config --list

git branch -a : shows all branches
git branch "name" : create branch labeled "name"
git branch "currentName" --move "newName" - move rename a branch
git branch "currentName" --M "newName" - force pomove rename a branch

# Remove local branch
-------------------
git branch -d "remote/branch" : delete branch 
git branch -D "branchName" : DELETE branch - force delete branch
git branch --delete "remote"/"branchName" - specify which branch from which remote


# Remove remote branch
--------------------

```
git push "remote" --delete "branch" - this will delete the branch from github, on the repo that is being aliased by remote

git checkout branchname: switch from current branch to  "branchname" if it exists

git checkout -b some : switch to NEW branch "some"

git remote : shows all remotes from this repo

git remote -v : verbose

git remote remove "origin" - remove origin

git remote add "name" "LINK" : add new origin labeled "name" to the link "LINK"

git remote show "name" : shows information about remote labeled "name"

git remote set-url --push origin no_push : remove push setting for particular remote

git remote rename "origin" "newLocalName" : changes the name of your remote name locally

git remote set-head "remotename" "branchname" : sets branchname of the remote to be the head pointer of the repo

git branch -u "remote"/"branch" : sets upstream branch??

git push --set-upstream "remote" "branch" : allows to simply use "git push" command and use those settings

adding a remote origin means to give the long link an alias

a remote is just an alias

```

# How to work within a group:
---------------------------

- git clone link
- Because we clone the repository from an exisiting one on github, there's already an alias "remote" called "whatever it was named, probably origin"

# OpenSource:
-----------
# How to individually work from an existing repo: 
----------------------------------------------
- Fork public repo from github
on git bash:
- git clone "repolink"
- add commit changes
- git push "remote" "branch" - 
after having cloned the repo post fork, you have to specify the name of the remote and the current branch you want to push to the repo
rm -f -r folder : remove forcefully folder "name"

# To contribute some change from a forked/clone repo:
---------------------------------------------------
On github -> "New Pull Request"
-> Create Pull Rerquest
-> Accept from Original Repo Creator


# To Host Website on GitHub Pages:
--------------------------------
change the name of the default branch to "gh-pages"

