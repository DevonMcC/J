NB.* DHMUtils7.ijs: my personal utility fns starting anew with J7.

NB.* BASEDSK: global default disk
NB.* sepLF: boxed vec -> items separated by LFs.
NB.* fappendDHM: basic file append used in debug logging.
NB.* dsp: despace - remove duplicate, leading, trailing spaces.
NB.* dir: Directory listing: override stdlib.
NB.* dospathsep: sub DOS path separator.
NB.* dsp: delete leading, trailing, redundant spaces.
NB.* dsp: despace - remove duplicate, leading, trailing spaces.
NB.* eqsgnptn: partition vec by 1st "="
NB.* f2v: File to Vector: read file -> vector of lines.
NB.* v2f: Vector to File: write vector of lines to file as lines.
NB.* l2v: Lines to Vec: convert lines terminated by LF to vector elements.
NB.* getEnviVars: get all environmental variables in 2-col mat:
NB.* isEnclosed: 0: not enclosed; 1: is enclosed array
NB.* isValNum: return 1 if y is char rep of valid number, 0 otherwise.
NB.* lead0s: left-pad w/0 integers in char string y to each be x long.
NB.* nameExists: 1 if item name 'y' is present.
NB.* openbox: open only if boxed.
NB.* q: Quit session, exit J
NB.* qts: Timestamp, e.g. 2011 2 10 9 51 48.648
NB.* quoteIfSp: surround name w/"s if it contains a space.
NB.* roundNums: round numbers y to precision x, e.g.
NB.* scaleNums: scale numbers y to map between (<./x) and (>./x).
NB.* stepsftn: vector of numbers from num, to num, in numsteps steps.
NB.* whereDefined: in which script file y was defined.
NB.* whUnq: where unique elements are
NB.* isNum: 1 if arg is some kind of numeric array.
NB.* numbNut: convert to num if literal rep of number, otherwise leave alone.
NB.* J2StdCvtNums: convert char rep of num from J to "Standard", or

BASEDSK=: 'E:'               NB.* BASEDSK: global default disk; this may vary by machine.
3 :0 ''
   bd=. (shell 'echo %BASEDSK%')-.CR,LF
   if. (0<#bd) *. -.bd-:'%BASEDSK%' do. BASEDSK=: bd end.
)

DEBUGSTARTUP=: 0              NB. Help debug startup errors:
NB. use following up to "dsp" in debug logging.
getTempDir=: 3 : 'BASEDSK,''/Temp/''[y'
DBGFL=: (getTempDir ''),'DHMUtils7Start.log'
NB.* sepLF: boxed vec -> items separated by LFs.
sepLF=: 13 : ';((": :: ])y),10{a.'
NB.* fappendDHM: basic file append used in debug logging.
fappendDHM=: 4 : '(,x) (#@[ [ 1!:3) :: _1: (([: < 8 u: >) ::]) y'
NB.* dsp: despace - remove duplicate, leading, trailing spaces.
dsp=: (] #~ [: (([: |. [: -. [: *./\ |.) *. [: -. ] *. 1 , }:) ' ' = ])^:(0 < [: # ,)

NB.* detrail: remove trailing {.x after {:x
detrail=: 3 : 0
   '0.' detrail y   NB. 0s after '.'
:   
   whd=. y i. {:x                       NB. Where decimal point is
   if. 0~:#decimal=. whd }. rr=. y do.  NB. If anything after decimal
       nt=. ({.x) ([: +/ [: *./\ [: |. =) decimal NB. Number of trailing items
       nt=. -nt+nt=<:#decimal NB. Also drop decimal point if only all trailing after it
       rr=. (whd{.y),nt}.decimal
   end.
   rr
NB.EG ('50.05';'0.5';'0';(,'0');'0.2';'100';'101')-:detrail &.> '50.050';'0.5000';'0';'0.0';'0.20';'100';'101'
)

NB.* rmTrailing0sAfterPoint: remove trailing zeros after decimal point.
rmTrailing0sAfterPoint=: 13 : 'y#~-.(*./\&.|.''0''=y)*.+./\''.''=y'
NB.* rmTrailingPoint: remove trailing decimal point if last character.
rmTrailingPoint=: 13 : 'y}.~-''.''={:y'
NB.* fmtJ2Snums: format J numbers to "standard" numbers in text format.
fmtJ2Snums=: rmTrailingPoint @: rmTrailing0sAfterPoint @: j2n

dir=: 1!:0@<                       NB.* dir: Directory listing: override stdlib.
dospathsep=: '\'&(('/' I.@:= ])})  NB.* dospathsep: sub DOS path separator.
dsp=: deb"1@dltb"1       NB.* dsp: delete leading, trailing, redundant spaces.
NB. Preceding "dsp" only if stdlib fns loaded.
NB.* dsp: despace - remove duplicate, leading, trailing spaces.
dsp=: (] #~ [: (([: |. [: -. [: *./\ |.) *. [: -. ] *. 1 , }:) ' ' = ])^:(0 < [: # ,)
endSlash=: (] , '/' -. {:)@:('/'&(('\' I.@:= ])}))
endSlashTC0_testcases_=: 3 : 0
   coinsert 'base'
   assert. (3$<'C:/') -: endSlash&.>'C:';'C:\';'C:/'
   assert. (3$<'abc/') -: endSlash&.>'abc';'abc\';'abc/'
   1
)

eqsgnptn=: 3 : '((1) (y i. ''='')}(#y){.1)<;.1 y'
NB.* eqsgnptn: partition vec by 1st "="

NB.* f2v: File to Vector: read file -> vector of lines.
f2v=: 3 : 'vec=. l2v 1!:1 <y'

f2v_testcases_=: 3 : 0
   ctr=. 3
   while. ctr>0 do.
       if. fexist y do. ctr=. 0 [ vec=. l2v 1!:1 <y
       else. wait 1 [ ctr=. <:ctr end.
   end.
)

v2f=: 4 : 0
NB.* v2f: Vector to File: write vector of lines to file as lines.
   if. -.nameExists 'EOL' do. EOL=. LF end.
   (;x,&.><EOL) 1!:2 <y
NB.EG ('line 1';'line 2';<'line 3') v2f 'C:/test.tmp'
)

NB.* l2v: Lines to Vec: convert lines terminated by LF to vector elements.
l2v=: 3 : '<;._1 LF,y-.CR'

getEnviVars=: 3 : 0
NB.* getEnviVars: get all environmental variables in 2-col mat:
NB. col 0 is (all uppercase) names, col 1 is values.
   enviVars=. <;._1 LF,CR-.~shell 'set' NB. List all environment variables.
   enviVars=. >eqsgnptn&.>enviVars-.a:  NB. Partition each by initial "="
   enviVars=. (0 1)}.&.>"1 enviVars     NB. Drop 1st "=" in 2nd col.
NB.EG enviVars=. getEnviVars ''
NB. e.g. Find command spec (uppercase to simplify names (in DOS)):
NB.EG comspec=. >((toupper&.>0{"1 enviVars)i. <'COMSPEC'){1{"1 enviVars
)

NB.* isEnclosed: 0: not enclosed; 1: is enclosed array
isEnclosed=: 0 ~: L.

NB.* isValNum: return 1 if y is char rep of valid number, 0 otherwise.
isValNum=: 3 : 0
   if. (0=1{.0$y)+.0~:L. y do. 0 NB. Not valid number if enclosed or numeric.
   else. y=. y-.' '              NB. Single number only.
       if. *./'0123456789_'e.~{.y do.
           try. ".y
              1
           catch. 0
           end.
       else. 0
       end.
   end.
)

3 : 0 ]'' NB.  jpath >1{Public_j_{~(0{"1 Public_j_) i. <'winlib'
if. DEBUGSTARTUP do. (;sepLF&.>'DHMUtils7.ijs:76';(ARGV_j_,<6!:0 '');y) fappendDHM DBGFL end.
)

isValNumTC0_testcases_=: 3 : 0
   postcs=. 1 [ coinsert 'base'
   assert. *./ 1=isValNum&>'0';'0.0';'1e2';'2.2e3';'3.3e_3';'_5.e3'
   assert. *./ 1=isValNum&>'_1';'_2.3';'_987654321';'_567.891011'
   assert. *./ 1=isValNum&>'_';'__';'_.'
   postcs=. 0       NB. Negative cases follow:
   assert. *./ 0=isValNum&>'This is bad';'Won''t error?'
   assert. *./ 0=isValNum&>'.0';'1.1e2e2';'abc';'1.1.1';'2.3e3.4'
   assert. *./ 0=isValNum&>99;(<'1');'_e1';'1e_';'5._3';'__.'
   1
)

NB.* lead0s: left-pad w/0 integers in char string y to each be x long.
lead0s=: [: ]`>@.(1=[: #,)('r<0>','.0',~ [: ":[) 8!:0 [: |[: ".`]@.(0=[: {.0#])]
lead0sTC0_testcases_=: 3 : 0
   assert. ('000';'001';'022';'333') -: 3 lead0s '0 1 22 333'
   assert. ('***';'044';'001') -: 3 lead0s '4444 44.44 _1'
   1
)

NB.* nameExists: 1 if item name 'y' is present.
nameExists=: 0:"_ <: [: 4!:0 <^:(L. = 0:)
openbox=: >^:L.     NB.* openbox: open only if boxed.

q=: 2!:55           NB.* q: Quit session, exit J
qts=: 6!:0          NB.* qts: Timestamp, e.g. 2011 2 10 9 51 48.648
litqts=: [: ": 6!:0 NB.* litqts: Timestamp as literal, e.g. '2018 3 12 22 4 48.648'
NB.* quoteIfSp: surround name w/"s if it contains a space.
quoteIfSp=: ('"' ,~ '"' , -.&'"')^:(' ' e. ])

roundNums=: 3 : 0"1 0
NB.* roundNums: round numbers y to precision x, e.g.
NB. 0.1 roundNums 1.23 3.14159 2.718 -> 1.2 3.1 2.7.
NB. Optional 2nd left argument is single letter specifying
NB. type of rounding: Up, Down, or Banker's.  Default
NB. banker's rounding (round halves up or down depending on
NB. parity of next (scaled) digit) tends to randomize bias.
   1 roundNums y
:
   RT=. 'B'                   NB. Default to Banker's rounding
   TO=. x                     NB. Precision to which to round.
   if. (2=#x)*.1=L. x do. 'TO RT'=. x end.
   scaled=. y%TO              NB. For Banker's: round down if last digit even,
   select. RT
   case. 'B' do. RN=. 0.5*(0~:2|<.scaled)+.0.5~:1|scaled   NB. up if odd.
   case. 'D' do. RN=. (0.5=1|scaled){0 _0.5       NB. Round halves down.
   case. 'U' do. RN=. 0.5                         NB. Round halves up.
   end.
   TO*<.scaled+RN
)

roundNumsTC0_testcases_=: 3 : 0
   assert. 1.2 3.1 2.7 -: 0.1 roundNums 1.23 3.14 2.718
   assert. 1.2 2.4 -: (0.1;'B') roundNums 1.25 2.35
   assert. 1.2 2.3 -: (0.1;'D') roundNums 1.25 2.35
   assert. 1.3 2.4 -: (0.1;'U') roundNums 1.25 2.35
   1
)

NB.* scaleNums: scale numbers y to map between (<./x) and (>./x).
scaleNums=: 3 : 0
   0 1 scaleNums y
:
   'low hi'=. ((<./),>./)x
   if. 0 *./ . = 11 o. ,y do. nums=. y-<./,y
       nums=. nums%>./,nums       NB. scale from 0 to 1
   else. nums=. y-<./10 o. ,y
       nums=. nums%>./10 o. ,nums NB. scale from 0 to 1 for complex
   end.
   nums=. low+nums*hi-low
)

stepsftn=: 3 : 0
NB.* stepsftn: vector of numbers from num, to num, in numsteps steps.
   'from to numsteps'=. y
   from+(to-from)*(numsteps-1)%~i.numsteps
)

3 : 0 ''
if. DEBUGSTARTUP do. (;sepLF&.>'DHMUtils7.ijs:157';ARGV_j_,<6!:0 '') fappendDHM DBGFL end.
)

wait=: 6!:3
NB.* whereDefined: in which script file y was defined.
whereDefined=: 3 : '(4!:4{.;:y) {:: (4!:3''''),<''Source of definition not found for '',''.'',~y'
whUnq=: 3 : '(/:/:y){1,2~:/\/:~y'     NB.* whUnq: where unique elements are

NB.* isNum: 1 if arg is some kind of numeric array.
isNum=: 3 : '1 4 8 16 64 128 1024 4096 8192 16384 e.~ 3!:0 y'
NB.EG 1 0 1 0 1-:isNum&>(i.3);'nope';(1~:0 1);(2 2$'NO');2r3
j2n=: 'S'&J2StdCvtNums             NB. Convert J number to std rep
NB. n2j=: 'J'&J2StdCvtNums         NB. Convert std representation of num to J
n2j=: (_&".)@:(-.&'+')             NB. Convert std representation of num to J
NB.* numbNut: convert to num if literal rep of number, otherwise leave alone.
numbNut=: 3 : 'if. (-.isNum y)*.isValNum y do. numify y else. y end.'

J2StdCvtNums=: 3 : 0
NB.* J2StdCvtNums: convert char rep of num from J to "Standard", or
NB. vice-versa if left arg is 'J' or '2J'; optional 2x2 left argument allows
NB. 2 arbitrary conversions: col 0 is "from", col 1 is "to" char.
NB. Monadic case changes Standard numeric representation to J representation.
   (2 2$'-_Ee') J2StdCvtNums y
:
   if. 'S'=x do. if. ' '={.,y do. y return. end. end.
   if. 0=#y do. '' return. end.
   pw16=. 0j16                          NB. Precision width: 16 digits>.
   diffChars=. 2 2$'-_Ee'               NB. Convert '-'->'_' & 'E'->'e'
   toStd=. -.'J'-:''$'2'-.~,x          NB. Flag conversion J->Standard
   if. 2 2-:$x do. diffChars=x        NB. if explicit conversion.
   elseif. toStd do. diffChars=. |."1 diffChars end.   NB. Convert other way
NB.   if. 0=1{.0$y do. y=. pw16":y end. NB. Numeric to character
   if. 0=1{.0$y do.                    NB. Numeric to character
       fmts=. (8=>(3!:0)&.>y){0,pw16   NB. Full-precision floats only
NB.       whvn=. isValNum &.> y
NB.       tty=. fmts":y                   NB. If this is too slow, go back
       y=. fmts":y                   NB. If this is too slow, go back
NB.       y=. whvn}tty,:y                NB. If this is too slow, go back
NB.       y=. pw16":y                 NB.  to this.
   end.

   y=. y-.'+'                         NB. EG 1.23e+11 is ill-formed & the
   wh=. y=0{0{diffChars                NB.  '+' is unnecessary.
   cn=. (wh#1{0{diffChars) (wh#i. $y)}y    NB. Translate chars that need it
   wh=. y=0{1{diffChars                     NB.  but leave others alone.
   cn=. (wh#1{1{diffChars) (wh#i. $cn)}cn
   if. -.toStd do.                      NB. Special handling -> J nums
       if. '%'e. cn do.                 NB. Convert nn% -> 0.nn
           cn=. pw16":0.01*".cn-. '%'
       end.
       cn=. cn-.','                     NB. No ',' in J numbers
   end.
   cn
NB.EG 'S' J2StdCvtNums _3.14 6.02e_23   NB. Convert J numbers to std rep
)
