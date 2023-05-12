import strutils, os, parseopt

# Esperanto latina al cirila, v1
# transliterumilo malgranda de mouri-sunlight, 2023

# formiĝo operaca:
# al_cirila [opcioj] <endosiero> <elidosiero>

# opcioj operacaj:
#   -x : unue aliformigu digramojn al ĉapelaleteroj
#   -f : anstataŭigu elidosieron antaŭan

# ekzemplo operaca:
# al_cirila -x ./bonaj-memeoj.txt ./pseuxda-ruso.txt
#    (bonaj-memeoj.txt digramojn enhavas)
# al_cirila -f ./impostoj.txt ./impostoj.txt
#    (anstataŭigu originalan impostoj.txt-n)

let iksSkribaro =
    @[("cx", "ĉ"), ("Cx", "Ĉ"), ("CX", "Ĉ"),
    ("gx", "ĝ"), ("Gx", "Ĝ"), ("GX", "Ĝ"),
    ("hx", "ĥ"), ("Hx", "Ĥ"), ("HX", "Ĥ"),
    ("jx", "ĵ"), ("Jx", "Ĵ"), ("JX", "Ĵ"),
    ("sx", "ŝ"), ("Sx", "Ŝ"), ("SX", "Ŝ"),
    ("ux", "ŭ"), ("Ux", "Ŭ"), ("UX", "Ŭ")]

let cirSkribaro =
    @[("b", "б"), ("B", "Б"), ("ĉ", "ч"), ("Ĉ", "Ч"), ("c", "ц"), ("C", "Ц"),
    ("d", "д"), ("D", "Д"), ("f", "ф"), ("F", "Ф"), ("ĝ", "џ"), ("Ĝ", "Џ"),
    ("g", "г"), ("G", "Г"), ("ĥ", "х"), ("Ĥ", "Х"), ("h", "һ"), ("H", "Һ"),
    ("ĵ", "ж"), ("Ĵ", "Ж"), ("i", "и"), ("I", "И"), ("k", "к"), ("K", "К"),
    ("l", "л"), ("L", "Л"), ("m", "м"), ("M", "М"), ("n", "н"), ("N", "Н"),
    ("p", "п"), ("P", "П"), ("r", "р"), ("R", "Р"), ("ŝ", "ш"), ("Ŝ", "Ш"),
    ("s", "с"), ("S", "С"), ("t", "т"), ("T", "Т"), ("ŭ", "ў"), ("Ŭ", "Ў"),
    ("u", "у"), ("U", "У"), ("v", "в"), ("V", "В"), ("z", "з"), ("Z", "З")]


#proc por aliformigi la tekstojn
proc aliformigu (en: string, iks: bool): string {.inline.} =
    if not en.isEmptyOrWhitespace():
        var enw = en
        #si la opcio -x cxeestantas, aliformigi unue al ĉapelaleteroj
        if iks: enw = enw.multiReplace(iksSkribaro)
        result = enw.multiReplace(cirSkribaro)
    else: result = " "

var dosieroj: seq[string] = @[]
var anst: bool = false #anstataŭigi elidosieron
var seniks: bool = false #aliformigi unue al ĉapelaleteroj

# legi opciojn
for spec, slosil, er in getopt():
    case spec
    of cmdEnd: assert(false)
    of cmdArgument: dosieroj.add(slosil)
    of cmdShortOption, cmdLongOption:
        case slosil
        of "f": anst = true
        of "x": seniks = true

# eraroj

if (dosieroj.len > 2 or dosieroj.len < 2) and not (dosieroj.len < 1):
    echo "malgxusta nombro de dosieroj"
    quit(2)

if dosieroj.len < 1:
    echo "formigxo operaca: al_cirila [opcioj] <endosiero> <elidosiero>"
    echo "opcioj:\n -f : anstatauxigu elidosieron antauxan\n -x : endosiero uzas x-digramojn\n"
    quit(0)

if not dosieroj[0].fileExists():
    echo "endosiero ne existas"
    quit(4)

if (not anst) and dosieroj[1].fileExists():
    echo "elidosiero existas, bonvolu uzi la opcio '-f' aux sxangxi la elidosiernomo"
    quit(3)

# apertigi elidosiero
let elidosiero = open(dosieroj[1], mode = fmWrite)

var lininumero: uint = 0
# multiguni liniojn de la endosiero (cxefa masxo)
for linio in lines(dosieroj[0]):
    echo " " & $lininumero & " " & linio
    # aliformigu
    var novlin: string = linio.aliformigu(seniks)
    echo "T" & $lininumero & " " & novlin
    lininumero += 1
    # skribi
    elidosiero.writeLine(novlin)

elidosiero.close()
