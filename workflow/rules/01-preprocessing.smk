#!/usr/bin/env python 
#### Preprocessing ####
rule ReadTrimming:
    input:
        GetPaired_input
    output:
        pairedFWD= pathTrimmed + "/{LIBRARY}_L{LANE}_val_1.fq.gz",
        pairedREV= pathTrimmed + "/{LIBRARY}_L{LANE}_val_2.fq.gz",
        fastqcFWD= pathTrimmed + "/fastqc_trimmed/{LIBRARY}_L{LANE}_val_1_fastqc.html",
        fastqcFWDzip= pathTrimmed + "/fastqc_trimmed/{LIBRARY}_L{LANE}_val_1_fastqc.zip",
        fastqcREV= pathTrimmed + "/fastqc_trimmed/{LIBRARY}_L{LANE}_val_2_fastqc.html",
        fastqcREVzip= pathTrimmed + "/fastqc_trimmed/{LIBRARY}_L{LANE}_val_2_fastqc.zip"
    params:
        indir= pathRaw,
        outdir= pathTrimmed,
        lib="{LIBRARY}_L{LANE}",
        mailto="garance.sarton-loheac@unil.ch",
        mailtype="BEGIN,END,FAIL,TIME_LIMIT_80",
        jobname="{LIBRARY}_L{LANE}_trimming"
    resources:
        runtime_s="3600", # pareil
        mem_mb=lambda wildcards, attempt:attempt*20000, # double memory
        account='pengel_spirit'
    threads: 8
    message:"Runing trim-galore!"
    log: "logs/01_trimmed/ReadTrimming_{LIBRARY}_L{LANE}.txt"
    benchmark: "logs/benchmark/01_trimming/{LIBRARY}_{LANE}_trimming.benchmark"
    conda: "envs/01_trimGalore.yaml"
    shell:
        """
        trim_galore --cores {threads} --phred33 --basename {params.lib} --output_dir {params.outdir} --gzip --fastqc_args "--outdir "{params.outdir}"/fastqc_trimmed/" --length 80 --max_n 1 --quality 20 --paired {input} &> {log}
        """


rule mergeReadsFiles:
    input:
        unpack(merge_readsFWD_input)
    output:
        mergedFWD_Lanes= pathTrimmed + "/merged/{LIBRARY}_R1_merged.fq",
        mergedREV_Lanes= pathTrimmed + "/merged/{LIBRARY}_R2_merged.fq"
    params:
        outDir= pathTrimmed + '/merged',
        mailto="garance.sarton-loheac@unil.ch",
        mailtype="BEGIN,END,FAIL,TIME_LIMIT_80",
        jobname="{LIBRARY}_merging_lanes"
    resources:
        runtime_s="1200"
    threads: 8
    message:"Merging the reads"
    log: "logs/01_trimmed/ReadMerging_{LIBRARY}.txt"
    shell:
        "mkdir -p {params.outDir} ; zcat {input.pathToFWD}  > {output.mergedFWD_Lanes} ; zcat {input.pathToREV} > {output.mergedREV_Lanes}"

