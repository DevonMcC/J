NB.* DHMConfig.ijs: load my usual configuration in J9.02 console mode

BASEDSK=: 'E:'               NB. This may vary by machine.
3 :0 ''
   bd=. (shell 'echo %BASEDSK%')-.CR,LF
   if. (0<#bd) *. -.bd-:'%BASEDSK%' do. BASEDSK=: bd end.
)

13!:0]1                       NB. Default to preserve stack on error
DEBUGSTARTUP=: 0              NB. Help debug startup errors
getTempDir=: 3 : 'BASEDSK,''/Temp/''[y'
DBGFL=: (getTempDir ''),'startup901.tmp'

NB.* enc2dlim: convert enclosed array to ({.x) (e.g. TAB)-delimited rows, ({:x) (e.g. LF)-delimited lines
NB.EG ('hi',TAB,'ho',LF,'hee',TAB,'haw',LF) -: (TAB,LF) enc2dlim ('hi';'ho'),:'hee';'haw'
enc2dlim=: [: ; ([: {: [) _1}&.> [: ;&.> ([: {. [) ,~&.>&.> [: <"1 ]
enc2dlim=: 3 : 0
   (TAB,LF) enc2dlim y
:
   x ([: ; ([: {: [) _1}&.> [: ;&.> ([: {. [) ,~&.>&.> [: <"1 ]) y
)

NB.* commaFmtNum: put commas in a long number: '12345678.91'->'12,345,678.91';
NB. left arg is precision amount, i.e. "0.001"-> 3 places.
commaFmtNum=: 3 : 0
   0.01 commaFmtNum y
:
   }.;(' ',' '-.~])&.>('c0.',":>.10^.%x) 8!:0 y
NB.EG    commaFmtNum 1234 123456.78 12.1 111222333
NB. 1,234.00 123,456.78 12.10 111,222,330.00
NB.EG    0 commaFmtNum 1234 123456.78 12.1 111222333
NB. 1,234 123,457 12 111,222,330
)
NB.* sepLF: boxed vec -> items separated by LFs.
sepLF=: 13 : ';((": :: ])y),10{a.'
fappendDHM=: 4 : '(,x) (#@[ [ 1!:3) :: _1: (([: < 8 u: >) ::]) y'
NB.* dsp: despace - remove duplicate, leading, trailing spaces.
dsp=: (] #~ [: (([: |. [: -. [: *./\ |.) *. [: -. ] *. 1 , }:) ' ' = ])^:(0 < [: # ,)

9!:7 '+++++++++|-'  NB. Simple ASCII characters for box-drawing
9!:37]0 256 18 20   NB. Display <:256 chars/line, 18 initial and 20 final for long displays.
PATHSEP_j_=: '/'    NB. For backward-compatibility with my old code
13!:0]1             NB. Turn on debug by default.
nameExists=: 0:"_ <: [: 4!:0 <^:(L. = 0:)
3 : 0]0
   if. -.nameExists 'IFJ6' do. IFJ6=: 0 end.
   if. -.nameExists 'JVERSION' do.
NB.       if. IFJ6 do. JVERSION=: 'Installer: j602a_win64.exe',LF,'Engine: j602/2008-03-03/16:45'
NB.       else. ".&.><;._2]CR-.~1!:1<jpath '~system/config/version.ijs' end.
NB.       else. JVERSION=: 'Engine: j701/2011-01-10/11:25',LF,'Library: 7.01.054' end.
   end.
)

ISWIN7=: 'Win 64' ([: +./ ([: < [) +./ .E.&> [: <;._2 ]) JVERSION,LF
J6root=. BASEDSK,>ISWIN7{'/Program Files/J602/';'/Program Files (x86)/j64-602/'

markEnd=: 4 : '1 ((#,x)+I. y)}y'
replaceItem=: 4 : '(x e. 0{y)}x,:1{y'
strRplc=: [: ; ([:,&.>]) replaceItem~ [ ([ <;.1~ (1) 0} ] markEnd E.~) [: > 0 { ]
strReplace=: 4 : 0
   if. 0 e. #x do. return. end.
   if. 0+./ .  e.&>#&.>y do. return. end.
   if. 0={.0$x do. return. end.
   if. +./0=&>{.&.>y do. return. end.
   x strRplc y
)

NB. Make available most-used abbreviations, modules...
j67pubkluge=. <;._1 &>TAB,&.><;._2]0 : 0
dt	~Code/datetime.ijs
filefns	~Code/fileFns.ijs
cmdtool	~Code/cmdtool.ijs
images	~addons/graphics/images/images.ijs
logo	~Code/bmpPal.ijs
mystats	~Code/mystats.ijs
photos	~Code/savephotodirinfo.ijs
winapi	~addons/api/winapi/winapi.ijs
WS	~Code/WS.ijs
bkp	~Code/parseDir.ijs
logger	~Code/logger.ijs
dsv	~addons/tables/dsv/dsv.ijs
)
NB. winlib	~system/main/winlib.ijs
j67pubkluge=. j67pubkluge strReplace &.> <'{BASEDSK}';BASEDSK

3 : 0 ] '' NB. jpath >1{Public_j_{~(0{"1 Public_j_) i. <'winlib'
if. DEBUGSTARTUP do. (;sepLF&.>'DHMConfig.ijs:77';(ARGV_j_,<6!:0 '');y) fappendDHM DBGFL end.
)

j67pubkluge=. 3 : 0 ] j67pubkluge
   paths=. y
   if. ISWIN7 do. 
       paths=. paths strReplace &.><'/Program Files/';'/Program Files (x86)/'
       paths=. paths strReplace &.><'/J602/';'/j64-602/'
       paths=. paths strReplace &.><'/J701/';'/j64-701/'
       paths=. paths strReplace &.><'/j64-701/';'/j64-802/'
       paths=. paths strReplace &.><'/j64-807/';'/J901/'
   end.
   paths
)

NB.* mergeByCol0: merge x into y, replacing y by x where 0{"1 matches.
mergeByCol0=: [ ,~ ] #~ [: -. (0 {"1 ]) e. 0 {"1 [

DoNotBother=: 0 : 0
3 : 0''
   if. IFJ6 do. Public_j_=: PUBLIC_j_ [ UserFolders_j_=: USERFOLDERS_j_ end.
)

Public_j_=: j67pubkluge mergeByCol0 Public_j_

UserFolders_j_=:  (<;._1 &>TAB,&.><;._2]0 : 0) mergeByCol0 UserFolders_j_
J7	{BASEDSK}/amisc/JSys/J7
Clarifi	{BASEDSK}/amisc/Clarifi/Data
Code	{BASEDSK}/amisc/Jsys/user/code
Config	{BASEDSK}/amisc/Jsys/user/config
)
UserFolders_j_=:  UserFolders_j_ strReplace &.><'{BASEDSK}';BASEDSK

3 : 0''
   if. IFJ6 do. PUBLIC_j_=: Public_j_ [ USERFOLDERS_j_ =: UserFolders_j_ end.
)

0 : 0
(3 : 0)''
   if. 2<#ARGV_z_ do. load >2{ARGV_z_ [ smoutput ARGV_z_ end.
)

require 'DHMUtils7.ijs'
