#!/bin/bash

run_snyk() {
    local repo=$1
    local start=$SECONDS

    snyk code test .

    duration=$(( SECONDS - start ))
    echo "Snyk test took $duration seconds for repo $repo" >> ../benchmark.txt
}

run_codeql() {
    local repo=$1
    local start=$SECONDS

    codeql database create codeqldb --language=javascript
    codeql database analyze codeqldb --format=sarif-latest --output codeqlresults
    
    duration=$(( SECONDS - start ))
    echo "CodeQL test took $duration seconds for repo $repo" >> ../benchmark.txt
}

> benchmark.txt
while read -r line
do
    repo_name=$(echo $line | sed -e 's/.*\///g')
    rm -rf $repo_name
    git clone https://github.com/$line

    cd $repo_name

    run_snyk $repo_name &
    # run_codeql $repo_name &

    cd ..
done < repos