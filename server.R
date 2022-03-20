library(shiny)
library(tidyverse)
library(fullPage)
library(typed)
library(glue)
library(hrbrthemes)
library(ggsci)
library(ggtext)
library(ggthemes)
library(tidymodels)
require(magrittr)
library(plotly)
library(ohmyggplot)
source("dataloader.R")

ohmyggplot::oh_my_ggplot()
# colorkey = read_csv("dataset/SHINY_scRNASeq_anno.csv") |>
#   select(CLUSTER, COLOR, CELL_TYPE) |>
#   group_by(CLUSTER) |>
#   slice(1) |>
#   ungroup()

server = function(input, output, session) {
  ## get requested seurat object

  seu_obj = reactive({
    req(input$scdat)
    obj.ls[[as.numeric(input$scdat)]]
  })
  
  ## Get gene list
  output$gene_select = renderUI({
    selectInput(
      "target_gene",
      "Select gene of interest",
      choices = rownames(GetAssayData(seu_obj(), assay = "RNA", slot = "data"))
    )
  })

  output$umap = renderPlot({
    tb = seu_obj() |>
      tidyseurat::as_tibble() |>
      mutate(celltype = fct_reorder(factor(celltype), celltype.combi.num))
    if (input$plot_type == "UMAP") {
      if (! input$color_by %in% c("gene")) {
        p = tb |>
          ggplot(aes(UMAP_1, UMAP_2)) +
          geom_point(aes_string(color = input$color_by), alpha = 0.6, shape = 16, size = 0.5) +
          theme_void() +
          # paletteer::scale_color_paletteer_d("ggthemes::Classic_20") +
          guides(color = guide_legend(override.aes = list(shape = 16, size = 2))) +
          theme(legend.position = "top")

        if (input$color_by == "celltype"){
          p = p + 
            scale_fill_manual(values = tb |> arrange(celltype.combi.num) |> pull(color) |> unique()) +
            scale_color_manual(values = tb |> arrange(celltype.combi.num) |> pull(color) |> unique())
        }
        # p = ggplotly(p)
      } else if ('Seurat' %in% class(seu_obj())) {
        gene_vec = GetAssayData(seu_obj(), assay = "RNA", slot = "data")[input$target_gene, ]
        p = tb |>
          mutate(gene = gene_vec) |>
          ggplot(aes(UMAP_1, UMAP_2)) + 
          geom_point(aes(color = gene), alpha = 0.6, shape = 16, size = 0.5) +
          labs(color = input$target_gene) +
          theme_void() +
          better_color_legend +
          theme(legend.position = "top") +
          paletteer::scale_color_paletteer_c("pals::ocean.amp")
          # scale_color_manual(tb |> arrange(celltype) |> pull(color) |> unique())
      } 
    } else if (input$plot_type == "gep" & 'Seurat' %in% class(seu_obj())) {
        gene_vec = GetAssayData(seu_obj(), assay = "RNA", slot = "data")[input$target_gene, ]
        p = tb |>
          mutate(gene = gene_vec) |>
          ggplot(aes(celltype, gene)) + 
          geom_jitter(aes_string(color = ifelse(input$color_by == "gene", "celltype", input$color_by)), alpha = 0.6, shape = 16, size = 0.5, width = 0.5, height = 0) +
          geom_violin(aes_string(fill = ifelse(input$color_by == "gene", "celltype", input$color_by)), alpha = 0.6, width = 0.8) +
          labs(color = input$target_gene, x = "", y = "Log-Normalized Expression") +
          better_color_legend +
          scale_fill_manual(values = tb |> arrange(celltype.combi.num) |> pull(color) |> unique()) +
          scale_color_manual(values = tb |> arrange(celltype.combi.num) |> pull(color) |> unique()) +
          # paletteer::scale_color_paletteer_d("ggthemes::Classic_20") +
          # paletteer::scale_fill_paletteer_d("ggthemes::Classic_20") +
          theme(legend.position = "top")
    }
    return(p)
  })
}
