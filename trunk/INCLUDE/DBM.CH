#include "fivedos.ch"

#xcommand DEFINE DATABASE <oDb> [ OF <oDict> ];
             [ ALIAS <cAlias> ] ;
             [ FILE  <cFile> ] ;
             [ DRIVER <cDriver> ] ;
             [ <sh: SHARED> ] ;
             [ <ro: READONLY> ] ;
             [ FIELDS <aField,...> ] ;
             [ INDEXES <aIndex,...> ] ;
       => ;
          <oDb>:= TDbm():New( <(cFile)>, <(cAlias)>, __DRV__<cDriver>,;
             <.sh.>, <.ro.>, [ { <(aField)> } ], [ { <(aIndex)> } ], <oDict> ) ;
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

#xCommand INDEX <cName> ON <key> [ TO <cFile> ];
             [ FOR <for> ] [ FILTER <for> ] [ <unq: UNIQUE> ] ;
       =>;
          _oDb_:AddIndex( <(cFile)>, <(cName)>, <(key)>, <{key}>, <(for)>, <{for}>, <.unq.> )

#xCommand ENDDATABASE =>  [ #undef _oDb_ ]

#xcommand REDEFINE DATABASE <oDb> ALIAS <cAlias> FROM <oDict> [ u:<UPDATE> ] ;
       => ;
          <oDb>:= TDbm():Redefine( <cAlias>, <oDict> [, u ] )

#xcommand CREATE DATABASE <oDb> ;
       => ;
          <oDb>:Create()
