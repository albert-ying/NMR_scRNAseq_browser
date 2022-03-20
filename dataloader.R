library(tidyverse)
library(Seurat)
library(tidyseurat)

files = dir('./processed', full.names = T)

nmes = c(
  'FACS-enriched NMR blood & marrow',
  'Unfractionated NMR bone marrow',
  'Unfractionated NMR peripheral blood',
  'Unfractionated mouse bone marrow'
)

obj.ls = map(files, readRDS)

names(obj.ls) = nmes

obj.ls[[4]]
