library(dplyr)

pth = '../../data/2019-02-15-pptc_rnaseq_hg38_matrix_244.RData'
exp <- load(pth)

pth <- '../../data/pdx-TPM-2019-02-15.tsv'
write.table(pptc.rna, file=pth, sep='\t', row.names=TRUE)