#!/bin/bash

# Return 0 when the provided parameter is an absoulte IRI
function isURL() {
  local regex="(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]"
  if [[ $0 =~ $regex ]]; then
    return 0;
  else
    return 1;
  fi
}

absoluteUrl="https://some.absolute.url.com";
relativeUrl="./some.relative.url.com";

isURL $absoluteUrl
if [[ $? -eq 0 ]]
then
echo "It workz"
else
echo "It does not workz"
fi

isURL $relativeUrl
if [[ $? -eq 0 ]]
then
echo "It workz"
else
echo "It does not workz"
fi
