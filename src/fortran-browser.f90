module fortran_browser
  implicit none
  private

  public :: say_hello
contains
  subroutine say_hello
    print *, "Hello, fortran-browser!"
  end subroutine say_hello
end module fortran_browser
