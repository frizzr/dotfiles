export GOSSAMER_SETUP=~/ent-devops-dashboard.yaml
export AWS_CA_BUNDLE=/usr/local/share/ca-certificates/GEExternalRootCA21.crt
export CLUSTER_NAME=ent-prod-01
export AWS_REGION="us-east-1"
export AWS_PROFILE=dash-dev

awset() {
    (export AWS_CA_BUNDLE="" ; gossamer3 bulk-login $GOSSAMER_SETUP --verbose)
    if [[ "$1" == "blue" ]] ; then
        export AWS_PROFILE=dash-prod
        aws eks update-kubeconfig --name $CLUSTER_NAME --alias $CLUSTER_NAME
        kubectl config set-context --current --namespace=devops-dashboard-blue
    elif [[ "$1" == "green" ]]; then
        export AWS_PROFILE=dash-prod
        aws eks update-kubeconfig --name $CLUSTER_NAME --alias $CLUSTER_NAME
        kubectl config set-context --current --namespace=devops-dashboard-green
    elif [[ "$1" == "dev" ]]; then
        export AWS_PROFILE=dash-dev
        aws eks update-kubeconfig --name $CLUSTER_NAME --alias $CLUSTER_NAME
        kubectl config set-context --current --namespace=devops-dashboard-dev
    elif [[ "$1" == "bsf" ]]; then
        export AWS_PROFILE=bu-bsf
    elif [[ "$1" == "" ]]; then
        echo "Usage: awset [bsf|dev|prod] "
    else
        export AWS_PROFILE=$1
    fi
}

