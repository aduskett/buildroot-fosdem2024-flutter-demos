#!/usr/bin/env bash
set -eu

add_inittab() {
  # Add a console on tty1 (HDMI)
  check=$(grep -qE '^tty1::' "${TARGET_DIR}"/etc/inittab || true)
  if [ -z "${check}" ]; then
    sed -i '/GENERIC_SERIAL/a tty1::respawn:/sbin/getty -L tty1 0 vt100 # HDMI console' \
      "${TARGET_DIR}"/etc/inittab
  fi
  exit $?
}

add_systemd() {
  # systemd doesn't use /etc/inittab, enable getty.tty1.service instead
  mkdir -p "${TARGET_DIR}/etc/systemd/system/getty.target.wants"
  ln -sf /lib/systemd/system/getty@.service \
    "${TARGET_DIR}/etc/systemd/system/getty.target.wants/getty@tty1.service"
  exit $?
}

main() {
  if [ -e "${TARGET_DIR}"/etc/inittab ]; then
    add_inittab
  fi
  add_systemd
}

main "${@}"
