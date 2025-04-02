# Assemblies
# @gsartonl
# 09-11-2022

rule assemblyMetaspades:
    input:
        FWD=rules.removeHostReads.output.FWD,
        REV=rules.removeHostReads.output.REV
    output:
        outdir=directory(workDir + ''.join(config['assembly']['outDir'])+ "/{LIBRARY}")
    params:
        inDir=pathTrimmed + '/merged',
    resources:
        account='pengel_spirit',
        runtime_s="86400", # = 24h
        mem_mb=lambda wildcards, attempt:700000+attempt*10000
    threads: 16
    log: "logs/03_assembly/{LIBRARY}_assembly"
    benchmark: "logs/benchmark/03_assembly/{LIBRARY}_assembly.benchmark"
    conda: "envs/03_SPAdes.yaml"
    shell:
        "scripts/03_metaspades.sh {output.outdir} {input.FWD} {input.REV} {resources.mem_mb}"

rule assemblyNorm:
    input:
        FWD= pathNoHost + "/{LIBRARY}_R1_Normalized.fq",
        REV= pathNoHost + "/{LIBRARY}_R2_Normalized.fq"
    output:
        outdir=directory(workDir + ''.join(config['assembly']['outDir'])+ "/{LIBRARY}_norm")
    params:
        inDir=pathTrimmed + '/merged',
    resources:
        account='pengel_spirit',
        runtime_s="86400",
        mem_mb=lambda wildcards, attempt:700000+attempt*10000
    threads: 30
    message:"Metaspades assembly"
    log: "logs/03_assembly/{LIBRARY}_assemblyNorm"
    benchmark: "logs/benchmark/03_assembly/{LIBRARY}_assemblyNorm.benchmark"
    conda: "envs/03_SPAdes.yaml"
    shell:
        "scripts/03_a1_metaspades.sh {output.outdir} {input.FWD} {input.REV} {resources.mem_mb}"

# rule assemblyMegahit:
#     input:
#         FWD=rules.NormalizeReads.output.FWD,
#         REV=rules.NormalizeReads.output.REV
#     output:
#         outdir=directory(workDir + ''.join(config['assembly']['outDir'])+ "/{LIBRARY}_MEGAHIT")
#     params:
#         inDir=pathTrimmed + '/merged',
#     resources:
#         account='pengel_spirit',
#         runtime_s="86400",
#         mem_mb=lambda wildcards, attempt:700000+attempt*10000
#     threads: 16
#     message:"MEGAHIT assembly"
#     log: "logs/03_assembly/{LIBRARY}_assemblyMEGAHIT"
#     benchmark: "logs/benchmark/03_assembly/{LIBRARY}_assemblyMEGAHIT.benchmark"
#     conda: "envs/03_MEGAHIT.yaml"
#     shell:
#         "scripts/03_a2_MEGAHIT.sh {output.outdir} {input.FWD} {input.REV} {resources.mem_mb}"


rule scaffoldFiltering:
    input:
        assembly='03_assembly/{LIBRARY}/scaffolds.fasta',
        assemblyNorm='03_assembly/{LIBRARY}_norm/scaffolds.fasta'
    output:
        assemblyFiltered='03_assembly/scaffoldsFiltered/{LIBRARY}/{LIBRARY}_scaffolds_min500bp.fasta',
        assemblyNormFiltered='03_assembly/scaffoldsFiltered/{LIBRARY}_norm/{LIBRARY}_norm_scaffolds_min500bp.fasta'
    params:
        minlen=minlen_scaffold_trimming
    resources:
        account='pengel_spirit',
        runtime_s="600",
        mem_mb=lambda wildcards, attempt:700+attempt*10000
    threads: 1
    message: "Filtering Scaffolds <500bp"
    log: "logs/03_assembly/{LIBRARY}_scaffoldFiltering_500bp"
    benchmark: "logs/benchmark/03_assembly/{LIBRARY}_scaffoldFiltering_500bp.benchmark"
    shell:
        "scripts/03_a2_scaffoldFiltering.sh {input.assembly} {input.assemblyNorm} {output.assemblyFiltered} {output.assemblyNormFiltered} {params.minlen}"

rule assemblyStats:
    input:
        assembly='03_assembly/{LIBRARY}/scaffolds.fasta',
        assemblyNorm='03_assembly/{LIBRARY}_norm/scaffolds.fasta',
        assemblyFiltered='03_assembly/scaffoldsFiltered/{LIBRARY}/{LIBRARY}_scaffolds_min500bp.fasta',
        assemblyFilteredNorm='03_assembly/scaffoldsFiltered/{LIBRARY}_norm/{LIBRARY}_norm_scaffolds_min500bp.fasta'
    output:
        stats='03_assembly/03_stats/{LIBRARY}/{LIBRARY}_scaffolds_min500bp.stats'
    params:
        minlen=minlen_scaffold_trimming
    resources:
        account='pengel_spirit',
        runtime_s="2400",
        mem_mb=lambda wildcards, attempt:1000+attempt*10000
    threads: 1
    message:"Computing assembly stats"
    log: "logs/03_assembly/{LIBRARY}_assemblyStats"
    benchmark: "logs/benchmark/03_assembly/{LIBRARY}_assemblyStats.benchmark"
    conda:
        "envs/03_assemblyStats.yaml"
    shell:
        "scripts/03_a3_assemblyStats.sh {input} {output}"
