#!/bin/sh

# links all files in home directory to their appropriate place under user HOME
# must be run as user from this directory
ALEX_HOME="$(pwd)/home"

lsmod | grep i915 >/dev/null 2>&1
if [ $? -eq 0 ]; then
	I915="true"
else
	I915="false"
fi

lsmod | grep amdgpu >/dev/null 2>&1
if [ $? -eq 0 ]; then
	AMDGPU="true"
else
	AMDGPU="false"
fi

lsmod | grep nvidia >/dev/null 2>&1
if [ $? -eq 0 ]; then
	NVIDIA="true"
else
	NVIDIA="false"
fi

for f in $(find "${ALEX_HOME}" -type f); do
	TARGET="${f/${ALEX_HOME}/${HOME}}"
	TARGET_FILE=$(basename "${TARGET}")
	TARGET_DIR=$(dirname "${TARGET}")

	SKIP="false"
	if [ "${TARGET_FILE}" = "20-intel.conf" -a "${I915}" = "false" ]; then
		SKIP="true"
	fi
	if [ "${TARGET_FILE}" = "20-amdgpu.conf" -a \( "${AMDGPU}" = "false" -o "${NVIDIA}" = "true" \) ]; then
		SKIP="true"
	fi
	if [ "${TARGET_FILE}" = "20-nvidia.conf" -a "${NVIDIA}" = "false" ]; then
		SKIP="true"
	fi

	if [ ${SKIP} = "false" ]; then
		if [ ! -d ${TARGET_DIR} ]; then
			mkdir -pv "${TARGET_DIR}"
		fi
		ln -fsv "${f}" "${TARGET}"
	fi
done
