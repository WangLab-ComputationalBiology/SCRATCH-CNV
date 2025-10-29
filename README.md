# SCRATCH-CNV Subworkflows

## Introduction

This repository contains subworkflows for performing copy number variation (CNV) analysis on single-cell RNA-seq (scRNA-seq) data. The CNV subworkflows support multiple tools including inferCNV, SCEVAN, and CopyKAT to assess tumor heterogeneity and identify chromosomal aberrations.

> **Disclaimer:** Subworkflows are high-level wrappers around chained Nextflow modules. They should be used as part of a pipeline and can be extended or reused across different scRNA-seq workflows.

## Prerequisites

Ensure the following tools are installed:

* [Nextflow](https://www.nextflow.io/) (v21.04.0 or higher)
* [Java](https://www.oracle.com/java/technologies/javase-downloads.html) (v8 or higher)
* [Singularity](https://sylabs.io/singularity/) or Docker for container execution
* [Git](https://git-scm.com/)

## Installation

Clone the repository:

```bash
git clone https://github.com/WangLab-ComputationalBiology/SCRATCH-CNV.git
cd SCRATCH-CNV
```

## Subworkflows

### `main.nf`

This is the main entry script that orchestrates CNV analysis using inferCNV, SCEVAN, and CopyKAT subworkflows.

### 1. inferCNV

Performs CNV inference using gene expression intensities compared between reference (normal) and observation (tumor) cells.

#### Usage

```bash
nextflow run main.nf -profile singularity --input_seurat_object <path/to/seurat_object.RDS> --input_reference_table <path/to/reference_table.csv>
```

#### Parameters

* `--input_seurat_object`: Seurat object with UMAP and count layers
* `--input_reference_table`: CSV with barcode and reference label columns
* `--project_name`: Output project name (optional)
* `--skip_infercnv`: Skip running inferCNV (default: false)

### 2. SCEVAN

Performs CNV detection using Bayesian inference across multiple tumor samples.

#### Parameters (passed via `ext.args`)

* `project_name`: Name for output and figures
* `input_model`: Organism (e.g., human)
* `n_threads`: Number of threads
* `n_memory`: Memory in GB
* `workdir`: Working directory for outputs
* `auto_save`: Save intermediate objects (true/false)

### 3. CopyKAT

Optional module for an alternative CNV inference strategy.

### Example

```bash
nextflow run main.nf -profile singularity \
  --input_seurat_object project_cluster_object.RDS \
  --input_reference_table assets/OV_reference_table.csv \
  --project_name OV_CNV \
  -resume
```

## Annotated Object Requirement

To ensure successful CNV analysis, your input Seurat object must include one of the following annotation columns in `meta.data` and contain the minimum required cell types:

### Annotated Metadata Requirements

| **Annotation Column** | **Required Cell Types**                         | **Role**                |
| --------------------- | ----------------------------------------------- | ----------------------- |
| `azimuth_labels`      | B cell, T cell, Fibroblast, Epithelial          | Reference + Observation |
| `sctype`              | B_Plasma_Cells, T_Cells, Fibroblast, Epithelial | Reference + Observation |
| `cell_label`          | B cell, T cell, Fibroblast, Epithelial          | Reference + Observation |

> **Note:** The presence of these cell types is critical to define both reference (normal) and observation (tumor) populations.

## Configuration

Default parameters and paths can be set in `nextflow.config`. Use institutional profiles for HPC environments.

## Output

* `./<project_name>/data/infercnv`: CNV matrices and plots from inferCNV
* `./<project_name>/data/scevan`: CNV profiles and oncoheatmaps from SCEVAN
* `./<project_name>/report`: Consolidated report

## Notes on Troubleshooting

* For inferCNV HMM mode on large matrices, increase cutoff (e.g., 0.25) or use `HMM_type = "i3"` to reduce model complexity.
* Inspect logs via `.nextflow.log` and `.command.out` in work directories for failed tasks.
* Avoid missing parameters in `ext.args` block for modules like SCEVAN to prevent pipeline crashes.

## Contributing

Open issues or submit PRs for bugs, enhancements, or suggestions.

## License

This project is licensed under the GNU General Public License v3.0.

## Contact

For help and questions:

* [syedsazaidi@gmail.com](mailto:syedsazaidi@gmail.com)
* [lwang22@mdanderson.org](mailto:lwang22@mdanderson.org)
