#ifndef _DBDICT_CH
#define _DBDICT_CH

#xtranslate __TYPE__                               => "C"
#xtranslate __TYPE__ <typ: STRING>                 => "C"
#xtranslate __TYPE__ <typ: NUMBER>                 => "N"
#xtranslate __TYPE__ <typ: LOGIC>                  => "L"
#xtranslate __TYPE__ <typ: DATE>                   => "D"
#xtranslate __TYPE__ <typ: MEMO>                   => "M"

#xtranslate __DRV__                                => "DBFNTX"
#xtranslate __DRV__ <typ: DBFNTX, NTX>             => "DBFNTX"
#xtranslate __DRV__ <typ: DBFCDX, CDX>             => "DBFCDX"
#xtranslate __DRV__ <typ: DBFNSX, NSX>             => "DBFNSX"
#xtranslate __DRV__ <typ: DBFNDX, NDX>             => "DBFNDX"
#xtranslate __DRV__ <typ: DBFMDX, MDX>             => "DBFMDX"
#xtranslate __DRV__ <typ: DBPX,   PX >             => "DBPX"

// Data Base Manager System, by J.M.R.

#define EXT_DBS     ".DBS"
#define EXT_FLS     ".FLS"
#define EXT_INS     ".INS"

#define EXT_FLD     ".FLD"
#define EXT_IND     ".IND"
#define EXT_REL     ".REL"

// Dictionary of Fields
#define aSTRU_FIELD  { { "Name", "C", 10, 0 },;
                       { "Type", "C",  1, 0 },;
                       { "Len",  "N",  5, 0 },;
                       { "Dec",  "N",  3, 0 },;
                       { "Pict", "C", 25, 0 } }

//Dictionary of Indexes
#define aSTRU_INDEX  { { "Name",   "C",  10, 0 },;
                       { "File",   "C",   8, 0 },;
                       { "Key",    "C", 250, 0 },;
                       { "Unique", "L",   1, 0 },;
                       { "For",    "C", 250, 0 },;
                       { "Descending","L",1, 0 } }

#define aSTRU_DB     { { "Alias",   "C", 10, 0 },;
                       { "File",    "C",  8, 0 },;
                       { "Driver",  "C",  6, 0 },;
                       { "Shared",  "L",  1, 0 },;
                       { "ReadOnly","L",  1, 0 },;
                       { "Area",    "N",  3, 0 } }

#xCommand DEFINE DBDICT <oDbDict> [ FILE <cFile> ] ;
      => ;
          <oDbDict>:= TDBDICT():New( <(cFile)> ) [; #define _DbDict_ <oDbDict> ]

#xCommand DEFINE FIELD <cField> ;
             [ AS <Typ: STRING, NUMBER, LOGIC, DATE, MEMO> ] ;
             [ LEN <nLen> ] [ DEC <nDec> ] ;
      => ;
          _DbDict_:AddField( <(cField)>, __TYPE__<Typ>, <nLen>, <nDec> )

#xCommand DEFINE FIELD <cField,...> ;
             [ AS <Typ: STRING, NUMBER, LOGIC, DATE, MEMO> ] ;
             [ LEN <nLen> ] [ DEC <nDec> ] [ PICTURE <cPict> ] ;
      => ;
          _DbDict_:AddField( { <(cField)> }, __TYPE__<Typ>, <nLen>, <nDec>, <cPict> )

#xCommand DEFINE INDEX <cName> ON <key> [ TO <(cFile)> ] ;
             [ FOR <for> ] [ FILTER <for> ] [ <unq: UNIQUE> ] ;
             [ <desc:DESCEND> ] ;
      =>;
          _DbDict_:AddIndex( <(cName)>, <(cFile)>, <(key)>, ;
                             <(for)>, <.unq.>, <.desc.> )

#xCommand END DBDICT => [ #undef _DbDict_ ]

#xCommand REDEFINE DBDICT <oDbDict> FROM FILE <cFile> ;
      => ;
          <oDbDict>:= TDBDICT():Redefine( <(cFile)> )

#xcommand DEFINE DATABASE [FILE] <(cFile)> [ FROM <oDict> ] ;
             [ AREA <nArea> ]   ;
             [ ALIAS <cAlias> ] ;
             [ DRIVER <cDriver> ] ;
             [ <sh: SHARED> ] ;
             [ <ro: READONLY> ] ;
             [ FIELDS <aField,...> ] ;
             [ INDEXES <aIndex,...> ] ;
       => ;
          <oDict>:AddDb( <nArea>, __DRV__<cDriver>, <(cFile)>, <(cAlias)>, ;
             <.sh.>, <.ro.>,[ { <(aField)> } ], [ { <(aIndex)> } ], <oDict> )

#endif  // _DbDict_CH
