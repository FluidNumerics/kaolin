module kaolin_device

  use iso_fortran_env
  use iso_c_binding
  use kaolin_device_enums
  implicit none
  private

  public :: KaolinArray

  type :: KaolinDevice
    integer :: device_id
    integer :: device_count
    integer :: device_type
    integer :: device_mem_size
  endtype KaolinDevice

endmodule kaolin_device
