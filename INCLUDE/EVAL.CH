
#ifndef _EVAL_CH
#define _EVAL_CH


#xtranslate DO <bCode,...> WHILE <bCond,...>    ;
                [ PARAMETERS <doprm,...> ]      ;  // recibe parametros
                [ WITH  <params,...> ]          ;  // manda parametros.
        => ;
        EvalWhile( \{|[<doprm>]| <bCode> \}, ;
                   \{|| <bCond> \} [, <params> ] )

#xtranslate WHILE <bCond,...>  DO <bCode,...>   ;
                [ PARAMETERS <doprm,...> ]      ;  // recibe parametros
                [ WITH  <params,...> ]          ;  // manda parametros.
        => ;
        EvalWhile( \{|[<doprm>]| <bCode> \}, ;
                   \{|| <bCond> \} [, <params> ] )


#xtranslate DO <bCode,...> UNTIL <bCond,...>    ;
                [ PARAMETERS <doprm,...> ]      ;
                [ WITH <params,...> ]           ;
        => ;
        EvalUntil( \{|[<doprm>]| <bCode> \}, ;
                   \{|| <bCond> \} [, <params> ] )

#xtranslate DO <bCode,...> FOR <nIndex> := <nInit> TO <nEnd>    ;
                [ STEP <nStep> ]                ;
                [ PARAMETERS <doprm,...> ]      ;
                [ WITH <params,...> ]           ;
        => ;
        EvalFor( \{|<nIndex>[,<doprm>]| <bCode> \}, ;
                 <nInit>, <nEnd>, [ <nStep> ] [, <params> ] )

#xtranslate FOR <nIndex> := <nInit> TO <nEnd> [ STEP <nStep> ]  ;
                DO <bCode,...>                  ;
                   [ PARAMETERS <doprm,...> ]      ;
                   [ WITH <params,...> ]           ;
        => ;
        EvalFor( \{|<nIndex>[,<doprm>]| <bCode> \}, ;
                 <nInit>, <nEnd>, [ <nStep> ] [, <params> ] )

#endif
