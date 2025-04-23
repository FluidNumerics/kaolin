program allocate_kaolin_array
  use iso_c_binding
  use iso_fortran_env
  use kaolin_array_base
  use kaolin_device_enums
  use kaolin_device
  implicit none

  type(KaolinArray(real32,1)) :: my_array
  type(KaolinDevice),target :: device

  device = KaolinDevice(kaolin_x86_cpu) ! Could have optional args for device_id, device_count, etc.

  my_array = KaolinArray((/100/),device) ! Allocate a 1D array of size 100 on the device

endprogram allocate_kaolin_array
