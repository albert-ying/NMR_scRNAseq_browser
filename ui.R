library(shiny)
library(tidyverse)
library(reticulate)
library(glue)
library(DT)
library(shinythemes)
library(shinyWidgets)
library(fullPage)
library(typed)
# - The UI -----------
ui = function() {
  tagList(
    tags$head(
      # golem::activate_js(),
      # golem::favicon(),
      tags$link(rel = "stylesheet", href = shinythemes::shinytheme("simplex")),
      # tags$link(rel = "stylesheet", type = "text/css", href = "css/style.css"),
      tags$script(async = NA, src = "https://www.googletagmanager.com/gtag/js?id=UA-74544116-1"),
      tags$script(
        "window.dataLayer = window.dataLayer || [];
    function gtag(){dataLayer.push(arguments);}
    gtag('js', new Date());
    gtag('config', 'UA-74544116-1');"
      )
    ),
    pagePiling(
      sections.color = c("#000000", "white", "white"),
      opts = list(direction = "horizontal", touchSensitivity = 0.1, parallax = T, scrollBar = T, scrollHorizontally = T, normalScrollElementTouchThreshold = 0, normalScrollElements = ".shiny-input-container"),
      # - Menu --------------
      menu = c(
        "Welcome" = "section1",
        "Single Cell Atlas" = "section2",
        "About" = "section3"
      ),
      # - Page 1 UI -------------------
      pageSectionImage(
        menu = "section1",
        center = T,
        img = "http://www.pbs.org/wgbh/rare/wp-content/uploads/2017/06/rare_e1_naked-mole-rat_3x2_3.jpg",
        pageRow(
          column(5,
            offset = 1,
            h1("Naked Mole-Rat single-cell hematopoietic landscape", class = "header shadow-dark")
          )
        )
      ),
      # - Page 2 UI --------------
      pageSection(
        menu = "section2",
        center = TRUE,
        # img = "http://www.pbs.org/wgbh/rare/wp-content/uploads/2017/06/rare_e1_naked-mole-rat_3x2_3.jpg",
        pageRow(
          # * Sidebar panel for inputs ----
          sidebarPanel(
            collapsed = TRUE,
            # helpText("Example dataset will be loaded if no file is uploaded"),
            # Horizontal line ----
            # Input: Checkbox if file has header ----
            # checkboxInput("m_age_include", "Meta data contains the age?", TRUE),
            ## Single cell dataset
            selectInput(
              "scdat", "Dataset", c(
                'FACS-enriched NMR blood & marrow' = 1,
                'Unfractionated NMR bone marrow' = 2,
                'Unfractionated NMR peripheral blood' = 3,
                'Unfractionated mouse bone marrow' = 4
              )
            ),
            selectInput(
              "plot_type", "Plot type", c(
                "UMAP plot" = "UMAP",
                "Gene expression" = "gep"
              ),
            ),
            # input color by
            selectInput(
              "color_by", "Color by", c(
                "Cell type" = "celltype",
                "Tissue" = "tissue",
                "Gene expression" = "gene",
                "Age" = "ontogeny",
                "Phase",
                "sort"
              ),
            ),
            uiOutput("gene_select"),
            width = 2,
            # submitButton("Submit", icon("upload")),
            helpText("It will take a few seconds to compute after changing"),
          ),
          # * main panel with data table
          mainPanel(
            pageRow(
              column(
                11,
                plotOutput("umap", height = 750)
              )
            ),
            width = 10
            # Download the output
            # downloadButton('download',"Download the result"),
          )
        )
      ),
      # - Page 3 UI -------------------
      pageSectionImage(
        menu = "section3",
        center = T,
        img = "http://www.pbs.org/wgbh/rare/wp-content/uploads/2017/06/rare_e1_naked-mole-rat_3x2_3.jpg",
        pageRow(
          column(10, offset = 1, style = "background-color:#ffffffCC;",
            span(htmltools::includeMarkdown("www/about.md"))
          )
        )
      )
    )
  )
}
