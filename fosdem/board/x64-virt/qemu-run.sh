#!/usr/bin/env bash
set -e
CWD="$(realpath "$(dirname "$0")")"
X64_QEMU="qemu-system-x86_64"
CPU=""
FONTCONFIG_PATH=/etc/fonts
LIBGL_DRIVERS_PATH=/usr/lib64/dri
OVMF="/usr/share/OVMF/OVMF_CODE.fd"
DISK_IMG="$(realpath "${CWD}"/../../output/x64_virt_flutter_demo/images/disk.img)"


check_env() {
  qemu=$(which "${X64_QEMU}" || true)
  if [ -z "${qemu}" ]; then
    echo "${X64_QEMU}: command not found!"
    exit 1
  fi
  if [ ! -d "${FONTCONFIG_PATH}" ]; then
    echo "Warning: ${FONTCONFIG_PATH} does not exist!"
  fi
  if [ ! -d "${LIBGL_DRIVERS_PATH}" ]; then
    echo "CRITICAL: ${LIBGL_DRIVERS_PATH} does not exist!"
    exit 1
  fi
  if [ ! -e "${OVMF}" ]; then
    echo "CRITICAL: ${OVMF} does not exist. Please install the edk2-ovmf package!"
    exit 1
  fi
  if [ ! -e "${DISK_IMG}" ]; then
    echo "CRITICAL: ${DISK_IMG} does not exit. Please build the x64_virt_flutter_demo image!"
    exit 1
  fi
}

check_cpu_features() {
  CPU=$(grep -m1 'GenuineIntel\|AuthenticAMD' /proc/cpuinfo |awk -F ' ' '{print $3}' || true)
  if [ -z "${CPU}" ]; then
    echo "CRITICAL: This script is only tested on Intel and AMD processors!"
    exit 1
  fi
  if [ ! -e /dev/kvm ]; then
    echo "Warning: /dev/kvm does not exist. Please enable virtualization in either the BIOS or EUFI settings!"
    exit 1
  fi
}

run_virt() {
  LIBGL_DRIVERS_PATH="${LIBGL_DRIVERS_PATH}" \
  FONTCONFIG_PATH="${FONTCONFIG_PATH}" \
  qemu-system-x86_64 \
    -enable-kvm \
    -M pc \
    -cpu host \
    -m 1024M \
    -bios "${OVMF}" \
    -drive file="${DISK_IMG}",if=virtio,format=raw \
    -net nic,model=virtio \
    -netdev bridge,br=virbr0,id=net0,helper=/usr/libexec/qemu-bridge-helper -device virtio-net-pci,netdev=net0 \
    -net user \
    -device virtio-vga-gl \
    -display gtk,gl=on,show-cursor=on \
    -usb \
    -device usb-ehci,id=ehci \
  -device usb-tablet,bus=usb-bus.0
}

main() {
  check_env
  check_cpu_features
  run_virt
  exit 0
}

main "${@}"
