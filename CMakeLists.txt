#  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
# 
#  Maintainers : support@fluidnumerics.com
#  Official Repository : https://github.com/FluidNumerics/kaolin/
# 
#  Copyright © 2024 Fluid Numerics LLC
# 
#  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
# 
#  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
# 
#  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in
#     the documentation and/or other materials provided with the distribution.
# 
#  3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from
#     this software without specific prior written permission.
# 
#  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS “AS IS” AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
#  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
#  HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
#  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
#  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
#  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# 
#  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 

cmake_minimum_required(VERSION 3.21)
cmake_policy(VERSION 3.21...3.27)
include(CMakePrintHelpers)

# C Language is needed in order to verify Fortran compiler is C-interoperable
project(KAOLIN VERSION 1.0.0
	DESCRIPTION "Kaolin - A foundational library for heterogeneous high performance computing in Fortran"
	LANGUAGES Fortran C)

option(KAOLIN_ENABLE_TESTING "Option to enable build of tests. (Default On)"  ON)
# option(KAOLIN_ENABLE_EXAMPLES "Option to enable build of examples. (Default On)"  ON)


# Fortran compiler requirements
include(FortranCInterface)
FortranCInterface_VERIFY()

if(NOT FortranCInterface_VERIFIED_C)
	message(FATAL_ERROR "Fortran compiler must support C Interface")
endif(NOT FortranCInterface_VERIFIED_C)
	
if(NOT CMAKE_Fortran_COMPILER_SUPPORTS_F90)
    MESSAGE(FATAL_ERROR "Fortran compiler does not support F90")
endif(NOT CMAKE_Fortran_COMPILER_SUPPORTS_F90)

# Default Fortran compiler flags
# Fortran compiler flags
if( "${CMAKE_Fortran_COMPILER_ID}" STREQUAL "GNU" )
    set( CMAKE_Fortran_FLAGS "${CMAKE_FORTRAN_FLAGS} -cpp -ffree-line-length-512" )
    set( CMAKE_Fortran_FLAGS_DEBUG "-g -O0 -C -Wall -fbounds-check -fbacktrace" )
    #set( CMAKE_Fortran_FLAGS_DEBUG "-g -O0 -C -Wall -fbounds-check -fbacktrace -ffpe-trap=invalid,zero,overflow" )
    set( CMAKE_Fortran_FLAGS_COVERAGE "${CMAKE_Fortran_FLAGS_DEBUG} --coverage")
    set( CMAKE_Fortran_FLAGS_PROFILE "-pg -O3")
    set( CMAKE_Fortran_FLAGS_RELEASE "-O3" )
    set( CMAKE_C_FLAGS_COVERAGE "-g -O0 --coverage")

elseif( "${CMAKE_Fortran_COMPILER_ID}" STREQUAL "Intel" )
    set( CMAKE_Fortran_FLAGS "-fpp" )
    set( CMAKE_Fortran_FLAGS_DEBUG "-O0 -g -debug all -check all -traceback" )
    set( CMAKE_Fortran_FLAGS_COVERAGE "${CMAKE_Fortran_FLAGS_DEBUG} -prof-gen=srcpos")
    set( CMAKE_Fortran_FLAGS_PROFILE "-O3")
    set( CMAKE_Fortran_FLAGS_RELEASE "-O3" )
    set( CMAKE_C_FLAGS_COVERAGE "-g -O0")

elseif( "${CMAKE_Fortran_COMPILER_ID}" STREQUAL "IntelLLVM" )
    set( CMAKE_Fortran_FLAGS "-fpp" )
    set( CMAKE_Fortran_FLAGS_DEBUG "-debug all -check all,nouninit -traceback" )
    set( CMAKE_Fortran_FLAGS_COVERAGE "${CMAKE_Fortran_FLAGS_DEBUG}") # Code coverage not available with ifx
    set( CMAKE_Fortran_FLAGS_PROFILE "-O3")
    set( CMAKE_Fortran_FLAGS_RELEASE "-O3" )
    set( CMAKE_C_FLAGS_COVERAGE "-g -O0")

elseif( "${CMAKE_Fortran_COMPILER_ID}" STREQUAL "Flang" )
    set( CMAKE_Fortran_FLAGS "-Mpreprocess" )
    set( CMAKE_Fortran_FLAGS_DEBUG "${CMAKE_Fortran_FLAGS} -O0 -g -Wall -pedantic -save-temps" )
    set( CMAKE_Fortran_FLAGS_COVERAGE "${CMAKE_Fortran_FLAGS_DEBUG}") # Code coverage not available with ifx
    set( CMAKE_Fortran_FLAGS_PROFILE "-O3")
    set( CMAKE_Fortran_FLAGS_RELEASE "-O3" )
    set( CMAKE_C_FLAGS_COVERAGE "-g -O0")

elseif( "${CMAKE_Fortran_COMPILER_ID}" STREQUAL "NVHPC" )
    set( CMAKE_Fortran_FLAGS "-Mpreprocess" )
    set( CMAKE_Fortran_FLAGS_DEBUG "${CMAKE_Fortran_FLAGS} -O0 -Wall -C -g -traceback" )
    set( CMAKE_Fortran_FLAGS_COVERAGE "${CMAKE_Fortran_FLAGS_DEBUG}") # Code coverage not available with ifx
    set( CMAKE_Fortran_FLAGS_PROFILE "-O3 -Mstack_arrays -Minfo")
    set( CMAKE_Fortran_FLAGS_RELEASE "-O3 -Mstack_arrays -Minfo" )
    set( CMAKE_C_FLAGS_COVERAGE "-g -O0")
endif()


# message("-- KAOLIN Build System : Enabling GPU Support")
# set( CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -DENABLE_GPU" )
# set( CMAKE_Fortran_FLAGS_DEBUG "${CMAKE_Fortran_FLAGS_DEBUG} -DENABLE_GPU" )
# set( CMAKE_Fortran_FLAGS_COVERAGE "${CMAKE_Fortran_FLAGS_COVERAGE} -DENABLE_GPU")
# set( CMAKE_Fortran_FLAGS_PROFILE "${CMAKE_Fortran_FLAGS_PROFILE} -DENABLE_GPU")
# set( CMAKE_Fortran_FLAGS_RELEASE "${CMAKE_Fortran_FLAGS_RELEASE} -DENABLE_GPU" )

# # HIP (Optional)
# # IF HIP is found, we prefer HIP. IF HIP is not found, then we fall back to look for CUDA
# # only. If neither HIP nor CUDA are found, Cmake will error out.
# find_package(hip)
# if(hip_FOUND)
#     message("-- HIP found. Enabling HIP language.")
#     enable_language(HIP)
#     set( CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -DHAVE_HIP" )
#     set( CMAKE_Fortran_FLAGS_DEBUG "${CMAKE_Fortran_FLAGS_DEBUG} -DHAVE_HIP" )
#     set( CMAKE_Fortran_FLAGS_COVERAGE "${CMAKE_Fortran_FLAGS_COVERAGE} -DHAVE_HIP")
#     set( CMAKE_Fortran_FLAGS_PROFILE "${CMAKE_Fortran_FLAGS_PROFILE} -DHAVE_HIP")
#     set( CMAKE_Fortran_FLAGS_RELEASE "${CMAKE_Fortran_FLAGS_RELEASE} -DHAVE_HIP" )
#     set( BACKEND_LIBRARIES hip::device)

# else()
#     # CUDA
#     find_package(CUDAToolkit REQUIRED)
#     message("-- CUDA found. Enabling CUDA language.")
#     enable_language(CUDA)
#     set( CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -DHAVE_CUDA" )
#     set( CMAKE_Fortran_FLAGS_DEBUG "${CMAKE_Fortran_FLAGS_DEBUG} -DHAVE_CUDA" )
#     set( CMAKE_Fortran_FLAGS_COVERAGE "${CMAKE_Fortran_FLAGS_COVERAGE} -DHAVE_CUDA")
#     set( CMAKE_Fortran_FLAGS_PROFILE "${CMAKE_Fortran_FLAGS_PROFILE} -DHAVE_CUDA")
#     set( CMAKE_Fortran_FLAGS_RELEASE "${CMAKE_Fortran_FLAGS_RELEASE} -DHAVE_CUDA" )
#     set( BACKEND_LIBRARIES CUDA::cuda_driver CUDA::cudart CUDA::cublas)

# endif()

# ----- end dependencies ----- #

# Libraries
add_subdirectory(${CMAKE_SOURCE_DIR}/src)

if(KAOLIN_ENABLE_TESTING)
    enable_testing()
    add_subdirectory(${CMAKE_SOURCE_DIR}/test)
endif()

# if(KAOLIN_ENABLE_EXAMPLES)
#     enable_testing()
#     add_subdirectory(${CMAKE_SOURCE_DIR}/examples)
# endif()


