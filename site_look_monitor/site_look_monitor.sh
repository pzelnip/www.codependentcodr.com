#!/bin/bash
set -e

CAPT_FILE=$(date -u +"%Y-%m-%dT%H-%M-%SZ_%s").png

echo "FILE: $CAPT_FILE"

echo "Capturing screenshot..."
xvfb-run --server-args="-screen 0, 1920x1080x24" cutycapt --url=www.codependentcodr.com --out=$CAPT_FILE --delay=3000 --min-width=1920 --min-height=1080
echo "Done"

echo "Cropping image..."
convert $CAPT_FILE -crop 1920x1080+0+0 $CAPT_FILE
echo "Done"

echo "Uploading cap to S3..."
aws s3 cp $CAPT_FILE s3://www.codependentcodr.com-screencaps
echo "Done"

echo "Diffing with previous..."
SCORE=$(image-diffr $CAPT_FILE prev.png -t 0.25 -q | cut -d " " -f2- )
THRESHOLD=0.1
echo "Score: $SCORE, threshold $THRESHOLD"

if (( $(echo "$SCORE < $THRESHOLD" | bc -l) )); then
    echo "Score good, all is well"
else
    echo "DANGER WILL ROBINSON, DANGER! Sites are different!"
    exit 1
fi
echo "Done"

echo "Copying $CAPT_FILE to prev.png"
cp $CAPT_FILE prev.png
echo "Done"

echo "All done"
