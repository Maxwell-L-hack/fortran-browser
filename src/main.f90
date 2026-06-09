program simple_get
  use http, only: response_type, request
  implicit none

  type(response_type) :: response

  character(len=2048) :: url_string
  character(len=:), allocatable :: url_input
  character(len=:), allocatable :: user_platform_string

  print *,'Enter the URL you wish to view:'
  read (*,'(A)') url_string

  url_input = trim(adjustl(url_string))

  if (len_trim(url_input) == 0) then
    print *, 'Error: No URL was provided'
    stop 1
  end if
    
  response = request(url=url_input)

  print *,'Enter the platform you''re on, either terminal or gui.'
  read (*,'(A)') user_platform_string
  user_platform_string = trim(adjustl(user_platform_string))

  ! Check if the request was successful
  if (.not. response%ok) then
    print *, 'Error: ', response%err_msg
  else
    ! Print the response details
    print *, 'Response Code    :', response%status_code
    print *, 'Response Length  :', response%content_length
    print *, 'Response Method  :', response%method
    print *, 'Response Content :'
    print *, response%content
  end if
    
  if (user_platform_string == 'terminal') then
    print *, 'Response Content (tags removed):'
    print *, tag_remover(response%content)
  end if

contains

  function tag_remover(s) result(a)
    character(len=:), allocatable :: a
    character(len=*), intent(in) :: s
    integer :: i, in_tag

    a = ''
    in_tag = 0

    do i = 1, len(s)
      select case (s(i:i))
      case ('<')
        in_tag = 1
      case ('>')
        in_tag = 0
      case default
        if (in_tag == 0) then
          a = a // s(i:i)
        end if
      end select
    end do

  end function tag_remover

end program simple_get