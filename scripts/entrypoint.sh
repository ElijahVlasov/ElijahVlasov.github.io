#!/bin/bash

if [[ $* == *--gh-action* ]] 
then 
    export HOME=/root/
    . /.bash_env
    bundle config set --local path '/.gem' && 
        bundle install &&
        bundle exec jekyll build &&
        npm run build &&
        typst compile cv/resume_yaml.typ _site/cv.pdf
else 
    bash 
fi