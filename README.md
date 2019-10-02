# Kubectl docker image

Simple alpine-based docker image with kubernetes tools.

# Components

# kubectl

Kubectl is the Kubernetes cli version of a swiss army knife, and can do many things.

Project link: <https://kubectl.docs.kubernetes.io>

# kustomize

Kustomize introduces a template-free way to customize application configuration that simplifies the use of off-the-shelf applications.

Project link: <https://kustomize.io>

# Helm

The package manager for Kubernetes.

Project link: <https://helm.sh>

# OpenSSL

OpenSSL is a robust, commercial-grade, and full-featured toolkit for the Transport Layer Security (TLS) and Secure Sockets Layer (SSL) protocols.

Project link: <https://www.openssl.org>

# Git

Git is a free and open source distributed version control system designed to handle everything from small to very large projects with speed and efficiency.

Project link: <https://git-scm.com/>

# Usage

Linux CLI example:

```shell
$ alias kubectl='docker run 4ops/kubectl kubectl'
$ alias kustomize-'docker run 4ops/kubectl kustomize'
$ kubectl version --client --short
Client Version: v1.15.2
$ kustomize version
Version: {KustomizeVersion:3.1.0 GitCommit:95f3303493fdea243ae83b767978092396169baf BuildDate:2019-07-26T18:11:16Z GoOs:linux GoArch:amd64}
```
