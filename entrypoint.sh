#!/bin/sh

set -eu

readonly kubectl="/usr/bin/kubectl"
readonly sa="/var/run/secrets/kubernetes.io/serviceaccount"
readonly debug="${DEBUG:-}"
readonly kubeconfig="${KUBECONFIG:-/config/kubectl.conf}"
readonly url="${KUBE_URL:-https://${KUBERNETES_SERVICE_HOST:-kubernetes.default.svc}:${KUBERNETES_SERVICE_PORT:-443}}"

token="${KUBE_TOKEN:-}"
ca="${KUBE_CA_PEM:-}"
namespace="${KUBE_NAMESPACE:-}"

[ -n "$token" ] && [ -r $sa/token ] && token="$(cat $sa/token)"
[ -n "$token" ] && secret="$token" && token="@token"
[ -n "$debug" ] && set -x && printenv | sed 's eyJhbGci.* @secret g'

unset KUBE_TOKEN KUBE_URL KUBE_NAMESPACE KUBE_CA_PEM

# try to get certificate authority
if [ -n "$ca" ] && [ ! -r "$ca" ]; then
	echo "$ca" > /tmp/ca.crt
	ca=/tmp/ca.crt
elif [ -z "$ca" ] && [ -r $sa/ca.crt ]; then
	ca=$sa/ca.crt
fi

# set namespace
if [ -z "$namespace" ] && [ -r $sa/namespace ]; then
	namespace="$(cat $sa/namespace)"
else
	namespace="default"
fi

# create kubeconfig
if [ -n "$ca" ] && [ -n "$token" ] && [ ! -r "$kubeconfig" ]; then
	kcfg="$kubectl --kubeconfig=$kubeconfig config"
	$kcfg set-credentials token --token="$secret"
	$kcfg set-cluster kube --server="$url" --certificate-authority="$ca" --embed-certs=true
	$kcfg set-context kube-token --cluster=kube --user=token
	$kcfg use-context kube-token
fi

# setup arguments
if [ -r "$kubeconfig" ]; then
	set -- --kubeconfig="$kubeconfig" "$@"
else
	[ -n "$token" ] && set -- --server="$url" --token="$secret" "$@"
fi

exec $kubectl "$@" || exit $?
