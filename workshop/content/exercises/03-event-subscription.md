Let's now look at the contents of the hook script to see how it works. To view the contents of the hook script run:

```execute
cat notifications/hooks/monitor-service-accounts.sh
```

The contents should be:

```
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
      watchEvent=$(jq -r ".[$k].watchEvent" $BINDING_CONTEXT_PATH)
      serviceAccountName=$(jq -r ".[$k].object.metadata.name" $BINDING_CONTEXT_PATH)
      echo ">>>>>> ${watchEvent} serviceaccount ${serviceAccountName} <<<<<<"
    fi
  done
fi
```

There are two parts to this script. The first part is executed when the script is run using the ``--config`` option. The ``shell-operator`` uses this to find out in what cases the hook script should be executed to handle an event.

The first thing the ``shell-operator`` therefore does on start up is to go through all the files in the hooks directory and if a file is an executable program, be that a script, or a compiled binary, it will run the program with the ``--config`` option.

To see what is generated for the hook script above, run:

```execute
notifications/hooks/monitor-service-accounts.sh --config
```

The output should be:

```
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
      - {{session_namespace}}
```

What the configuration in this case says is that the hook script should be executed whenever an ``ADDED``, ``MODIFIED`` or ``DELETED`` event occurs on a resource type with API version ``v1`` and kind ``ServiceAccount``. The events of interest are specified by the ``executeHookOnEvent`` property.

Since we are interested in all three event types, the ``executeHookOnEvent`` property could have been left out as the default is to create a subscription for all three event types. The example includes the property still, just so you can see how it can be set.

The ``namespace`` property is used for this workshop environment as you only have access to the single namespace associated with your workshop session. Using the name selector we are able to restrict the ``shell-operator`` to only look out for changes to the resource in the context of that namespace. If the ``namespace`` property were left out, it would attempt to monitor all namespaces in the cluster. In either case, the instance of ``shell-operator`` needs to be provided with an access token with suitable roles granted via RBAC, to query the resources in the desired scope, namespace or cluster.

If this operator were being run for the whole cluster, you could therefore have got away with using just:

```
configVersion: v1
kubernetes:
- apiVersion: v1
  kind: ServiceAccount
```
