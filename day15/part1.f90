program PartOne
    use vector_class

    implicit none

    integer, parameter :: Y_VAL = 2000000

    type(intvector) :: segments, beacons

    character :: ch
    integer :: buff, sgn, i, fp

    integer, dimension(4) :: dat
    integer, dimension(2) :: coordinate, element

    open(newunit=fp, file="input.txt", access="stream")

    segments = intvector(2)
    beacons = intvector(1)

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
            dat(i) = buff * sgn
            buff = abs(dat(1) - dat(3)) + abs(dat(2) - dat(4)) - abs(dat(2) - Y_VAL)
            if (buff > 0) then
                coordinate = [dat(1) - buff, dat(1) + buff]
                i = 1
                do while (i <= segments%length())
                    element = segments%item(i)
                    if (coordinate(2) >= element(1) .and. element(2) >= coordinate(1)) then
                        coordinate = [min(coordinate(1), element(1)), max(coordinate(2), element(2))]
                        call segments%delete(i)
                    else
                        i = i + 1
                    end if
                end do
                call segments%push(coordinate)
            end if
            if (dat(4) == Y_VAL .and. .not. vec_contains(beacons, dat(3))) then
                call beacons%push([dat(3)])
            end if
            buff = 0
            sgn = 1
            i = 1
        end select
    end do

1   call count_used_positions(segments, beacons)

    contains 
        logical function vec_contains(vec, target)
            type(intvector), intent(in) :: vec
            integer, intent(in) :: target
            integer, dimension(1) :: x
            integer :: i

            vec_contains = .false.
            do i = 1, vec%length()
                x = vec%item(i)
                if (x(1) == target) then
                    vec_contains = .true.
                    return
                end if
            end do
        end function vec_contains

        subroutine count_used_positions(segments, beacons)
            type(intvector), intent(in) :: segments, beacons
            integer, dimension(2) :: segment
            integer, dimension(1) :: beacon
            integer :: total, i, x

            total = segments%length()
            do i = 1, segments%length()
                segment = segments%item(i)
                do x = 1, beacons%length()
                    beacon = beacons%item(x)
                    total = total + segment(2) - segment(1)
                    if ((beacon(1) - segment(1)) * (beacon(1) - segment(2)) <= 0) then
                        total = total - 1
                    end if
                end do
            end do

            print *, total
        end subroutine count_used_positions
end program PartOne
