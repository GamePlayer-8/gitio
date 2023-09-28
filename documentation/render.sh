#!/bin/sh

SCRIPT_PATH="$(dirname "$(realpath "$0")")"
CI_REPO_NAME="${CI_REPO_NAME:-'nan'}"
HTML_HEAD="$SCRIPT_PATH"/../docs/docs-head.html
HTML_UI="$SCRIPT_PATH"/../docs/docs-ui.html
WIKI_DOCUMENTS=""

wiki_docs="$(find "$SCRIPT_PATH" -type f -name "*.md")"

find "$SCRIPT_PATH" -type f -name "*.md" | while IFS= read -r element; do
    content_name="$(basename "$element" | sed 's/\.md$//')"
    new_path="$content_name"'.html'

    first_letter="$(printf "%s" "$content_name" | cut -c1 | tr '[:lower:]' '[:upper:]')"
    rest_of_string="$(printf "%s" "$content_name" | cut -c2-)"
    content_name="${first_letter}${rest_of_string}"
    content_name="$(echo "$content_name" | sed 's/-/ /g')"

    WIKI_DOCUMENTS="$WIKI_DOCUMENTS"'<a href="'"$new_path"'">'"$content_name"'</a>'
    echo "$WIKI_DOCUMENTS" > /tmp/documents.render.pages."$CI_REPO_NAME".tmp
done

unset wiki_docs

scrap_markdown() {
    local input_file="$1"
    local contents=""

    while IFS= read -r line; do
        if printf "%s" "$line" | grep -qE '^(#{1,6})[[:space:]]+(.*)$'; then
            header="$(printf "%s" "$line" | sed -E 's/^(#{1,6})[[:space:]]+(.*)$/\2/')"
            level="$(printf "%s" "$line" | sed -E 's/^(#{1,6}).*$/\1/')"
            indent=""
            
            # Calculate the indentation based on the header level
            for i in $(seq $(echo "$level" | wc -c)); do
                indent="$indent  "
            done

            # Add the list item to the TOC
            contents="${contents}${indent}<li><a href=\"#${header}\">${header}</a></li>
"
        fi
    done < "$input_file"

    echo "${contents}"

}

# Use a for loop to iterate over the Markdown files
find "$SCRIPT_PATH" -type f -name "*.md" | while read -r file; do
    content_name="$(basename "$file" | sed 's/\.md$//')"
    new_path="$(dirname "$file")/$content_name"'.html'
    first_letter="$(printf "%s" "$content_name" | cut -c1 | tr '[:lower:]' '[:upper:]')"
    rest_of_string="$(printf "%s" "$content_name" | cut -c2-)"
    content_name="${first_letter}${rest_of_string}"
    echo 'Processing '"$file"'...'

    file_contents="$(scrap_markdown "$file")"

    echo "$file_contents" > /tmp/contents.render.pages."$CI_REPO_NAME".tmp

    echo '<!DOCTYPE html>' > "$new_path"
    echo '<html lang="en-US">' >> "$new_path"
    cat "$HTML_HEAD" >> "$new_path"

    echo '<body>' >> "$new_path"
    cat "$HTML_UI" >> "$new_path"
    sed -i "/<documents>/ {
    r /tmp/documents.render.pages."$CI_REPO_NAME".tmp
    s/<documents>//g
}" "$new_path"
    sed -i "/<contents>/ {
    r /tmp/contents.render.pages."$CI_REPO_NAME".tmp
    s/<documents>//g
}" "$new_path"
    sed -i "s|<filename>|$content_name|" "$new_path"
    echo '<div id="content">' >> "$new_path"
    sh "$SCRIPT_PATH"/markdown "$file" >> "$new_path"
    echo '</div>' >> "$new_path"
    echo '</div>' >> "$new_path"
    echo '</body>' >> "$new_path"
    echo '</html>' >> "$new_path"
done

rm -f /tmp/contents.render.pages."$CI_REPO_NAME".tmp
rm -f /tmp/documents.render.pages."$CI_REPO_NAME".tmp

cp "$SCRIPT_PATH"/../docs/redirect.html "$SCRIPT_PATH"/index.html
