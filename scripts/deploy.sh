#!/usr/bin/env bash
echo $BASH_VERSION
###########################
#### LOAD PARAMS
###########################

POSITIONAL=()
while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
    -h|--help)
      echo "\
      This script provides consistency in multiple deployments/upgrades on the Mine Digital Trust team's OCP4 namespaces 
      with options that effect: security, naming, themeing, environment, ledger 
      options can be provided as flags, or will be prompted in the execution

      Output is a helm upgrade --install command with --set <key from values.yaml>=<override_value> for each applicable value

      see 'helm_values_map' in this script to configure/see mapping from .yaml to script variables, can be added/updated as need
    
      FLAGS:
      -e, --environment, loads variables from /env/<parameter>.param file 
      -c, --config, loads variables from /config/<parameter>.param file 
      -d, --deployment, overrides helm deployment name (default=<config>) 
          --secret_file, loads any other variables from <parameter> file should refer to unversioned file for keycloak_client_secret

      SIMPLE EXAMPLE: 
      ./deploy.sh -c demo -e dev

      KEYCLOAK EXAMPLE: 
      ./deploy.sh -c gov -e dev --secret_file example_secret_file -d dev_gov_keycloak
       " 
      exit 1
      ;;
    -e|--environment)
      ENVIRONMENT="$2"
      shift # past argument
      shift # past value
      ;;
    -c|--config)
      CONFIG="$2"
      shift # past argument
      shift # past value
      ;;
    -d|--deployment_name)
      DEPLOYMENT_NAME_OVERRIDE="$2"
      shift # past argument
      shift # past value
      ;;
    --secret-file)
      SECRET_FILE="$2"
      shift # past argument
      shift # past value
      ;;
    *)    # unknown option
      POSITIONAL+=("$1") # save it in an array for later
      shift # past argument
      ;;
  esac
done

###########################
#### LOAD PROFILES
###########################

## --secret-file for things that shouldn't be source controlled
if [ $SECRET_FILE ]
then
    source $SECRET_FILE
fi

if  [ $ENVIRONMENT ]
then 
    echo "-e flag provided, loading environment profile"
else
    read -p "-e not set: provide environment name (dev, test, prod): " ENVIRONMENT
fi
if [ $ENVIRONMENT ]
then
    eval "oc project f6b17d-${ENVIRONMENT}"
    source ./env/$ENVIRONMENT.param
else 
    echo "not set, using defaults (../charts/bpa/values.yaml)"
fi

if [ $CONFIG ]
then 
    echo "-c flag provided, loading config profile"
else
    read -p "-c not set: provide config name (see config folder): " CONFIG
fi    
if [ $CONFIG ]
then
    source ./config/$CONFIG.param
else 
    echo "not set, using defaults (../charts/bpa/values.yaml)"
fi


###########################
#### SET VARIABLES
###########################
declare -A helm_values_map

## config
declare BPA_VAR_NAME=$ENVIRONMENT_DEPLOYMENT_NAME
helm_values_map["bpa.config.name"]=$BPA_VAR_NAME
helm_values_map["ux.preset"]=$UX_PRESET
helm_values_map["ux.config.theme.themes.light.primary"]=$UX_PRIMARY_COLOR

## environment
helm_values_map["global.ingressSuffix"]=$INGRESS_SUFFIX

## ledger
helm_values_map["bpa.ledger.browserUrlOverride"]=$BPA_LEDGER_BROWSER_URL
helm_values_map["bpa.ledger.genesisUrlOverride"]=$BPA_LEDGER_GENESIS_URL

## security
helm_values_map["bpa.config.security.enabled"]=$BPA_SECURITY_ENABLED
helm_values_map["keycloak.enabled"]=$BPA_KEYCLOAK_ENABLED

## security.keycloak
helm_values_map["keycloak.clientId"]=$KEYCLOAK_CLIENT_ID
helm_values_map["keycloak.config.issuer"]=$KEYCLOAK_ISSUER_URL
helm_values_map["keycloak.config.endsessionUrl"]=$KEYCLOAK_END_SESSION_URL

if $BPA_KEYCLOAK_ENABLED && [ -z $KEYCLOAK_CLIENT_SECRET ]
then
    read -p "Keycloak enabled, provide client secret for (env=$ENVIRONMENT, client_id=$KEYCLOAK_CLIENT_ID) : " KEYCLOAK_CLIENT_SECRET
    if [ -z $KEYCLOAK_CLIENT_SECRET ]
    then 
        echo "don't skip that next time"
        exit 1
    fi
fi
helm_values_map["keycloak.clientSecret"]=$KEYCLOAK_CLIENT_SECRET


###########################
#### Construct Command
###########################

declare DEPLOYMENT_NAME=${DEPLOYMENT_NAME_OVERRIDE:-$CONFIG$DEPLOYMENT_SUFFIX}


CMD="helm upgrade $DEPLOYMENT_NAME ../charts/bpa -f ../charts/bpa/values.yaml --install"
SET_PARAMS=

for key in "${!helm_values_map[@]}"; do
    [ -z ${helm_values_map[$key]} ] || SET_PARAMS="$SET_PARAMS --set $key=${helm_values_map[$key]}"
done


eval "${CMD} ${SET_PARAMS}"

###########################
#### FORCE REDEPLOY
###########################

# pod_name="oc get pods --no-headers | grep $CONFIG-bpa-core"
# eval "oc delete pod $pod_name"