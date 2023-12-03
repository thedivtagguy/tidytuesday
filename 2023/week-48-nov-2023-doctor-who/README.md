# TidyTuesday Project

This is a TidyTuesday project repository for the topic: week-48-nov-2023-doctor-who.

I decided to make a Doctor Who, Gallifrey-themed postcard for this week. The area chart and the histogram looked like they could be a sort of minimal, Gallifrey shape and well, here we are! It's got the two moons, the glass dome and everything. All elements here, except the title graphic which I made in Photoshop, was done in R. You can look through the code [here](./analysis/notebook.qmd).

I tried making this work with patchwork for overlaying various plots but it was far too painful. Instead, I exported each image as an individual element and assembled it the way I wanted with the `{magick}` package. Mucchhhh faster, more intuitive and has a bunch of cool effects like this noise overlay I could use.

Allons-y! Till next time.

![Final graphic](output/postcard.png)
