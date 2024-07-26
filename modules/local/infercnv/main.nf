process INFERCNV {

    tag "Performing INFERCNV analysis"
    label 'process_medium'

    container 'oandrefonseca/scratch-cnv:main'
    publishDir "${params.outdir}/${params.project_name}", mode: 'copy', overwrite: true

    input:
        path(seurat_object)
        path(notebook)
        path(config)

    output:
        path("_freeze/${notebook.baseName}")            , emit: cache

    when:
        task.ext.when == null || task.ext.when

    script:
        def param_file = task.ext.args ? "-P seurat_object:${seurat_object} -P ${task.ext.args}" : ""
        """
        quarto render ${notebook} ${project_name} ${param_file}
        """
    stub:
        def param_file = task.ext.args ? "-P seurat_object:${seurat_object} -P ${task.ext.args}" : ""
        """
        """

}
