In order to monitor events affecting the resource type of interest, in the previous example we used the ``kubectl get --watch`` option.

Although technically possible to implement a basic operator as a wrapper using the output from ``kubectl get --watch``, an operator would usually be deployed as its own application instance running in a pod within the Kubernetes cluster, and use the Kubernetes REST API directly to watch resources.

Before we progress to that point, for the ``shell-operator`` we will first run it locally from the terminal. Running it locally allows one to iterate over the implementation of any custom operator as you work on it.

The ``shell-operator`` command has already been installed in this workshop environment. To see what sub commands it accepts run:

```execute
shell-operator help
```

The main sub command we are interested in is ``start``. You can list its options by running:

```execute
shell-operator start --help
```

The key option we care about at this point is the ``--hooks-dir`` option. This specifies the location of a directory where we have placed the hook scripts we want the ``shell-operator`` to execute when certain events occur for the resource types of interest.

We already have a set of hook scripts for our first example using the ``shell-operator`` which you can find in the ``event-subscription`` directory. Run:

```execute
tree event-subscription
```

to list the scripts. You should find a single executable shell script called ``hooks/monitor-service-accounts.sh``.

Before we dive into what the script contains, let's run the ``shell-operator`` and see what happens.

```execute-1
shell-operator start --hooks-dir event-subscription/hooks
```

First up, although it may not be obvious within the log output, nothing was output corresponding to the existing service account called ``default`` as occurred when we use ``kubectl get --watch``.

This is because by default the ``shell-operator`` behaviour is closer to what happens when ``kubectl get --watch`` is also supplied with the option ``--watch-only``. That is, it doesn't emit synthetic ``ADDED`` events for existing instances of the resource. We will come back to this later as it is important for a subsequent example we will use.

To trigger generation of some events, create a new service account ``builder`` again by running:

```execute-2
kubectl create serviceaccount builder
```

This time if you look closely at the log output of the ``shell-operator`` you should see two separate messages, the first being:

```
>>>>>> Added serviceaccount builder <<<<<<
```

and the second:

```
>>>>>> Modified serviceaccount builder <<<<<<
```

Delete the service account by running:

```execute-2
kubectl delete serviceaccount builder
```

and a message corresponding to deletion of the service account should be logged.

```
>>>>>> Deleted serviceaccount builder <<<<<<
```

Shutdown the ``shell-operator`` by interrupting it.

```execute-1
<ctrl-c>
```

Unfortunately, for some unknown reason the version of the ``shell-operator`` being used doesn't want to shutdown gracefully when run from a terminal, so send an interrupt one more time, which should force it to shutdown.

```execute-1
<ctrl-c>
```
