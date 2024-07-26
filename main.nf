#!/usr/bin/env nextflow
nextflow.enable.dsl = 2

include { NFQUARTO_EXAMPLE } from './subworkflow/local/example.nf'

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Check mandatory parameters
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

if (params.input_seurat_object)   { input_seurat_object = file(params.input_seurat_object) } else { exit 1, 'Please, provide a --input_seurat_object <PATH/TO/seurat_object.RDS> !' }
if (params.input_reference_cells) { input_reference_cells = file(params.input_reference_cells) } else { exit 1, 'Please, provide a --input_reference_cells <PATH/TO/seurat_object.RDS> !' }

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RUN ALL WORKFLOWS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

workflow {

    log.info """\

        Parameters:

        Input: ${input_seurat_object}
        Reference cells: ${input_reference_cells}

    """

    // Mandatory inputs
    ch_seurat_object  = Channel.fromPath(params.input_seurat_object, checkIfExists: true)

    // Optional inputs
    ch_reference      = Channel.fromPath(params.input_reference_cells)

    // Running subworkflows
    SCRATCH_CNV(
        ch_seurat_object,
        ch_reference
    )

}

workflow.onComplete {
    log.info(
        workflow.success ? "\nDone! Open the following report in your browser -> ${launchDir}/${params.project_name}/report/index.html\n" :
        "Oops... Something went wrong"
    )
}
