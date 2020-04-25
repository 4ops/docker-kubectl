# Kubectl docker image

Minimal docker image with kubectl only.

# Components

## kubectl

Kubectl is the Kubernetes cli version of a swiss army knife, and can do many things.

[Project link](https://kubectl.docs.kubernetes.io)

# Usage

## Console

Docker:

```shell
$ docker run \
    --name="docker-kubectl-example" \
    --volume="$HOME/.kube/config:/config:ro" \
    --env="KUBECONFIG=/config" \
    --network="host" \
    --rm \
    --interactive \
    --tty \
    4ops/kubectl:1.18.2 \
    get pods
```

Kubernetes:

```shell
$ TOKEN=$(kubectl -n test-jobs get secrets -o jsonpath="{.items[?(@.metadata.annotations['kubernetes\.io/service-account\.name']=='executor')].data.token}" | base64 --decode)
$ kubectl run "get-pods-example" \
    --rm="true" \
    --restart="Never" \
    --image="4ops/kubectl:1.18.2" \
    --image-pull-policy="Always" \
    --stdin \
    --tty \
    --namespace="test-jobs" \
    --env="TOKEN=$TOKEN" \
    -- \
    --token='$(TOKEN)' \
    get \
    pods
```
