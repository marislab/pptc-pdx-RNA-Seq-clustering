## PPTC PDX RNA-Seq Clustering

1. Generate input for Stan multilevel model
	- Extract expression data from RDS file
	- Run make-stan-input-v8-2019-07-30.ipynb

2. Build Stan code 
	- Refer to the Stan documentation for instruction: https://github.com/stan-dev/cmdstan/releases/download/v2.20.0/cmdstan-guide-2.20.0.pdf
	- make </path to multilevel-pdx-model-v8.stan> 

3. Run Stan model
	- ./multilevel-stan-v8 variatonal data file=</path to dump> output file = </path to output> 

4. Extract parameters of interest 
	- `cat stan-data-v8.output | grep -m 1 lp__ | tr ',' '\n' | cat -n | grep -P "d\." | cut -f 1 > stan-data-v8-columns`
	- `cat stan-data-v8.output | grep -v "#" | cut -d ',' -f <start>-<stop> > stan-data-v8.disease_effect`
	- This file can be quite large, so I load it into ipython using pandas and convert it to hd5 format. This makes downstream analysis run a lot faster.

5. Prepare parameters for GSEA 
	- Run analyze-post-stan-v8-2019-07-31.ipynb

6. GSEA anaysis
	- Run fgsea-analysis-stan-v8-tiger-2018-07-31.ipynb


