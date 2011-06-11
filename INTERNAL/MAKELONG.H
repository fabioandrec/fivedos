#define LOBYTE(w)           ((BYTE)(w))
#define HIBYTE(w)           ((BYTE)((UINT)(w) >> 8))

#define LOWORD(l)           ((unsigned int)(l))
#define HIWORD(l)           ((unsigned int)((unsigned long)(l) >> 16))

#define MAKELONG(low, high) ((unsigned long)(((unsigned int)(low)) | (((unsigned long)((unsigned int)(high))) << 16)))


#define MK_FP( seg,ofs )( (void _seg * )( seg ) +( void near * )( ofs ))
#define FP_SEG( fp )( (unsigned )( void _seg * )( void far * )( fp ))
#define FP_OFF( fp )( (unsigned )( fp ))
