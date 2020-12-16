#!/usr/bin/env bash

set -e;

if [[ -z "${INPUT_GITHUB_TOKEN}" ]]; then
	echo "::warning::No GitHub token is provided. If you want to annotate the code with coverage, set 'GITHUB_TOKEN' input variable";
	exit 0
fi;

#if [[ -z "${ACTIONS_RUNTIME_URL}" ]]; then
#	echo "::error::ACTIONS_RUNTIME_URL is missing. Uploading pipeline icons as artifacts (base64 uris are not accepted) won't work without it. See https://github.com/KOLANICH-GHActions/passthrough-restricted-actions-vars and https://github.com/KOLANICH-GHActions/node_based_cmd_action_template";
#	exit 1;
#fi;

#if [[ -z "${ACTIONS_RUNTIME_TOKEN}" ]]; then
#	echo "::error::ACTIONS_RUNTIME_TOKEN is missing. Uploading pipeline icons as artifacts (base64 uris are not accepted) won't work without it. See https://github.com/KOLANICH-GHActions/passthrough-restricted-actions-vars and https://github.com/KOLANICH-GHActions/node_based_cmd_action_template";
#	exit 1;
#fi;


THIS_SCRIPT_DIR=`dirname "${BASH_SOURCE[0]}"`; # /home/runner/work/_actions/KOLANICH-GHActions/typical-python-workflow/master
echo "This script is $THIS_SCRIPT_DIR";
THIS_SCRIPT_DIR=`realpath "${THIS_SCRIPT_DIR}"`;
echo "This script is $THIS_SCRIPT_DIR";
ACTIONS_DIR=`realpath "$THIS_SCRIPT_DIR/../../.."`;

ISOLATE="${THIS_SCRIPT_DIR}/isolate.sh";

AUTHOR_NAMESPACE=KOLANICH-GHActions;

if pip list | grep "\\bcoverage2GHChecksAnnotation\\b"; then
	:
else
	GIT_PIP_ACTION_REPO=$AUTHOR_NAMESPACE/git-pip;
	GIT_PIP_ACTION_DIR=$ACTIONS_DIR/$GIT_PIP_ACTION_REPO/master;

	if [ -d "$GIT_PIP_ACTION_DIR" ]; then
		:
	else
		$ISOLATE git clone --depth=1 https://github.com/$GIT_PIP_ACTION_REPO $GIT_PIP_ACTION_DIR;
	fi;

	bash $GIT_PIP_ACTION_DIR/action.sh $THIS_SCRIPT_DIR/pythonPackagesToInstallFromGit.txt;
	$ISOLATE bash $GIT_PIP_ACTION_DIR/action.sh $THIS_SCRIPT_DIR/pythonPackagesToInstallFromGitCoverageReportDeps.txt;
fi;

coverageReportGHChecksAnnotations $INPUT_DATABASE_PATH $INPUT_PACKAGE_NAME $INPUT_PACKAGE_ROOT;
