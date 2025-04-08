#!/bin/bash

# Directory to watch
WATCH_DIR="/Users/john/Library/Mobile Documents/com~apple~CloudDocs/Web/ntnx-image-repo"

#change directory to the Git repo
cd "$WATCH_DIR" || exit 1

# Extensions to monitor
EXTENSIONS=("png" "jpg" "jpeg" "gif" "webp" "mp4" "mov" "avi" "mkv" "webm" "m4v" "m4a" "m4b" "m4p" "m4v" "m4a" "m4b" "m4p" "m4v" "m4a" "m4b" "m4p")

# Random commit messages
MESSAGES=("Add new image" "Updated visual" "Fresh screenshot" "New asset" "Design update")

# Function to choose a random message
random_message() {
  size=${#MESSAGES[@]}
  index=$((RANDOM % size))
  echo "${MESSAGES[$index]}"
}

# Infinite loop to watch for changes
echo "Watching for new images in $WATCH_DIR..."
fswatch -0 "$WATCH_DIR" | while read -d "" FILE
do
  FILE=$(basename "$FILE")
  for EXT in "${EXTENSIONS[@]}"
  do
    if [[ "$FILE" == *.$EXT ]]; then
      echo "New image detected: $FILE"
      git add "$FILE"
      git commit -m "$(random_message)"
      git push
      REPO_URL="https://github.com/john00123/ntnx-image-repo/blob/main"
      URL="$REPO_URL/$(echo "$FILE" | sed 's/ /%20/g')?raw=true"
      echo "Copied to clipboard: $URL"
      echo -n "$URL" | pbcopy
      echo "Committed and pushed $FILE"
      break
    fi
  done
done