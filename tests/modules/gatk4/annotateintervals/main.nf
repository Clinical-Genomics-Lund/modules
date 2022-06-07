#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

// include { GATK4_PREPROCESSINTERVALS } from '../../../../modules/gatk4/preprocessintervals/main.nf'
include { GATK4_ANNOTATEINTERVALS } from '../../../../modules/gatk4/annotateintervals/main.nf'

workflow test_gatk4_annotateintervals {
    
    bed = file(params.test_data['homo_sapiens']['genome']['genome_blacklist_interval_bed'], checkIfExists: true)
    fasta = file(params.test_data['homo_sapiens']['genome']['genome_fasta'], checkIfExists: true)
    fai = file(params.test_data['homo_sapiens']['genome']['genome_fasta_fai'], checkIfExists: true)
    dict = file(params.test_data['homo_sapiens']['genome']['genome_dict'], checkIfExists: true)
    preprocessed_intervals = file(params.test_data['homo_sapiens']['genome']['genome_preprocessed_interval_bed'], checkIfExists: true)

    // GATK4_PREPROCESSINTERVALS ( bed, fasta, fai, dict )
    // GATK4_ANNOTATEINTERVALS ( GATK4_PREPROCESSINTERVALS.out.interval_list, fasta, fai, dict )
    GATK4_ANNOTATEINTERVALS ( preprocessed_intervals, fasta, fai, dict )
}