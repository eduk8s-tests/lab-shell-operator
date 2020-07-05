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
  for k in $(jq '. | keys | .[]' $BINDING_CONTEXT_PATH); do
    type=$(jq -r ".[$k].type" $BINDING_CONTEXT_PATH)
    if [[ $type == "Event" ]] ; then
      serviceAccountName=$(jq -r ".[$k].object.metadata.name" $BINDING_CONTEXT_PATH)
      watchEvent=$(jq -r ".[$k].watchEvent" $BINDING_CONTEXT_PATH)
      echo ">>>>>> ${watchEvent} serviceaccount ${serviceAccountName} <<<<<<"
    fi
  done
fi
