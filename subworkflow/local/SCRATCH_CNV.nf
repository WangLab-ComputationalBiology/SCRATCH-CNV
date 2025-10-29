#!/usr/bin/env nextflow

include {  INFERCNV     } from '../../modules/local/infercnv/main.nf'
include {  SCEVAN       } from '../../modules/local/scevan/main.nf'
include { COPYKAT } from '../../modules/local/copykat/main.nf' // Re-added from your first shared code for completeness


workflow SCRATCH_CNV {

    take:
        ch_seurat_object     // channel: []
        // ch_reference_table   // channel: []

    main:

        // Importing notebook
        ch_notebook_infercnv  = Channel.fromPath(params.notebook_infercnv, checkIfExists: true)
        ch_notebook_scevan    = Channel.fromPath(params.notebook_scevan, checkIfExists: true) 
        // ch_notebook_copykat = Channel.fromPath(params.notebook_copykat, checkIfExists: true) 


        // Quarto configurations
        ch_template    = Channel.fromPath(params.template, checkIfExists: true)
            .collect()
        ch_page_config = Channel.fromPath(params.page_config, checkIfExists: true)
            .collect()


        // Version channel
        ch_versions = Channel.empty()

        // Run inferCNV
        if (!params.skip_infercnv) { 
            INFERCNV(
                ch_seurat_object,
                // ch_reference_table,
                ch_notebook_infercnv,
                ch_page_config 
            )
        }

        // Run SCEVAN
        if (!params.skip_scevan) {
            SCEVAN(
                ch_seurat_object,
                // ch_reference_table,
                ch_notebook_scevan,
                ch_page_config 
            ) 
        }

        // // Run CopyKAT
        // if (!params.skip_copykat) { // Added 'if' conditions back
        //     COPYKAT(
        //         ch_seurat_object,
        //         ch_notebook_copykat,
        //         ch_page_config // Pass the *original*, simple ch_page_config
        //     )
        // }


    emit:
        versions = ch_versions

}


