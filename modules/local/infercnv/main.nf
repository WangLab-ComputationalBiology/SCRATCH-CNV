process INFERCNV {

    tag "Performing INFERCNV analysis"
    label 'process_medium'

    // container 'oandrefonseca/scratch-cnv:main'
    container '/home/sazaidi/Softwares/SCRATCH-CNV-main/scratch-cnv.sif'
    // container 'syedsazaidi/scratch-cnv:latest'
    publishDir "${params.outdir}/${params.project_name}", mode: 'copy', overwrite: true

    input:
        path(seurat_object)
        // path(reference_table)
        path(notebook)
        path(config)


    output:
        path("data/infercnv")                             , emit: results
        path("report/*")
        path("_freeze/${notebook.baseName}")              , emit: cache

    when:
        task.ext.when == null || task.ext.when

    script:
        def param_file = task.ext.args ? "-P seurat_object:${seurat_object}  -P ${task.ext.args}" : ""
        // def param_file = task.ext.args ? "-P seurat_object:${seurat_object} -P reference_table:${reference_table} -P ${task.ext.args}" : ""
        """
        quarto render ${notebook} ${param_file}
        """
    stub:
        def param_file = task.ext.args ? "-P seurat_object:${seurat_object}  -P ${task.ext.args}" : ""
        """
        mkdir -p data _freeze/${notebook.baseName}
        mkdir -p _freeze/DUMMY/figure-html

        touch _freeze/DUMMY/figure-html/FILE.png

        touch data/${params.project_name}_infercnv_meta_object.RDS
        touch _freeze/${notebook.baseName}/${notebook.baseName}.html

        mkdir -p report
        touch report/${notebook.baseName}.html

        echo ${param_file} > _freeze/${notebook.baseName}/params.yml
        """

}
