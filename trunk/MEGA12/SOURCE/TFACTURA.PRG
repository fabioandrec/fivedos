// Clase para la clase Factura.

#include "Objects.ch"
#include "MegaReco.ch"

Static oDescFact

// -------------------------------------------------------------------------- //
CLASS TFacturac FROM TWorkArea

    DATA aCliente
    DATA aDescFact

    METHOD Skip( nReg ) // Is derivated because Load don't call this method
    METHOD Load()
    METHOD Save()

    DEFAULT oDescFact := GetDescFact()

ENDCLASS

// -------------------------------------------------------------------------- //
METHOD TFacturac::Skip( nRec )
    ( ::nArea )->( DbSkip( nRec ) )
    If ::lBuffer
        ::Load()
    EndIf
Return NIL

// -------------------------------------------------------------------------- //
METHOD TFacturac::Load()
    Static oClientes, oAlmacen

    Local nRegCli, nRegAlm, nRegDes, nTotal  := 0
    Local aDescFact

    If oClientes == NIL
        oClientes := GetClientes()
        oAlmacen  := GetAlmacen()
    EndIf

    nRegCli := oClientes:RecNo()
    nRegAlm := oAlmacen:RecNo()
    nRegDes := oDescFact:RecNo()

    Super:Load()

    // Iniciamos el array de facturas
    ::aDescFact := aDescFact := {}

    // Si se ha encontrado el codigo de factura
    If oDescFact:Seek( ::Codigo )

        // Los a¤adimos.
        Do While ::Codigo == oDescFact:Codigo

            aAdd( aDescFact, { oDescFact:CodPro, ;
                               If( oAlmacen:Seek( oDescFact:CodPro ), ;
                                   oAlmacen:Nombre, Space( 24 ) ), ;
                               oDescFact:Cant, ;
                               oDescFact:PVP, ;
                               oDescFact:Descu, ;
                               oDescFact:Cant * oDescFact:PVP - ;
                                   If( oDescFact:Descu > 0, ;
                                       Int( oDescFact:Cant * oDescFact:PVP * ;
                                       ( oDescFact:Descu / 100 ) ), 0 ) } )

            // Ir al siguiente registro
            oDescFact:Skip()

        EndDo

    EndIf

    // Hallamos el total.
    aEval( aDescFact, {|aElem| nTotal += aElem[ DES_PARCIAL ] } )
    aAdd( aDescFact, { Space( 10 ), Space( 24 ), 0, 0, 0, nTotal } )


    // Buscamos el codigo de cliente.
    If oClientes:Seek( ::CodCli )

        // Tomamos los datos del cliente actual.
        ::aCliente := { oClientes:Nombre, ;
                        oClientes:NIF, ;
                        oClientes:Domicilio, ;
                        oClientes:Poblacion, ;
                        oClientes:CodPost, ;
                        oClientes:Telefono, ;
                        oClientes:Cantidad, ;
                        oClientes:UltFecha }

    Else

        ::aCliente := { Space( 35 ), ;
                        Space( 10 ), ;
                        Space( 40 ), ;
                        Space( 15 ), ;
                        Space(  5 ), ;
                        Space( 15 ), ;
                        0, ;
                        CToD( Space( 8 ) ) }

    EndIf

    // Restauramos los punteros de las areas tocadas.
    oDescFact:Goto( nRegDes )
    oClientes:Goto( nRegCli )
    oAlmacen:Goto( nRegAlm )


Return NIL

// -------------------------------------------------------------------------- //
METHOD TFacturac::Save()
    Local nPro, nLen, aDescFact

    Super:Save()

    aDescFact := ::aDescFact

    // Cuantos hay que salvar.
    nLen := Len( aDescFact )

    // Inicializamos el contador para recorrer el array.
    nPro := 1

    If oDescFact:Seek( ::Codigo )               // Se ha encontrado.

        Do While oDescFact:Codigo == ::Codigo

            // Salvamos los datos en el registro actual
            oDescFact:CodPro := aDescFact[ nPro ][ DES_CODPRO ]
            oDescFact:Cant   := aDescFact[ nPro ][ DES_CANT   ]
            oDescFact:PVP    := aDescFact[ nPro ][ DES_PVP    ]
            oDescFact:Descu  := aDescFact[ nPro ][ DES_DESCU  ] // Descuento.

            // Ir al siguiente registro.
            oDescFact:Skip( 1 )

            // Si se ha terminado el array
            If ++nPro == nLen
                Exit
            EndIf

        EndDo

    EndIf

    If nLen > nPro // Se encontraron menos en base que en array.
        While nLen > nPro
            //Se a¤ade un registro
            oDescFact:Append()
            // Se toman los datos
            oDescFact:Codigo := ::Codigo
            oDescFact:CodPro := aDescFact[ nPro ][ DES_CODPRO ]
            oDescFact:Cant   := aDescFact[ nPro ][ DES_CANT   ]
            oDescFact:PVP    := aDescFact[ nPro ][ DES_PVP    ]
            oDescFact:Descu  := aDescFact[ nPro ][ DES_DESCU  ]
            // Se salvan los datos.
            oDescFact:Save()
            nPro++
        End
    Else
        Do While oDescFact:Codigo == ::Codigo
            oDescFact:Delete()
            oDescFact:Skip()
        EndDo
    EndIf

Return NIL

// -------------------------------------------------------------------------- //
