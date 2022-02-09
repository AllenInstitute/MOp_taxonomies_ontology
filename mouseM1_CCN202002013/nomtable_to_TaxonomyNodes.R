# Script for converting nomenclature to TaxonomyNodes file, for use by EBI ontology and AIBS engineering teams

suppressPackageStartupMessages({
  library(dplyr)
})
setwd("~/MOp_taxonomies_ontology-main/mouseM1_CCN202002013")


# Function to concert nomenclature table to taxonomy nodes CSV
nomtable_to_taxonomy_nodes <- function(nomenclature,parent_region){


# Subset class nodes and add parent
  class_rows <- nomenclature %>%
    filter(cell_type_card == "Class") %>%
    select(cell_set_preferred_alias, cell_set_accession, cell_set_label, child_cell_set_accessions, cell_type_card, cell_set_color)
  class_rows$parent <- rep(parent_region,nrow(class_rows))



# Using the child cell set accessions column, add parents for each subclass
  templist <- strsplit(class_rows$child_cell_set_accessions, "|", fixed = TRUE)
  subclass_rows <- nomenclature %>%
    filter(cell_type_card == "Subclass" | cell_type_card == "Cell Type,Subclass") %>%
    select(cell_set_preferred_alias, cell_set_accession, cell_set_label, child_cell_set_accessions, cell_type_card, cell_set_color)

  sub_parents <- c()
  for (i in 1:nrow(subclass_rows)) {
    children <- unlist(strsplit(subclass_rows$child_cell_set_accessions[i],'|',fixed = T))
  
    if (!is.na(children)){
    for (j in 1:length(templist)){
      temp <- which(templist[[j]] %in% children)
      if (length(temp) > 0) {
        classname <- class_rows$cell_set_preferred_alias[j]
        }
      }
    }
  
    if (is.na(children)) {
      typename <- subclass_rows$cell_set_accession[i]
      for (j in 1:length(templist)){
        temp <- which(templist[[j]] %in% typename)
        if (length(temp) > 0) {
        classname <- class_rows$cell_set_preferred_alias[j]
        }
      }
    }
  
    sub_parents <- c(sub_parents,classname)
  }


  subclass_rows$parent <- sub_parents





  # Using the child cell set accessions column, add parents for each type
  type_rows <- nomenclature %>%
    filter(cell_type_card == "Cell Type" | cell_type_card == "Cell Type,Subclass") %>%
    select(cell_set_preferred_alias, cell_set_accession, cell_set_label, cell_type_card, cell_set_color)

  type_parents <- c()
  templist <- strsplit(subclass_rows$child_cell_set_accessions,"|", fixed = TRUE)

  for (i in 1:nrow(type_rows)) {
    typename <- type_rows$cell_set_accession[i]
  
    if (length(subclass_rows$child_cell_set_accessions[subclass_rows$cell_set_accession == typename]) > 0) {
      subclassname <- subclass_rows$cell_set_preferred_alias[subclass_rows$cell_set_accession == typename]
    }
  
    for (j in 1:length(templist)){
      temp <- which(templist[[j]] %in% typename)
    
      if (length(temp) > 0) {
        subclassname <- subclass_rows$cell_set_preferred_alias[j]
      }
    }
  
  
  
    type_parents <- c(type_parents,subclassname)
  }

  type_rows$parent <- type_parents


  # Combine rows, name and sort columns, append all parent names to each parent label
  class_rows <- class_rows %>% select(-c(child_cell_set_accessions))
  subclass_rows <- subclass_rows %>% select(-c(child_cell_set_accessions))
  allnodes <- rbind(class_rows,subclass_rows,type_rows)
  colnames(allnodes) <- c("labels", "accession_ID", "class_label", "type","color","parents")
  allnodes$parents[allnodes$type == "Cell Type"] <-paste0(parent_region, "-",allnodes$parents[allnodes$type == "Subclass"],"-",allnodes$parents[allnodes$type == "Cell Type"])
  allnodes$parents[allnodes$type == "Subclass"] <-paste0(parent_region, "-", allnodes$parents[allnodes$type == "Subclass"])
  allnodes$parents[allnodes$type == "Cell Type,Subclass"] <- paste0(parent_region, "-", allnodes$parents[allnodes$type =="Cell Type,Subclass"])
  
  

  allnodes <- allnodes[,c("labels","parents","color","accession_ID","class_label","type")]

  # Add row for region and color at the top
  insertRow <- function(existingDF, newrow, r) {
    existingDF <- as.data.frame(existingDF)
    existingDF[seq(r+1,nrow(existingDF)+1),] <- existingDF[seq(r,nrow(existingDF)),]
    existingDF[r,] <- newrow
    existingDF
  }

  regionrow <- as.vector(c(parent_region,NA,"white",NA,NA,NA))
  allnodes <- insertRow(allnodes, regionrow, 1)

  # Write to CSV
  write.table(allnodes,"TaxonomyNodes.csv",sep=",",row.names = F)
}



# Convert mouse nomenclature table as an example
# Load nomenclature file - 
nom <- read_csv("nomenclature_table_CCN202002013.csv")
nom <- nom %>%
  filter(cell_type_card != "No")


nomtable_to_taxonomy_nodes(nomenclature = nom, parent_region = "MOp")
