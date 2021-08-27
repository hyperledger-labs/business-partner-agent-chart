echo "This will delete the aca-py private_keys and wallet for this namespace:"
eval "oc project"
read -p "Deployment name: " DEPLOYMENT_NAME

eval "helm uninstall $DEPLOYMENT_NAME"
eval "oc delete secret $DEPLOYMENT_NAME-bpa-acapy"
eval "oc delete pvc data-$DEPLOYMENT_NAME-postgresql-0"