export LC_ALL=C
export LANG=C

# wal's cache directory.
cache_dir="${HOME}/.cache/wal"
iterm_color_dir="${cache_dir}/itermcolors"
mkdir -p "$iterm_color_dir"

# Filename for output.
wal_filename="$(< "${cache_dir}/wal")"
wal_filename="${wal_filename/*\/}"
out_filename="${iterm_color_dir}/${wal_filename}.itermcolors"

# Import colors
c=($(< "/Users/kylesmith/.cache/wal/colors"))
c=("${c[@]//\#}")


div() {
    # Function to do floating point division in bash.
    counter="${2}"
    result="$((${1} / 255))"
    printf "%s" "$result"
    multiply="$((result * 255))"

    ((counter == 0 && multiply != ${1})) && printf "%s" "."
    ((${1} == multiply || counter == 17)) && return
    ((counter++))

    div "$(((${1} - multiply) * 10))" "$counter"
}

set_color() {
    # Split the hex color into RGB and convert it to decimal.
    blue="$(div "$((16#${2:4:2}))" 0)"
    green="$(div "$((16#${2:2:2}))" 0)"
    red="$(div "$((16#${2:0:2}))" 0)"

    e "%s\n" "        <key>${1}</key>"
    printf "%s\n" "        <dict>"
    printf "%s\n" "                <key>Color Space</key>"
    printf "%s\n" "                <string>sRGB</string>"
    printf "%s\n" "                <key>Blue Component</key>"
    printf "%s\n" "                <real>${blue}</real>"
    printf "%s\n" "                <key>Green Component</key>"
    printf "%s\n" "                <real>${green}</real>"
    printf "%s\n" "                <key>Red Component</key>"
    printf "%s\n" "                <real>${red}</real>"
    printf "%s\n" "        </dict>"
}
