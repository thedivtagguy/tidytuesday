---
title: Methodology
---

The data for this page comes from [Week 47, 2023](https://github.com/rfordatascience/tidytuesday/blob/master/data/2023/2023-11-21/readme.md) of the tidytuesday project by R4Ds. This entire thing is overkill, but I wanted to try out the Open AI API and some of the libraries used here, and this seemed like a good opportunity. The chapters were geocoded using information about the chapter from Meetup.com and the Nominatim API. For finding similar chapters, which is based on the title for each meetup, I used the Open AI embeddings API to cluster similar topics and then aggregated that information to the chapter level. Similarly, the Open AI completions API was used to return 'keywords' for each chapter, based on the titles of the meetups. This processing was done in R, with no more than 30% of the code being written by ChatGPT (my personal acceptable limit).

<br/>
This microsite was made with Sveltekit and the globe, tables, sparklines and other interactive elements were built with the excellent LayerChart and Svelte-UX libraries, by Sean Lynch (who also nice enough to troubleshoot some of my issues in the beginning). This site uses Tailwind CSS and DaisyUI for styling. I don't track anything.

<br/>
<br/>

The code for this site is available on [Github](https://github.com/thedivtagguy/tidytuesday/tree/master/2023/week-47-nov-2023-r-ladies/website)

<br/>

Made by [Aman Bhargava](https://aman.bh). Available under [DWTFYWPL](http://www.wtfpl.net/)
