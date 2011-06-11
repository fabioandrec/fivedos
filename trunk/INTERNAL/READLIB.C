// (c) Ignacio Ortega 1994
// (c) FiveWin - Lib Tools

// Lectura de Ficheros Lib 02:55 30/05/94
   // Includes
      #include <ClipApi.h>
      #include <obj.h>
   // Defines
      LONG alOffsets[500];
      BYTE *pcStrings[500];
      WORD wModules = 0 ;
      WORD wLib=0xffff;
   // Funciones de Apoyo
      void FreeStrings(WORD wStrings){
         WORD i;
         for (i=0;i<=wStrings;i++) _xfree(pcStrings[i]);
      }
      BYTE ReadByte( void ){
         char c;
         _tread(wLib,(LPBYTE)&c,1);
         return c;
      }
      WORD ReadWord( void ){
         WORD wLen;
         if (_tread(wLib,(LPBYTE)&wLen,2)==2){
            return wLen;
         }else return 0xffff;
      }
      int SkipRecord( void ){
         WORD wLen;
         if ((wLen=ReadWord())!=0xffff){
            _tlseek(wLib,wLen,1);
            return TRUE;
         }else return FALSE;
      }
      int ReadName(LPBYTE lpBuffer){
         WORD wLen=ReadByte();
         if ((wLen=_tread(wLib,lpBuffer,wLen))==wLen){
            lpBuffer[wLen]=0x0;
            return TRUE;
         }
         return FALSE;
      }
      int ReadHdrRecord(LPBYTE lpBuffer){
         if (ReadWord()!=0xffff)
            if  (ReadName(lpBuffer)){
               ReadByte();
               return TRUE;
            }
         return FALSE;
      }
      
      int ScanLibOffsets( void ){
         BYTE bType;
         while(TRUE){
            bType = ReadByte();
            switch(bType){
               case THEADR:
                  alOffsets[wModules++] = _tlseek(wLib,0,1)-1;
                  if (!SkipRecord()){
                     _beep_();
                     return FALSE;
                  }
                  break;
               case LIBTRL:
                  return TRUE;
               case 0x0:
                  break;
               case LIBHDR:
               default:
                  if (!SkipRecord()){
                     return FALSE;
                  }
            }
         }
      }
      int ScanModPublics(WORD wModule){
         BYTE abBuffer[300];
         WORD wLen,wPublics;
         BYTE *pbBuffer,bType;
         wPublics=0;
         _tlseek(wLib,alOffsets[wModule],0);
         if (ReadByte()== THEADR)
            if (ReadHdrRecord(abBuffer)){
               while(TRUE){
                  bType = ReadByte();
                  switch(bType){
                     case PUBDEF:
                        if ((wLen = ReadWord())!=0xffff){
                           WORD GrpIndex,SegIndex;
                           if ((GrpIndex=ReadByte()) >= 128){
                              wLen -=2;
                              ReadByte();
                           } else wLen--;
                           if ((SegIndex=ReadByte()) >= 128){
                              wLen -=2;
                              ReadByte();
                           } else wLen--;
                           if (GrpIndex==0 && SegIndex == 0){
                              ReadWord();
                              wLen -= 2;
                           }
                           while(wLen > 1){
                              ReadName(abBuffer);
                              pcStrings[wPublics]=_xgrab(strlen(abBuffer)+1);
                              strcpy(pcStrings[wPublics],abBuffer);
                              wPublics++;
                              ReadWord();
                              if (ReadByte() >= 128){
                                 wLen -=2;
                                 ReadByte();
                              } else wLen--;
                              wLen -= strlen(abBuffer)+1;
                              wLen -= 2;
                           }
                           ReadByte();
                        }
                        break;
                     case 0x0:
                     case LIBTRL:
                     case THEADR:
                        return wPublics;
                     default:
                        if (!SkipRecord()){
                           return 0xffff;
                        }
                  }
               }
            }
         FreeStrings(wPublics);
         return 0xffff;
      }
      int ScanModExternals(WORD wModule){
         BYTE abBuffer[300];
         WORD wLen,wExternals;
         BYTE *pbBuffer,bType;
         wExternals=0;
         _tlseek(wLib,alOffsets[wModule],0);
         if (ReadByte()== THEADR)
            if (ReadHdrRecord(abBuffer)){
               while(TRUE){
                  bType = ReadByte();
                  switch(bType){
                     case EXTDEF:
                        if ((wLen = ReadWord())!=0xffff){
                           while(wLen > 1){
                              ReadName(abBuffer);
                              pcStrings[wExternals]=_xgrab(strlen(abBuffer)+1);
                              strcpy(pcStrings[wExternals],abBuffer);
                              wExternals++;
                              wLen -= strlen(abBuffer)+1;
                              if (ReadByte() >= 128){
                                 wLen -=2;
                                 ReadByte();
                              } else wLen--;
                           }
                           ReadByte();
                        }
                        break;
                     case 0x0:
                     case LIBTRL:
                     case THEADR:
                        return wExternals;
                     default:
                        if (!SkipRecord()){
                           return 0xffff;
                        }
                  }
               }
            }
         FreeStrings(wExternals);
         return 0xffff;
      }
   // Interfaz
      CLIPPER  ALIBOFFSET( void ){
         WORD i;
         if (wLib!=0xffff){
            _reta(wModules);
            for (i=0;i<wModules;i++){
               _stornl(alOffsets[i],-1,i+1);
            }
            return;
         }
         _ret();
         return;
      }

      CLIPPER aLibSizes( void )
      {
         WORD i, wPrev;
         if ( wLib != 0xffff )
         {
            _reta( wModules );

            i = 0;

            do
            {
              _stornl( alOffsets[i+1] - alOffsets[i],-1,i+1);
            } while( ++i < wModules );
         }
      }



      CLIPPER  ALIBMODULE( void ){
         BYTE acBuffer[300];
         WORD i;
         if (wLib!=0xffff){
            _reta(wModules);
            _tlseek(wLib,0,0);
            for (i=0;i<wModules;i++){
               _tlseek(wLib,alOffsets[i],0);
               if (ReadByte() == THEADR){
                  if (ReadHdrRecord(acBuffer)){
                     _storc(acBuffer,-1,i+1);
                  }
               }else{
                  _ret();
                  return;
               }
            }
            return;
         }
         _ret();
         return;
      }
      CLIPPER  AMODEXTERN( void ){
         WORD wModule,i,wExternals;
         if ((PCOUNT() >= 1) && ISNUM(1) && (wLib != 0xffff) && ((wModule=_parni(1)-1)  < wModules)){
            wExternals=ScanModExternals(wModule);
            if (wExternals > 0){
               _reta(wExternals);
               for(i=0;i <= wExternals; i++){
                  _storc(pcStrings[i],-1,i+1);
               }
               FreeStrings(wExternals);
               return;
            }
            _ret();
            return;
         }
      }
      CLIPPER  AMODPUBLIC( void ){
         WORD wModule,i,wPublics;
         if ((PCOUNT() >= 1) && ISNUM(1) && (wLib != 0xffff) && ((wModule=_parni(1)-1)  < wModules)){
            wPublics=ScanModPublics(wModule);
            if (wPublics > 0){
               _reta(wPublics);
               for(i=0;i <= wPublics; i++){
                  _storc(pcStrings[i],-1,i+1);
               }
               FreeStrings(wPublics);
               return;
            }
            _ret();
            return;
         }
      }
      CLIPPER  LLIBCLOSE( void ){
         if (wLib != 0xffff){
            _tclose(wLib);
            wLib = 0xffff;
            wModules = 0;
         }
         _retl(TRUE);
         return;
      }
      CLIPPER  LLIBOPEN( void ){
         WORD i;
         if (PCOUNT() >= 1 && ISCHAR(1) && wLib == 0xffff){
            if ((wLib=_topen(_parc(1),0))!=0xffff){
               if (ScanLibOffsets()){
                  _retl(TRUE);
                  return;
               }
            }
         }
         _retl(FALSE);
         return;
      }
