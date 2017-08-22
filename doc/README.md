# BasicXX
Alternatively, it can also use <a href="https://github.com/maiziex/BasicXX_One">BasicXX_One</a> by only one step.

## Dependencies:
BasicXX_One utilizes <a href="https://www.python.org/downloads/">Python3</a>, <a href="http://bio-bwa.sourceforge.net/">BWA (Align Fastqs Files)</a>, <a href="http://samtools.sourceforge.net/">SAMtools</a>, and <a href="http://broadinstitute.github.io/picard/">Picard (Remove PCR duplicates)</a>. To be able to execute the above programs by typing their name on the command line, the program executables must be in one of the directories listed in the PATH environment variable.

## Downloads:
To download referece files, go to <a href="https://support.10xgenomics.com/single-cell-gene-expression/software/downloads/latest">10X GENOMICS Website</a>, or
```
wget http://cf.10xgenomics.com/supp/cell-exp/refdata-cellranger-GRCh38-1.2.0.tar.gz
```
Click <a href="http://xinzhouneuroscience.org/wp-content/uploads/2017/08/barcode4M.fa.zip">barcode4M.fa</a> to download 10X barcode whitelist, or 
```
wget http://xinzhouneuroscience.org/wp-content/uploads/2017/08/barcode4M.fa
```

## Running The Code:
### Step 1: (Type "python BasicXX_step1.py -h" for help information)
```
python BasicXX_step1.py -l 100000000 -i ../S_24385_Lysis_2_USPD16081850_H3332CCXY_L1 -o S_24385_L1 --out_dir ../
```
```
usage: BasicXX_step1.py [-h] [--lines LINES]
                        [--input_file_prefix INPUT_FILE_PREFIX]
                        [--output_file_prefix OUTPUT_FILE_PREFIX]
                        [--out_dir OUT_DIR]

Run 10x Basic -- step1: Split raw fastqs files to multiple files, and generate
10X fastqs files

optional arguments:
  -h, --help            show this help message and exit
  --lines LINES, -l LINES
                        line number
  --input_file_prefix INPUT_FILE_PREFIX, -i INPUT_FILE_PREFIX
                        Input file prefix
  --output_file_prefix OUTPUT_FILE_PREFIX, -o OUTPUT_FILE_PREFIX
                        Output file prefix
  --out_dir OUT_DIR, -o_dir OUT_DIR
                        Directory to store outputs
```

### Step 2: (Type "python BasicXX_step2.py -h" for help information)
```
python BasicXX_step2.py -o S_24385_L1 --out_dir ../
```
```
usage: BasicXX_step2.py [-h] [--output_file_prefix OUTPUT_FILE_PREFIX]
                        [--out_dir OUT_DIR]

Run 10x Basic -- step 2: Generate Barcoded Fastqs Files

optional arguments:
  -h, --help            show this help message and exit
  --output_file_prefix OUTPUT_FILE_PREFIX, -o OUTPUT_FILE_PREFIX
                        Output file prefix
  --out_dir OUT_DIR, -o_dir OUT_DIR
                        Directory to store outputs

```

### Step 3: (Type "python BasicXX_step3.py -h" for help information)
```
python BasicXX_step3.py -o S_24385_L1 --out_dir ../
```

```
usage: BasicXX_step3.py [-h] [--output_file_prefix OUTPUT_FILE_PREFIX]
                        [--out_dir OUT_DIR]

Run 10x Basic -- step 3: Concatenate All Fastqs Files (10X fastqs files,
Barcoded fastqs files)

optional arguments:
  -h, --help            show this help message and exit
  --output_file_prefix OUTPUT_FILE_PREFIX, -o OUTPUT_FILE_PREFIX
                        Output file prefix
  --out_dir OUT_DIR, -o_dir OUT_DIR
                        Directory to store outputs
```

### Step 4: (Type "python BasicXX_step4.py -h" for help information)
```
python BasicXX_step4.py -o S_24385_L1 --out_dir ../ -r refdata-GRCh38-2.1.0/fasta/genome.fa
```

```
usage: BasicXX_step4.py [-h] [--output_file_prefix OUTPUT_FILE_PREFIX]
                        [--out_dir OUT_DIR] [--reference REFERENCE]

Run 10x Basic -- step 4: BWA(align), Picard(rmdup), Samtools(filter by qual20)

optional arguments:
  -h, --help            show this help message and exit
  --output_file_prefix OUTPUT_FILE_PREFIX, -o OUTPUT_FILE_PREFIX
                        output file prefix
  --out_dir OUT_DIR, -o_dir OUT_DIR
                        Directory to store outputs
  --reference REFERENCE, -r REFERENCE
                        Referece fasta files
```

### Step 5: (Type "python BasicXX_step5.py -h" for help information)
```
python BasicXX_step5.py -o S_24385_L1 --out_dir ../ -b barcode4M.fa --h5_dir ../qual_20/
```

```
usage: BasicXX_step5.py [-h] [--output_file_prefix OUTPUT_FILE_PREFIX]
                        [--out_dir OUT_DIR] [--h5_dir H5_DIR]
                        [--barcode_whitelist BARCODE_WHITELIST]

Run 10x Basic -- step 5: a) create fastq only for barcode, b) align barcode c)
correct barcode d) generate .h5 file

optional arguments:
  -h, --help            show this help message and exit
  --output_file_prefix OUTPUT_FILE_PREFIX, -o OUTPUT_FILE_PREFIX
                        output file prefix
  --out_dir OUT_DIR, -o_dir OUT_DIR
                        Directory to store outputs
  --h5_dir H5_DIR, -h5 H5_DIR
                        Directory to store h5 related files
  --barcode_whitelist BARCODE_WHITELIST, -b BARCODE_WHITELIST
                        Barcode white list
```

### Step 6: (Type "python BasicXX_step6.py -h" for help information)
```
python BasicXX_step6.py --h5_dir ../../qual_20/
```
```
output: report.txt
```

```
usage: BasicXX_step6.py [-h] [--h5_dir H5_DIR]

Run 10x Basic -- step 6: concatenate all h5 files and report results

optional arguments:
  -h, --help            show this help message and exit
  --h5_dir H5_DIR, -h5 H5_DIR
                        Directory to store h5 related files
```
