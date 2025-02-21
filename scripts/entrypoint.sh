#!/bin/bash

if [[ $* == *--gh-action* ]] 
then 
    bundle install &&
        bundle exec jekyll build &&
        npm run build &&
        cp -r ./_site/ /github/workspace
else 
    bash 
fi