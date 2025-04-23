module kaolin_array_base
  use iso_fortran_env
  use iso_c_binding
  implicit none
  private

  public :: KaolinArray

  enum,bind(c)
    enumerator :: kaolin_memory_host = 0
    enumerator :: kaolin_memory_device = 1
    enumerator :: kaolin_memory_distributed_host = 2
    enumerator :: kaolin_memory_distributed_device = 3
  endenum

  type :: KaolinArray(prec)
  integer,kind :: prec
  integer :: ndim
  integer,allocatable :: shape(:)
  real(kind=prec),pointer :: data(:)
  integer :: mem_space
contains
  procedure,public :: is_on_device
  procedure,public :: get_shape
  endtype KaolinArray

  type,extends(KaolinArray) :: KaolinArrayHost
    ! Add any additional fields or methods specific to host arrays here
  endtype KaolinArrayHost

  ! Default constructor for KaolinArray
  interface KaolinArray
    module procedure Construct_KaolinArray
  endinterface KaolinArray

  contains

  function Construct_KaolinArray(ndim,shape,mem_space) result(this)
    integer,intent(in) :: ndim
    integer,intent(in):: shape(:)
    integer,intent(in) :: mem_space
    class(KaolinArray) :: this

    allocate(this)
    this%ndim = ndim
    allocate(this%shape(ndim))
    this%shape = shape
    this%mem_space = mem_space

    numel
    select case(mem_space)
    case(kaolin_memory_host)
      allocate(this%data(product(shape)))
    case(kaolin_memory_device)
      this%data = c_loc(0_c_ptr) ! Placeholder for device memory
    case(kaolin_memory_distributed_host)
      this%data = c_loc(0_c_ptr) ! Placeholder for distributed host memory
    case(kaolin_memory_distributed_device)
      this%data = c_loc(0_c_ptr) ! Placeholder for distributed device memory
    case default
      error stop "Invalid memory space"
    endselect

  endfunction Construct_KaolinArray

  function is_on_device(this) result(flag)
    class(KaolinArray),intent(in) :: this
    logical :: flag
    flag = this%mem_space == memory_device .or. this%mem_space == memory_distributed_device
  endfunction

  function get_shape(this) result(s)
    class(KaolinArray),intent(in) :: this
    integer,allocatable :: s(:)
    s = this%shape
  endfunction

endmodule kaolin_array_base
