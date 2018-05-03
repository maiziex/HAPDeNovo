### Get raw DNMs file from other tools like TrioDeNovo, GATK and etc

#### 1. Run TrioDeNovo, more info about TrioDeNovo, check it's  <a href="http://genome.sph.umich.edu/wiki/Triodenovo">website</a>:

```
../lib/triodenovo/bin/triodenovo --ped trio.ped  --in_vcf ../example/trio_merge.vcf --out_vcf trio.denovo.vcf_depth15_DQ7.out --minDepth 15 --minDQ 7
```
--in_vcf: "trio_merge.vcf" is variant calling format file from FreeBayes. <br />


#### 2. Preprocess TrioDeNovo result file for HAPDeNovo:
#### (Type "python Preprocess_triodenovo_results.py -h" for help information)
```
python3 Preprocess_triodenovo_results.py -i trio.denovo.vcf_depth15_DQ7.out -o denovo_triodenovo_depth15_DQ7.txt --child_id 20976 --parent1_id 20971 --parent2_id 20972
```
--input_file: "trio.denovo.vcf_depth15_DQ7.out" is the file generated from TrioDeNovo.<br />
--output_file: "denovo_triodenovo_depth15_DQ7.txt" can be used for HAPDeNovo. <br />

### Or
#### Preprocess GATK result file for HAPDeNovo:
#### (Type "python Preprocess_GATK_results.py -h" for help information)
```
python3 Preprocess_GATK_results.py -i ../example/trio_merge_byGATK.vcf -o denovo_gatk_DP15_PL450.txt --depth 15 --PL 450 --child_id 20976 --parent1_id 20971 --parent2_id 20972
```
--input_file: "trio_merge_byGATK.vcf" is variant calling format file from GATK. <br />
--output_file: "denovo_gatk_DP15_PL450.txt" can be used for HAPDeNovo. <br />

### Or
#### 1. Run DeNovoGear, more info about DeNovogear, check it's  <a href="https://github.com/denovogear/denovogear">website</a>:

```
../lib/denovogear/bin/dng dnm auto --ped family.ped --rd_cutoff 15 --pp_cutoff 0.00003 --vcf trio_merge_byGATK.vcf --output_vcf $output
```
--in_vcf: "trio_merge_byGATK.vcf" is variant calling format file from GATK. <br />

