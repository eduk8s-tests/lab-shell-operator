The intent of the hidden Kubernetes controller we saw when the service account was being modified after creation was to inject a secret for the access token, and a certificate, to be used by a service account when accessing the Kubernetes REST API. In this case, the injection of the secret is a standard part of how Kubernetes functions.

Automatic injection of secrets can be useful in another situation, but where we need to craft our own solution as it isn't handled by Kubernetes. This is where you have your own private image registry, and want to inject an image pull secret into all service accounts. Doing this eliminates the need to modify deployment definitions to add the name of the image pull secret.

What we will do next is modify our initial example for the ``shell-operator`` to implement this capability. This example can be found in the ``injection`` subdirectory.

```execute
tree secrets-injection
```
