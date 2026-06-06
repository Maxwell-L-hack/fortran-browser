program simple_get
    use http, only : response_type, request
    implicit none
    type(response_type) :: response

    character(len=:),allocatable :: url_input

    print *,'Enter the URL you wish to view:'
    read (*,*) url_input

    response = request(url=url_input)

    ! Check if the request was successful
    if (.not. response%ok) then
        print *, 'Error message:', response%err_msg
    else
        ! Print the response details
        print *, 'Response Code    :', response%status_code
        print *, 'Response Length  :', response%content_length
        print *, 'Response Method  :', response%method
        print *, 'Response Content :', response%content
    end if

end program simple_get