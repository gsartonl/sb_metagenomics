#!/usr/bin/env python 
rule ReadTrimming:
    input:
        GetPaired_input
    output:
        pairedFWD= pathTrimmed + "/{LIBRARY}_L{LANE}_R1_val_1.fq.gz",
        pairedREV= pathTrimmed + "/{LIBRARY}_L{LANE}_R2_val_2.fq.gz",
        fastqcFWD= pathTrimmed + "/fastqc_trimmed/{LIBRARY}_L{LANE}_R1_val_1_fastqc.html",
        fastqcFWDzip= pathTrimmed + "/fastqc_trimmed/{LIBRARY}_L{LANE}_R1_val_1_fastqc.zip",
        fastqcREV= pathTrimmed + "/fastqc_trimmed/{LIBRARY}_L{LANE}_R2_val_2_fastqc.html",
        fastqcREVzip= pathTrimmed + "/fastqc_trimmed/{LIBRARY}_L{LANE}_R2_val_2_fastqc.zip"
    params:
        inDir= pathRaw,
        outDir= pathTrimmed,
        mailto="garance.sarton-loheac@unil.ch",
        mailtype="BEGIN,END,FAIL,TIME_LIMIT_80",
        jobname="{LIBRARY}_{LANE}_trimming"
    resources:
        runtime_s="3600", # pareil
        mem_mb=lambda wildcards, attempt:attempt*20000, # double memory
        account='pengel_spirit'
    threads: 8
    message:"Runing trim-galore!"
    log:
        "logs/01_trimmed/ReadTrimming_{LIBRARY}_L{LANE}.txt"
    conda:
        "envs/01_trimGalore.yaml"
    shell:
        "scripts/01_trimGalore.sh {input} {params.inDir} {params.outDir} > {log}"


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
    threads: 8
    message:"Merging the reads"
    log: "logs/01_trimmed/ReadMerging_{LIBRARY}.txt"
    shell:
        "mkdir -p {params.outDir} ; zcat {input.pathToFWD}  > {output.mergedFWD_Lanes} ; zcat {input.pathToREV} > {output.mergedREV_Lanes}"


rule removeHostReads :
    input :
        FWD= pathTrimmed + "/merged/{LIBRARY}_R1_merged.fq",
        REV= pathTrimmed + "/merged/{LIBRARY}_R2_merged.fq"
    output :
        FWD= pathNoHost + "/{LIBRARY}_R1_noHost.fq",
        REV= pathNoHost + "/{LIBRARY}_R2_noHost.fq",
        hostMapped= pathNoHost + "/{LIBRARY}_HostMapped.fq"
    params:
        refGenome=pathHostGenome,
        pathIndex=pathIndex,
        mailto="garance.sarton-loheac@unil.ch",
        mailtype="BEGIN,END,FAIL,TIME_LIMIT_80",
        jobname="{LIBRARY}_removeHostReads"
    resources:
        account='pengel_spirit',
        runtime_s="3600",
        mem_mb=lambda wildcards, attempt:30000+attempt*1000
    threads: 20
    message:"Filtering host reads"
    #conda:
    #    "envs/02_BBduk.yaml"
    log:
        "logs/02_HostReads/removeHostReads_{LIBRARY}"
    shell:
        "scripts/02_removeHostReads.sh {input.FWD} {input.REV} {output.FWD} {output.REV} {output.hostMapped} {params.refGenome} {params.pathIndex}"

rule NormalizeReads :
    input :
        FWD= pathTrimmed + "/merged/{LIBRARY}_R1_merged.fq",
        REV= pathTrimmed + "/merged/{LIBRARY}_R2_merged.fq"
    output :
        FWD= pathNoHost + "/{LIBRARY}_R1_Normalized.fq",
        REV= pathNoHost + "/{LIBRARY}_R2_Normalized.fq",
        Histogram= pathNoHost + "/{LIBRARY}_Kmer.hist",
        peaks= pathNoHost + "/{LIBRARY}_peaks.txt"
    params:
        mailto="garance.sarton-loheac@unil.ch",
        mailtype="BEGIN,END,FAIL,TIME_LIMIT_80",
        jobname="{LIBRARY}_removeHostReads"
    resources:
        account='pengel_spirit',
        runtime_s="3600",
        mem_mb=lambda wildcards, attempt:30000+attempt*1000
    threads: 30
    message:"Normalization"
    log: "logs/02_HostReads/normalizeReads_{LIBRARY}"
    conda:
        "envs/02_BBduk.yaml"
    shell:
        "scripts/02_normalizeReads.sh {input.FWD} {input.REV} {output.FWD} {output.REV} {output.Histogram} {output.peaks}"
