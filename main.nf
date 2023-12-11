#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

ch_fasta_input = Channel.fromPath(params.fasta_file)
ch_combined_csvs = Channel.empty()

process NEXTCLADE_H1 {

    container 'nextstrain/nextclade:latest' // Use Nextclade's Docker image
    errorStrategy 'ignore' // Ignore errors in Nextclade

    input:
    path fasta_file 

    output:
    path "output/nextclade_H1.csv"

    //publishDir "H1_results", mode: 'copy'

    script:
    """
    nextclade dataset get --name 'flu_h1n1pdm_ha' --output-dir 'data/flu_h1n1pdm_ha'
    nextclade run \
       --input-dataset data/flu_h1n1pdm_ha \
       --output-all=output/ \
       $fasta_file
    
    mv output/nextclade.csv output/nextclade_H1.csv
    """
}

process NEXTCLADE_H3 {

    container 'nextstrain/nextclade:latest' // Use Nextclade's Docker image
    errorStrategy 'ignore' // Ignore errors in Nextclade

    input:
    path fasta_file 

    output:
    path "output/nextclade_H3.csv"

    //publishDir "H3_results", mode: 'copy'

    script:
    """
    nextclade dataset get --name 'flu_h3n2_ha' --output-dir 'data/flu_h3n2_ha'
    nextclade run \
       --input-dataset data/flu_h3n2_ha  \
       --output-all=output/ \
       $fasta_file
    
    mv output/nextclade.csv output/nextclade_H3.csv
    """
}

process NEXTCLADE_BVIC {

    container 'nextstrain/nextclade:latest' // Use Nextclade's Docker image
    errorStrategy 'ignore' // Ignore errors in Nextclade

    input:
    path fasta_file 

    output:
    path "output/nextclade_B_VIC.csv"

    //publishDir "B_VIC", mode: 'copy'

    script:
    """
    nextclade dataset get --name 'flu_vic_ha' --output-dir 'data/flu_vic_ha'
    nextclade run \
       --input-dataset data/flu_vic_ha  \
       --output-all=output/ \
       $fasta_file
    
    mv output/nextclade.csv output/nextclade_B_VIC.csv
    """
}

process FILTER_CSV {

    container 'amancevice/pandas:latest' // Use the Pandas Docker container
    containerOptions = "-v ${baseDir}/bin:/project-bin" // Mount the bin directory

    input:
    path csv_file

    output:
    path "filtered_${csv_file.baseName}.csv"

    script:
    """
    python3 /project-bin/filter_csv.py $csv_file filtered_${csv_file.baseName}.csv
    """
}

process COMBINE_CSV {

        container 'amancevice/pandas:latest' // Use the Pandas Docker container
        containerOptions = "-v ${baseDir}/bin:/project-bin" // Mount the bin directory
    
        input:
        path csv_files
    
        output:
        path "*_clade_update.csv"
    
        publishDir "results", pattern: "*.csv", mode: 'copy'
    
        script:
        """
        python3 /project-bin/combine_csv.py $csv_files 
        """

}

workflow {
    NEXTCLADE_H1(ch_fasta_input).mix(ch_combined_csvs).set { ch_combined_csvs }
    NEXTCLADE_H3(ch_fasta_input).mix(ch_combined_csvs).set { ch_combined_csvs }
    NEXTCLADE_BVIC(ch_fasta_input).mix(ch_combined_csvs).set { ch_combined_csvs }
    FILTER_CSV(ch_combined_csvs)
    COMBINE_CSV(FILTER_CSV.out.collect())
}
