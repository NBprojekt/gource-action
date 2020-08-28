#!/bin/bash

# Loading animation
function spinner() {
  local pid=$!
  local spin='⣾⣽⣻⢿⡿⣟⣯⣷'

  local i=0
  local t="\t\t\t\t\t\t\t\t\t\t\t\t\t"

  while kill -0 $pid 2>/dev/null
  do
    i=$(( (i+1) %${#spin} ))
    printf "\r$t${spin:$i:1}\t"
    sleep .15
  done

  printf "\r$t✔\n"
}

printf "> \tSetup\n"
# Predefined resolutions and settings.
if [[ "${VIDEO_RESOLUTION}" == "2160p" ]]; then
	GOURCE_RES="3500x1940"
	OVERLAY_RES="1920x1080"
	GOURCE_PAD="3520:1960:3520:1960:#313133"
	KEY_CROP="320:1860:0:0"
	KEY_PAD="320:1960:0:0:#202021"
	DATE_CROP="3520:200:640:0"
	DATE_PAD="3840:200:320:200:#202021"
	OUTPUT_RES="3840:2160"
	printf "> \t\tUsing 2160p settings. Output will be 3840x2160 at ${GOURCE_FPS}fps.\n"
elif [[ "${VIDEO_RESOLUTION}" == "1440p" ]]; then
	GOURCE_RES="2333x1293"
	OVERLAY_RES="1920x1080"
	GOURCE_PAD="2346:1306:2346:1306:#313133"
	KEY_CROP="214:1240:0:0"
	KEY_PAD="214:1306:0:0:#202021"
	DATE_CROP="2346:134:426:0"
	DATE_PAD="2560:134:214:134:#202021"
	OUTPUT_RES="2560:1440"
	printf "> \t\tUsing 1440p settings. Output will be 2560x1440 at ${GOURCE_FPS}fps.\n"
elif [[ "${VIDEO_RESOLUTION}" == "1080p" ]]; then
	GOURCE_RES="1750x970"
	OVERLAY_RES="1920x1080"
	GOURCE_PAD="1760:980:1760:980:#313133"
	KEY_CROP="160:930:0:0"
	KEY_PAD="160:980:0:0:#202021"
	DATE_CROP="1760:100:320:0"
	DATE_PAD="1920:100:160:100:#202021"
	OUTPUT_RES="1920:1080"
	printf "> \t\tUsing 1080p settings. Output will be 1920x1080 at ${GOURCE_FPS}fps.\n"
elif [[ "${VIDEO_RESOLUTION}" == "720p" ]]; then
	GOURCE_RES="1116x646"
	OVERLAY_RES="1920x1080"
	GOURCE_PAD="1128:653:1128:653:#313133"
	KEY_CROP="102:590:0:0"
	KEY_PAD="102:590:0:0:#202021,scale=152:653"
	DATE_CROP="1128:67:152:0"
	DATE_PAD="1280:67:152:0:#202021"
	OUTPUT_RES="1280:720"
	printf "> \t\tUsing 720p settings. Output will be 1280x720 at ${GOURCE_FPS}fps.\n"
fi


printf "> \t\tUsing inverted colors "
if [[ "${INVERT_COLORS}" == "true" ]]; then
	GOURCE_FILTERS="${GOURCE_FILTERS},lutrgb=r=negval:g=negval:b=negval"
  	printf "\r\t\t\t\t\t\t\t\t\t\t\t\t\t✔\n"
else
  	printf "\r\t\t\t\t\t\t\t\t\t\t\t\t\t✖\n"
fi

printf "> \t\tCreate temp directory"
mkdir /gource/tmp & spinner

printf "> \t\tCreate gource pipe"
mkfifo /gource/tmp/gource.pipe & spinner
printf "> \t\tCreate overlay pipe"
mkfifo /gource/tmp/overlay.pipe & spinner


printf "> \tGource"
printf "\n> \t\tStarting Gource pipe for git repo"
gource --seconds-per-day ${GOURCE_SECONDS_PER_DAY} \
	--user-scale ${GOURCE_USER_SCALE} \
	--time-scale ${GOURCE_TIME_SCALE} \
	--auto-skip-seconds ${GOURCE_AUTO_SKIP_SECONDS} \
	--title "${GOURCE_TITLE}" \
	--background-colour ${GOURCE_BACKGROUND_COLOR} \
	--font-colour ${GOURCE_TEXT_COLOR} \
	--user-image-dir ${GOURCE_USER_IMAGE_DIR} \
	--camera-mode ${GOURCE_CAMERA_MODE} \
	--hide ${GOURCE_HIDE_ITEMS} \
	--font-size ${GOURCE_FONT_SIZE} \
	--dir-name-depth ${GOURCE_DIR_DEPTH} \
	--filename-time ${GOURCE_FILENAME_TIME} \
	--max-user-speed ${GOURCE_MAX_USER_SPEED} \
	--bloom-multiplier 1.2 \
	--${GOURCE_RES} \
	--stop-at-end \
	-r ${GOURCE_FPS} \
	-o - >/gource/tmp/gource.pipe &

printf "\n> \t\tStarting Gource pipe for overlay components"
gource --seconds-per-day ${GOURCE_SECONDS_PER_DAY} \
	--user-scale ${GOURCE_USER_SCALE} \
	--time-scale ${GOURCE_TIME_SCALE} \
	--auto-skip-seconds ${GOURCE_AUTO_SKIP_SECONDS} \
	--key \
	--transparent \
	--background-colour 202021 \
	--font-colour ${OVERLAY_FONT_COLOR} \
	--camera-mode overview \
	--hide bloom,dirnames,files,filenames,mouse,root,tree,users,usernames \
	--font-size 60 \
	--${OVERLAY_RES} \
	--stop-at-end \
	--dir-name-depth 3 \
	--filename-time 2 \
	--max-user-speed 500 \
	-r ${GOURCE_FPS} \
	-o - >/gource/tmp/overlay.pipe &

printf "\n> \t\tStart ffmpeg to merge the two video outputs"
ffmpeg -y -r ${GOURCE_FPS} -f image2pipe -probesize 100M -i /gource/tmp/gource.pipe \
	-y -r ${GOURCE_FPS} -f image2pipe -probesize 100M -i /gource/tmp/overlay.pipe \
	${LOGO} \
	-filter_complex "[0:v]pad=${GOURCE_PAD}${GOURCE_FILTERS}[center];\
                   [1:v]scale=${OUTPUT_RES}[key_scale];\
                   [1:v]scale=${OUTPUT_RES}[date_scale];\
                   [key_scale]crop=${KEY_CROP},pad=${KEY_PAD}[key];\
                   [date_scale]crop=${DATE_CROP},pad=${DATE_PAD}[date];\
                   [key][center]hstack[with_key];\
                   [date][with_key]vstack[with_date]${LOGO_FILTER_GRAPH}${GLOBAL_FILTERS}" ${FILTER_GRAPH_MAP} \
	-vcodec libx264 -level ${H264_LEVEL} -pix_fmt yuv420p -crf ${H264_CRF} -preset ${H264_PRESET} \
	-bf 0 /gource/output/gource.mp4 &> /gource/logs/gource.log & spinner

printf "> \tClean up"
printf "\n> \t\tRemoving temporary files"
rm -rf /gource/tmp & spinner

printf "> \t\tShow file size: "
filesize="$(du -sh /gource/output/gource.mp4 | cut -f 1)"
printf "\r\t\t\t\t\t\t\t\t\t\t\t\t\t$filesize\n"
