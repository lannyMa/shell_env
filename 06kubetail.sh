#!/usr/bin/env bash



usage="${PROGNAME} <search term> [-h] [-c] [-n] [-t] [-l] [-s] [-b] [-k] [-v] -- tail multiple Kubernetes pod logs at the same time
where:
    -h, --help           Show this help text
    -c, --container      The name of the container to tail in the pod (if multiple containers are defined in the pod).
                         Defaults to all containers in the pod. Can be used multiple times.
    -t, --context        The k8s context. ex. int1-context. Relies on ~/.kube/config for the contexts.
    -l, --selector       Label selector. If used the pod name is ignored.
    -n, --namespace      The Kubernetes namespace where the pods are located (defaults to \"default\")
    -s, --since          Only return logs newer than a relative duration like 5s, 2m, or 3h. Defaults to 10s.
    -b, --line-buffered  This flags indicates to use line-buffered. Defaults to false.
    -e, --regex          The type of name matching to use (regex|substring)
    -j, --jq             If your output is json - use this jq-selector to parse it.
                         example: --jq \".logger + \\\" \\\" + .message\"
    -k, --colored-output Use colored output (pod|line|false).
                         pod = only color pod name, line = color entire line, false = don't use any colors.
                         Defaults to line.
    -z, --skip-colors    Comma-separated list of colors to not use in output
                         If you have green foreground on black, this will skip dark grey and some greens -z 2,8,10
                         Defaults to: 7,8
        --timestamps     Show timestamps for each log line
        --tail           Lines of recent log file to display. Defaults to -1, showing all log lines.
    -v, --version        Prints the kubetail version
examples:
    ${PROGNAME} my-pod-v1
    ${PROGNAME} my-pod-v1 -c my-container
    ${PROGNAME} my-pod-v1 -t int1-context -c my-container
    ${PROGNAME} '(service|consumer|thing)' -e regex
    ${PROGNAME} -l service=my-service
    ${PROGNAME} --selector service=my-service --since 10m
    ${PROGNAME} --tail 1"

if [ $# -eq 0 ]; then
    echo "$usage"
    exit 1
fi
