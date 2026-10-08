#!/bin/bash

DATA_DIR=${1%/}
PLOTTER_DIR="/nevis/riverside/data/sc5303/sbnd/continuous_readout/plotting/python"

PYTHON="/nevis/riverside/data/sc5303/sbnd/continuous_readout/plotting/python-3.13.5/bin/python3.13"
ENV_DIR="/nevis/riverside/data/sc5303/sbnd/continuous_readout/plotting/process3"
source "${ENV_DIR}/bin/activate"


for FILE in "${DATA_DIR}"/*.root; do
    if [ -f "${FILE%.root}.pdf" ]; then
        echo ${FILE%.root}.pdf exists. Skipping.
    else
        ${PYTHON} "${PLOTTER_DIR}/plotDataCheckSN.py" --file "${FILE}" --save
    fi
done

