
#include "set.ch"
#include "Objects.ch"

CLASS tForm FROM tListado

        DATA aForm
        DATA bFrmPagina, nTotalPaginas
        DATA aFields, nNumFields
        DATA nWorkArea, Cargo

        METHOD New( nWorkArea, aFields, cLstCanal, nLstLineas, nLstCol ) CONSTRUCTOR
        METHOD CreaArrayForm()
        METHOD FrmMaster()

ENDCLASS


METHOD tForm::New( nWorkArea, aFields, cLstCanal, nLstLineas, nLstCol )

    DEFAULT ::bFrmPagina:={ || nil }, ;
            ::nTotalPaginas:=0, ::nLstPage:=0, ::lLstNumeraPage:=.F.

    if( !empty(aFields), ::aFields:=aClone(aFields), nil )
    if( !empty(nWorkArea), ::nWorkArea:=nWorkArea, Select() )

    Super:New( cLstCanal, nLstLineas, nLstCol )

Return


METHOD tForm::CreaArrayForm()
Local nTemp
::aForm:={}
for nTemp:=1 to ::nLstLineas - ::nLstMrgUp
        aadd( ::aForm, space(::nLstCol) )
next
Return 



METHOD tForm::FrmMaster()
Local nLimite, xDato, nLenDato, cPictureDato, nRow, nCol, cTipoDato
Local lAligLeft, nContador, nMaxRow, xDesconocido

// Calcular numero de campos
::nNumFields:=Len( ::aFields )

::OpenCanal()
Select( ::nWorkArea )
DbGotop()
// Limite para el salto de pagina.
nLimite:=::nLstLineas - ::nLstMrgDown
::OutToPrint()

While !eof()

    
    // el array aForm tiene: ::nLstLineas - ::nLstMrgUp Elementos.
    ::CreaArrayForm() 
    nMaxRow:=Len( ::aForm )
    // Primero rellenamos el array ::aForm con toda la informacion del
    // formulario

    For nTemp:=1 to ::nNumFields
          nRow:=::aFields[nTemp][1]
          nCol:=::aFields[nTemp][2]
          xDato:=Eval( ::aFields[nTemp][3] )
          nLenDato:=::aFields[nTemp][4]
          if Len( ::aFields[nTemp] )>4
                cPictureDato:=::aFields[nTemp][5]
             else
                cPictureDato:=nil
          endif

          // Convertir en funcion del tipo de dato.
          cTipoDato:=ValType( xDato )
          lAligLeft:=.T.

          do case
                case cTipoDato == "N"
                        xDato:=Str( xDato, nLenDato )
                case cTipoDato == "D"
                        xDato:=dToc( xDato )
          endcase

          // Controlar que la fila este dentro del array.
          if nRow <= nMaxRow
                // Agregar el dato a su sitio en el formulario
                ::aForm[ nRow ]:= Stuff( ::aForm[ nRow ], ;
                                         nCol, nLenDato, xDato )
          endif
    next

    // Imprimimos el formulario.
    ::nLstNumLinea:=0
    ::nLstNumLinea+=::PrintBlank( ::nLstMrgUp )    // Margen Superior.
    For nTemp:=1 to nMaxRow // Imprime las filas
          ?::aForm[ nTemp ]
    Next
    ::nLstNumLinea+=nMaxRow
    ::LstEjectPage( nLimite )   // Realiza el Eject.
    ::nLstPage++
    xDesconocido:=Eval( ::bFrmPagina, ::nLstPage, ::nTotalPaginas )
    If ValType( xDesconocido ) == "N"
       if xDesconocido == -1
            exit
       endif
    endif
    dbSkip(1)
end
::OutToScreen()
Return
