module kaolin_array_base
  use iso_fortran_env
  use iso_c_binding
  use kaolin_device
  use kaolin_device_enums

  implicit none

  private
  public :: KaolinArray

  type :: KaolinArray(prec,ndim)
  integer,private,kind :: prec
  integer,private :: ndim
  integer,private :: shape(1:ndim)
  real(kind=prec),pointer :: data(:)
  type(KaolinDevice),private,pointer :: device

contains

  procedure,public :: init => init_KaolinArray

  endtype KaolinArray

  contains

  subroutine init_KaolinArray(this,shape,device)
    class(KaolinArray),intent(inout) :: this
    integer,dimension(:),intent(in) :: shape
    type(KaolinDevice),intent(in) :: device

    if(.not. allocated(shape)) then
      error stop "Shape must be allocated"
    endif
    if(size(shape) == 0) then
      error stop "Shape must have at least one dimension"
    endif
    if(size(shape) .neq.this%ndim) then
      error stop "Shape must have the same number of dimensions as the array"
    endif

    this%device => device

    select case(this%device%mem_space)
    case(kaolin_memory_cpu)
      allocate(this%data(product(shape)))
    case(kaolin_memory_gpu)
      call gpuCheck(gpuMalloc(c_loc(this%data),(product(shape)*this%prec)))
    case(kaolin_memory_apu)
      call gpuCheck(gpuMalloc(c_loc(this%data),(product(shape)*this%prec)))
    case default
      error stop "Invalid memory space"
    endselect

  endsubroutine init_KaolinArray

endmodule kaolin_array_base
