#!/bin/bash
while read -r line
do
    repo_name=$(echo $line | sed -e 's/.*\///g')
    rm -rf $repo_name
    git clone https://github.com/$line

    cd $repo_name
    
    start=$SECONDS

    snyk code test .

    duration=$(( SECONDS - start ))
    echo "Snyk test took $duration seconds"
    echo $duration >> ../benchmark.txt

    # codeql database create codeqldb --language=javascript
    # codeql database analyze codeqldb --format=sarif-latest --output codeqlresults
    cd ..
done < repos