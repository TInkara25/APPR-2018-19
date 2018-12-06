# Analiza podatkov s programom R, 2018/19

# Analiza kriminalitete v Sloveniji

Avtor: Tinkara Žitko

Repozitorij z gradivi pri predmetu APPR v študijskem letu 2018/19

* [![Shiny](http://mybinder.org/badge.svg)](http://beta.mybinder.org/v2/gh/TInkara25/APPR-2018-19/master?urlpath=shiny/APPR-2018-19/projekt.Rmd) Shiny
* [![RStudio](http://mybinder.org/badge.svg)](http://beta.mybinder.org/v2/gh/TInkara25/APPR-2018-19/master?urlpath=rstudio) RStudio

## Tematika

V svoji projektni nalogi bom analizirala kriminaliteto v Sloveniji. 

Analizirala bom:
* količino ovadenih, obtoženih in obsojenih fizičnih oseb
* te količine primerjala po spolu in starosti
* izobrazbo in status aktivnosti obtoženih 
* količino obsojenih oseb glede na statistične regije Slovenije
* trende obsodb skozi zadnjih 10 let

Tabele:
* Tabela 1: Ovadene polnoletne osebe - KAZNIVO DEJANJE, VRSTA ODLOČBE, SPOL, STAROST, LETO
* Tabela 2: Obtožene polnoletne osebe - KAZNIVO DEJANJE, VRSTA ODLOČBE, SPOL, LETO
* Tabela 3: Obsojene polnoletne osebe - KAZNIVO DEJANJE, GLAVNA KAZEN, SPOL, LETO
* Tabela 4: Ovadene mladoletne osebe - KAZNIVO DEJANJE, STAROST, VRSTA ODLOČBE, SPOL, LETO
* Tabela 5: Obtožene mladoletne osebe - KAZNIVO DEJANJE, VRSTA ODLOČBE, SPOL, LETO
* Tabela 6: Obsojene mladoletne osebe - KAZNIVO DEJANJE, KAZENSKA SANKCIJA, SPOL, LETO
* Tabela 7: Obsojene polnoletne osebe glede na izobrazbo in status aktivnosti - IZOBRAZBA, STATUS AKTIVNOSTI, LETO, KAZNIVO DEJANJE
* Tabela 8: Obsojeni polnoletni in mladoletni po statističnih regijah - STATISTIČNA REGIJA, KAZALNIK, LETO
* Tabela 9: Polnoletni obsojenci (2006-2013) - KAZNIVO DEJANJE, GLAVNA KAZEN, SPOL, LETO
* Tabela 10: Mladoletni obsojenci (2006-2013) - KAZNIVO DEJANJE, ŠTEVILO OSEB, SPOL, LETO

Viri:
* https://pxweb.stat.si/pxweb/Dialog/varval.asp?ma=1360106s&ti=&path=../Database/Dem_soc/13_kriminaliteta/01_statistika_toz_sodisc/01_13601_ovadene_poln_osebe/&lang=2
* https://pxweb.stat.si/pxweb/Dialog/varval.asp?ma=1360201s&ti=&path=../Database/Dem_soc/13_kriminaliteta/01_statistika_toz_sodisc/02_13602_obtozene_poln_osebe/&lang=2
* https://pxweb.stat.si/pxweb/Dialog/varval.asp?ma=1360301S&ti=&path=../Database/Dem_soc/13_kriminaliteta/01_statistika_toz_sodisc/03_13603_obsojene_poln_osebe/&lang=2
* https://pxweb.stat.si/pxweb/Dialog/varval.asp?ma=1360403s&ti=&path=../Database/Dem_soc/13_kriminaliteta/01_statistika_toz_sodisc/04_13604_ovadene_mlad_osebe/&lang=2
* https://pxweb.stat.si/pxweb/Dialog/varval.asp?ma=1360501s&ti=&path=../Database/Dem_soc/13_kriminaliteta/01_statistika_toz_sodisc/05_13605_obtozene_mlad_osebe/&lang=2
* https://pxweb.stat.si/pxweb/Dialog/varval.asp?ma=1360603s&ti=&path=../Database/Dem_soc/13_kriminaliteta/01_statistika_toz_sodisc/06_13606_obsojene_mlad_osebe/&lang=2
* https://pxweb.stat.si/pxweb/Dialog/varval.asp?ma=1360312S&ti=&path=../Database/Dem_soc/13_kriminaliteta/01_statistika_toz_sodisc/03_13603_obsojene_poln_osebe/&lang=2
* https://pxweb.stat.si/pxweb/Dialog/varval.asp?ma=1372202s&ti=&path=../Database/Dem_soc/13_kriminaliteta/01_statistika_toz_sodisc/10_13722_obsojene_kazalniki/&lang=2
* https://pxweb.stat.si/pxweb/Dialog/varval.asp?ma=1360391S&ti=&path=../Database/Dem_soc/13_kriminaliteta/90_arhiv/03_13603_obsojene_poln_osebe/&lang=2
* https://pxweb.stat.si/pxweb/Dialog/varval.asp?ma=1360691S&ti=&path=../Database/Dem_soc/13_kriminaliteta/90_arhiv/06_13606_obsojene_mlad_osebe/&lang=2

## Program

Glavni program in poročilo se nahajata v datoteki `projekt.Rmd`.
Ko ga prevedemo, se izvedejo programi, ki ustrezajo drugi, tretji in četrti fazi projekta:

* obdelava, uvoz in čiščenje podatkov: `uvoz/uvoz.r`
* analiza in vizualizacija podatkov: `vizualizacija/vizualizacija.r`
* napredna analiza podatkov: `analiza/analiza.r`

Vnaprej pripravljene funkcije se nahajajo v datotekah v mapi `lib/`.
Podatkovni viri so v mapi `podatki/`.
Zemljevidi v obliki SHP, ki jih program pobere,
se shranijo v mapo `../zemljevidi/` (torej izven mape projekta).

## Potrebni paketi za R

Za zagon tega vzorca je potrebno namestiti sledeče pakete za R:

* `knitr` - za izdelovanje poročila
* `rmarkdown` - za prevajanje poročila v obliki RMarkdown
* `shiny` - za prikaz spletnega vmesnika
* `DT` - za prikaz interaktivne tabele
* `rgdal` - za uvoz zemljevidov
* `digest` - za zgoščevalne funkcije (uporabljajo se za shranjevanje zemljevidov)
* `readr` - za branje podatkov
* `rvest` - za pobiranje spletnih strani
* `reshape2` - za preoblikovanje podatkov v obliko *tidy data*
* `dplyr` - za delo s podatki
* `gsubfn` - za delo z nizi (čiščenje podatkov)
* `ggplot2` - za izrisovanje grafov
* `mosaic` - za pretvorbo zemljevidov v obliko za risanje z `ggplot2`
* `maptools` - za delo z zemljevidi
* `extrafont` - za pravilen prikaz šumnikov (neobvezno)

## Binder

Zgornje [povezave](#analiza-podatkov-s-programom-r-201819)
omogočajo poganjanje projekta na spletu z orodjem [Binder](https://mybinder.org/).
V ta namen je bila pripravljena slika za [Docker](https://www.docker.com/),
ki vsebuje večino paketov, ki jih boste potrebovali za svoj projekt.

Če se izkaže, da katerega od paketov, ki ji potrebujete, ni v sliki,
lahko za sprotno namestitev poskrbite tako,
da jih v datoteki [`install.R`](install.R) namestite z ukazom `install.packages`.
Te datoteke (ali ukaza `install.packages`) **ne vključujte** v svoj program -
gre samo za navodilo za Binder, katere pakete naj namesti pred poganjanjem vašega projekta.

Tako nameščanje paketov se bo izvedlo pred vsakim poganjanjem v Binderju.
Če se izkaže, da je to preveč zamudno,
lahko pripravite [lastno sliko](https://github.com/jaanos/APPR-docker) z želenimi paketi.

Če želite v Binderju delati z git,
v datoteki `gitconfig` nastavite svoje ime in priimek ter e-poštni naslov
(odkomentirajte vzorec in zamenjajte s svojimi podatki) -
ob naslednjem.zagonu bo mogoče delati commite.
Te podatke lahko nastavite tudi z `git config --global` v konzoli
(vendar bodo veljale le v trenutni seji).
