#  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
# 
#  Maintainers : support@fluidnumerics.com
#  Official Repository : https://github.com/FluidNumerics/kaolin/
# 
#  Copyright © 2025 Fluid Numerics LLC
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

CMAKE_MINIMUM_REQUIRED(VERSION 3.21)

set(CMAKE_Fortran_MODULE_DIRECTORY ${CMAKE_BINARY_DIR}/include)
set(make_env KAOLIN_HOME=${CMAKE_BINARY_DIR} KAOLIN_COMPILER=${KAOLIN_COMPILER})

function (add_fortran_tests)

    foreach (TFILE ${ARGN})
        string (REGEX REPLACE ".f90$" "" TEST_NAME ${TFILE})
        add_executable (${TEST_NAME} ${CMAKE_CURRENT_SOURCE_DIR}/${TFILE})
        add_dependencies(${TEST_NAME} kaolin)
        target_link_libraries(${TEST_NAME} kaolin)
        target_include_directories(${TEST_NAME} PUBLIC ${CMAKE_BINARY_DIR}/include)
        add_test(NAME ${TEST_NAME} COMMAND ${TEST_NAME})
        install(TARGETS ${TEST_NAME} DESTINATION test)
    endforeach ()

endfunction ()

add_fortran_tests ( "create_kaolin_array_1d_x86_cpu.f90" )

