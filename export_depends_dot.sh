#!/bin/bash

pushd ..
OUTPUT_DIR="../export"
CORE_IMAGE="core-image-minimal"
BUILD_LIST_FILE="pn-buildlist"
TASK_DEPENDS_FILE="task-depends.dot"

source poky/oe-init-build-env
mkdir "${OUTPUT_DIR}"

if [ -f "${OUTPUT_DIR}/${CORE_IMAGE}_${BUILD_LIST_FILE}" ]; then
    rm -f "${OUTPUT_DIR}/${CORE_IMAGE}_${BUILD_LIST_FILE}"
fi

if [ -f "${OUTPUT_DIR}/${CORE_IMAGE}_${TASK_DEPENDS_FILE}" ]; then
    rm -f "${OUTPUT_DIR}/${CORE_IMAGE}_${TASK_DEPENDS_FILE}"
fi

# generate the image-wide pn-buildlist/dot files and move them so they don't get overwritten
bitbake "${CORE_IMAGE}" -g
mv "${BUILD_LIST_FILE}" "${OUTPUT_DIR}/${CORE_IMAGE}_${BUILD_LIST_FILE}"
mv "${TASK_DEPENDS_FILE}" "${OUTPUT_DIR}/${CORE_IMAGE}_${TASK_DEPENDS_FILE}"

# using the image-wide pn-buildlist, generate pn-buildlist/dot files for each package, with package name as file prefix
while IFS= read -r line
do
    bitbake "$line" -g
    mv "${BUILD_LIST_FILE}" "${OUTPUT_DIR}/${line}_${BUILD_LIST_FILE}"
    mv "${TASK_DEPENDS_FILE}" "${OUTPUT_DIR}/${line}_${TASK_DEPENDS_FILE}"
done < "${OUTPUT_DIR}/${CORE_IMAGE}_${BUILD_LIST_FILE}"


popd