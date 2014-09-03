#!/bin/bash

# Setup the compiler environment
module purge 1>/dev/null 2>&1 #Ignore errors about missing modules
module load PrgEnv-gnu
module load gcc/4.7.2 # currently dependencies are not available for > 4.7.2
module load craype-target-compute_node
module load craype-interlagos
module load cmake
export CRAYPE_LINK_TYPE=static

# Load dependency libraries
module load cray-mpich
module load cray-netcdf-hdf5parallel
module load mxml
module load szip
module load dataspaces/1.4.0
module load pmi
module load ugni

CMAKE=$(which cmake)
#CMAKE=$HOME/Code/CMake/build/add-find-root-system_only-mode/bin/cmake
TC=$HOME/Code/Cray-CMake-Modules/ToolChain/CrayPrgEnv-ToolChain.cmake
SRC_DIR=$HOME/Code/ADIOS/source/master
INST_DIR=$HOME/Code/ADIOS/install/compute/${PE_ENV}/master

# Various settings not helped by modules
#export SEQ_HDF5_DIR=${HDF5_DIR}
#export SEQ_HDF5_LIBS=${HDF5_DIR}/lib/libhdf5.a
#export SEQ_NC_DIR=${NETCDF_DIR}
#export SEQ_NC_LIBS=${NETCDF_DIR}/lib/libnetcdf.a
PAR_HDF5_DIR=${HDF5_DIR} \
PAR_HDF5_LIBS=${HDF5_DIR}/lib/libhdf5_parallel.a \
PAR_NC_DIR=${NETCDF_DIR} \
PAR_NC_LIBS=${NETCDF_DIR}/lib/libnetcdf_parallel.a \
LUSTRE_DIR=/usr/lib64 \
BZIP2_DIR=${SYSROOT_DIR}/usr \
DATASPACES_LIBDIR=${DATASPACES_DIR}/lib \
FLEXPATH_DIR=/ccs/proj/e2e/chaos/titan/gnu \
CRAY_PMI_DIR=$(echo "${CRAY_PMI_POST_LINK_OPTS}" | sed 's|.*-L\([^ ]*\)/lib64.*|\1|') \
CRAY_UGNI_DIR=$(echo "${CRAY_UGNI_POST_LINK_OPTS}" | sed 's|.*-L\([^ ]*\)/lib64.*|\1|') \
INSTALL_PREFIX=${INST_DIR} \
${CMAKE} -DCMAKE_TOOLCHAIN_FILE=${TC} ${SRC_DIR}
