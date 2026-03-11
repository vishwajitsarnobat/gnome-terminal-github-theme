#!/bin/bash

THEME_DIR="themes"

apply_theme() {
  local THEME_FILE="$1"

  if [ ! -f "$THEME_FILE" ]; then
    echo "Error: Theme file '$THEME_FILE' not found."
    exit 1
  fi

  source "$THEME_FILE"
  printf "\nApplying %s theme to Gnome Terminal...\n" "$THEME_FILE"

  if ! command -v dconf &>/dev/null; then
    echo "Error: dconf is not installed."
    exit 1
  fi

  PROFILE_ID=$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d "'")
  if [ -z "$PROFILE_ID" ]; then
    echo "Error: Could not find default Gnome Terminal profile."
    exit 1
  fi

  DCONF_PATH="/org/gnome/terminal/legacy/profiles:/:${PROFILE_ID}/"
  dconf write "${DCONF_PATH}use-theme-colors" "false"
  dconf write "${DCONF_PATH}background-color" "'${BG_COLOR}'"
  dconf write "${DCONF_PATH}foreground-color" "'${FG_COLOR}'"
  dconf write "${DCONF_PATH}bold-color-same-as-fg" "true"
  dconf write "${DCONF_PATH}bold-color" "'${BOLD_COLOR}'"
  dconf write "${DCONF_PATH}cursor-colors-set" "true"
  dconf write "${DCONF_PATH}cursor-background-color" "'${CURSOR_BG}'"
  dconf write "${DCONF_PATH}cursor-foreground-color" "'${CURSOR_FG}'"
  dconf write "${DCONF_PATH}highlight-colors-set" "true"
  dconf write "${DCONF_PATH}highlight-background-color" "'${HIGHLIGHT_BG}'"
  dconf write "${DCONF_PATH}highlight-foreground-color" "'${HIGHLIGHT_FG}'"
  dconf write "${DCONF_PATH}palette" "${PALETTE}"

  echo "Success! The $THEME_NAME theme has been applied."
}

echo "Available Themes:"
shopt -s nullglob
theme_files=("$THEME_DIR"/*.sh)
if [ ${#theme_files[@]} -eq 0 ]; then
  echo "Error: No themes found in '$THEME_DIR' directory."
  exit 1
fi

PS3="Enter your choice (or Ctrl+C to quit): "
select selected_file in "${theme_files[@]}"; do
  if [ -n "$selected_file" ]; then
    apply_theme "$selected_file"
    break
  else
    echo "Invalid selection. Please type a number from your list."
  fi
done
