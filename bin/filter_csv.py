#!/usr/bin/env python3

import pandas as pd
import sys
# Read command-line arguments
input_file = sys.argv[1]
output_file = sys.argv[2]

# Read the CSV file into a pandas DataFrame
df = pd.read_csv(input_file, sep=';')

# Filter rows where 'clade' column is not empty
filtered_df = df[df['clade'].notna() & (df['clade'] != '')]

# Write the filtered data back to a new CSV file
filtered_df.to_csv(output_file, index=False)
