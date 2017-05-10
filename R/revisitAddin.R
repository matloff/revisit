revisitAddin <- function() {

    library(shiny)
    library(miniUI)
    library(shinyAce)
    rvinit()

    ui <- miniPage(

    gadgetTitleBar("Revisit"),
    miniContentPanel(
      stableColumnLayout(
        uiOutput("changes")
      ),
      stableColumnLayout(
        textInput("file", "Filename (w/o Branch# or .R):", value = "inst/examples/pima"),
        numericInput("loadBn", "Load Branch#", value = 0),
        numericInput("saveBn", "Save Branch#", value = 1),
        textInput("desc", "Description:")
      ),
      miniButtonBlock(
          actionButton("runb", "Run Code"),
          actionButton("saveb", "Save Code")
      ),
      aceEditor("ace", value = rvenv$currcode)
    )
  )

  server <- function(input, output, session) {

    reactiveRefactor <- reactive({

      file <- input$file
      loadBn <- input$loadBn
      desc <- input$desc
      #boundaries <- input$boundaries

      if (loadBn < 0){
          filename <- paste0(file, ".R")
      } else {
          filename <- paste0(file, ".", as.character(loadBn), ".R")
      }
      if (file.exists(filename)){
          loadb(filename)
          currcode <- paste(rvenv$currcode, collapse = '\n')
          updateAceEditor(session, "ace", value = currcode)
      }
      #return(list(refactored = rvenv$currcode, changes = 0))
      return(list(refactored = rvenv$currcode))
    })

    output$changes <- renderUI({
      spec <- reactiveRefactor()
      return(div(""))
    })

    output$ace <- renderCode({
      spec <- reactiveRefactor()
      highlightCode(session, "ace")
      paste(spec$refactored, collapse = "\n")
    })

    observeEvent(input$runb, {
        runb()
    })

    observeEvent(input$saveb, {
        currcode <- unlist(strsplit(input$ace, "\n"))
        rvenv$currcode <- currcode
        saveb(input$saveBn, input$desc)
    })

    observeEvent(input$done, {
      spec <- reactiveRefactor()
      transformed <- paste(spec$refactored, collapse = "\n")
      invisible(stopApp())
    })

  }

  viewer <- dialogViewer("Find and Replace", width = 1000, height = 800)
  runGadget(ui, server, viewer = viewer)
}
