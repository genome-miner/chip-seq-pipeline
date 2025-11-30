# Installation of SRA data
wget https://sra-pub-run-odp.s3.amazonaws.com/sra/SRR2155470/SRR2155470

# Conversion of SRA data to fastq file
fastq-dump --split-files SRR2155470

# Quality check and removing adapters
fastp -i SRR2155470_1.fastq -o SRR2155470_trimmed.fastq -j json.report -h report.html 

# Download reference genome
From NCBI Genome

# Indexing of reference genome
bwa index genomic.fna

# Align the fastq with genome
bwa mem genomic.fna SRR2155470_trimmed.fastq -o SRR2155470.sam

# SAM file to BAM file
samtools view -bS SRR2155470.sam > SRR2155470.bam

# Sorting of BAM file
samtools sort SRR2155470.bam -o SRR2155470_sorted.bam

# Indexing of sorted SAM
samtools index SRR2155470_sorted.bam

# Filtering of quality reads
samtools view -q 30 -b SRR2155470_sorted.bam > SRR2155470_q30.bam

# Indexing of filtered file
samtools index SRR2155470_q30.bam

# Peak callin  via Macs2 tool
macs2 callpeak -t SRR2155470_q30.bam -f BAM -g 1.2e7 -n macs-myeast -- outdir macs2_output

# Download Homer tool
wget http://homer.ucsd.edu/homer/configureHomer.pl
perl configureHomer.pl -install
export HOMER_HOME=~/path
export PATH=SHOMER_HOME/bin:$PATH
export PERL5LIB=$HOMER_HOME/lib:$PERL5LIB
which annotatePeaks.pl
homer2

# Download reference genome (available in Homer)
perl configureHomer.pl -install sacCer3

# Peak annotation
annotatePeaks.pl macs-myeast_summits.bed sacCer3 > annotate_peaks.txt

# Motifs discovery
findMotifsGenome.pl macs-myeast_summits.bed sacCer3 motifs/
