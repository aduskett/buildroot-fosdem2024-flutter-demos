#!/usr/bin/env bash
set -e
BOARD_DIR="$(dirname "$0")"
CONFIG_TXT="${BOARD_DIR}/config.txt"
GENIMAGE_CFG="${BINARIES_DIR}/genimage.cfg"
RPI_FIRMWARE_OVERLAY_FILES_DIR="${BINARIES_DIR}/rpi-firmware/overlays"

# Check config.txt for dtoverlay= lines and do the following:
# - Ensure that a matching .dtbo file exists in rpi-firmware/overlays
# - Set #OVERLAY_DIR# to "overlays" if dtoverlay= lines are in config.txt
# - Remove the #OVERLAY_DIR# line completely if no dtoverlay= lines are in config.txt
#
# Essentially, this is a sanity check to make sure the dtoverlay lines will,
# at the very least, load a dtbo file.
parse_rpi_firmware_overlay_files() {
  overlay_files="False"
  while IFS= read -r line; do
    if [ "${line:0:1}" == "#" ]; then
      continue
    fi
    line=$(echo "${line}" |awk -F'=' '{print $2}' |awk -F',' '{print $1}')
    overlay_file="${RPI_FIRMWARE_OVERLAY_FILES_DIR}/${line}.dtbo"
    if [ ! -e "${overlay_file}" ]; then
      echo "Error: dtoverlay=${line} in ${BOARD_DIR}/config.txt but ${overlay_file} does not exist!"
      exit 1
    fi
    overlay_files="True"
  done < <(grep "dtoverlay" "${CONFIG_TXT}")

  if [ "${overlay_files}" == "True" ]; then
    sed "s%#OVERLAY_DIR#%rpi-firmware/overlays%" "${BOARD_DIR}/genimage.cfg.in" > "${GENIMAGE_CFG}"
  else
    sed '/"#OVERLAY_DIR#",/d' "${BOARD_DIR}/genimage.cfg.in" > "${GENIMAGE_CFG}"
  fi
}


# The RPI5 defaults to kernel_2712.img. A user may specify "kernel=" in
# config.txt, but simply moving "Image" to "kernel_2712.img" means one less
# line in config.txt!
move_kernel() {
  if [ -e "${BINARIES_DIR}/Image" ]; then
    mv "${BINARIES_DIR}/Image" "${BINARIES_DIR}/kernel_2712.img"
  fi
}


generate_image() {
  support/scripts/genimage.sh -c "${GENIMAGE_CFG}"
}


main() {
  parse_rpi_firmware_overlay_files
  move_kernel
  generate_image
  exit 0
}

main "${@}"
