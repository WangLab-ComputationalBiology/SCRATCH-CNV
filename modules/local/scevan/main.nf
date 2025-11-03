process SCEVAN {

    tag "Performing SCEVAN analysis"
    label 'process_medium'

    container 'syedsazaidi/scratch-cnv:latest'

    publishDir "${params.outdir}/${params.project_name}", mode: 'copy', overwrite: true

    input:
        path(seurat_object)
        // path(reference_table)
        path(notebook)
        path(config)

    output:
        path("data/scevan")                             , emit: results
        path("report/*")
        path("_freeze/${notebook.baseName}")            , emit: cache

    when:
        task.ext.when == null || task.ext.when

    script:
        def param_file = task.ext.args ? "-P seurat_object:${seurat_object} -P ${task.ext.args}" : ""
        """
        quarto render ${notebook} ${param_file}
        """
        

    stub:
        def param_file = task.ext.args ? "-P seurat_object:${seurat_object} -P ${task.ext.args}" : ""
        // my addition..
        """
        quarto render ${notebook} ${param_file}
        mkdir -p report
        cp ${notebook.baseName}.html report/
        """
}
