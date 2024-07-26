#!/usr/bin/env nextflow

include {  INFERCNV     } from '../../modules/local/scevan/main.nf'
include {  SCEVAN       } from '../../modules/local/scevan/main.nf'

workflow SCRATCH_CNV {

    take:
        ch_seurat_object  // channel: []

    main:

        // Importing notebook
        ch_notebook_infercnv  = Channel.fromPath(params.notebook_infercnv, checkIfExists: true)
        ch_notebook_scevan    = Channel.fromPath(params.notebook_infercnv, checkIfExists: true)

        // Quarto configurations
        ch_template    = Channel.fromPath(params.template, checkIfExists: true)
            .collect()
        ch_page_config = Channel.fromPath(params.page_config, checkIfExists: true)
            .collect()

        ch_page_config = ch_template
            .map{ file -> file.find { it.toString().endsWith('.png') } }
            .combine(ch_page_config)
            .collect()

        // Version channel
        ch_versions = Channel.empty()

        // Passing notebooks for respective functions
        INFERCNV(
            ch_seurat_object,
            ch_notebook_infercnv,
            ch_page_config,
        )
        
        SCEVAN(
            ch_seurat_object,
            ch_notebook_scevan,
            ch_page_config
        )

    emit:
        versions = ch_versions

}
