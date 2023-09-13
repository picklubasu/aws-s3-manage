#!/bin/sh

build_application() {
	sam build --template-file ${TEMPLATE_PATH}
}

package_deploy() {
	#sam deploy --template-file ${CODEBUILD_SRC_DIR}/template.yml --stack-name llypharma-data-execution --parameter-overrides "$(jq -j 'to_entries[] | "\(.key)='\\\"'\(.value)'\\\"''\ '"' params.json)"
	SAM_PARAMETERS=$( cat ${CODEBUILD_SRC_DIR}/payload.json | jq -r ' .Parameters | to_entries[] | "\(.key)='\\\"'\(.value)'\\\"''\ '"' )
	sam deploy --template-file ${CODEBUILD_SRC_DIR}/template.json --stack-name "cft-stack-manage-s3" --parameter-overrides $SAM_PARAMETERS
}

echo "Starting build - $(date)"
set -xe
build_application
package_deploy
echo "Completed build - $(date)"