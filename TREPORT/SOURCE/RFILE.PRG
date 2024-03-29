/*
旼 Programa 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
�   Aplication: Class TRFile for class TReport                             �
�         File: RFILE.PRG                                                  �
�       Author: Ignacio Ortiz de Z＄iga Echeverr죂                         �
�          CIS: Ignacio Ortiz (100042,3051)                                �
�         Date: 07/28/94                                                   �
�         Time: 20:20:07                                                   �
�    Copyright: 1994 by Ortiz de Zu쨒ga, S.L.                              �
읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
*/
#include "FiveDos.ch"

//----------------------------------------------------------------------------//

CLASS TRFile

     DATA hDC
     DATA aRows
     DATA nHeight, nWidth

     METHOD New(cFile) CONSTRUCTOR


     METHOD StartPage()  INLINE Afill(::aRows,"")
     METHOD EndPage()

     METHOD End()        INLINE fClose(::hDC)

     METHOD Say( nRow, nCol, cText, oFont )

     METHOD SetHeight(nHeight)   INLINE aSize(::aRows, nHeight) ,;
                                        ::StartPage()

     METHOD GetTextWidth(cText)  INLINE len(cText)
     METHOD GetTextHeight(cText) INLINE 1

     METHOD SayBitmap()       VIRTUAL
     METHOD SetPos()          VIRTUAL
     METHOD Line()            VIRTUAL
     METHOD Box()             VIRTUAL

     METHOD nVertRes()        INLINE  ::nHeight
     METHOD nHorzRes()        INLINE  ::nWidth

     METHOD nVertSize()       INLINE  (::nHeight * 25.4)
     METHOD nHorzSize()       INLINE  (::nWidth  * 25.4)

     METHOD nLogPixelsX()     INLINE 1
     METHOD nLogPixelsY()     INLINE 1

     METHOD SetPixelMode()    VIRTUAL
     METHOD SetTwipsMode()    VIRTUAL

     METHOD SetLoInchMode()   VIRTUAL
     METHOD SetHiInchMode()   VIRTUAL

     METHOD SetLoMetricMode() VIRTUAL
     METHOD SetHiMetricMode() VIRTUAL

     METHOD SetIsotropicMode()   VIRTUAL
     METHOD SetAnisotropicMode() VIRTUAL

     METHOD SetWindowExt()    VIRTUAL

     METHOD SetViewPortExt()  VIRTUAL

     METHOD FillRect()        VIRTUAL

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New(cFile) CLASS TRFile

     ::nHeight = 66
     ::nWidth  = 1

     ::hDC := fCreate(cFile)

     IF ::hDC < 0
          ::hDC := 0
     ENDIF

     ::aRows := Array(::nHeight)


RETURN NIL

//----------------------------------------------------------------------------//

METHOD EndPage() CLASS TRFile

     Aeval(::aRows, {|val| fWrite(::hDC,val+CRLF) })

RETURN NIL

//----------------------------------------------------------------------------//

METHOD Say(nRow, nCol, cText, oFont,nMaxSize) CLASS TRFile

     LOCAL cBefore, cAfter

     DEFAULT nMaxSize := len(cText)

     nRow++

     IF nRow > len(::aRows) .OR. nRow < 1
          RETU NIL
     ENDIF

     IF len(::aRows[nRow]) < nCol
          cBefore := Padr(::aRows[nRow],nCol)
     ELSE
          cBefore := Substr(::aRows[nRow],1,nCol-1)
     ENDIF

     IF len(::aRows[nRow]) < (nCol+nMaxSize-1)
          cAfter := ""
     ELSE
          cAfter := Substr(::aRows[nRow],nCol+nMaxSize)
     ENDIF

     ::aRows[nRow] := cBefore + Padr(cText, nMaxSize) + cAfter

RETURN NIL
