#!/usr/bin/env bash

if [[ $1 == "--config" ]] ; then
  cat <<EOF
configVersion: v1
kubernetes:
- apiVersion: v1
  kind: ServiceAccount
  executeHookOnEvent:
  - Added
  - Modified
  - Deleted
  namespace:
    nameSelector:
      matchNames:
      - $SESSION_NAMESPACE
EOF
else
  type=$(jq -r '.[0].type' $BINDING_CONTEXT_PATH)
  if [[ $type == "Event" ]] ; then
    serviceAccountName=$(jq -r '.[0].object.metadata.name' $BINDING_CONTEXT_PATH)
    watchEvent=$(jq -r '.[0].watchEvent' $BINDING_CONTEXT_PATH)
    echo ">>>>>> ${watchEvent} serviceaccount '${serviceAccountName}' <<<<<<"
  fi
fi
