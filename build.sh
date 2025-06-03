#!/bin/bash
set -e

mkdir -p build
cd lambda_src
zip -r ../build/lambda.zip . > /dev/null
cd ..
echo "Lambda zipped at build/lambda.zip"
