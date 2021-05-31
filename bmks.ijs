NB.* bmks.ijs: basic machine compute and file benchmarks.
NB. require 'mystats filefns'
NB. coinsert 'fldir'           NB. For "frdix" - indexed file read.

NB. Floating-point arithmetic:
fpArithmetic=: 3 : 0
arfp=. i.0
(y) 6!:2 'arfp=. arfp,6!:2 ''([:%.[:<:+:) 1000 1000?@$0'''
(y) 6!:2 'arfp=. arfp,6!:2 ''([: +/ .*/ %."2) <:+:2 1000 1000?@$0'''
arfp
)

NB. Integer arithmetic:
iat1=: (([: +/\ 0 { ]) +/ .* [: -/\ 1 { ]) * ([: +/\ 2 { ]) +/ .* [: -/\ 3 { ]
intArithmetic=: 3 : 0
ari=. i.0
(y) 6!:2 'ari=. ari,6!:2 ''([: +/ .-/ +/\"2) <:2 1000 1000?@$3'''
(y) 6!:2 'ari=. ari,6!:2 ''iat1 <:4 1000 1000?@$3'''
ari
)

NB. File writing and reading:
fileWrite=: 3 : 0
fw=. i.0 [ fnms=. ('12345',~&.><'App100x1e'),&.><'.txt'
for_fct. i.#fnms do. nw=. 10^>:fct
   (y) 6!:2 'fw=. fw,6!:2 ''nw&(4 : ''''y[(x$a.) fappend y'''')^:100]>fct{fnms'''
end.
fw;<fnms
)

NB.   ferase &> fnms
fileRead=: 3 : 0
'y fnms'=. y [ frdtm=. i.0
for_outr. i. y do.
   for_fct. ?/2$#fnms do.     NB. Scramble order to impede caching
       (y) 6!:2 'frdtm=. frdtm,6!:2 ''fread >fct{fnms'''
   end.
end.
frdtm
)

rndIxRead=: 4 : 'fread y;stix,x<.>:?stix-~fsize y [ stix=. ?fsize y'
multiIxRd=: 4 : 'y[x&rndIxRead y'
fileRndRead=: 3 : 0
'y max fnms'=. y [ fxrd=. i.0
for_fct. i.#fnms do.
   (y) 6!:2 'fxrd=. fxrd,6!:2 ''(max&multiIxRd)^:100]>fct{fnms'''
end.
fxrd
)

bmkSet=: 3 : 0
smoutput 'Starting: ',":qts''

arfp=: fpArithmetic y
smoutput 'Floating-point arithmetic: min, max, mean, SD:'
smoutput usus arfp

ari=: intArithmetic y
smoutput 'Integer arithmetic: min, max, mean, SD:'
smoutput usus ari

'fwrtm fnms'=: fileWrite y
smoutput 'File writes: min, max, mean, SD:'
smoutput usus fwrtm

frdtm=: fileRead y;<fnms
smoutput 'File reads: min, max, mean, SD:'
smoutput usus frdtm

fxrd=. fileRndRead 2;1e6;<fnms
smoutput 'Random File reads: min, max, mean, SD:'
smoutput usus fxrd

smoutput 'Done: ',":qts''
arfp;ari;fwrtm;frdtm;<fxrd
)

(3 : 0) ''
   if. -.nameExists 'DONTAUTORUN' do.
       fiwrtms=: bmkSet 10
   end.
)

NB.*** Earlier, simpler times:
NB.* Some simple system timings
writeFile=: 3 : 0
   tm=. ''
   flnm=. 'C:\Temp\tmp.tmp'
   for_sz. 1000*2^i.15 do.
       datblk=. a.{~?sz$#a.
       tm=. tm,6!:2'datblk (13 : ''x fappend y'')^:10]flnm'
       ferase flnm
   end.
   tm
)

readFile=: 3 : 0
   tm=. ''
   flnm=. 'C:\Temp\tmp.tmp'
   for_sz. 1000*2^i.15 do.
       (a.{~?sz$#a.) fwrite flnm
       tm=. tm,6!:2'(13 : ''fread y'')^:10]flnm'
       ferase flnm
   end.
   tm
)

matMults=: 3 : 0
   tm=. ''
   for_sz. 2^>:i.9 do.
       mm=. <:+:?(2$sz)$0
       tm=. tm,6!:2 '(1 |. ] [ +/ .*~)^:10]mm'
   end.
   tm
)
