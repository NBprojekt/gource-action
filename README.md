<!-- Project img -->
<p align="center">
  <a href="https://github.com/nbproject/gource-action">
    <img src="https://user-images.githubusercontent.com/24683383/92398226-79a40680-f128-11ea-9f54-6ccbaca4a6a5.png" width="200">
  </a>
</p> 

<!-- About -->
<h2 align="center"> <b> Gource Action </b> </h2>
<h4 align="center"> Action to visualize your source code using gource </h4>

<!-- Pipes -->
<p align="center">
  <a href="https://github.com/NBprojekt/gource-action/actions?query=workflow%3A%22Gource+Action+Dev%22" alt="GitHub Dev Status">
    <img src="https://github.com/NBprojekt/gource-action/workflows/Gource%20Action%20Dev/badge.svg">
  </a>
</p>

<hr>

<!-- Navigation -->
<p align="center">
  <a href="#getting-started"> Getting Started </a> &bull;
  <a href="#settings"> Settings </a> &bull;
  <a href="#advanced-example"> Advanced example </a> &bull;
  <a href="#advanced-settigns"> Advanced Settings </a> &bull;
  <a href="#comming-soon"> Comming soon </a> &bull;
  <a href="#maintainer"> Maintainer </a> 
</p>

<hr>

## Getting Started
This is a minimal setup example to visualize the local repository.

Place the following in `./.github/workflows/gource.yml`
```yml
name: Gource Action
on:
  push:
    branches:
      - master

jobs:
  action:
    runs-on: ubuntu-latest

    steps:
      - name: 'Checkout'
        uses: actions/checkout@v2
        
      - name: 'Gource Action'
        uses: nbprojekt/gource-action@v1

      - name: 'Upload gource video'
        uses: actions/upload-artifact@v2
        with:
          name: Gource
          path: ./gource/gource.mp4
```
> After the workflows have successfully completed, you can download the MP3 file of your artifacts.  
> Or use it in another Job.


## Settings
Keys can be added directly to your .yml config file or referenced from your project Secrets storage.

| Key Name    	              | Required? 	| Default 	            | Description                                                                                                	|
|---------------------------	|-----------	|----------------------	|------------------------------------------------------------------------------------------------------------	|
| git_url     	              | false     	| ./      	            | Location of git repository. Can also be an remote repository e.g.: https://github.com/acaudwell/Gource.git 	|
| git_token   	              | false     	|         	            | If the provided repository is private, the action need an token with read scope.                           	|
| logo_url    	              | false     	|         	            | Displayed icon on bottom right corner.                                                                     	|
| avatars_url 	              | false       |         	            | Path of local directory containing user avatars.                                                           	|
| gource_resolution         	| false     	| 1080p                	| Used gource resolution (2160p, 1440p, 1080p, 720p).             	                                          |

## Advanced Settings
Lets use a more advanced setup to visualize the development from the [Docker CLI][docker-cli].
```yml
name: Gource Action for Docker CLI
on:
  push:
    branches:
      - master

jobs:
  action:
    runs-on: ubuntu-latest

    steps:
      - name: 'Gource Action'
        uses: nbprojekt/gource-action@v1
        with:
          git_url: https://github.com/docker/cli
          gource_title: 'Docker CLI'
          logo_url: 'https://user-images.githubusercontent.com/24683383/92395924-70189f80-f124-11ea-815c-aa4d9f4de29d.png'
          gource_resolution: '1080p'
          gource_fps: 60
          gource_font_size: 40
          gource_start_date: '2016-04-18'
          gource_stop_date: '2019-12-31'

      - uses: actions/upload-artifact@v2
        with:
          name: gource
          path: ./gource/gource.mp4
```
> This action can take up to _17 Minutes_

## Advanced example
This settings are all supported setting for [gource][gource-homepage] itself.  
A full list of all available options can be found [here][gource-docs].

| Key Name                  	| Required? 	| Default              	| Description                                                                                                	|
|---------------------------	|-----------	|----------------------	|------------------------------------------------------------------------------------------------------------	|
| gource_title              	| false     	| Title                	| Set a title.                                                    	                                         	|
| gource_fps                	| false     	| 60                   	| Used gource fps.                                                	                                         	|
| gource_auto_skip_seconds  	| false     	| 0.5                  	| Skip to next entry if nothing happens for a number of seconds.  	                                         	|
| gource_background_color   	| false     	| 0a0a0a               	| Background colour in hex.                                       	                                         	|
| gource_overlay_background_color | false  	| 202021               	| Overlay background colour in hex.                                       	                                 	|
| gource_font_color         	| false     	| F0F0F0               	| Font color used by the date and title in hex.                   	                                         	|
| gource_overlay_font_color 	| false     	| F0F0F0               	| Font color used by the overlay in hex.                                	                                   	|
| gource_font_size          	| false     	| 44                   	| Font size used by the date and title.                           	                                         	|
| gource_camera_mode        	| false     	| overview             	| Camera mode (overview, track).                                  	                                         	|
| gource_dir_depth          	| false     	| 3                    	| Draw names of directories down to a specific depth in the tree. 	                                         	|
| gource_filename_time      	| false     	| 2                    	| Duration to keep filenames on screen (>= 2.0).                  	                                         	|
| gource_hide_items         	| false     	| mouse,date,filenames 	| Hide one or more display elements from the list below.          	                                         	|
| gource_max_user_speed     	| false     	| 500                  	| Max speed users can travel per second.                          	                                         	|
| gource_seconds_per_day    	| false     	| 0.1                  	| Speed of simulation in seconds per day.                         	                                         	|
| gource_time_scale         	| false     	| 1.5                  	| Change simulation time scale.                                   	                                         	|
| gource_user_scale         	| false     	| 1.2                  	| Change scale of user avatars.                                   	                                         	|
| gource_start_date         	| false     	|                     	| Start with the first entry after the supplied date and optional time.                                       |
| gource_stop_date          	| false     	|                     	| Stop after the last entry prior to the supplied date and optional time.                                   	|

> More comming soon.

## Comming soon

- #1 Visualizing Multiple Repositories

## Maintainer
| [![NbProjekt](https://avatars3.githubusercontent.com/u/24683383?v=3&s=80)](https://github.com/NBprojekt) |
| :---: |

<!-- Links -->
[docker-cli]: https://github.com/docker/cli
[gource-homepage]: https://gource.io/
[gource-docs]: https://github.com/acaudwell/Gource/blob/master/README
