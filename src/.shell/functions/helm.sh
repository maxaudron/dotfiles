#!/usr/bin/env sh

helm () {
    if [ "$1" = "deploy" ]; then
        command helm install --name "$2" --namespace "$2" . -f "../helm-values/${2}.yaml"
    elif [ "$1" = "sign" ]; then
        shasum=$(openssl sha256 "$2" | awk '{ print $2 }')
        chartyaml=$(tar -zxf "$2" --exclude 'charts/' -O '*/Chart.yaml')
         c=$(cat << EOF
$chartyaml
...
files:
  quassel-1.0.0.tgz: sha256:$shasum
EOF
)
        echo "$c" | gpg --clearsign -o "$2.prov"
    else
        command helm $*
    fi
}

