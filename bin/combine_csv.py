#!/usr/bin/env python3

import pandas as pd
import sys
from datetime import date

# Get current date
date = date.today()

def combine_csvs(files):
    if len(files) >= 2:
        dfs = [pd.read_csv(file, sep=',') for file in files]

        combined_df = pd.concat(dfs, ignore_index=True)

        combined_df = combined_df[["seqName", "clade"]]

        combined_df.to_csv(str(date) + '_clade_update.csv', sep=';', index=False)
    else:
        combined_df = pd.read_csv(files[0], sep=',')
        combined_df.to_csv(str(date) +'_clade_update.csv', sep=';', index=False)


combine_csvs(sys.argv[1:])



