workflow coverage {
	call Coverage 
	meta {
		author: "Sehyun Oh"
        email: "shbrief@gmail.com"
        description: "Coverage.R of PureCN: Calculate and GC-normalize coverage from a BAM file"
    }
}

task Coverage {
	File bam
	File bai
	File intervals
	String BAM_pre = basename(bam, ".bam")
	String outdir   # .
	String pcn_extdata

	# Runtime parameters
	Int? machine_mem_gb
	Int? disk_space_gb
	Int disk_size = ceil(size(bam, "GB")) + 20

	command <<<
		Rscript ${pcn_extdata}/Coverage.R \
		--outdir ${outdir} \
		--bam ${bam} \
		--intervals ${intervals}
	>>>

	runtime {
		docker: "quay.io/shbrief/pcn_docker"
		cpu : 2
		memory: "32 GB"
    	disks: "local-disk " + select_first([disk_space_gb, disk_size]) + " SSD"
	}
	
	output {
		File png = "${BAM_pre}_coverage_loess.png"
		File qc = "${BAM_pre}_coverage_loess_qc.txt"
		File loess = "${BAM_pre}_coverage_loess.txt"
		File cov = "${BAM_pre}_coverage.txt"
	}
}