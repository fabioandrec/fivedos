;           旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
;           �                                            �
;           �    There is no need to process with RAR!   �
;           �                                            �
;           �     JUST RUN THIS SFX MODULE AND ENJOY!    �
;           �                                            �
;           읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
;
;
;
;
;
; iSFX script will not be shown as the archive comment with RAR 1.54 and above!
DestDir="\FD11"
; Total files in archive. CHANGE TO PROPER VALUE!
files=282
; Disk space needed to extract files, bytes. CHANGE TO PROPER VALUE!
diskneed=2580
; Define filebar
defbar BLACK,WHITE,WHITE,BLACK,14,7,52
; Print out the standard ansi comment 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
clrscr
outtext ansi on
RAR Installation SFX module
Created by RAR 1.54
FiveDos version 1.1
(c)FiveTech 1995

ShareWare Version

outtext ansi off


; Main background
setcolor DARKGRAY,BLACK
window 1,1,80,25
clrscr 219
; Main window
window 1,1,80,25

; AV info
box 3,3,68,8,YELLOW,BLUE,SINGLE
setcolor YELLOW,BLUE
gotoxy 24,3
text " Archive information "
setcolor DARKGRAY,BLACK
window 5,9,69,9
clrscr 177
window 69,4,69,9
clrscr 177
window 4,4,67,7
setcolor LIGHTCYAN,BLUE
clrscr
; Fields
gotoxy 1,1
text "  Valid archive name:  "
gotoxy 1,2
text "  Actual archive name: "
gotoxy 1,3
text "  Archive date:        "
gotoxy 1,4
text "  Created by:          "
; Values
setcolor WHITE,BLUE
gotoxy 26,1
if AVArcName!="AVArcName"
    text AVArcName
endif
gotoxy 26,2
text ArcName
gotoxy 26,3
AVDate="08/09/95"
if AVDate!="AVDate"
    text AVDate
endif
gotoxy 26,4
AVUserName="FiveDos Team, FiveTech"
if AVUserName!="AVUserName"
    text AVUserName
endif

window 1,1,80,25
; Bottom line
setcolor LIGHTCYAN,DARKGRAY
gotoxy 1,25
text "                         Press F1 for help, Alt-X to exit                       "

; Shadow on the meadow
setcolor DARKGRAY,BLACK
window 25,17,56,17
clrscr 177
window 54,11,56,17
clrscr 177
window 1,1,80,25

; Sound on the same meadow
sound 90,1

; Installation Menu:

Menu:

Choice = menu 25,10,BLACK,WHITE,1,"Installation menu","     Read license"," Destination directory ","       Install","         Exit"

if Choice == 0
      goto Quit
endif

if Choice==1
     savescr 1
FirstPage:
     window 1,1,80,25
     setcolor LIGHTCYAN,BLUE
     clrscr
     box 1,1,80,25,LIGHTCYAN,BLUE,DOUBLE
     gotoxy 8,25
     ctext " Press PgDn for the second page or Esc for menu... "
     gotoxy 1,1
     ctext " License "
     gotoxy 1,1
     window 2,2,80,25
     setcolor YELLOW,BLUE
     sound 140,5
     outtext on
 IMPORTANT NOTICE:

 Read the following terms and conditions before using the software.
 By using the software, you show your agreement to the terms of
 this license agreement. If you do not agree with the terms and
 conditions of this agreement, as specified below, promptly return the
 unused disk package and all other items (including any written materials)
 for a full refund.

 The enclosed computer software package is licensed to you by the authors,
 it is not sold to you. You may use it only under the terms of this
 agreement and the authors reserve any rights not expressly granted to you
 herein.

 You may use the enclosed software only in machine readable form.

 In consideration of the right to a refund of the license fee for any reason,
 including any terms of this agreement which are unacceptable or are
 unenforceable by reason of law or regulation applicable to you, within a 30
 day period provided.  You expressly agree to waive all redress other than as
 provided by these terms and to return the package unused for such refund
 within this 30 day period.
     outtext off
GetKey1:
     Key=getkey
     if Key==27
           restscr 1
           goto Menu
     endif
     if Key==337
SecondPage:
          window 1,1,80,25
          setcolor LIGHTCYAN,BLUE
          clrscr
          box 1,1,80,25,LIGHTCYAN,BLUE,DOUBLE
          gotoxy 8,25
          ctext " Press PgUp for first page or Esc for menu ..."
          window 2,2,80,25
          setcolor YELLOW,BLUE
          gotoxy 1,1
          sound 145,5
          outtext on
 Disclaimers: The authors make no warranties as to the contents of this
 document or the software contained herein, and specifically  disclaims any
 warranties of merchantability or fitness for any  particular purpose. We
 will not be liable for indirect, special, consequential or other damages
 resulting from the use of this product. The authors reserve the right
 to make changes to the specifications of this software product and contents
 of its documentation -electronically or printed- without obligation to
 notify any person or organization of such changes.

 NOTE:  Distributors are not responsible for any claims against this
 software product.  Distributors will only be responsible for replacing
 defective media. All other claims must be made to the authors of this
 product.  Your use of this product constitutes your acceptance of these
 terms.

I.   GRANT OF LICENSE:   A.Linares & F.Pulp줻 (LICENSORs) give you
     (LICENSEE) the right to use one (1) copy of this software
     product (PROGRAM) on a single computer system.  This does not grant
     you the right to use the software on a network by multiple users or on
     more than one computer at a time.
          outtext off
GetKey2:
          Key=getkey
          if Key==27
                restscr 1
                goto Menu
          endif
          if Key == 329
               goto FirstPage
          endif
          if key==337
           goto Page3
          endif
          goto GetKey2
endif
Page3:
          window 1,1,80,25
          setcolor LIGHTCYAN,BLUE
          clrscr
          box 1,1,80,25,LIGHTCYAN,BLUE,DOUBLE
          gotoxy 8,25
          ctext " Press PgUp for first page or Esc for menu ..."
          window 2,2,80,25
          setcolor YELLOW,BLUE
          gotoxy 1,1
          sound 145,5
          outtext on
 II.  COPYRIGHT.  The software is owned by  A.Linares & F.Pulp줻 and
     is protected under the Copyright Laws of Spain and the United States
     of America and international treaty provisions.  LICENSEE must treat the
     software like any other copyrighted material (books, records, tapes,
     etc.) except LICENSEE may make additional copies of the distribution
     diskette for archival purposes.  The LICENSEE agrees not to copy the
     documentation and to take all necessary precautions to ensure the
     archival copies of the software are not distributed to or acquired by
     other parties except as provided for in paragraph VI below.  LICENSEE
     may not copy any of the written materials provided with the software.
     LICENSEE must retain possession of the original distribution diskette
     for Registered software at all times.

 III. OTHER RESTRICTIONS.  LICENSEE may not rent or lease the software but
     has the right to transfer the software license to another party
     provided LICENSEE retains no copies of the software, documentation or
     other written materials.  Transfer of license must be approved by
     LICENSOR and must be submitted in writing to the address listed herein.
          outtext off
GetKey3:
          Key=getkey
          if Key==27
                restscr 1
                goto Menu
          endif
          if Key == 329
               goto SecondPage
          endif
          if Key == 337
            goto Page4
          end
          goto GetKey3
Page4:
          window 1,1,80,25
          setcolor LIGHTCYAN,BLUE
          clrscr
          box 1,1,80,25,LIGHTCYAN,BLUE,DOUBLE
          gotoxy 8,25
          ctext " Press PgUp for first page or Esc for menu ..."
          window 2,2,80,25
          setcolor YELLOW,BLUE
          gotoxy 1,1
          sound 145,5
          outtext on
 IV.  LANGUAGE SOFTWARE.  The software is considered to be a language
     software product if the software either creates executable files or
     attaches itself to other language products as an enhancement.  If the
     software is a language software product, LICENSEE has the royalty-free
     right to incorporate it into software applications developed by
     LICENSEE and distribute those applications, privately or commercially,
     provided that LICENSEE: (a) ensures it is only in machine readable
     form; (b) agrees to indemnify, hold harmless, and defend  LICENSORs
     and their agents and distributors from and against any claims or
     lawsuits, including attorney's fees, that arise or result from the
     use or distribution of same.

  V.   REVERSE ENGINEERING.  You may NOT alter, decompile, disassemble,
     or reverse engineer the software.  However, you are free to make
     modifications for your own use to that source code which is provided
     with the package.  You may use any portion of the example source code
     included in the examples or samples subdirectories in your applications
     but, you may not use any portion of the product to create a competing
     product.
          outtext off
GetKey4:
          Key=getkey
          if Key==27
                restscr 1
                goto Menu
          endif
          if Key == 329
               goto Page3
          endif
          if Key == 337
            goto Page5
          end
          goto GetKey4
Page4:
          window 1,1,80,25
          setcolor LIGHTCYAN,BLUE
          clrscr
          box 1,1,80,25,LIGHTCYAN,BLUE,DOUBLE
          gotoxy 8,25
          ctext " Press PgUp for first page or Esc for menu ..."
          window 2,2,80,25
          setcolor YELLOW,BLUE
          gotoxy 1,1
          sound 145,5
          outtext on
 VI.  EVALUATION EDITION.  UNREGISTERED EVALUATION EDITION versions of
     this software may be freely copied and distributed via disk or
     electronic medium and may be shared freely with others.  In fact we
     encourage you to do so.  Unregistered Evaluation editions are those
     which are marked as Evaluation Editions, have not been registered
     with the author or the distributor and have not been "unlocked" with
     the registration code granted by the authors or distributors at the
     time of purchase.  You may only distribute copies of the Evaluation
     Edition that are unaltered and are identical in every way to the
     files sent out by the distributors.   There are files included
     with the REGISTERED versions which do not appear in the Evaluation
     Edition and these files may NOT be distributed by you.

     This agreement is governed by the laws of SPAIN and the United States
     Of America.
     outtext off
GetKey5:
          Key=getkey
          if Key==27
                restscr 1
                goto Menu
          endif
          if Key == 329
               goto Page3
          endif
          if Key == 337
            goto Page5
          end
          goto GetKey5
Page5:
          window 1,1,80,25
          setcolor LIGHTCYAN,BLUE
          clrscr
          box 1,1,80,25,LIGHTCYAN,BLUE,DOUBLE
          gotoxy 8,25
          ctext " Press PgUp for first page or Esc for menu ..."
          window 2,2,80,25
          setcolor YELLOW,BLUE
          gotoxy 1,1
          sound 145,5
          outtext on



             (c) Antonio Linares & Francisco Pulp줻, 1993-1995

                         All rights reserved WorldWide

           CA-Clipper is Copyright (c) Computer Associates Inc.
         Microsoft Windows is Copyright (c) Microsoft corporation
       All other products mentioned are for informational purposes
    only, and are copyright or Trademarks of their respective owners
        outtext off
GetKey6:
          Key=getkey
          if Key==27
                restscr 1
                goto Menu
          endif
          if Key == 329
               goto Page3
          endif
          if Key == 337
            goto FirstPage
          end
          goto GetKey6
endif


if Choice == 2
     savescr 1
     setcolor WHITE,CYAN
     window 11,10,67,15
     clrscr
     box 4,2,54,5,WHITE,CYAN,SINGLE
     gotoxy 20,2
     text " Destination directory "
     window 15,12,63,13
     clrscr
     setcolor WHITE,CYAN
     gotoxy 4,1 
     text "Enter directory to which to install"
     window 18,13,60,13
     Res=INPUT DARKGRAY,WHITE,DestDir,DestDir,42
     restscr 1
     window 1,1,80,25
     goto Menu
endif

if Choice == 3
  box 6,11,76,24,LIGHTCYAN,BLUE,DOUBLE
  setcolor LIGHTCYAN,BLUE
  gotoxy 27,11
  text " Installation status: "
  window 7,12,75,23
  clrscr
; Check free space
  DiskSpace=getdfree
  KDiskSpace=DiskSpace/1024
  KDiskNeed=diskneed/1024
  text "Installation started.\n"
  text "Disk space required:  ",KDiskNeed," Kb\n"
  text "Disk space available: ",KDiskSpace," Kb\n"
  inswrow=4
  window 1,1,80,25

  if DiskSpace < diskneed
          savescr 1
          window 1,1,80,25
          sound 2300,25
          delay 100
          sound 1450,25
          delay 100
          sound 2300,100
          Choice = menu 24,16,WHITE,RED,1,"Out of disk space","Continue with installation","          Exit"
          if Choice == 0
               goto Quit
          endif
          if Choice == 2
               goto Quit
          endif
          restscr 1
     endif
endif

if Choice == 4
Quit:
     setcolor WHITE,BLACK
     clrscr
     gotoxy 2,3
     text "The SFX package has not yet been extracted."
     sound 380,25
     delay 210
     sound 190,25
     exit 1
     goto Menu
endif

; HERE INSTALLATION STARTS!
; ctext "Installation has started."

proc OnKey
     window 1,1,80,25
     if Par1 == 3
          savescr 15
          Par1=-1
          sound 2300,25
          delay 100
          sound 1450,100
          Choice=Menu 22,11,WHITE,LIGHTRED,1,"Ctrl-Break","             Abort           ","   Continue with installation   "
          if Choice == 1
               exit 1
          endif
          restscr 15
     endif

     if Par1 == 301
           goto Quit
     endif

     if Par1 == 315
          savescr 15
          call OutHelp
          Par1=-1
          restscr 15
     endif
endp

proc ChangeVol

     window 7,12,75,23
     setcolor YELLOW,BLUE
     gotoxy 1,inswrow

     if Par2 == 0
           text ".. VOLUME #",Par1," should be installed."
           savescr 14
           Par1=-1
           sound 2300,25
           delay 100
           sound 1450,100
           sound 5450,50
           sound 7450,25
           sound 1450,100

           Choice=Menu 22,11,WHITE,GREEN,1," Change volume ","   Process the next volume        ","         Exit immediately    "

           restscr 14

           if Choice == 2
                 window 7,12,75,23
                 inswrow=inswrow+1
                 gotoxy 1,inswrow
                 text " Volume not found. Exiting..          "
                 exit 1
           endif
     endif

     if Par2 != 0
           setcolor LIGHTCYAN,BLUE
           text ".. VOLUME #",Par1," has been processed."
     endif

     if inswrow = 12
           text "\n"
     endif

     if inswrow < 12
           inswrow=inswrow+1
     endif
     window 1,1,80,25
endp

proc FileDone
     gotoxy 49,11
     setcolor LIGHTCYAN,BLUE
     Percent=Par1*100
     Percent=Percent/files
     text Percent,"%% "
     window 7,12,75,23
     setcolor LIGHTCYAN,BLUE
     gotoxy 1,inswrow
     text DestFileName
     if inswrow = 12
           text "\n"
     endif
     if inswrow < 12
           inswrow=inswrow+1
     endif
     window 1,1,80,25
endp

proc Error

     window 7,12,75,23
     setcolor LIGHTCYAN,BLUE
     gotoxy 1,inswrow

     Title="Error"

     ; Par1 is assigned with error code:

     if Par1 == 1
           Message="Fatal error"
           call ErrMsg
     endif

     if Par1 == 2
           Message="CRC error, broken archive"
           call ErrMsg
     endif

     if Par1 == 3
           Message="Write error"
           call ErrMsg
     endif

     if Par1 == 4
           Message="File create error"
           call ErrMsg
     endif

     if Par1 == 5
           Message="Read error"
           call ErrMsg
     endif

     if Par1 == 6
           Message="File close error"
           call ErrMsg
     endif

     if Par1 == 7
           Message="File open error"
           call ErrMsg
     endif

     if Par1 == 8
           Message="Not enough memory"
           call ErrMsg
     endif

     if inswrow = 12
           text "\n"
     endif

     if inswrow < 12
           inswrow=inswrow+1
     endif
     window 1,1,80,25
endp

proc ErrMsg
     window 17,14,62,21
     setcolor WHITE,RED
     clrscr
     window 1,1,80,25
     box 20,15,59,20,WHITE,RED,DOUBLE
     gotoxy 1,15
     ctext " ",Title," "
     gotoxy 1,17
     ctext Message
     setcolor WHITE,BLACK
     gotoxy 1,19
     ctext " Ok "
     sound 20,5
     sound 80,50
     delay 15000
     window 1,1,80,25
endp

proc ArcDone
     sound 3300,25
     delay 100
     sound 2450,100
     window 7,12,75,23
     setcolor LIGHTCYAN,BLUE
     gotoxy 1,inswrow
     text "Done. Installation completed"
     delay 500
     savescr 2
     Title="Installation status"
     Message=" Completed "
     call OkMsg
     restscr 2
endp

proc OkMsg
     window 24,14,57,21
     setcolor BLACK,WHITE
     clrscr
     window 1,1,80,25
     box 27,15,53,20,BLACK,WHITE,DOUBLE
     gotoxy 1,15
     ctext " ",Title," "
     gotoxy 1,17
     ctext Message
     setcolor WHITE,BLACK
     gotoxy 1,19
     ctext " Ok "
     delay 50000
     window 1,1,80,25
endp

proc OutHelp
     setcolor BLACK,CYAN
     box 14,6,65,20,BLACK,CYAN,SINGLE
     gotoxy 37,6
     text " Help "
     window 15,7,64,19
     clrscr
     outtext on

    To install choose the destination directory,
    then press Enter on the "Install" item
    of the menu.

    After installation files should be
    in the specified directory.

     outtext off
     delay
endp
;
;
;
;
;
;
;
;
;
;
;
;           旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
;           �                                            �
;           �    There is no need to process with RAR!   �
;           �                                            �
;           �     JUST RUN THIS SFX MODULE AND ENJOY!    �
;           �                                            �
;           읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
;
;
;
;
;
; iSFX script will not be shown as the archive comment with RAR 1.54 and above!
