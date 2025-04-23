module kaolin_device

  use iso_fortran_env
  use iso_c_binding
  use kaolin_device_enums
  implicit none

  type :: KaolinDevice
    integer :: device_id
    integer :: device_type
    integer :: mem_space
  endtype KaolinDevice

  interface KaolinDevice
    module procedure create_KaolinDevice
  endinterface

contains

  function create_KaolinDevice(device_type,device_id) result(this)
    type(KaolinDevice) :: this
    integer,intent(in) :: device_type
    integer,intent(in),optional :: device_id
    ! Local
    integer :: device_id_

    if(present(device_id)) then
      device_id_ = device_id
    else
      device_id_ = 0
    endif

    this%device_id = device_id_
    this%device_type = device_type

    select case(device_type)
    case(kaolin_x86_cpu)
      this%mem_space = kaolin_memory_cpu
    case(kaolin_amdgpu)
      this%mem_space = kaolin_memory_gpu
    case(kaolin_nvidiagpu)
      this%mem_space = kaolin_memory_gpu
    case(kaolin_intelgpu)
      this%mem_space = kaolin_memory_gpu
    case(kaolin_amdapu)
      this%mem_space = kaolin_memory_apu
    case default
      error stop "Invalid device type"
    endselect

  endfunction create_KaolinDevice

endmodule kaolin_device
