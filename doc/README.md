### Get raw DNMs file from other tools like TrioDeNovo, GATK and etc

## Running The Code:

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

