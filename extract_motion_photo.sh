#!/bin/bash

function extract() {
  # Directory to save extracted videos
  OUTPUT_DIR="$INPUT_DIR/extracted-motion-photos/"

  mkdir -p "$OUTPUT_DIR"

  echo "Running the following command:"
  echo "exiftool -b -EmbeddedVideoFile filename.jpg >$OUTPUT_DIR/filename.mp4"

  SKIPPED_FILES=()
  EXTRACTED_FILES=()
  TOTAL_FOUND=0
  for FILE in "$INPUT_DIR"/*.jpg; do
    if [[ ! -f $FILE ]]; then
      continue
    fi
    TOTAL_FOUND=$((TOTAL_FOUND + 1))

    BASENAME=$(basename "$FILE" .jpg)
    OUTPUT_FILE="$OUTPUT_DIR/$BASENAME.mp4"

    # exiftool can check if image contains embedded video
    CONTAINS_VIDEO=$(exiftool -b -EmbeddedVideoFile "$FILE" | wc -l)
    if [[ $CONTAINS_VIDEO -eq 0 ]]; then
      SKIPPED_FILES+=("$BASENAME.jpg")
      continue
    fi

    # extract embedded video from .jpg
    exiftool -b -EmbeddedVideoFile "$FILE" >"$OUTPUT_FILE"

    EXTRACTED_FILES+=("$BASENAME")
    printf "."
  done

  echo "Extraction completed!"
  echo "Extracted: ${#EXTRACTED_FILES[@]} out of ${TOTAL_FOUND} files"
  echo "Skipped ${#SKIPPED_FILES[@]} files of which are:"
  echo "${SKIPPED_FILES[@]}"
  echo ""
  echo "Output Directory: $OUTPUT_DIR"
}

function usage() {
  echo "Usage: $0 <input directory>"
}

# if no arguments given, return usage:
if [[ -z "$1" ]]; then
  usage
fi
# Script input arguments:
INPUT_DIR=$1

# check if directory exists
if [ ! -d "$INPUT_DIR" ]; then
  echo "Input directory does not exist"
  exit
fi

extract
