program create_kaolin_array_1d
! This program demonstrates how to create a 1D KaolinArray on a specified device.
  use iso_fortran_env
  use kaolin_array_base
  use kaolin_device_enums
  use kaolin_device

  implicit none

  type(KaolinArray(real32,1)) :: karr
  type(KaolinDevice),target :: device

  device = KaolinDevice(kaolin_x86_cpu) ! Could have optional args for device_id, device_count, etc.

  call karr%create((/100/),device) ! Allocate a 1D array of size 100 on the device

endprogram create_kaolin_array_1d
