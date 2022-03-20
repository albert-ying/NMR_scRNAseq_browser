library(tidyverse)
library(Seurat)
library(tidyseurat)

full_color = read_csv("dataset/SHINY_scRNASeq_anno.csv")

## dataset 1 FACS-enriched NMR blood & marrow ----

load("./dataset/NMR.BM123PB.meta.UMAP.colors.RData")

ds1_color = color.clusters.NOmp
ds1_meta = NMR.BM123PB.metadata.UMAP |>
  as_tibble()

load("dataset/Seurat_hgl_sorted_BM.RData")

color_tb = tibble(celltype.combi = names(ds1_color), color = ds1_color)

new_seu = S.NOmp |>
  select(.cell) |>
  DietSeurat() |>
  inner_join(ds1_meta, by = c('.cell' = "Row.names")) |>
  inner_join(color_tb) |>
  mutate(celltype = celltype.combi, ontogeny = "Not available", cryo = "Not available", sex = "Not available")

write_rds(new_seu, "processed/hgl_BM_sorted.rds")

## dataset 2 Unfractionated NMR peripheral blood ----
load("./new_dataset/NMR.PB.S.NOmp.RData")
load("./new_dataset/NMR.PB.counts.RData")

color_tb = tibble(celltype = names(color.clusters.NOmp), color = color.clusters.NOmp)
seu = CreateSeuratObject(NMR.PB.counts, meta.data = column_to_rownames(PB.metadata.UMAP, "Row.names"))

new_seu = seu |>
  inner_join(color_tb) |>
  mutate(sort = "Not avalible")

distinct(new_seu, celltype.combi.num, celltype)

write_rds(new_seu, "processed/hgl_PB_whole.rds")

## dataset 3 Unfractionated NMR bown marrow
# load("dataset/Seurat_hgl_whole_BM.RDta")
load("new_dataset/NMR.BM.counts.RData")
load("new_dataset/NMR.BM.S.NOmp.RData")

color_tb = tibble(celltype = names(color.clusters.NOmp), color = color.clusters.NOmp) |>
  mutate(celltype.combi.num = row_number())
ds_meta = as_tibble(S.NOmp) |>
  select(-starts_with("PC"))
head(NMR.BM.meta)
head(color.clusters.NOmp)

new_seu = S.NOmp |>
  select(.cell) |>
  DietSeurat() |>
  inner_join(ds_meta) |>
  inner_join(color_tb) |>
  mutate(cryo = "Not available", sex = "Not available", sort = "Not available")
write_rds(new_seu, "processed/hgl_BM_whole.rds")

## dataset 4 Unfractionated NMR bown marrow
load("new_dataset/MOUSE.BM.S.NOmp.RData")

color_tb = tibble(celltype = names(color.clusters.NOmp), color = color.clusters.NOmp)
ds_meta = as_tibble(S.NOmp) |>
  select(-starts_with("PC"))

new_seu = S.NOmp |>
  select(.cell) |>
  DietSeurat() |>
  inner_join(ds_meta) |>
  inner_join(color_tb) |>
  mutate(cryo = "Not available", sex = "Not available", sort = "Not available") |>
  select(everything(), celltype.combi.num = celltype.num)

write_rds(new_seu, "processed/mmu_BM_whole.rds")

cols = c("celltype", "Phase", "sort", "ontogeny", "cryo", "sex")
S.NOmp |> str()

## Class checker for server
'Seurat' %in% class(new_seu)
'tbl' %in% class(color_tb)
