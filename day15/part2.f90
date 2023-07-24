program PartTwo
    use vector_class

    implicit none

    type(intvector) :: sensors
    type(intvector) :: borders

    integer :: buff, sgn, i, fp
    character :: ch

    integer, dimension(3) :: dat

    open(newunit=fp, file="input.txt", access="stream")

    sensors = intvector(3)
    borders = intvector(2)

    buff = 0
    sgn = 1
    i = 1
    do
        read(fp, end=1) ch
        select case (ch)
        case ('0' : '9')
            buff = buff * 10 + ichar(ch) - 48

        case (',', ':')
            dat(i) = buff * sgn
            buff = 0
            sgn = 1
            i = i + 1

        case ('-')
            sgn = -1

        case (char(10))
            buff = abs(dat(1) - dat(3)) + abs(dat(2) - buff * sgn)

            call sensors%push([dat(1), dat(2), buff])
            call borders%push([dat(1) - dat(2) - buff, dat(1) + dat(2) - buff])
            call borders%push([dat(1) - dat(2) + buff, dat(1) + dat(2) + buff])
            
            buff = 0
            sgn = 1
            i = 1
        end select
    end do

1   call find_empty_space(sensors, borders)

    contains 
        subroutine find_empty_space(sensors, borders)
            type(intvector), intent(in) :: sensors, borders
            type(intvector) :: pos, neg
            integer, dimension(2) :: a, b
            integer :: i, j

            pos = intvector(1)
            neg = intvector(1)

            a = borders%item(2)

            do i = 0, sensors%length()-1
                do j = 1, sensors%length()-1
                    if (i + 1 /= j) then
                        a = borders%item(i * 2 + 1)
                        b = borders%item(j * 2)

                        if (a(1) - b(1) == 2) then
                            call pos%push([(a(1) + b(1)) / 2])
                        end if

                        if (a(2) - b(2) == 2) then
                            call neg%push([(a(2) + b(2)) / 2])
                        end if
                    end if
                end do
            end do

            if (pos%length() + neg%length() == 2) then
                a = pos%item(1)
                b = neg%item(1)

                call print_tuning_frequency((a(1) + b(1)) / 2, (b(1) - a(1)) / 2)
            else
                call find_segment_intersection(pos, neg, sensors)
            end if
        end subroutine find_empty_space

        subroutine find_segment_intersection(pos, neg, sensors)
            type(intvector), intent(in) :: pos, neg, sensors
            integer, dimension(3) :: s
            integer :: i, j, k, x, y
            integer, dimension(1) :: p, n
            logical :: b

            do i = 1, pos%length()
                do j = 1, neg%length()
                    p = pos%item(i)
                    n = neg%item(j)

                    x = (p(1) + n(1)) / 2
                    y = (n(1) - p(1)) / 2

                    if (x >= 0 .and. x <= 4000000 .and. y >= 0 .and. y <= 4000000) then
                        b = .true.
                        do k = 1, sensors%length()
                            s = sensors%item(k)

                            if (abs(x - s(1)) + abs(y - s(2)) <= s(3)) then
                                b = .false.
                                exit
                            end if
                        end do

                        if (b) then
                            print *, x, y
                            call print_tuning_frequency(x, y)
                            return
                        end if
                    end if
                end do
            end do
        end subroutine find_segment_intersection

        subroutine print_tuning_frequency(x, y)
            integer, intent(in) :: x, y
            integer :: digit_count
            character(7) :: str_y
            digit_count = floor(log10(real(y))) - 5
            write(str_y, '(I0)') y
            if (digit_count < 1) then
                do i = 1, abs(digit_count)
                    str_y = "0" // str_y
                end do
                print '(I0AA)', x * 4 + (y / 1000000), str_y(:6)
            else
                print '(I0A)', x * 4 + (y / 1000000), str_y(2:)
            end if
        end subroutine print_tuning_frequency
end program PartTwo
