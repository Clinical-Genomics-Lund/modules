process GATK4_ANNOTATEINTERVALS {
    tag "$fasta"
    label 'process_medium'

    conda (params.enable_conda ? "bioconda::gatk4=4.2.6.0" : null)
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/gatk4:4.2.6.0--hdfd78af_0':
        'quay.io/biocontainers/gatk4:4.2.6.0--hdfd78af_0' }"

    input:
    path  processed_intervals
    path  fasta
    path  fai
    path  dict

    output:
    path  "*.tsv"                 , emit: tsv
    path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''

    def avail_mem = 3
    if (!task.memory) {
        log.info '[GATK AnnotateIntervals] Available memory not known - defaulting to 3GB. Specify process memory requirements to change this.'
    } else {
        avail_mem = task.memory.giga
    }
    """
    gatk --java-options "-Xmx${avail_mem}g" AnnotateIntervals \\
        --intervals $processed_intervals \\
        --reference $fasta \\
        -imr OVERLAPPING_ONLY \\
        --output annotated_intervals.tsv \\
        $args

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        gatk4: \$(echo \$(gatk --version 2>&1) | sed 's/^.*(GATK) v//; s/ .*\$//')
    END_VERSIONS
    """
}