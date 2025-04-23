module kaolin_array
  use iso_fortran_env
  use iso_c_binding
  use kaolin_device
  use kaolin_device_enums

  implicit none

  private
  public :: KaolinArray
  public :: Create_KaolinArray

  type :: KaolinArray(prec)
  integer,kind :: prec = real32
  integer,private :: ndim
  integer,allocatable,private :: datashape(:)
  real(kind=prec),pointer :: data(:)
  type(KaolinDevice),private,pointer :: device

  endtype KaolinArray

  interface Create_KaolinArray
    module procedure Create_KaolinArray_real32
    module procedure Create_KaolinArray_real64
  endinterface

  contains

  subroutine Create_KaolinArray_real32(this,datashape,device)
    type(KaolinArray(real32)),intent(out) :: this
    integer,dimension(:),intent(in) :: datashape
    type(KaolinDevice),target,intent(in) :: device

    this%ndim = size(datashape)

    this%device => device

    select case(this%device%mem_space)
    case(kaolin_memory_cpu)
      allocate(this%data(product(datashape)))
    case(kaolin_memory_gpu)
      error stop "GPU memory allocation not implemented yet"
      !call gpuCheck(gpuMalloc(c_loc(this%data),(product(shape)*this%prec)))
    case(kaolin_memory_apu)
      error stop "APU memory allocation not implemented yet"
      !call gpuCheck(gpuMalloc(c_loc(this%data),(product(shape)*this%prec)))
    case default
      error stop "Invalid memory space"
    endselect

  endsubroutine Create_KaolinArray_real32

  subroutine Create_KaolinArray_real64(this,datashape,device)
    type(KaolinArray(real64)),intent(out) :: this
    integer,dimension(:),intent(in) :: datashape
    type(KaolinDevice),target,intent(in) :: device

    this%ndim = size(datashape)

    this%device => device

    select case(this%device%mem_space)
    case(kaolin_memory_cpu)
      allocate(this%data(product(datashape)))
    case(kaolin_memory_gpu)
      error stop "GPU memory allocation not implemented yet"
      !call gpuCheck(gpuMalloc(c_loc(this%data),(product(shape)*this%prec)))
    case(kaolin_memory_apu)
      error stop "APU memory allocation not implemented yet"
      !call gpuCheck(gpuMalloc(c_loc(this%data),(product(shape)*this%prec)))
    case default
      error stop "Invalid memory space"
    endselect

  endsubroutine Create_KaolinArray_real64

endmodule kaolin_array
