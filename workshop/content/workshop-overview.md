Operators are software extensions to Kubernetes that make use of custom resources to manage applications and their components.

An operator can be described as being an encapsulation of the knowledge required to manage a system or set of services. By implementing such knowledge into an operator, you remove from a human the need to perform such steps manually, enabling complex processes to be automated.

For more details on what an operator comprises and can be used for, check out the Kubernetes documentation.

* https://kubernetes.io/docs/concepts/extend-kubernetes/operator/

There are numerous software toolkits available to help in the task of implementing an operator. These are available for popular programming languages such as Go, Java and Python.

In this workshop we will look at one method for implementing an operator which is a bit different to most operator toolkits. This is the ``shell-operator``.

The core of the ``shell-operator`` is implemented in Go, but implementation of the handlers (hooks) for responding to events can be implemented as separate applications using scripting languages such as the UNIX shell, or Python.
