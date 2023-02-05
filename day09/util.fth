: <=> ( n1 n2 -- n = Compare the two numbers and return the compare result [-1,0,1] )
  2dup = IF 2drop 0
  ELSE < 2 * 1 + THEN
;

: @! ( x1 a-addr -- x2 = First fetch the contents x2 and then store value x1 ) dup @ -rot ! ;
: free-throw free throw ;

begin-structure acn%       ( -- n = Get the required space for a acn node )
  field:  acn>parent    \ the parent node
  field:  acn>left      \ the left node
  field:  acn>right     \ the right node
  field:  acn>key       \ the key
  field:  acn>cell      \ cell data
  field:  acn>balance   \ balance factor (-1, 0, 1)
end-structure

: acn-parent@ ( bnn1 -- bnn2 ) acn>parent @ ;
: acn-left@ ( bnn1 -- bnn2 ) acn>left @ ;
: acn-right@ ( bnn1 -- bnn2 ) acn>right @ ;
: acn-balance@ ( acn -- n ) acn>balance @ ;

: acn-parent! ( bnn1 bnn2 -- = Set for the node bnn2 the parent to bnn1, if bnn2 is not nil )
  dup nil <> IF acn>parent !
  ELSE 2drop THEN
;

: acn-new ( x1 x2 acn1 -- acn2 = Create a new node acn2 on the heap with parent acn1, key x2 and data x1 )
  acn% allocate throw >r
  r@ tuck acn>parent    !
  dup  acn>left   nil swap !
  dup  acn>right  nil swap !
  acn>key       !
  r@ acn>cell !
  r@ acn>balance 0 swap ! r>
;

: acn-compare-key ( x xt bnn -- x xt bnn n ) >r 2dup r@ acn>key @ swap execute r> swap ;

begin-structure act% ( -- n = Get the required space for a act variable )
  field: act>root            \ the root of the tree
  field: act>length          \ the number of nodes in the tree
  field: act>compare         \ the compare word for the key
end-structure

: act-length@ ( act -- u ) act>length @ ;

: act-new ( -- act = Create a new tree on the heap )
  act% allocate throw   dup
  dup          act>root   nil swap !
  dup          act>length   0 swap !
  ['] <=> swap act>compare   !
;

: act-free ( act -- = Free the tree from the heap )
  dup ['] free-throw >r
  dup act>root @
  BEGIN
    dup nil <>
  WHILE
    dup acn-left@ nil <> IF            \ Walk left tree
      dup  acn-left@
      swap acn>left nil swap !
    ELSE
      dup acn-right@ nil <> IF         \ Walk right tree
        dup  acn-right@
        swap acn>right nil swap !
      ELSE
        dup  acn-parent@               \ Move up and ..
        swap r@ execute                \ .. free the node
      THEN
    THEN
  REPEAT
  rdrop drop
  dup act>root nil swap !              \ Root = nil and length = 0
      act>length 0 swap !
  free throw
;

: act-rotate 
  >r swap
  2dup acn>parent @!                   \ root.parent = root'
  dup nil = IF                         \ IF root.parent = nil Then
    2drop dup r@ act>root ! nil        \   tree.root = root
  ELSE                                 \ Else
    tuck acn-left@ = IF                \  IF root = parent.left Then
      2dup acn>left !                  \    parent.left = root'
    ELSE                               \  Else
      2dup acn>right !                 \    parent.right = root'
    THEN
  THEN
  over acn-parent!                     \ root'.parent = parent or nil
  rdrop
;

: act-rotate-left  ( acn1 act -- acn2 = Rotate nodes to the left for balance, return the root node of the subtree )
  >r
  dup acn-right@                       \ root' = root.right
  2dup acn-left@ swap acn>right !      \ root.right = root'.left
  2dup acn-left@ acn-parent!           \ root'.left.parent = root
  2dup acn>left !                      \ root'.left = root
  r> act-rotate
;

: act-rotate-right ( acn1 act -- acn2 = Rotate nodes to the right for balance, return the new root node of the subtree )
  >r
  dup acn-left@                        \ root' = root.left
  2dup acn-right@ swap acn>left !      \ root.left = root'.right
  2dup acn-right@ acn-parent!          \ root'.right.parent = root
  2dup acn>right !                     \ root'.right = root
  r> act-rotate
;

: act-left   ( acn1 act -- acn2 flag )
  >r dup acn-balance@ ?dup 0= IF       \ If this node was balanced Then
    -1 over acn>balance !              \   Heavy to the left
    true
  ELSE 0< IF                           \ Else If already heavy to the left Then
    dup acn-left@ acn-balance@ 0< IF   \ If node.left.balance = LEFT Then
      dup acn>balance 0 swap !         \   node.balance = equal
      dup acn-left@ acn>balance 0 swap ! \   node.left.balance = equal
      r@ act-rotate-right              \   rotate subtree right
    ELSE
      >r                               \   If node.left.right.balance = equal Then
      0 r@ acn-left@ acn-right@ acn>balance @! ?dup 0= IF
        0 0                            \     equal, equal
      ELSE
        0< IF 1  0                     \     If ...balance = LEFT Then right, equal
        ELSE  0 -1                     \     Else ...balance = RIGHT equal, left  
        THEN
      THEN
      r@ acn-left@ acn>balance !       \   Set node.left.balance
      r@ acn>balance !                 \   Set node.balance
      r>
      dup acn-left@ r@ act-rotate-left drop \  rotate left subtree to the left
      r@ act-rotate-right              \  rotate subtree to the right
    THEN
    ELSE   dup acn>balance 0 swap ! THEN \ Else if heavy to the right Then
    false
  THEN
  rdrop
;

: act-right  ( acn1 act -- acn2 flag )
  >r dup acn-balance@ ?dup 0= IF       \ If this node was balanced Then
    1 over acn>balance !               \   Heavy to the right
    true
  ELSE
    0> IF                              \ Else If already heavy to the right Then
      dup acn-right@ acn-balance@ 0> IF \ If node.right.balance = RIGHT Then
        dup acn>balance 0 swap !       \   node.balance = equal
        dup acn-right@ acn>balance 0 swap ! \   node.right.balance = equal
        r@ act-rotate-left             \   rotate subtree left
      ELSE
        >r                             \   If node.right.left.balance = equal Then
        0 r@ acn-right@ acn-left@ acn>balance @! ?dup 0= IF
          0 0                          \     equal, equal
        ELSE
          0< IF 0 1                    \     If ...balance = LEFT Then equal, right
          ELSE -1 0                    \     Else ...balance = RIGHT Then left, equal  
          THEN
        THEN
        r@ acn-right@ acn>balance !    \   Set node.right.balance
        r@ acn>balance !               \   Set node.balance
        r>
        dup acn-right@ r@ act-rotate-right drop \  rotate right subtree to the right
        r@ act-rotate-left             \  rotate subtree to the left
      THEN
    ELSE  dup acn>balance 0 swap ! THEN \ Else if heavy to the left Then
    false
  THEN
  rdrop
;

: act-insert       ( x1 x2 act -- = Insert data x1 with key x2 in the tree )
  >r ['] acn-new swap
  r@ act>root @ nil = IF               \ first element in tree
    nil rot execute
    dup r@ act>root !                  \ Create the root node
    true
  ELSE
    r@ act>compare @
    r@ act>root    @
    BEGIN
      acn-compare-key ?dup 0= IF      \ Key already present, return for update
        nip nip nip                   \ Compare token, key, creation token 
        false true                    \ Done, no insertion
      ELSE
        0< IF
          dup acn-left@ nil = IF      \ No left node present -> insert
            >r drop                   \ Compare token
            r@ rot execute            \ Create the node
            dup r> acn>left !
            true true                 \ Done, insertion
          ELSE
            acn-left@ false           \ continue searching to the left
          THEN
        ELSE
          dup acn-right@ nil = IF     \ No right node present -> insert
            >r drop                   \ Compare token
            r@ rot execute            \ Create the node
            dup r> acn>right !
            true true                 \ Done, insertion
          ELSE
            acn-right@ false          \ continue searching to the right
          THEN
        THEN
      THEN
    UNTIL
  THEN
  
  dup IF r@ act>length 1 swap +! THEN
  
  IF                                   \ If inserted Then
    dup acn-parent@ true               \   Balance the tree
    BEGIN
      over nil <> AND                   \   While nodes and not balanced Do
    WHILE
      tuck acn-left@ = IF              \   If walked left Then
        r@ act-left              \     Grown left
      ELSE                             \   Else
        r@ act-right             \     Grown right
      THEN
      >r dup acn-parent@ r>            \   Move to the parent
    REPEAT
    2drop
  ELSE acn>cell ! THEN
  rdrop
;
