# Motion Photo Extractor

A handy script for extracting videos out of Motion Photo files
I wrote this to automate extracting videos from my Samsung's motion photo gallery.

## Requirements

- exiftool

## Usage

```sh
./extract_motion_photo.sh my_photos_directory/
```

The tool searches all files ending with .jpg in provided input directory, and then extracts the embedded `.mp4` video into an output directory named extracted-motion-photos/.
If file doesn't contains Embedded Video data, it is skipped and added to an array (which is printed out at the end).
