#ifndef _INITS_CH
#define _INITS_CH

#xtranslate BYNAME <V> [, <VN> ] INIT => if <V> != nil; ::<V> := <V>; end ;
                                        [; if <VN> != nil; ::<VN> := <VN>; end ]
/*
Inicializa ::<V> 
  1.- con <V> si ‚sta != nil.
 else
  2.- si ::<V> == nil ::<V> = <V1>.
*/
#xtranslate BYNAME <V> INIT DEFAULT <V1> ;
     => if( <V> != nil,::<V> := <V>,;
           if( Empty( ::<V> ).and.!Empty( <V1> ),::<V> := <V1>, ) )

// Este no funciona pues las variables en Object 4.0 se inicializan.
//     => if( <V> != nil,::<V> := <V>, if( ::<V>==nil,::<V> := <V1>, ) )

/*
#xtranslate BYNAME <V> [, <VN> ] INIT <B> ;
           => ;
             if <B>( <V> ); ::<V> := <V>; end ;
             [; if <B>( <VN> ); ::<VN> := <VN>; end ]
*/

#xtranslate BYNAME <V> [, <VN> ] INIT BLOCK ;
           => ;
             if IS_BLOCK( <V> ); ::<V> := <V>; end ;
             [; if IS_BLOCK( <VN> ); ::<VN> := <VN>; end ]

#xtranslate BYNAME <V> [, <VN> ] INIT OBJECT ;
           => ;
             if IS_OBJECT( <V> ); ::<V> := <V>; end ;
             [; if IS_OBJECT( <VN> ); ::<VN> := <VN>; end ]

#xtranslate BYNAME <V> [, <VN> ] INIT ARRAY ;
           => ;
             if IS_ARRAY( <V> ); ::<V> := <V>; end ;
             [; if IS_ARRAY( <VN> ); ::<VN> := <VN>; end ]

#xtranslate BYNAME <V> [, <VN> ] INIT CHARACTER ;
           => ;
             if IS_CHARACTER( <V> ); ::<V> := <V>; end ;
             [; if IS_CHARACTER( <VN> ); ::<VN> := <VN>; end ]

#xtranslate BYNAME <V> [, <VN> ] INIT NUMBER ;
           => ;
             if IS_NUMBER( <V> ); ::<V> := <V>; end ;
             [; if IS_NUMBER( <VN> ); ::<VN> := <VN>; end ]

#xtranslate BYNAME <V> [, <VN> ] INIT LOGICAL ;
           => ;
             if IS_LOGICAL( <V> ); ::<V> := <V>; end ;
             [; if IS_LOGICAL( <VN> ); ::<VN> := <VN>; end ]

#xtranslate BYNAME <V> [, <VN> ] INIT DATE ;
           => ;
             if IS_DATE( <V> ); ::<V> := <V>; end ;
             [; if IS_DATE( <VN> ); ::<VN> := <VN>; end ]

#endif
