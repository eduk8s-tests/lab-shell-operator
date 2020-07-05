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
        "namespace": "lab-shell-operator-w01-s006",
        "resourceVersion": "10925720",
        "selfLink": "/api/v1/namespaces/lab-shell-operator-w01-s006/serviceaccounts/builder",
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
        "namespace": "lab-shell-operator-w01-s006",
        "resourceVersion": "10925723",
        "selfLink": "/api/v1/namespaces/lab-shell-operator-w01-s006/serviceaccounts/builder",
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
