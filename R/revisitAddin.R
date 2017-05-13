revisitAddin <- function() {

   library(shiny)
   library(miniUI)
   library(shinyAce)
   rvinit()

   ui <- miniPage(

      gadgetTitleBar("Revisit"),
      miniContentPanel(
         stableColumnLayout(
            uiOutput("message")
         ),
         stableColumnLayout(
            h3("")
         ),
         stableColumnLayout(
            textInput("file", "Filename (w/o Branch# or .R)", value = "inst/examples/pima"),
            numericInput("runstart", "Run Start Line", value = 1),
            numericInput("saveBn", "Save Branch#", value = 1)
         ),
         stableColumnLayout(
            numericInput("loadBn", "Load Branch#", value = 0),
            numericInput("runthru", "Run Through Line", value = -1),
            textInput("desc", "Description")
         ),
         miniButtonBlock(
            actionButton("loadb", "Load Code"),
            actionButton("runb", "Run Code"),
            actionButton("saveb", "Save Code")
         ),
         aceEditor("ace", value = "...")
      )
   )

   server <- function(input, output, session) {

      doLoad <- function(file, loadBn){
          if (loadBn < 0){
            filename <- paste0(file, ".R")
            makebranch0(filename)
         } else {
            filename <- paste0(file, ".", as.character(loadBn), ".R")
         }
         if (file.exists(filename)){
            loadb(filename)
            status <- paste(filename, "loaded")
            currcode <- paste(rvenv$currcode, collapse = '\n')
            updateAceEditor(session, "ace", value = currcode)
         } else {
            status <- paste("***** ERROR:", filename, "not found")
         }
         print(status)
      }

      reactiveLoad <- reactive({
         file <- isolate(input$file)
         loadBn <- input$loadBn
         status <- "OK"

         status <- doLoad(file, loadBn)
         return(list(loaded = rvenv$currcode, status = status))
      })

      output$message <- renderUI({
         spec <- reactiveLoad()
         return(div(spec$status))
      })

      output$ace <- renderCode({
         spec <- reactiveLoad()
         highlightCode(session, "ace")
         paste(spec$loaded, collapse = "\n")
      })

      observeEvent(input$loadb, {
         file <- input$file
         loadBn <- input$loadBn
         doLoad(file, loadBn)
      })

      observeEvent(input$runb, {
         runstart <- input$runstart
         runthru  <- input$runthru
         if (runstart < 1){
            runstart <- 1
         }
         if (runthru > length(rvenv$currcode)){
            runthru <- length(rvenv$currcode)
         }
         if (runthru < 1){
            print(paste("RUN FROM", runstart))
            runb(startline = runstart)
         }
         else{
            print(paste("RUN FROM", runstart, "THROUGH", runthru))
            runb(startline = runstart, throughline = runthru)
         }
      })

      observeEvent(input$saveb, {
         currcode <- unlist(strsplit(input$ace, "\n"))
         rvenv$currcode <- currcode
         saveb(input$saveBn, input$desc)
         print(paste("SAVE", input$saveBn, "|", input$desc))
      })

      observeEvent(input$done, {
         spec <- reactiveLoad()
         transformed <- paste(spec$loaded, collapse = "\n")
         invisible(stopApp())
      })

   }

   viewer <- dialogViewer("Find and Replace", width = 1000, height = 800)
   runGadget(ui, server, viewer = viewer)
}
