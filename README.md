# MOp_taxonomies_ontology
This repository serves as a central location for versioning and sharing of taxonomy files and code relevant for development of the BDS Ontology as part of the first version of Cell Types Explorer and ongoing collaboration with EMBL-EBI and JCVI. Included here are taxonomy files for BICCN human, marmoset and mouse primary cortex mini-atlases.

## File summaries
* **CCN202002013_landingpage_dataset_info.csv**: additional information on the mouse landing page
* **Taxonomy Info Panel.csv**: general information for the mouse taxonomy
* **NSForestMarkers**: contains CSV files of gene symbols for cell type marker genes determined using the [NS-Forest algorithm](https://genome.cshlp.org/content/early/2021/06/04/gr.275569.121).
* **cell_set_nomenclature_DATE.csv**: contains the current (as of listed date) cell sets for all BICCN taxonomies (and is a superset of what is in the folders)
* **All Descriptions_Mouse.json**: contains short text descriptions and aliases used to populate cell type cards for the mouse.
* **sunburst plots**: static images and HTML widgets of species taxonomies displayed as sunburst plots
* **FOLDER/(all files)**: scripts and associated output files generated for the three single-species taxonomies as described in [the nomenclature repo](https://github.com/AllenInstitute/nomenclature).  These files are used for ontology building and for the cell type taxonomy service

## Level of Support
We are currently only planning to update code and data in this repo if there are changes to the motor cortex taxonomies, but otherwise are not able to provide any guarantees of support. The community is welcome to submit issues, but you should not expect an active response.


## License
The license for this repo is available on Github at: https://github.com/AllenInstitute/MOp_taxonomies_ontology/blob/main/LICENSE.txt
