#include "fivedos.ch"

#xcommand DEFINE DATABASE <oDb> ;
             [ FILE <(cFile)> ] ;
             [ ALIAS <cAlias> ] ;
             [ AREA <nArea> ]   ;
             [ DRIVER <cDriver> ] ;
             [ <sh: SHARED> ] ;
             [ <ro: READONLY> ] ;
             [ FIELDS <aField> ] ;
             [ INDEXES <aIndex> ] ;
       => ;
         <oDb>:= TDataBase():New( <nArea>, __DRV__<cDriver>, <(cFile)>,;
                                  <(cAlias)>, <.sh.>, <.ro.>,;
                                  \{ <aField> \}, \{ aIndex \} ) ;
              [; #define _oDb_ <oDb> ]

#xCommand FIELD <cField> ;
             [ AS <Typ: STRING, NUMBER, LOGIC, DATE, MEMO> ] ;
             [ LEN <nLen> ] [ DEC <nDec> ] ;
       => ;
          _oDb_:AddField( <(cField)>, __TYPE__<Typ>, <nLen>, <nDec> )

#xCommand FIELD <cField,...> ;
             [ AS <Typ: STRING, NUMBER, LOGIC, DATE, MEMO> ] ;
             [ LEN <nLen> ] [ DEC <nDec> ] ;
       => ;
          _oDb_:AddField( { <(cField)> }, __TYPE__<Typ>, <nLen>, <nDec> )

#xCommand INDEX <cName> ON <key> [ TO <(cFile)> ];
             [ FOR <for> ] [ FILTER <for> ] [ <unq: UNIQUE> ] ;
             [ <desc:DESCEND> ] ;
       =>;
          _oDb_:AddIndex( <(cFile)>, <(cName)>, <(key)>, ;
                          <(for)>, <.unq.>, <.desc.> )

#xCommand END DATABASE =>  [ #undef _oDb_ ]

#xcommand CREATE DATABASE <oDb> [ WITH <aField> ]                         ;
       => ;
          <oDb>:Create( [<aField>] )

// WARNING, Donït touch the corchetes at [ <.sh.> ], [ <.ro.> ] 
#xcommand USE DATABASE <oDb>                                              ;
             [ FILE  <(cFile)> ]                                          ;
             [ ALIAS <cAlias> ]                                           ;
             [ DRIVER <cDriver> ]                                         ;
             [ <sh: SHARED> ]                                             ;
             [ <ro: READONLY> ]                                           ;
             [ AREA <nArea> ]                                             ;
             [ INDEX <cIndex,...> ]                                       ;
        =>                                                                ;
          if IS_NIL( <oDb> ); <oDb>:= TDataBase(); end                    ;
        ; <oDb>:Use( <nArea>, <cDriver>, <(cFile)>, <(cAlias)>,;
                     [ <.sh.> ], [ <.ro.> ] ) ;
        ; SET INDEX TO [ <cIndex> ] OF <oDb> 
                        
#xcommand CLOSE DATABASE <oDb> => <oDb>:Close()

#xcommand SET INDEX TO <cIndex,...> OF <oDb>                               ;
        => ;
          <oDb>:SetIndex( \{ <(cIndex)> \} )

#xcommand SET INDEX TO ALL OF <oDb>                                        ;
        => ;
          <oDb>:SetIndex( , .t. )

#xcommand SET INDEX NAME <cIndex,...> OF <oDb>                             ;
        => ;
          <oDb>:SetIndex( \{ <(cIndex)> \}, .t.  )

#xcommand SET INDEX TO OF <oDb>                                            ;
        => ;
          <oDb>:CloseIndex()

#xcommand SET SCOPE [TO] [ <nTag> [ IN <(cIndex)> ] ]           ;
             [ FOR <uValTop> [ TO <uValBottom> ] ] [ OF <oDb> ] ;
        => ;
          <oDb>:SetScope( <uValTop>, <uValBottom>, <nTag>, <(cIndex)>, .t. )

#xcommand SET SCOPE ON [ <nTag> [ IN <(cIndex)> ] ] [ OF <oDb> ] ;
        => ;
          <oDb>:SetScope( , , <nTag>, <(cIndex)>, .t. )

#xcommand SET SCOPE OFF [ <nTag> [ IN <(cIndex)> ] ] [ OF <oDb> ] ;
        => ;
          <oDb>:SetScope( , , <nTag>, <(cIndex)>, .f. )

#xcommand SET SCOPE ALL <uVal> OF <oDb> ;
        => ;
          <oDb>:SetScope( <uVal>, <uVal>, .t., , .t. )

#command SET ORDER TO <xOrder> [ IN <(cIndex)> ] OF <oDb>                 ;
        => ;
          <oDb>:SetOrder( <xOrder> [, <(cIndex)>] )

// Ojo: Al redefinir oDb AS oDbInit, el array de aField es comun.
#xcommand REDEFINE DATABASE <oDb> [ AS <cName> ] [ FROM <oDict> ] ;
             [ ALIAS <cAlias> ] [ SCOPE <cScope> ];
       => ;   
           if !lObject( <oDb> ); <oDb>:= TDataBase(); end                  ;
          ;<oDb>:Redefine( <(cName)>, <(cAlias)>, <cScope>, <oDict> )

#xcommand SELECT DATABASE <oDb> [ INDEX <cIndex> ];
       => ;
         <oDb>:SelectDb()[:SetIndex( <cIndex>, .t. )]
