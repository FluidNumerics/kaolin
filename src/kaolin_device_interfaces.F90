! //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// !
!
! Maintainers : support@fluidnumerics.com
! Official Repository : https://github.com/FluidNumerics/self/
!
! Copyright © 2024 Fluid Numerics LLC
!
! Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
!
! 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
!
! 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in
!    the documentation and/or other materials provided with the distribution.
!
! 3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from
!    this software without specific prior written permission.
!
! THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS “AS IS” AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
! LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
! HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
! LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
! THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
! THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
!
! //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// !

module kaolin_device_interfaces

  use iso_c_binding
  use kaolin_device_enums

  implicit none

  interface gpuGetDeviceCount
    function gpuGetDeviceCount_(count) bind(c,name="hipGetDeviceCount")
      use iso_c_binding
      use kaolin_device_interfaces_enums
      implicit none
      integer(kind(gpuSuccess)) :: gpuGetDeviceCount_
      integer(c_int) :: count
    endfunction
  endinterface

  interface gpuSetDevice
    function gpuSetDevice_(device_id) bind(c,name="hipSetDevice")
      use iso_c_binding
      use kaolin_device_interfaces_enums
      implicit none
      integer(kind(gpuSuccess)) :: gpuSetDevice_
      integer(c_int),value :: device_id
    endfunction
  endinterface
  interface gpuMalloc
    function gpuMalloc_(ptr,mySize) bind(c,name="hipMalloc")
      use iso_c_binding
      use kaolin_device_interfaces_enums
      implicit none
      integer(kind(gpuSuccess)) :: gpuMalloc_
      type(c_ptr) :: ptr
      integer(c_size_t),value :: mySize
    endfunction
  endinterface gpuMalloc

  interface gpuFree
    function gpuFree_(ptr) bind(c,name="hipFree")
      use iso_c_binding
      use kaolin_device_interfaces_enums
      implicit none
      integer(kind(gpuSuccess)) :: hipFree_
      type(c_ptr),value :: ptr
    endfunction
  endinterface gpuFree

  interface gpuMemcpy
    function gpuMemcpy_(dest,src,sizeBytes,myKind) bind(c,name="hipMemcpy")

      use iso_c_binding
      use kaolin_device_interfaces_enums
      implicit none
      integer(kind(gpuSuccess)) :: hipMemcpy_
      type(c_ptr),value :: dest
      type(c_ptr),value :: src
      integer(c_size_t),value :: sizeBytes
      integer(kind(gpuMemcpyHostToHost)),value :: myKind
    endfunction gpuMemcpy_
  endinterface gpuMemcpy

contains

  subroutine gpuCheck(gpuError_t)
    implicit none
    integer(kind(gpuSuccess)) :: gpuError_t

    if(gpuError_t /= hipSuccess) then
      write(*,*) "GPU ERROR: Error code = ",gpuError_t
      call exit(gpuError_t)
    endif
  endsubroutine gpuCheck

  function GPUAvailable() result(avail)
    implicit none
    logical :: avail
    ! Local
    integer(c_int) :: gpuCount
    integer(kind(gpuSuccess)) :: err

    err = gpuGetDeviceCount(gpuCount)
    if(gpuCount > 0 .and. err == hipSuccess) then
      avail = .true.
    else
      avail = .false.
    endif

  endfunction GPUAvailable

endmodule kaolin_device_interfaces
