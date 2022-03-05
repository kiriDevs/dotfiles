#!/bin/bash
git config --global user.name "Kiron"
git config --global user.email "56218513+kiriDevs@users.noreply.github.com"
git config --global pull.ff only

git config --global alias.s "status"

git config --global alias.c "commit"
git config --global alias.a "add"

git config --global alias.unadd "restore --cached"

git config --global alias.aa "add ."
git config --global alias.ca "commit -a"
git config --global alias.cm "commit -m"
git config --global alias.cam "commit -a -m"

git config --global alias.lastc "log --oneline --graph -n 1"
git config --global alias.lastce 'log --pretty="%ce" -n 1'
git config --global alias.lastae 'log --pretty="%ae" -n 1'

git config --global alias.prettylog "log --oneline --graph"
git config --global alias.plog "log --oneline --graph"
