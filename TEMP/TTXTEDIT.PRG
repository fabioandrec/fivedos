// FiveWin own colored & fonts Text editing Class
// Warning: Under development. Not available yet!

#include "FiveWin.ch"
#include "Set.ch"

#define VK_BACKSPACE   8

//-------------------------------------------------------------------------//

CLASS TTxtEdit FROM TControl

   DATA   aLines          // Array with the text lines
   DATA   aDelLines       // Array where store the del lines
   DATA   nDelLines       // Max. number of deleted lines to store
   DATA   nVisLines       // Number of lines that fit in screen
   DATA   nLineTop        // First line visible on screen
   DATA   lInsert, lChanged
   DATA   cFileName, cOperators, cSeparators
   DATA   nRow, nCol AS NUMBER           // Phisical row and col
   DATA   nLineRow, nLineCol AS NUMBER   // Logical row and col
   DATA   aTokens1, aTokens2, aTokens3, aBegWith
   DATA   nClrTok1, nClrTok2, nClrTok3, nClrBegin
   DATA   nClrNumber, nClrString, nClrOperator
   DATA   nClrNormal
   DATA   cClrLabel

   DATA   nClrBBlock AS NUMERIC INIT 7
   DATA   nClrFBlock AS NUMERIC INIT 12
   DATA   nBlkStart, nBlkEnd AS NUMERIC INIT 0 // Block markers
   DATA   bChange  as Block INIT bNil()

   DATA   nTabLen
   DATA   lVScroll AS LOGICAL INIT .t. // Always show the vertical scrollbar

   DATA nLabel AS NUMERIC // have label ??

   CLASSDATA lRegistered AS LOGICAL

   METHOD New( nTop, nLeft, nWidth, nHeight, oWnd ) CONSTRUCTOR

   METHOD Change() INLINE Eval( ::bChange )

   METHOD DelCurLine() INLINE ::DelLine( ::nLineRow + 1 )

   METHOD DelLine( nLine )

   METHOD DrawLine( nLine, nRow, nClrBack )

   METHOD DrawCurLine() INLINE  ::DrawLine( ::nLineRow + 1,;
                        ::nLineRow - ::nLineTop + 2 )

   METHOD Display() INLINE ::BeginPaint(), ::Paint(), ::EndPaint(), 0

   METHOD GoUp()

   METHOD InsLine()

   METHOD Load( cTxtFile )

   METHOD nGetTokenColor( cToken )

   METHOD nLine INLINE ::nLineTop + ::nLineRow

   METHOD _nLine( nNewLine ) INLINE ::GoLine( nNewLine )

   METHOD Paint()

   METHOD SelFile( cMask, cTitle )

//   METHOD GotFocus()
//   METHOD LostFocus() INLINE DestroyCaret(), Super:LostFocus()

//   METHOD KeyChar( nKey, nFlags )

//   METHOD KeyDown( nKey, nFlags )

   METHOD KeyPressed( nKey )

//   METHOD LButtonDown( nRow, nCol, nFlags )

   METHOD Click( nRow, nCol, lDblClick )

   METHOD GoPrevLine()
   METHOD GoNextLine()
   METHOD GoPrevChar()
   METHOD GoNextChar()

   METHOD GoBeginLine()
   METHOD GoEndLine()

   METHOD GoPrevWord()
   METHOD GoNextWord()

   METHOD ToggleInsert()

   METHOD ReSize( nType, nWidth, nHeight )

//   METHOD SetFont( oFont ) INLINE Super:SetFont( oFont ),;
//              ::nVisLines = Int( ::nHeight / ::nGetChrHeight() )

   METHOD SetText( cText )
   METHOD VScrAdjust()       // Vertical ScrollBar Range Adjust

   METHOD GoBottom()
   METHOD GoTop()
   METHOD GotoLine()
   METHOD GoLine( nLine )

   METHOD PageUp()  INLINE If( ( ::nLineTop - ::nVisLines ) > 0, ;
                         ::GoLine( ::nLineTop - ::nVisLines ), ;
                         ::GoTop() )

   METHOD PageDown() INLINE If( ( ::nLineTop + ::nVisLines ) < Len( ::aLines ), ;
                         ::GoLine( ::nLineTop + ::nVisLines ), ;
                         ::GoBottom() )

ENDCLASS

//-------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nWidth, nHeight, cColor, cChar, cLabel, acLabelClrs;
     cMessage, bWhen, bValid, bChange, oWnd ) CLASS TTxtEdit

   local nRow


   ::aLines      = {}
   ::aDelLines   = {}
   ::nDelLines   = 20
   ::lInsert     = .t.
   ::lChanged    = .f.
   ::cFileName   = ""
   ::cOperators  = "+-/:==%(){}@."
   ::nRow        = 0
   ::nCol        = 0
   ::nLineRow    = 0
   ::nLineCol    = 0
   ::nLineTop    = 1
   ::cSeparators = " ,;.:()[]+-=" + Chr( 13 ) + Chr( TAB )
   ::nTabLen     = 3

   DEFAULT cColor := 'n/w,g+/w,b+/w,gr+/w,r/bg,gr+/bg,w+/w'


   ::nClrTok1     = nStrColor( cColor, 1)
   ::nClrTok2     = nStrColor( cColor, 2)
   ::nClrTok3     = nStrColor( cColor, 3)
   ::nClrBegin    = nStrColor( cColor, 4)
   ::nClrNumber   = nStrColor( cColor, 5)
   ::nClrString   = nStrColor( cColor, 6)
   ::nClrOperator = nStrColor( cColor, 7)
   ::aTokens1     = { "FUNCTION", "RETURN", "CLASS", "FROM",;
                     "DATA", "METHOD", "ENDCLASS", "DEFINE",;
                     "WINDOW", "ACTIVATE" }
   ::aTokens2     = { "LOCAL", "CONSTRUCTOR" }
   ::aTokens3     = { "NIL" }
   ::aBegWith     = { "//" }
   ::cOperators   = "+-/*%:[]()=,."

   ::nLabel   = if( Empty( cLabel ), 0, 1 )

    METHOD New( nTop, nLeft, nWidth, nHeight, cColor, cChar, oWnd, cMessage,;
               cLabel, bWhen, bValid, acLabelClrs )

      DEFINE SCROLLBAR ::oVScroll VERTICAL ;
         RANGE 1, 1 ;
         ON UP       ::GoPrevLine() ;
         ON DOWN     ::GoNextLine() ;
         ON PAGEUP   ::PageUp() ;
         ON PAGEDOWN ::PageDown() ;
         ON THUMBPOS ::GoLine( nPos )

     ::oVscroll:oWnd:=self

return nil

//-------------------------------------------------------------------------//

METHOD DelLine( nLine ) CLASS TTxtEdit

   if nLine < Len( ::aLines )
      ADel( ::aLines, nLine )
      ASize( ::aLines, Len( ::aLines ) - 1 )
      ::VScrAdjust()
   endif
   ::Refresh()

return nil

//-------------------------------------------------------------------------//

METHOD DrawLine( nLine, nRow, nClrBack ) CLASS TTxtEdit

   local cWord
   local nOffset := 0, nAt
   local cTextLine := ::aLines[ nLine ]
   local nCol := 0
   local lString := .f.
   local lKeepColor := .f.
   local lBock := .f.
   local nColor

   DEFAULT  nRow := ::nRowPos


   if nLine >= Min( ::nBlkStart, ::nBlkEnd ) .and. ;
      nLine <= Max( ::nBlkEnd, ::nBlkStart )
      lBlock := .t.
   end

    ::say( ::nLabel + nRow, cTextLine, ::nClrText )

   while ! Empty( cWord := cStrWord( cTextLine, @nOffset, ::cSeparators ) ) .and. ;
         ! lKeepColor
      do case
         case lString
              nColor := ::nClrString
              if At( '"', cWord ) != 0
                 lString = .f.
              endif

         case SubStr( LTrim( cWord ), 1, 1 ) >= "0" .and. ;
              SubStr( LTrim( cWord ), 1, 1 ) <= "9"
              nColor := ::nClrNumber

         case SubStr( LTrim( cWord ), 1, 1 ) == '"'
              nColor := ::nClrString
              lString = .t.

         case At( LTrim( cWord ), ::cOperators ) != 0
              nColor := ::nClrOperator

         case ( nAt := AScan( ::aTokens1, Upper( LTrim( cWord ) ) ) ) != 0
              nColor := ::nClrTok1

         case ( nAt := AScan( ::aTokens2, Upper( LTrim( cWord ) ) ) ) != 0
              nColor := ::nClrTok2

         case ( nAt := AScan( ::aTokens3, Upper( LTrim( cWord ) ) ) ) != 0
              nColor := ::nClrTok3

         case ( nAt := AScan( ::aBegWith, Upper( LTrim( cWord ) ) ) ) != 0
              nColor := ::nClrBegin
              lKeepColor = .t.

         otherwise
              if nLine >= Min( ::nBlkStart, ::nBlkEnd ) .and. ;
                 nLine <= Max( ::nBlkEnd, ::nBlkStart )
                 nColor := ::nClrFBlock
              else
                 nColor := ::nClrText
              endif
      endcase
      ::oWnd:say(nRow+::nLabel ,nCol, cWord, nColor)
      nCol += len( cWord )
   end

   if lKeepColor
      TextOut( ::hDC, ( nRow - 1 ) * nChrHeight, nCol,;
               cWord := SubStr( cTextLine, nOffset ) )
      nCol += ::GetWidth( cWord )
   endif

   TextOut( ::hDC, ( nRow - 1 ) * nChrHeight, nCol, Space( 200 ) )

   ::ReleaseDC()

return nil

//----------------------------------------------------------------------------//

METHOD GoUp() CLASS TTxtEdit

   if ::nLine > 1
      if GetKeyState( VK_SHIFT )
         if ::nBlkStart != 0
            --::nBlkEnd
         else
            ::nBlkStart = ::nLine
            ::nBlkEnd   = ::nLine
         endif
         ::GoPrevLine()
         ::DrawCurLine()
      else
         if ::nBlkStart != 0
            ::nBlkStart = 0
            ::nBlkEnd   = 0
            HideCaret( ::hWnd )
            ::Paint()
            ShowCaret( ::hWnd )
         endif
         ::GoPrevLine()
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD InsLine( nLine ) CLASS TTxtEdit

   DEFAULT nLine := ::nLineRow + 1

   AAdd( ::aLines, nil )
   AIns( ::aLines, nLine )
   ::aLines[ nLine ] = ""
   ::VScrAdjust()
   ::Refresh()

return nil

//----------------------------------------------------------------------------//

METHOD Load( cTxtFile ) CLASS TTxtEdit      // Load a file from disk

   local oFile

   if ! File( cTxtFile )
      MsgStop( "Can't find file: " + cTxtFile )
      return nil
   endif

   oFile = TTxtFile():New( cTxtFile )

   CursorWait()

   while ! oFile:lEof()
      AAdd( ::aLines, oFile:ReadLine() )
      oFile:Skip()
   end

   oFile:Close()
   ::VScrAdjust()

return nil

//-------------------------------------------------------------------------//

METHOD SelFile( cMask, cTitle ) CLASS TTxtEdit     // Interactively select
                                                   // a file to edit
   local cFile

   DEFAULT cMask := "*.*", cTitle := "Select a file to edit"

   if File( cFile := cGetFile( cMask, cTitle ) )
      ::cFileName = cFile
      ::Load( cFile )
   endif

return nil

//-------------------------------------------------------------------------//

METHOD GotFocus() CLASS TTxtEdit

   if Set( _SET_INSERT )
      CreateCaret( ::hWnd, 0, 6, ::nGetChrHeight() )
   else
      CreateCaret( ::hWnd, 0, 2, ::nGetChrHeight() )
   endif
   ShowCaret( ::hWnd )
   ::setcursor( ::nCol, ::nRow )

return Super:GotFocus()

//-------------------------------------------------------------------------//

METHOD KeyChar( nKey, nFlags ) CLASS TTxtEdit

   local cLastToken, nColor

   if Len( ::aLines ) == 0
      ::aLines = { "" }
   endif

   if Chr( nKey ) $ ::cSeparators
      cLastToken = SubStr( ::aLines[ ::nLineRow + 1 ],;
                           RAt( " ", ::aLines[ ::nLineRow + 1 ] ) + 1 )
      if ( nColor := ::nGetTokenColor( cLastToken ) ) != 0
         HideCaret( ::hWnd )
         ::Say( ::nRow, ::nCol - ::GetWidth( cLastToken ),;
                cLastToken, nColor,,, .t. )
         ShowCaret( ::hWnd )
      endif
   endif

   do case
      case nKey == VK_BACKSPACE
           if Len( ::aLines[ ::nLineRow + 1 ] ) > 0
              ::aLines[ ::nLineRow + 1 ] = ;
                 SubStr( ::aLines[ ::nLineRow + 1 ], 1, ::nLineCol - 1 ) + ;
                 SubStr( ::aLines[ ::nLineRow + 1 ], ::nLineCol + 1 )
              ::DrawCurLine()
              ::GoPrevChar()
           endif

      case nKey == VK_RETURN
           if Set( _SET_INSERT )
              ::InsLine()
           else
              ::nRow += ::nChrHeight
              ::nCol  =  0
              ::nLineRow++
              ::nLineCol = 0
              if Len( ::aLines ) < ::nLineRow + 1
                 AAdd( ::aLines, "" )
                 ::VScrAdjust()
              endif
              ::setcursor( ::nCol, ::nRow )
           endif
           ::oVScroll:GoDown()

      case nKey == VK_TAB
           ::nLineCol += ::nTabLen
           HideCaret( ::hWnd )
           ::Say( ::nRow, ::nCol, Space( ::nTabLen ),,,,.t. )
           ::aLines[ ::nLineRow + 1 ] += Chr( VK_TAB )
           ::nCol += ::GetWidth( Space( ::nTabLen ) )
           ::setcursor( ::nCol, ::nRow )
           ShowCaret( ::hWnd )

      otherwise
          HideCaret( ::hWnd )
          if ::nLineCol < Len( ::aLines[ ::nLineRow + 1 ] )
             if Set( _SET_INSERT )
                ::aLines[ ::nLineRow + 1 ] = ;
                   SubStr( ::aLines[ ::nLineRow + 1 ], 1,;
                   ::nLineCol ) + Chr( nKey ) + SubStr( ;
                   ::aLines[ ::nLineRow + 1 ], ::nLineCol + 1 )
             else
                ::aLines[ ::nLineRow + 1 ] = ;
                   SubStr( ::aLines[ ::nLineRow + 1 ], 1,;
                   ::nLineCol ) + Chr( nKey ) + SubStr( ;
                   ::aLines[ ::nLineRow + 1 ], ::nLineCol + 2 )
             endif
             ::DrawCurLine()
          else
             ::Say( ::nRow, ::nCol, Chr( nKey ),,,,.t. )
             ::aLines[ ::nLineRow + 1 ] += Chr( nKey )
          endif
          ::nCol += ::GetWidth( Chr( nKey ) )
          ::setcursor( ::nCol, ::nRow )
          ShowCaret( ::hWnd )
          ::nLineCol++
   endcase

return nil

//-------------------------------------------------------------------------//

METHOD KeyDown( nKey, nFlags ) CLASS TTxtEdit

   do case
      case nKey == VK_UP
           ::GoUp()

      case nKey == VK_DOWN
           if GetKeyState( VK_SHIFT )
              if ::nBlkStart != 0
                 ::nBlkEnd = ::nLine
              else
                 ::nBlkStart = ::nLine
                 ::nBlkEnd   = ::nLine
              endif
              ::DrawCurLine()
              ::GoNextLine()
           else
              if ::nBlkStart != 0
                 ::nBlkStart = 0
                 ::nBlkEnd   = 0
                 HideCaret( ::hWnd )
                 ::Paint()
                 ShowCaret( ::hWnd )
              endif
              ::GoNextLine()
           endif

      case nKey == VK_RIGHT
           if GetKeyState( VK_CONTROL )
              ::GoNextWord()
           else
              ::GoNextChar()
           endif

      case nKey == VK_LEFT
           if GetKeyState( VK_CONTROL )
              ::GoPrevWord()
           else
              ::GoPrevChar()
           endif

      case nKey == VK_HOME
           ::GoBeginLine()

      case nKey == VK_END
           ::GoEndLine()

      case nKey == VK_DELETE
           if Len( ::aLines[ ::nLineRow + 1 ] ) > 0
              ::aLines[ ::nLineRow + 1 ] = ;
                 SubStr( ::aLines[ ::nLineRow + 1 ], 1, ::nLineCol ) + ;
                 SubStr( ::aLines[ ::nLineRow + 1 ], ::nLineCol + 2 )
              ::DrawCurLine()
           else
              ::DelCurLine()
           endif

      case nKey == VK_INSERT
           ::ToggleInsert()

      case nKey == VK_NEXT
           if GetKeyState( VK_CONTROL )
              ::GoBottom()
           else
              ::PageDown()
           endif

      case nKey == VK_PRIOR
           if GetKeyState( VK_CONTROL )
              ::GoTop()
           else
              ::PageUp()
           endif
   endcase

   ::Change()

return nil

//-------------------------------------------------------------------------//

METHOD nGetTokenColor( cToken ) CLASS TTxtEdit

   local nColor := 0

   cToken = Upper( AllTrim( cToken ) )

   do case
      case SubStr( cToken, 1, 1 ) == '"'
           nColor = ::nClrString

      case SubStr( cToken, 1, 1 ) >= "0" .and. ;
           SubStr( cToken, 1, 1 ) <= "9"
           nColor = ::nClrNumber

      case AScan( ::aTokens1, cToken ) != 0
           nColor = ::nClrTok1

      case AScan( ::aTokens2, cToken ) != 0
           nColor = ::nClrTok2

      case AScan( ::aTokens3, cToken ) != 0
           nColor = ::nClrTok3

      case AScan( ::aBegWith, cToken ) != 0
           nColor = ::nClrBegin
   endcase

return nColor

//-------------------------------------------------------------------------//

METHOD Paint() CLASS TTxtEdit

   local n

   for n = 1 to Min( Len( ::aLines ) - ::nLineTop + 1, ::nVisLines )
      ::DrawLine( ::nLineTop + n - 1, n, ::nClrPane )
   next

return nil

//-------------------------------------------------------------------------//

METHOD GoPrevLine() CLASS TTxtEdit

   if ::nLineRow == 0
      if ::nLineTop > 1
         HideCaret( ::hWnd )
         WScroll( ::hWnd, -1 )
         ::DrawLine( --::nLineTop + ::nLineRow, 1, ::nClrPane )
         ::setcursor( ::nCol, ::nRow )
         ShowCaret( ::hWnd )
         ::oVScroll:SetPos( ::oVScroll:GetPos() - 1 )
      else
         MsgBeep()
      endif
   else
      ::nRow -= ::nChrHeight
      ::nLineRow--
      ::nLineCol = Min( Len( ::aLines[ ::nLineRow + 1 ] ), ::nLineCol )
      ::nCol = ::GetWidth( SubStr( ::aLines[ ::nLineRow + 1 ], 1, ::nLineCol ) )
      HideCaret( ::hWnd )
      ::setcursor( ::nCol, ::nRow )
      ShowCaret( ::hWnd )
      ::oVScroll:SetPos( ::oVScroll:GetPos() - 1 )
   endif

return nil

//-------------------------------------------------------------------------//

METHOD GoNextLine() CLASS TTxtEdit

   if ::nLineTop + ::nLineRow < Len( ::aLines )
      if ::nLineRow = ::nVisLines - 1
         HideCaret( ::hWnd )
         WScroll( ::hWnd, 1 )
         ::DrawLine( ++::nLineTop + ::nLineRow, ::nVisLines, ::nClrPane )
         ::setcursor( ::nCol, ::nRow )
         ShowCaret( ::hWnd )
         ::oVScroll:SetPos( ::oVScroll:GetPos() + 1 )
      else
         ::nRow += ::nChrHeight
         ::nLineRow++
         ::nLineCol = Min( Len( ::aLines[ ::nLineRow + 1 ] ), ::nLineCol )
         ::nCol = ::GetWidth( SubStr( ::aLines[ ::nLineRow + 1 ], 1, ::nLineCol ) )
         ::setcursor( ::nCol, ::nRow )
         ::oVScroll:SetPos( ::oVScroll:GetPos() + 1 )
      endif
   endif

return nil

//-------------------------------------------------------------------------//

METHOD GoNextChar() CLASS TTxtEdit

   local cChar

   if ::nLineCol < Len( ::aLines[ ::nLineTop + ::nLineRow ] )
      cChar = StrChar( ::aLines[ ::nLineTop + ::nLineRow ], ::nLineCol++ + 1 )
      if cChar == Chr( VK_TAB )
         ::nCol += ::GetWidth( Space( ::nTabLen ) )
      else
         ::nCol += ::GetWidth( cChar )
      endif
      ::setcursor( ::nCol, ::nRow )
   else
      if ::nLineRow < Len( ::aLines ) - 1
         ::nLineRow++
         ::nLineCol = 0
         ::nRow    += ::nChrHeight
         ::nCol     = 0
         ::setcursor( ::nCol, ::nRow )
         ::oVScroll:SetPos( ::oVScroll:GetPos() + 1 )
      endif
   endif

return nil

//-------------------------------------------------------------------------//

METHOD GoPrevChar() CLASS TTxtEdit

   local cChar

   if ::nLineCol > 0
      cChar = StrChar( ::aLines[ ::nLineTop + ::nLineRow ], --::nLineCol + 1 )
      if cChar == Chr( VK_TAB )
         ::nCol -= ::GetWidth( Space( ::nTabLen ) )
      else
         ::nCol -= ::GetWidth( cChar )
      endif
      ::setcursor( ::nCol, ::nRow )
   else
      if ::nLineRow > 0
         ::nLineRow--
         ::nLineCol = Len( ::aLines[ ::nLineTop + ::nLineRow ] )
         ::nRow -= ::nChrHeight
         ::nCol  = ::GetWidth( ::aLines[ ::nLineTop + ::nLineRow ] )
         ::setcursor( ::nCol, ::nRow )
         ::oVScroll:SetPos( ::oVScroll:GetPos() - 1 )
      endif
   endif

return nil

//-------------------------------------------------------------------------//

METHOD GoBeginLine() CLASS TTxtEdit

   if ::nLineCol > 0
      ::nLineCol = 0
      ::nCol     = 0
      ::setcursor( ::nCol, ::nRow )
   endif

return nil

//-------------------------------------------------------------------------//

METHOD GoEndLine() CLASS TTxtEdit

   local cLine := StrTran( ::aLines[ ::nLineRow + 1 ],;
                  Chr( VK_TAB ), Space( ::nTabLen ) )

   if ::nLineCol < Len( ::aLines[ ::nLineRow + 1 ] )
      ::nLineCol = Len( ::aLines[ ::nLineRow + 1 ] )
      ::nCol = ::GetWidth( cLine )
      ::setcursor( ::nCol, ::nRow )
  endif

return nil

//-------------------------------------------------------------------------//

METHOD GoNextWord() CLASS TTxtEdit

   local n := ::nLineCol
   local cLine := StrTran( ::aLines[ ::nLineRow + 1 ],;
                           Chr( VK_TAB ), Space( ::nTabLen ) )

   while ! StrChar( cLine, n + 2 ) $ ::cSeparators .and. ;
         n++ < Len( cLine )
   end

   if n < Len( cLine )
      while StrChar( cLine, n + 2 ) $ ::cSeparators .and. ;
            n++ < Len( cLine )
      end
      if ! StrChar( cLine, n + 2 ) $ ::cSeparators
         ::nLineCol = n + 1
         ::nCol = ::GetWidth( SubStr( cLine, 1, ::nLineCol ) )
         ::setcursor( ::nCol, ::nRow )
      endif
  endif

return nil

//-------------------------------------------------------------------------//

METHOD GoPrevWord() CLASS TTxtEdit

   local n := ::nLineCol

   while StrChar( ::aLines[ ::nLineRow + 1 ], n ) == " " .and. ;
         --n > 0
   end

   if n > 0
      while StrChar( ::aLines[ ::nLineRow + 1 ], n ) != " " .and. ;
            --n > 0
      end
      ::nLineCol = n
      ::nCol = ::GetWidth( SubStr( ::aLines[ ::nLineRow + 1 ], 1,;
                           ::nLineCol ) )
      ::setcursor( ::nCol, ::nRow )
   endif

return nil

//-------------------------------------------------------------------------//

METHOD ToggleInsert() CLASS TTxtEdit

   Set( _SET_INSERT, ! Set( _SET_INSERT ) )
   DestroyCaret()
   if Set( _SET_INSERT )
      CreateCaret( ::hWnd, 0, 6, ::nGetChrHeight() )
   else
      CreateCaret( ::hWnd, 0, 2, ::nGetChrHeight() )
   endif
   ShowCaret( ::hWnd )

return nil

//-------------------------------------------------------------------------//

METHOD LButtonDown( nRow, nCol, nFlags ) CLASS TTxtEdit

   local nLine   := Int( nRow / ::nChrHeight )
   local n := 0, nColPos := 0, nChrWidth := 1
   local cLine

   if Empty( ::aLines ) .or. nLine > Len( ::aLines ) - 1
      return nil
   endif

   if ::nLineRow != nLine
      ::nLineRow = nLine
      ::nRow     = nLine * ::nChrHeight
      ::oVScroll:SetPos( nLine + 1 )
   endif

   cLine = ::aLines[ nLine + 1 ]
   while nColPos < nCol .and. n < Len( cLine ) - 1
      nChrWidth = ::GetWidth( StrChar( cLine, n++ + 1 ) )
      nColPos  += nChrWidth
   end
   if ( nColPos - nCol ) > ( nChrWidth / 2 )
      ::nCol     = nColPos - nChrWidth
      ::nLineCol = --n
   else
      ::nCol     = nColPos
      ::nLineCol = n
   endif
   ::setcursor( ::nCol, ::nRow )

   ::Change()

return nil

//-------------------------------------------------------------------------//

METHOD ReSize( nType, nWidth, nHeight ) CLASS TTxtEdit

   ::nVisLines = Int( nHeight / ::nChrHeight )
   ::VScrAdjust()

return Super:ReSize( nType, nWidth, nHeight )

//-------------------------------------------------------------------------//

METHOD SetText( cText ) CLASS TTxtEdit

   local n

   ::aLines   = {}
   ::nRow     = 0
   ::nCol     = 0
   ::nLineRow = 0
   ::nLineCol = 0

   for n = 1 to MlCount( cText )
      AAdd( ::aLines, RTrim( MemoLine( cText,, n ) ) )
   next

   ::VScrAdjust()

return nil

//-------------------------------------------------------------------------//

METHOD VScrAdjust() CLASS TTxtEdit

   if ::lVScroll
      if ::oVScroll != nil
         ::oVScroll:SetRange( 1, Len( ::aLines ) )
      endif
   else
      if Len( ::aLines ) > ::nVisLines
         ::oVScroll:SetRange( 1, Len( ::aLines ) )
      else
         ::oVScroll:SetRange( 0, 0 )
      endif
   endif

return nil

//-------------------------------------------------------------------------//

METHOD GotoLine() CLASS TTxtEdit

   local oGLine, nLine := 0

   DEFINE DIALOG oGLine FROM 5,5 TO 10,29 TITLE "Go To"

   @ 0.5, 2 SAY "Line:" OF oGLine
   @ 0.5, 5 GET nLine OF oGLine PICTURE "99999" SIZE 20, 10

   @ 1.9, 1 BUTTON "&Ok"  OF oGLine SIZE 35,10                              ;
      ACTION  ( IF( nLine < ( Len( ::aLines ) + 1 ) .and. ( nLine > 0 ), ;
              ::GoLine( nLine ), ;
              ::GoBottom() ), ;
              ::setcursor( ::nCol, ::nRow ), ::VScrAdjust(), ;
              ::Refresh(), oGLine:end() )

   @ 1.9, 8 BUTTON "&Cancel" OF oGLine SIZE 35, 10 ACTION oGLine:end()

   ACTIVATE DIALOG oGLine CENTERED

return nil

//-------------------------------------------------------------------------//

METHOD GoLine( nLine ) CLASS TTxtEdit

   local n

   ::nLineTop = nLine

   for n = 1 to Min( Len( ::aLines ) - ::nLineTop + 1, ::nVisLines )
      ::DrawLine( ::nLineTop + n - 1, n, ::nClrPane )
   next

   ::nLineRow = n - 1
   ::nCol = 1
   ::nRow = 0
   ::setcursor( ::nCol, ::nRow )
   ShowCaret( ::hWnd )
   ::oVScroll:SetPos( ::nLineTop )

   ::Change()

return nil

//-------------------------------------------------------------------------//

METHOD GoBottom() CLASS TTxtEdit

   local n

/*   MsgInfo( Str( ::nLineTop ) )
   MsgInfo( Str( ::nLineRow ) )
   MsgInfo( Str( ::nVisLines ) )
   MsgInfo( Str( ::nLineCol ) )
   MsgInfo( Str( ::nCol ) )
   MsgInfo( Str( ::nRow ) )
   MsgInfo( Str( ::nChrHeight ) )
*/
   HideCaret( ::hWnd )
   ::nLineTop = Len( ::aLines ) - ( ::nVisLines - 1 )

   for n = 1 to ::nVisLines
      ::DrawLine( ::nLineTop + n - 1, n, ::nClrPane )
   next

   ::nLineRow = n - 1
   ::nCol = 1
   ::nRow = ( ::nLineRow - 1 ) * ::nChrHeight
   ::setcursor( ::nCol, ::nRow )
   ShowCaret( ::hWnd )
   ::oVScroll:SetPos( ::nRoW )

return nil

//-------------------------------------------------------------------------//

METHOD GoTop() CLASS TTxtEdit

   local n

   HideCaret( ::hWnd )
   ::nLineTop = 1

   for n = 1 to ::nVisLines
      ::DrawLine( ::nLineTop + n - 1, n, ::nClrPane )
   next

   ::nLineRow = 0
   ::nCol = 1
   ::nRow = 0
   ::setcursor( ::nCol, ::nRow )
   ShowCaret( ::hWnd )
   ::oVScroll:SetPos( ::nRoW )

return nil

//-------------------------------------------------------------------------//

function cStrWord( cText, nOffset, cSeparator )
    local cWord := ''
    default cSeparator := " ,;.:()[]+-=" + Chr( 13 ) + Chr( TAB )

    do while ++nOffset <= len( cText )
        if substr( cText, nOffset,1 )$ cSeparator
            exit
        end
    end

    do while ++nOffset <= len( cText )
        if substr( cText, nOffset,1 )$ cSeparator
            exit
        end
        cWord += substr( cText, nOffset,1 )
    end

return cWord

