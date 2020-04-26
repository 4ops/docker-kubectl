# Kubectl docker image

[![](https://images.microbadger.com/badges/image/4ops/kubectl:1.16.9.svg)](https://microbadger.com/images/4ops/kubectl "Get your own image badge on microbadger.com")

Minimal docker image based on busybox with kubeconfig automation.

# Components

## Kubectl

Kubectl is the Kubernetes cli version of a swiss army knife, and can do many things.

[Project link](https://kubectl.docs.kubernetes.io/)

## BusyBox

BusyBox provides a fairly complete environment for any small or embedded system.

[Project link](https://busybox.net/)

# Usage

## Run in Docker

```shell
$ docker run \
    --name="docker-kubectl-example" \
    --volume="$HOME/.kube/config:/config/kubectl.conf:ro" \
    --network="host" \
    --rm \
    --interactive \
    --tty \
    4ops/kubectl:1.16.9 \
    get pods
```

## Run in Kubernetes

From command line:

```shell
$ kubectl run "get-pods-example" \
    --rm="true" \
    --restart="Never" \
    --image="4ops/kubectl:1.16.9" \
    --stdin \
    --tty \
    -- \
    get \
    pods
```

Pod manifest example:

```YAML
apiVersion: v1
kind: Pod
metadata:
  name: get-pods-example
spec:
  containers:
    - name: "kubectl"
      image: "4ops/kubectl:1.16.9"
      args: ["get", "pods"]
```

# Credentials

## Using existing kubeconfig

- Mount volume with kubeconfig file
- Setup path to kubeconfig using environment variable `KUBECONFIG`

## Using ServiceAccount token

- Setup token as environment variable `KUBE_TOKEN`
- If no `KUBECONFIG` or `KUBE_TOKEN` set, entrypoint script will try to discover ServiceAccount secrets from `/var/run/secrets/kubernetes.io/serviceaccount` directory

# Environment variables

- `KUBECONFIG` - path to kubeconfig file (default: `/config/kubectl.conf`)
- `KUBERNETES_SERVICE_HOST`, `KUBERNETES_SERVICE_PORT` - Kubernetes API native service discovery [variables](https://kubernetes.io/docs/concepts/services-networking/service/#environment-variables) (default: `kubernetes.default.svc`, `443`)
- `KUBE_URL` - custom Kubernetes API URL
- `KUBE_CA_PEM` - PEM-encoded certificate (or path to cert file) for TLS verification
- `KUBE_NAMESPACE` - default namespace for kubeconfig context (default: `default`)
- `KUBE_TOKEN` - auth token
- `DEBUG` - enable entrypoint script tracing
