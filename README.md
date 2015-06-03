#Taak Static Website

----
## changelog
**0.0.1** (01-Jun-2015)

* Initial static website containing 4 test webinar
* Initial design with bootstrap
* using [wintersmith](https://github.com/jnordberg/wintersmith) as a template generator

----
## How to use?

1. navigate to `site/contents/webinars`
2. put your webinar folder there, using discussed naming structure `YYYMMDD_name-of-webinar`
3. Check your changes in your *http://localhost:8080* with `wintersmith preview` command
4. build your changes with `wintersmith build` command
5. your generated contents will be in `build` directory

----
## What needs to be fixed?

1. size of the player in details page
2. active state of navigation

----
## What will be next steps?

>please raise whatever you think can be helpful or could be better in site... From design perspective till features!

1. Taak logo on the top of the page
2. Including video player in the layout
3. Finalizing the download buttons in webinar pages, based on a more realistic sample
4. Better description in the heading part / removing it (any suggestion?)
5. Pagination is set to 6 webinar per page, changing the amount if it was needed