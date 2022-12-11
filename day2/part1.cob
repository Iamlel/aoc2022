       IDENTIFICATION DIVISION.
       PROGRAM-ID. AOCD2P1.
       AUTHOR. lel.
       DATE-WRITTEN. Dec 11, 2022.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT INPUT_FILE ASSIGN TO "input.txt"
                   ORGANIZATION IS LINE SEQUENTIAL
                   ACCESS IS SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD INPUT_FILE.
       01 RPS_DATA PIC X(3).

       WORKING-STORAGE SECTION.
       77 TOTAL PIC 9(8) VALUE ZERO.

       77 PLAYER1ASCII PIC X.
       77 PLAYER1 REDEFINES PLAYER1ASCII PIC 9(2) COMP-X.

       77 PLAYER2ASCII PIC X.
       77 PLAYER2 REDEFINES PLAYER2ASCII PIC 9(2) COMP-X.


       01 WS-EOF PIC A(1).

       PROCEDURE DIVISION.
           OPEN INPUT INPUT_FILE.
           PERFORM UNTIL WS-EOF='Y'
                   READ INPUT_FILE INTO RPS_DATA
                   AT END MOVE 'Y' TO WS-EOF
                   NOT AT END

                   UNSTRING RPS_DATA
                   DELIMITED BY ALL ' '
                   INTO PLAYER1ASCII, PLAYER2ASCII
                   END-UNSTRING
                   
                   COMPUTE TOTAL = FUNCTION MOD((PLAYER2 - PLAYER1) -
                   19, 3) * 3 + PLAYER2 - 87 + TOTAL
                   END-READ
           END-PERFORM.
           DISPLAY TOTAL.
           CLOSE INPUT_FILE.
           STOP RUN.
