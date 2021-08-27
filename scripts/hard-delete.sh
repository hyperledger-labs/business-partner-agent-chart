echo "This will delete the aca-py private_keys and wallet for this namespace:"
namespace=`oc project --short=true`
read -p "Deployment name to delete from $namespace: " DEPLOYMENT_NAME

eval "helm uninstall $DEPLOYMENT_NAME"
eval "oc delete secret $DEPLOYMENT_NAME-bpa-acapy"
eval "oc delete pvc data-$DEPLOYMENT_NAME-postgresql-0"