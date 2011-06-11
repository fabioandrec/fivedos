#include "FiveDos.ch"

//----------------------------------------------------------------------------//

CLASS TBitmap FROM TView

   DATA   cBinFile, bResource

   METHOD New( nRow, nCol, nWidth, nHeight, bResource, cBinFile, oWnd ) ;
                                                                   CONSTRUCTOR
   METHOD Refresh()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nRow, nCol, nWidth, nHeight, bResource, cBinFile, oWnd, lUpdate )

   DEFAULT nWidth := ScrMaxCol() + 1, nHeight := ScrMaxRow() + 1

   ::cBinFile  = cBinFile
   ::bResource = bResource

return Super:New( nRow, nCol, nWidth, nHeight,,, oWnd,, bFalse(),,lUpdate )

//----------------------------------------------------------------------------//

METHOD Refresh()

    VSetImage( ::cVPort, if( ! Empty( ::cBinFile ), ;
                                            MemoRead( ::cBinFile ),;
                                            Eval( ::bResource ) ) )
    ::UpdateOwner()

return nil

//----------------------------------------------------------------------------//
