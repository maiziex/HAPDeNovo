# HAPDeNovo: a haplotype based approach for filtering and phasing de novo mutations on barcoded linked read sequencing

## Introduction

HAPDeNovo is a software package to detect de novo mutations on barcoded linked read sequencing. We identified the major source of de novo mutation from NGS data was caused by the biased haplotype coverage. HAPDeNovo can eliminate more than 99% false positive de novo calls with the help of 10X linked read sequencing.

## Download:
```
git clone https://github.com/maiziex/HAPDeNovo.git
```
To download human reference genome, go to <a href="https://support.10xgenomics.com/genome-exome/software/downloads/latest">10X GENOMICS Website</a>, or
```
wget http://cf.10xgenomics.com/supp/genome/refdata-hg19-2.1.0.tar.gz
tar -xzvf refdata-hg19-2.1.0.tar.gz
```
## Install:
```
cd HAPDeNovo
chmod +x install.sh
./install.sh
```

## Running The Code:
##### src: the working directory
##### lib: includes all the tools needed
##### example: includes tested files if needed
##### doc: includes scripts to generate raw DNMs pool from other tools if needed

### Step 1:

Inputs are 10X fastqs files, to get `bam` files: 
```
../lib/longranger/longranger wgs --id=12878 --fastqs=NA12878.fastqs --reference=refdata-hg19-2.1.0/fasta/genome.fa 
../lib/longranger/longranger wgs --id=12891 --fastqs=NA12891.fastqs --reference=refdata-hg19-2.1.0/fasta/genome.fa  
../lib/longranger/longranger wgs --id=12892 --fastqs=NA12892.fastqs --reference=refdata-hg19-2.1.0/fasta/genome.fa   
```
Performs a multiple-sample variants call by FreeBayes or GATK.  <br />
To generate `trio_merge.vcf` by using FreeBayes: <br />
```
../lib/freebayes/bin/freebayes -f refdata-hg19-2.0.0/fasta/genome.fa ../example/NA12878_GRCh37.bam ../example/NA12891_GRCh37.bam ../example/NA12892_GRCh37.bam  > trio_merge.vcf  
```

Or to generate `trio_merge.vcf` by using GATK. For GATK, more information can be found from <a href="https://software.broadinstitute.org/gatk/documentation/tooldocs/current/org_broadinstitute_gatk_tools_walkers_haplotypecaller_HaplotypeCaller.php">here</a>.
```
java -jar ../lib/GenomeAnalysisTK/GenomeAnalysisTK.jar -T HaplotypeCaller -R refdata-hg19-2.1.0/fasta/genome.fa -I ../example/NA12878_GRCh37.bam -o child_gvcf -ERC GVCF  
java -jar ../lib/GenomeAnalysisTK/GenomeAnalysisTK.jar -T HaplotypeCaller -R refdata-hg19-2.1.0/fasta/genome.fa -I ../example/NA12891_GRCh37.bam -o parent1_gvcf -ERC GVCF  
java -jar ../lib/GenomeAnalysisTK/GenomeAnalysisTK.jar -T HaplotypeCaller -R refdata-hg19-2.1.0/fasta/genome.fa -I ../example/NA12892_GRCh37.bam -o parent2_gvcf -ERC GVCF 
java -jar ../lib/GenomeAnalysisTK/GenomeAnalysisTK.jar -T GenotypeGVCFs -R refdata-hg19-2.1.0/fasta/genome.fa -V child_gvcf -V parent1_gvcf -V parent2_gvcf -o trio_merge.vcf  
```
To split the multiple-sample vcf file:
```
../lib/vcftools/src/perl/vcf-subset -c trio_merge.vcf
```

To run phased variants call, all the precalled vcf files are generated from the previous step:
```
longranger wgs --id=NA12878 --sex=female --fastqs=NA12878.fastqs --reference=refdata-hg19-2.1.0/fasta/genome.fa --precalled=20976.vcf  
longranger wgs --id=NA12891 --sex=male --fastqs=NA12891.fastqs --reference=refdata-hg19-2.1.0/fasta/genome.fa --precalled=20971.vcf  
longranger wgs --id=NA12892 --sex=female --fastqs=NA12892.fastqs --reference=refdata-hg19-2.1.0/fasta/genome.fa --precalled=20972.vcf  
```

### Step 2: (Type "python3 HAPDeNovo_step2.py -h" for more information)
```
python3 HAPDeNovo_step2.py --child_vcf ../example/NA12878_phased_variants.vcf.gz --parent1_vcf ../example/NA12891_phased_variants.vcf.gz --parent2_vcf ../example/NA12892_phased_variants.vcf.gz --chr_start 1 --chr_end 22 --out_dir ../output/
```

--child_vcf: "NA12878_phased_variants.vcf.gz" is the phased gzipped vcf file of the child generated by Long Ranger from step 1. <br />
--parent1_vcf: "NA12891_phased_variants.vcf.gz" is the phased gzipped vcf file of the first parent generated by Long Ranger from step 1. <br />
--parent2_vcf: "NA12892_phased_variants.vcf.gz" is the phased gzipped vcf file of the second parent generated by Lon gRanger from step 1. <br />
--chr_start: "1" specifies chromosome starting from 1.  <br />
--chr_end: "22" specifies chromosome ending by 22.   <br />
--out_dir: "../output/" specifies the customized folder name for output results. <br />



### Step3: (Type "pythons HAPDeNovo_step3.py -h" for more information)  
##### For large memory server, chromosomes can be processed by multi-threading, and for small memory server, chromosome is suggested to be processed one by one. This step is time consuming.
```
python3 HAPDeNovo_step3.py --child NA12878 --parent1 NA12891 --parent2 NA12892 --child_id 20976 --parent1_id 20971 --parent2_id 20972 --child_bam ../example/NA12878_GRCh37.bam --parent1_bam ../example/NA12891_GRCh37.bam --parent2_bam ../example/NA12892_GRCh37.bam --reference refdata-hg19-2.1.0/fasta/genome.fa --chr_start 1 --chr_end 1 --out_dir ../output/
```

--child: "NA12878" is the origin sample id of the child.  <br />
--parent1: "NA12891" is the origin sample id of the first parent.  <br />
--parent2: "NA12892" is the origin sample id of the second parent.  <br />
--child_id: "20976" is the sample id from the header of the bam file for child. To check this sample id, you can use <a href="https://github.com/maiziex/HAPDeNovo/tree/master/src">/src/Check_sampleID.py</a> <br />
--parent1_id: "20971" is the sample id from the header of the bam file for the first parent. To check this sample id, you can use <a href="https://github.com/maiziex/HAPDeNovo/tree/master/src">/src/Check_sampleID.py</a> <br />
--parent2_id: "20972" is the sample id from the header of the bam file for second parent. To check this sample id, you can use <a href="https://github.com/maiziex/HAPDeNovo/tree/master/src">/src/Check_sampleID.py</a> <br />
--child_bam: "NA12878_GRCh37.bam" is the bam file of the child. <br />
--parent1_bam: "NA12891_GRCh37.bam" is the bam file of the first parent. <br />
--parent2_bam: "NA12892_GRCh37.bam" is the bam file of the second parent. <br />
--reference: "refdata-hg19-2.1.0/fasta/genome.fa" is the reference as before. <br />
--chr_start: "1" specifies chromosome starting from 1.  <br />
--chr_end: "1" specifies chromosome ending by 1.   <br />
--out_dir: "../output/" specifies the customized folder name for output results. <br />


### Run HAPDeNovo_final.py: (Type "python3 HAPDeNovo_final.py -h" for more information)

```
python3 HAPDeNovo_final.py --chr_start 1 --chr_end 22 --child_id 20976 --parent1_id 20971 --parent2_id 20972 --out_dir ../output/ --output_file_prefix HAPDeNovo_filer1_result --depth 1 --input_file ../example/trio_merge.vcf
```
--chr_start: "1" specifies chromosome starting from 1.  <br />
--chr_end: "22" specifies chromosome ending by 22.   <br />
--child_id: "20976" is the sample id from the header of the bam file for child.  <br />
--parent1_id: "20971" is the sample id from the header of the bam file for first parent. <br />
--parent2_id: "20972" is the sample id from the header of the bam file for second parent.  <br />
--out_dir: "../output/" specifies the customized folder name for output results. <br />
--output_file_prefix: "denovo_triodenovo_depth15_HAPDeNovo_filer1" is the user customized file name for final de novo mutation output. <br />
--depth: "1" specifies the depth filter by 1. <br />
--input_file: "trio_merge.vcf" is the variant call file from FreeBayes (default). This input can also be the de novo results from other tools like GATK/TrioDenovo/DeNovoGear  (check <a href="https://github.com/maiziex/HAPDeNovo/tree/master/doc">doc</a> <br />), or any user customized txt file for de novo muations. This text file only needs to contain chromose name and the corresponding locus per row for each de novo mutation. <br />



#### The output format of HAPDeNovo:
```
Chr	Locus	      REFALTchild_GTparents1_GTparents2_GTConfidence
chr15	21173525	C	T	0|1	0|0	0|0	H
chr15	22659065	G	A	0|1	0|0	0|0	L
chr15	32590720	C	G	1|0	0|0	0|0	L
chr15	33183990	C	T	0|1	0|0	0|0	H
chr15	50953965	A	C	1|0	0|0	0|0	H
chr15	51248561	C	T	0|1	0|0	0|0	H
chr15	52560491	G	A	0/1	0|0	0|0	L
chr15	58149075	T	A	1|0	0|0	0|0	H
chr15	58669774	T	C	0|1	0|0	0|0	H
chr15	63727259	C	A	0/1	0|0	0|0	L
chr15	64217272	T	G	0/1	0|0	0|0	L
chr15	74880589	A	G	1|0	0|0	0|0	H
chr15	83299364	A	C	0|1	0|0	0|0	L
chr15	83299956	T	A	0|1	0|0	0|0	L
chr15	83305550	A	G	0|1	0|0	0|0	L
chr15	83307063	T	A	0|1	0|0	0|0	L
chr15	83319622	G	C	0|1	0|0	0|0	L
chr15	83323255	C	G	0|1	0|0	0|0	L
chr15	83336872	C	T	0|1	0|0	0|0	L
chr15	83358339	C	T	0|1	0|0	0|0	L
chr15	83361080	C	A	0|1	0|0	0|0	L
chr15	83386567	C	T	0|1	0|0	0|0	L
chr15	83389209	T	C	0|1	0|0	0|0	H
chr15	83450721	C	T	0|1	0|0	0|0	L
chr15	83457052	G	A	0|1	0|0	0|0	L
chr15	85056658	C	T	1|0	0|0	0|0	L
chr15	85715561	C	T	0|1	0|0	0|0	H
chr15	87791919	T	C	1|0	0|0	0|0	H
chr15	99175976	A	G	0|1	0|0	0|0	H
chr15	100884734	A	G	0/1	0|0	0|0	L
```

