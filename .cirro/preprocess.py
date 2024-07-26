#!/usr/bin/env python3

from cirro.helpers.preprocess_dataset import PreprocessDataset
import pandas as pd
import os

def setup_input_parameters(ds: PreprocessDataset):

    if ds.params.get("input_reference_table") is None:
        ds.add_param(
            "input_reference_table",
            "${baseDir}/assets/NO_FILE"
        )

if __name__ == "__main__":

    ds = PreprocessDataset.from_running()
    setup_input_parameters(ds)

    ds.logger.info("Printing exported paths:")
    ds.logger.info(os.environ['PATH'])

    ds.logger.info("Printing out parameters:")
    ds.logger.info(ds.params)