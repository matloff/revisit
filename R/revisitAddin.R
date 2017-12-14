
# RStudio add-in code

# author:  Reed Davis


revisitAddin <- function() {

   library(shiny)
   library(miniUI)
   library(shinyAce)
   library(shinythemes)
   rvinit()
   rv <- reactiveValues()
   rv$statusmsg <- ""

   ui <- miniPage(
      #includeCSS("R/revisit.css"),
      tags$style(type = "text/css",
                 "label { padding: 0px; font-size: 20px }",
                 ".btn { padding: 0px; font-size: 20px }",
                 ".form-control { padding: 4px; font-size: 20px }",
                 ".form-group { padding: 0px; font-size: 20px }",
                 "#ace { font-weight: bold }",
                 "#cancel { padding: 0px; font-size: 16px }",
                 "#done { padding: 0px; font-size: 16px }",
                 "#message { padding: 0px; font-size: 20px }"
      ),
      #shinythemes::themeSelector(),
      theme = shinytheme("united"),
      gadgetTitleBar("Revisit"),
      miniContentPanel(
         fluidRow(
            div(class = "col-xs-4 col-md-4",
                selectInput("cases", "Case Studies",
                            choices = "Pima diabetes study",
                            selected = "Pima diabetes study")
            ),
            div(class = "col-xs-8 col-md-8",
               textInput("desc", "Description", width = "760px")
            )
         ),
         stableColumnLayout(
            textInput("file", "Filename (w/o Branch# or .R)", value = "Pima/pima"),
            numericInput("runstart", "Run Start Line", value = 1),
            numericInput("saveBn", "Save Branch #", value = 1)
         ),
         stableColumnLayout(
            numericInput("loadBn", "Load Branch #", value = 0),
            numericInput("runthru", "Run Through Line", value = -1),
            textInput("username", "Username", value =  "e.g. LastName, FirstName") # username here and force a userID
         ),
         miniButtonBlock(
            actionButton("loadb", "Load Code"),
            actionButton("nxt",   "Next"),
            actionButton("runb",  "Run/Continue"),
            actionButton("saveb", "Save Code")
         ),
         htmlOutput("message"),
         aceEditor("ace", value = "...",mode='r', fontSize = 20),
         stableColumnLayout(
            numericInput("aceFontSize", "Editor Font Size", value = 20),
            numericInput("pcount", "P-value Count", value = 0)
      	 )
      )
   )

   server <- function(input, output, session) {

      startOfSession <- TRUE
      loadBn_succ <- NULL
      caselist <- NULL
      casepath <- system.file("CaseStudies", package="revisit")
      if (casepath == ""){
         status <- paste("***** ERROR: system.file(\"CaseStudies\", package=\"revisit\") returned an empty string")
         rv$statusmsg <<- status
         print(status)
      }
      else{
         casefile <- paste0(casepath, "/CaseStudyList.txt")
         if (file.exists(casefile)){
            caselist <- read.csv(casefile, strip.white = TRUE, sep = ",")
            updateSelectInput(session, "cases", choices = caselist$label, selected = caselist$label[caselist$n == 1])
         }
         else{
            status <- paste("***** ERROR:", casefile, "not found")
            rv$statusmsg <<- status
            print(status)
         }
      }

      doLoad <- function(file, loadBn){
         if (loadBn < 0){
            filename <- paste0(file, ".R")
         } else if (loadBn == 0){
            filename <- paste0(file, ".0.R")
            # always recreate the .0.R file
            filename0 <- paste0(file, ".R")
            pathfilename0 <- paste0(casepath,"/",filename0)
            if (file.exists(pathfilename0)){
               makebranch0(pathfilename0)
            }
         } else {
            filename <- paste0(file, ".", as.character(loadBn), ".R")
         }
         pathfilename <- paste0(casepath,"/",filename)
         if (file.exists(pathfilename)){
            loadb(pathfilename)
            loadBn_succ <<- loadBn
            status <- paste(filename, "loaded")
            currcode <- paste(rvenv$currcode, collapse = '\n')
            updateAceEditor(session, "ace", value = currcode, fontSize = input$aceFontSize)
            updateNumericInput(session, "runstart", value = 1)
            updateNumericInput(session, "runthru",  value = length(rvenv$currcode))
            nextBn <- loadBn + 1
            filename <- paste0(file, ".", as.character(nextBn), ".R")
            pathfilename <- paste0(casepath,"/",filename)
            while (file.exists(pathfilename)){
               nextBn <- nextBn + 1
               filename <- paste0(file, ".", as.character(nextBn), ".R")
               pathfilename <- paste0(casepath,"/",filename)
            }
            updateNumericInput(session, "saveBn",  value = nextBn)
         } else {
            if (!startOfSession){
               if (loadBn == 0){
                  status <- paste("***** ERROR:", pathfilename, "and", filename0, "not found")
               } else {
                  status <- paste("***** ERROR:", pathfilename, "not found")
               }
            } else {
               startOfSession <<- FALSE
               #status <- "" # don't overwrite startup error
            }
         }
         rv$statusmsg <<- status
         print(status)
      }

      reactiveLoad <- reactive({
         file <- isolate(input$file)
         loadBn <- input$loadBn
         doLoad(file, loadBn)
         return(list(loaded = rvenv$currcode))
      })

      output$pcount <- renderText({
         rvenv$pcount
      })

      output$message <- renderText({
         spec <- reactiveLoad()
         if (substring(rv$statusmsg, 1, 1) == "*"){
            msg <- paste0("<b><font color=\"red\">", rv$statusmsg, "</font></b>")
         } else {
            msg <- paste0("<b>", rv$statusmsg, "</b>")
         }
         msg
      })

      output$ace <- renderCode({
         spec <- reactiveLoad()
         highlightCode(session, "ace")
         paste(spec$loaded, collapse = "\n")
      })

      observeEvent(input$cases, {
         cases <- input$cases
         file <- caselist$file[caselist$label == cases]
         desc <- caselist$desc[caselist$label == cases]
         updateTextInput(session, "desc", value = desc)
         updateTextInput(session, "file", value = file)
         doLoad(file, 0)
      })

      observeEvent(input$loadb, {
         file <- input$file
         loadBn <- input$loadBn
         doLoad(file, loadBn)
      })

      observeEvent(input$nxt, {
         rvenv$currcode <- unlist(strsplit(input$ace, "\n")) # update currcode
         rvenv$pc <- input$runstart
         rc <- try(
            nxt()
         )
         if (class(rc) == 'try-error'){
            rv$statusmsg <- "***** RUN ERROR: see error message in console"
         } else {
            rv$statusmsg <- paste("RUN", input$runstart)
            if (input$runstart < length(rvenv$currcode)){
               updateNumericInput(session, "runstart", value = input$runstart + 1)
            } else {
               updateNumericInput(session, "runstart", value = length(rvenv$currcode) + 1) # set to last line + 1
            }
            updateNumericInput(session, "runthru",  value = length(rvenv$currcode))
         }
      })

      observeEvent(input$runb, {
         rvenv$currcode <- unlist(strsplit(input$ace, "\n")) # update currcode
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
            rc <- try(
               runb(startline = runstart)
            )
            if (class(rc) == 'try-error'){
               rv$statusmsg <- "***** RUN ERROR: see error message in console"
            } else {
               rv$statusmsg <- paste("RUN FROM", runstart)
            }

         }
         else{
            print(paste("RUN FROM", runstart, "THROUGH", runthru))
            rc <- try(
               runb(startline = runstart, throughline = runthru)
            )
            if (class(rc) == 'try-error'){
               rv$statusmsg <- "***** RUN ERROR: see error message in console"
            } else {
               rv$statusmsg <- paste("RUN FROM", runstart, "THROUGH", runthru)
               if (runthru < length(rvenv$currcode)){
                  updateNumericInput(session, "runstart", value = runthru + 1)
                  updateNumericInput(session, "runthru",  value = length(rvenv$currcode))
               } else {
                  updateNumericInput(session, "runstart", value = length(rvenv$currcode) + 1) # set to last line + 1
                  updateNumericInput(session, "runthru",  value = length(rvenv$currcode))
               }
            }
         }
         updateNumericInput(session, "pcount", value = rvenv$pcount)
      })

      observeEvent(input$saveb, {
         file <- input$file
         saveBn <- input$saveBn
         username <- input$username   					   ########################## HI I MADE A CHANGE HERE
         if (is.null(loadBn_succ)){
            showModal(modalDialog(
               title = "SAVE ERROR",
               "Cannot save because no branch has yet been loaded."
            ))
            return()
         }
         if (saveBn <= 0){
            showModal(modalDialog(
               title = "SAVE ERROR",
               "Save Branch# must be greater than 0 in order to save."
            ))
            return()
         }
         desc <- gsub("^\\s+|\\s+$", "", input$desc)
         if (desc == ""){
            showModal(modalDialog(
               title = "SAVE ERROR",
               "Description must be set."
            ))
            return()
         }
         username <- gsub("^\\s+|\\s+$", "", input$username)
         if (username == ""){
            showModal(modalDialog(
               title = "SAVE ERROR",
               "Username must be set."
            ))
            return()
         }
         filename <- paste0(file, ".", as.character(saveBn), ".R")
         if (file.exists(filename)){
            question <- paste("WARNING: ", filename, "exists. Overwrite it?")
            showModal(yesNoModal(msg = question, yesAction="ok", yesLabel="Yes", noLabel="No"))
            return()
         }
         rvenv$currcode <- unlist(strsplit(input$ace, "\n")) # update currcode
         saveb(input$saveBn, paste(input$username, "-", input$desc))
         print(paste("SAVE", input$saveBn, "|", input$desc))
         updateNumericInput(session, "loadBn",  value = input$saveBn)
      })

      yesNoModal <- function(msg="Continue?", yesAction="yes", yesLabel="Yes", noLabel="No"){
         modalDialog(
            span(msg),
            footer = tagList(
               actionButton(yesAction, yesLabel),
               modalButton(noLabel)
            )
         )
      }

      observeEvent(input$ok, {
         rvenv$currcode <- unlist(strsplit(input$ace, "\n")) # update currcode
         saveb(input$saveBn, input$desc)
         print(paste("OVERWROTE", input$saveBn, "|", input$desc))
         updateNumericInput(session, "loadBn",  value = input$saveBn)
         removeModal()
      })

      observeEvent(input$done, {
         invisible(stopApp())
      })

      observeEvent(input$cancel, {
         stopApp(NULL)
      })
    }

   viewer <- dialogViewer("Revisit", width = 1200, height = 1200)
   runGadget(ui, server, viewer = viewer, stopOnCancel = FALSE)
}
