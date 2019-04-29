require(shiny)
require(shinythemes)

ui <- tagList(
  navbarPage(
    theme = shinytheme("cosmo"),
    "Testing Center",
    fluid = TRUE,
    tabPanel("Lab View",
             sidebarPanel(
               
               # Input: Select a file ----
               fileInput('file1', 'Upload Testing Sample File',
                         accept=c('.csv')
               ),
               
               actionButton("addButton", "Upload"),
               
               # Horizontal line ----
               tags$hr(),
               
               
               # Output: Download submission sample file ----
               downloadButton('downloadTemplate',  'Download Template')
             ),
             
             mainPanel(
               tableOutput('content1')
             ),
             style='width: 1000px; height: 1000px'
    ),
    
    tabPanel("Analyst View", 
             sidebarPanel(
               
               # Output: Download submission sample file ----
               downloadButton('downloadSample',  'Download Testing Samples'),
               
               # Horizontal line ----
               tags$hr(),
               
               # Input: Select a file ----
               fileInput('file2', 'Upload Result File',
                         accept=c('.csv')
               ),
               
               #Upload button
               actionButton("addButton2", "Upload")
             ),
             
             mainPanel(
               tableOutput('content2')
             ),
             style='width: 1000px; height: 1000px'),
    
    tabPanel("Database View",
             sidebarPanel(
               actionButton("refreshButton", "Refresh Database"),
               
               # Horizontal line ----
               tags$hr(),
               
               downloadButton('downloadDatabase',  'Download All Samples')
               
             ),
             
             mainPanel(
               tableOutput('content3')
             )
    )
  )
)