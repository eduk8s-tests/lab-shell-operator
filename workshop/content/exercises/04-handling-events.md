Having queried the configuration from the hook script the ``shell-operator`` will set up appropriate watchers against the resources of interest using the Kubernetes REST API. Whenever events occur on the resources, the appropriate hook script will be executed. When executing the hook script no command line options are passed, so without ``--config``, resulting in the main part of the hook script being executed.

For the first example, the main part of the hook script which will be executed when events arise is the section:

```
for k in $(jq '. | keys | .[]' $BINDING_CONTEXT_PATH); do
  type=$(jq -r ".[$k].type" $BINDING_CONTEXT_PATH)
  if [[ $type == "Event" ]] ; then
    watchEvent=$(jq -r ".[$k].watchEvent" $BINDING_CONTEXT_PATH)
    serviceAccountName=$(jq -r ".[$k].object.metadata.name" $BINDING_CONTEXT_PATH)
    echo ">>>>>> ${watchEvent} serviceaccount ${serviceAccountName} <<<<<<"
  fi
done
```

In order to pass details to the hook script about the events which have occured, the ``shell-operator`` uses the environment variable called ``BINDING_CONTEXT_PATH``. The value of the environment variable is a file system path to a temporary file which contains details of the events.

An example of the contents of this file is as follows.

```
[
  {
    "binding": "kubernetes",
    "type": "Event",
    "watchEvent": "Added",
    "object": {
      "apiVersion": "v1",
      "kind": "ServiceAccount",
      "metadata": {
        "creationTimestamp": "2020-07-05T06:30:01Z",
        "name": "builder",
        "namespace": "lab-shell-operator-w01-s001",
        "resourceVersion": "10925720",
        "selfLink": "/api/v1/namespaces/lab-shell-operator-w01-s001/serviceaccounts/builder",
        "uid": "81a957c9-f566-41db-9356-62415118b2a8"
      }
    }
  },
  {
    "binding": "kubernetes",
    "type": "Event",
    "watchEvent": "Modified"
    "object": {
      "apiVersion": "v1",
      "kind": "ServiceAccount",
      "metadata": {
        "creationTimestamp": "2020-07-05T06:30:01Z",
        "name": "builder",
        "namespace": "lab-shell-operator-w01-s001",
        "resourceVersion": "10925723",
        "selfLink": "/api/v1/namespaces/lab-shell-operator-w01-s001/serviceaccounts/builder",
        "uid": "81a957c9-f566-41db-9356-62415118b2a8"
      },
      "secrets": [
        {
          "name": "builder-token-49hnm"
        }
      ]
    }
  }
]
```

The file contains a JSON data structure, specifically a list, where each element in the list relate to a specific event.

As you can see, on any single execution of the hook script, multiple events can be passed at once. As such, a hook script needs to iterate over each of the events and process them.

Because UNIX shell scripts can't process JSON data structures themselves, the ``jq`` program is used to extract the required data from the file.

Using ``jq`` in this case, the main loop which drives the processing of each event has the form:

```
for k in $(jq '. | keys | .[]' $BINDING_CONTEXT_PATH); do
  ...
done
```

This magic ``jq`` command results in a list of keys for accessing items in the JSON array being returned. Within the loop, the key can then be used to lookup details of a specific event.

```
type=$(jq -r ".[$k].type" $BINDING_CONTEXT_PATH)
```

Note that because ``jq`` needs to be executed at many points with the hook script, with the overhead of having to re-parse the JSON data structure each time, for an operator which is expected to process many resource events you might consider using another scripting language such as Python, which contains builtin libraries for processing JSON.
