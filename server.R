setwd("C:/Users/Yiling/Desktop/DSCI598 Capstone Project/R Code/project/project")


shinyServer(function(input, output) {
  
###Lab View
  #Upload data
  upload_data <- reactive({
    req(input$file1)
    inFile <- input$file1
  })
  
  #Show uploaded data
  output$content1 <- renderTable({
    req(input$file1)
    tryCatch(
      {
        df <- read.csv(input$file1$datapath,
                       header = TRUE,
                       stringsAsFactors = FALSE)
      },
      error = function(e) {
        # return a safeError if a parsing error occurs
        stop(safeError(e))
      }
    )
  })
  
  #Save data to database
  observeEvent(input$addButton, {
    
    if(input$addButton > 0){
      database <- read.csv("database.csv", 
                           header = TRUE,
                           stringsAsFactors = FALSE)
      df <- read.csv(input$file1$datapath,
                     header = TRUE,
                     stringsAsFactors = FALSE)
      
      #Add submitted date
      for (row in 1:nrow(df)){
        if (is.na(df[row, 4])){
          df[row, 4] <- format(Sys.Date(),"%m/%d/%Y")
        }
      }
      
      #Combine df and database
      database_update <- rbind(df, database)
      
      #Remove duplicated records with same Tester_ID and Analyte_Name
      database_update <- database_update[!duplicated(database_update[c(1,2)], fromLast = TRUE),]
      
      write.csv(database_update, file.path("database.csv"), row.names = FALSE, na = "")
    }
  })
  
  
  #Download Button
  output$downloadTemplate <- downloadHandler(
    filename = function(){
      paste("template","csv",sep=".")
    },
    
    content <- function(file) {
      file.copy("template.csv", file)
    },
    
    contentType = "csv"
  )
  
###Analyst View
  #Download button
  output$downloadSample <- downloadHandler(
    filename = function(){
      paste("testing_samples_",format(Sys.Date(),"%y%m%d"),".csv",sep="")
    },
    
    content <- function(file) {
      df <- read.csv("database.csv",
                     header = TRUE,
                     stringsAsFactors = FALSE)
      
      df <- df[is.na(df$Result), ]
      write.csv(df, file, row.names = FALSE, na = "")
    },
    
    contentType = "csv"
  )
  
  
  output$content2 <- renderTable({
    
    req(input$file2)
    
    tryCatch(
      {
        df <- read.csv(input$file2$datapath,
                       header = TRUE,
                       stringsAsFactors = FALSE)
      },
      error = function(e) {
        # return a safeError if a parsing error occurs
        stop(safeError(e))
      }
    )
  })
  
  #Upload button
  observeEvent(input$addButton2, {
    
    if(input$addButton2 > 0){
      database <- read.csv("database.csv", 
                           header = TRUE,
                           stringsAsFactors = FALSE)
      df <- read.csv(input$file2$datapath,
                     header = TRUE,
                     stringsAsFactors = FALSE)
      
      #Combine df and database
      database_update <- rbind(df, database)
      
      #Remove duplicated records with same Tester_ID and Analyte_Name
      database_update <- database_update[!duplicated(database_update[c(1,2)]),]
      
      write.csv(database_update, file.path("database.csv"), row.names = FALSE, na = "")
    }
  })
  
###Database View
  #Refresh button
  observeEvent(input$refreshButton, {
    
    if(input$refreshButton > 0) {
    database <- read.csv("database.csv", header = TRUE)
    }
  })
  
  #Show all samples
  output$content3 <- renderTable({
    input$refreshButton
    
    database <- read.csv("database.csv", header = TRUE)
    return(database)
  })
  
  #Download all samples
  output$downloadDatabase <- downloadHandler(
    filename = function(){
      paste("database_",format(Sys.Date(),"%y%m%d"),".csv",sep="")
    },
    
    content <- function(file) {
      file.copy("database.csv", file)
    },
    
    contentType = "csv"
  )
})