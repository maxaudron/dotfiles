#!/usr/bin/env bash

export KUBECONFIG="~/.kube/config:$(find ~/.kube/configs -type f | paste -sd ':' - )"
