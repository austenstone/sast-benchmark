#!/bin/bash

run_snyk() {
    local repo=$1
    local start=$SECONDS

    snyk code test . --sarif-file-output=../snyk-$repo.sarif

    duration=$(( SECONDS - start ))
    echo "snyk,$repo,$duration" >> ../benchmark.txt
}

run_codeql() {
    local repo=$1
    local start=$SECONDS

    codeql database create codeqldb --language=javascript
    codeql database analyze codeqldb --download --format=sarif-latest --output=../codeql-out.sarif
    
    duration=$(( SECONDS - start ))
    echo "codeql,$repo,$duration" >> ../benchmark.txt
}

> benchmark.txt
while read -r line
do
    repo_name=$(echo $line | sed -e 's/.*\///g')
    rm -rf $repo_name
    git clone https://github.com/$line

    cd $repo_name

    run_snyk $repo_name &
    run_codeql $repo_name &

    cd ..
done < repos