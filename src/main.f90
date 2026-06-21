module handlers

  use, intrinsic :: iso_c_binding
  use gtk, only: gtk_application_new, G_APPLICATION_FLAGS_NONE, gtk_application_window_new, gtk_widget_show, gtk_window_set_title
  use g, only: g_application_run, g_object_unref
  implicit none

  contains

    subroutine activate(app, gdata) bind(c)
      type(c_ptr), value, intent(in) :: app, gdata
      type(c_ptr) :: window

      window = gtk_application_window_new(app)
      call gtk_window_set_title(window, "the Fortran Web Browser")
      call gtk_widget_show(window)
    end subroutine activate
    
end module handlers

program simple_get
  use, intrinsic :: iso_c_binding
  use http, only: response_type, request
  use handlers
  use gtk
  use g

  implicit none

  type(c_ptr)         :: app
  integer(c_int)      :: status

  type(response_type) :: response

  character(len=2048) :: url_string
  character(len=:), allocatable :: url_input
  character(len=:), allocatable :: user_platform_string
  character(len=:), allocatable :: body

  app = gtk_application_new("Maxwell-L-hack.fortran-browser"//c_null_char, G_APPLICATION_FLAGS_NONE)
  status = g_application_run(app, 0_c_int, [c_null_ptr])

  print *,'Enter the URL you wish to view:'
  read (*,'(A)') url_string

  url_input = trim(adjustl(url_string))

  if (len_trim(url_input) == 0) then
    print *, 'Error: No URL was provided'
    stop 1
  end if
    
  response = request(url=url_input)

  print *,'Enter the platform you wish to use, either terminal or gui.'
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
    
  body = response%content

  if (user_platform_string == 'terminal') then
    print *, 'Response Content (tags removed):'
  end if

  if (user_platform_String == 'gui') then
    call g_signal_connect(app, "activate"//c_null_char, c_funloc(activate), c_null_ptr)
  end if
  
  call g_object_unref(app)

end program simple_get