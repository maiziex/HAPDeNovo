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
output: denovo_triodenovo_depth15_DQ7.txt can be used for HAPDeNovo
```
usage: Preprocess_triodenovo_results.py [-h] [--input_file INPUT_FILE]
                                        [--output_file OUTPUT_FILE]
                                        [--child_id CHILD_ID]
                                        [--parent1_id PARENT1_ID]
                                        [--parent2_id PARENT2_ID]

This Script Is Used for Preprocessing DeNovo Mutations from TrioDeNovo

optional arguments:
  -h, --help            show this help message and exit
  --input_file INPUT_FILE, -i INPUT_FILE
                        input filename
  --output_file OUTPUT_FILE, -o OUTPUT_FILE
                        output filename
  --child_id CHILD_ID, -c CHILD_ID
                        child id
  --parent1_id PARENT1_ID, -p1 PARENT1_ID
                        parent1 id
  --parent2_id PARENT2_ID, -p2 PARENT2_ID
                        parent2 id
```

