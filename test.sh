#!/bin/bash
if [ ${CODESPACES} = "true" ]; then REPO=$(echo $GITHUB_REPOSITORY | cut -d"/" -f2); bash /workspaces/${REPO}/.devcontainer/scripts/onCreateCommand.sh; fi
