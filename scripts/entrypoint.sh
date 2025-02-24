#!/bin/bash

if [[ $* == *--gh-action* ]] 
then 
    export HOME=/root/
    . /.bash_env
    bundle config set --local path '/.gem' && 
        npm run build &&
        npm run res:build &&
        bundle install &&
        bundle exec jekyll build &&
        typst compile cv/resume_yaml.typ _site/cv.pdf
else 
    bash 
fi