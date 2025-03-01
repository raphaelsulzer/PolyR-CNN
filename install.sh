#!/bin/bash
set -e

# Local variables
ENV_NAME=polyrcnn2
PYTHON=3.11.11

# Installation script for Anaconda3 environments
echo "____________ Pick conda install _____________"
echo
# Recover the path to conda on your machine
CONDA_DIR=`realpath /opt/miniconda3`
if (test -z $CONDA_DIR) || [ ! -d $CONDA_DIR ]
then
  CONDA_DIR=`realpath ~/anaconda3`
fi

while (test -z $CONDA_DIR) || [ ! -d $CONDA_DIR ]
do
    echo "Could not find conda at: "$CONDA_DIR
    read -p "Please provide you conda install directory: " CONDA_DIR
    CONDA_DIR=`realpath $CONDA_DIR`
done

echo "Using conda found at: ${CONDA_DIR}/etc/profile.d/conda.sh"
source ${CONDA_DIR}/etc/profile.d/conda.sh
echo
echo


echo "________________ Installation _______________"
echo

# Check if the environment exists
if conda env list | awk '{print $1}' | grep -q "^$ENV_NAME$"; then
    echo "Conda environment '$ENV_NAME' already exists. Removing..."

    # Remove the environment
    conda env remove --name "$ENV_NAME" --yes > /dev/null 2>&1

    # Double-check removal
    if conda env list | awk '{print $1}' | grep -q "^$ENV_NAME$"; then
        echo "Failed to remove the environment '$ENV_NAME'."
        exit 1
    else
        echo "Conda environment '$ENV_NAME' removed successfully."
    fi
fi

## Create a conda environment from yml
echo "Create conda environment '$ENV_NAME'."
conda create -y --name $ENV_NAME python=$PYTHON > /dev/null 2>&1

# Activate the env
source ${CONDA_DIR}/etc/profile.d/conda.sh
conda activate ${ENV_NAME}

########## PIP VERSION IS NOW WORKING #############
### PIP VERSION
#pip install -r requirements_ori.txt
#pip install requests
#pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
#python -m pip install detectron2 -f   https://dl.fbaipublicfiles.com/detectron2/wheels/cu118/torch2.5.1/index.html
#pip install copclib

### CONDA VERSION
## dependencies
conda install pytorch==2.5.1 torchvision==0.20.1 torchaudio==2.5.1  pytorch-cuda=11.8 -c pytorch -c nvidia -y
conda install conda-forge::detectron2 -y
conda install conda-forge::fvcore -y
conda install geos -y
conda install conda-forge::wandb -y

conda install conda-forge::tqdm -y
conda install conda-forge::matplotlib -y
conda install conda-forge::pycocotools -y
conda install anaconda::scikit-image -y
conda install conda-forge::opencv -y
conda install conda-forge::timm -y

#pip install -r requirements.txt
##pip install torch==2.1.2 torchvision==0.16.2 torchaudio==2.1.2 --index-url https://download.pytorch.org/whl/cu118
python -c "import torch; torch.cuda.is_available()"
RETVAL=$?  # Capture return code
if [ $RETVAL -eq 0 ]; then
    echo "PyTorch cuda is working!"
fi

# problem with torch:tms? do this:
# https://github.com/huggingface/diffusers/issues/8958#issuecomment-2253055261

## for lidar_poly_dataloader
#conda install conda-forge::gcc_linux-64=10 conda-forge::gxx_linux-64=10 -y # otherwise copclib install bugs
#pip install copclib
#conda install conda-forge::colorlog -y
#conda install conda-forge::descartes=1.1.0 -y