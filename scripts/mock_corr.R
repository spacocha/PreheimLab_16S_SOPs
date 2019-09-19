#!/usr/bin/env Rscript

mix9 = read.table("./Rfile", header =TRUE, sep="\t")
file='./corr.txt'
results=cor.test(mix9[,2], mix9[,3])
write(results$estimate, file)

