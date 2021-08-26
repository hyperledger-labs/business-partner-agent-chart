#!/bin/bash

POSITIONAL=()
while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
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
    -s|--security)
      SECURITY="$2"
      shift # past argument
      shift # past value
      ;;
    --default)
      DEFAULT=YES
      shift # past argument
      ;;
    *)    # unknown option
      POSITIONAL+=("$1") # save it in an array for later
      shift # past argument
      ;;
  esac
done


if  [ $ENVIRONMENT ]
then 
    echo "-e flag provided, loading environment"
else
    read -p "-e not set: provide environment name (dev, test, prod): " ENVIRONMENT
fi
# echo `cat env/$ENVIRONMENT.sh`
./env/$ENVIRONMENT.sh


if [ $CONFIG ]
then 
    echo "-c flag provided, loading config"
else
    read -p "-c not set: provide config name (see config folder): " CONFIG
fi
# echo `cat config/$CONFIG.sh`
./config/$CONFIG.sh


if [ $SECURITY ]
then 
    echo "-s flag provided, loading s"
else
    read -p "-s not set: provide security config name (none, basic, keycloak): " SECURITY
fi
# echo `cat security/$SECURITY.sh`
./security/$SECURITY.sh


# read -p "Environment Name (default=${defaultEnvName}): " envName
# export INGRESS_SUFFIX=-${envName:-$defaultEnvName}.apps.silver.devops.gov.bc.ca

# read -p "Ledger Genesis Files URL (default=${defaultGenesisUrl}): " genesisUrlOverride
# export genesisUrlOverride=${genesisUrlOverride:-$defaultGenesisUrl}

# read -p "Security type (default=$defaultSecurity): " security
# export security=${security:-$defaultSecurity}

# read -p "Docker Image Repo (default=$defaultBPAImageRepo): " BPAImageRepo
# export bpaImageRepo=${BPAImageRepo:-$defaultBPAImageRepo}

# read -p "Docker Image Tag (default=$defaultBPAImageTag): " BPAImageTag
# export bpaImageTag=${BPAImageTag:-$defaultBPAImageTag}


# echo $INGRESS_SUFFIX
# echo $genesisUrlOverride
# echo $security
# echo $bpaImageRepo
# echo $bpaImageTag
