## Triple Crown Map

This repo contains the code for an interactive map showcasing GPS data from my recent thru hikes. The app is built on [R Shiny](https://shiny.rstudio.com), is hosted on an [AWS EC2 instance](https://aws.amazon.com/ec2/), and is served using a [Shiny Server](https://www.rstudio.com/products/shiny/shiny-server/).  

Visit the map [here](https://hallietheswan.com/shiny/sample-apps/trail_map/) to view images, campsites, resupply points, and more. The app takes about 3-5 seconds to load.  

### Background

The [triple crown of hiking](https://en.wikipedia.org/wiki/Triple_Crown_of_Hiking) entails hiking the Appalachian Trail (AT), Pacific Crest Trail (PCT), and the Continental Divide Trail (CDT). Over three summers, I completed all three trails and in the process walked 7500+ miles, gained 1,000,000+ vertical feet, and visited 22 states.  

Along the way, I carried a satellite communication device that recorded my location every 30 minutes. Unfortunately, the GPS data from my first two hikes (AT, PCT) was deleted. However, I have the GPS data from my CDT thru hike. I also have notes of my campsites and resupply points from all three trails.  

When I got home from the CDT, I realized I could build a visualization to share my experience in a different way. 

### Data Processing

First, I processed my GPS data, as described on [my blog](https://hallietheswan.com/2019/01/28/cdt-data-part-one/). I then marked which points were off trail, as described [here](https://hallietheswan.com/2019/01/28/cdt-data-part-two/). Then, I built this R Shiny app to showcase my hike. 

### Repo Structure

This app follows the two-file Shiny app format, where the user interface is defined in `ui.R` and the server logic is contained within `server.R`.  

The GPS data and annotation files are stored in a `data` subdirectory, which is not tracked in git.  

The `Global.R` file loads necessary packages, reads in the data, and does some data processing.  

`js` and `css` files are stored within the `www` subdirectory.  

Images are also displayed in popups. These images are hosted on [AWS S3](https://aws.amazon.com/s3/).  

### Next Steps

Currently, the app only contains data from my CDT thru hike. I would like to add images, campsites, and resupply points from my AT and PCT thru hikes. I also plan to include viewers for elevation profiles and mileage hiked.

### Collaborating

I would really love to try this process on another hiker’s data. If you’re interested in collaborating, send me an email at [hallietheswan@gmail.com](mailto:hallietheswan@gmail.com). I’d love to hear from you.  
