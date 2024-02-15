#!/bin/bash
# this script is used to initialize the directories for the data and the docker files
# - data: downlowded or created datasets
# - models: trained models
# - outputs: outputs of the models
# - wandb: weights and biases logs

# move to the root directory
SCRIPT_DIR=`dirname $0`
cd $SCRIPT_DIR/..

CMDNAME=`basename $0`

directories=("data" "models" "outputs" "wandb-artifacts" "wandb-runs")

while getopts cl: OPT
do
  case $OPT in
    "c" ) FLG_C="TRUE" ;;
    "l" ) FLG_L="TRUE" ; VALUE_L="$OPTARG" ;;
      * ) echo "Usage: $CMDNAME [-c] [-l link-path] [-h]" 1>&2
          echo "  -c: clear directories" 1>&2
          echo "  -l link-path: make and link directories" 1>&2
          echo "  -h: display this help and exit" 1>&2
          exit 1 ;;
  esac
done

if [ "$FLG_C" = "TRUE" ]; then
  for directory in ${directories[@]}; do
    # if the directory is a symbolic link, remove the link
    # otherwise, remove the directory
    if [ -L $directory ]; then
      unlink $directory
    else
      rm -rf $directory
    fi
  done
  exit 0
fi

if [ "$FLG_L" = "TRUE" ]; then
  for directory in ${directories[@]}; do
    mkdir -p $VALUE_L/$directory
    ln -snfv $VALUE_L/$directory $directory
  done
else
  for directory in ${directories[@]}; do
    mkdir -p $directory
  done
fi
