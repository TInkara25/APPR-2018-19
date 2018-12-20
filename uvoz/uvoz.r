# 2. faza: Uvoz podatkov

sl <- locale("sl", decimal_mark=",", grouping_mark=".")

# Funkcija, ki uvozi občine iz Wikipedije
uvozi.obcine <- function() {
  link <- "http://sl.wikipedia.org/wiki/Seznam_ob%C4%8Din_v_Sloveniji"
  stran <- html_session(link) %>% read_html()
  tabela <- stran %>% html_nodes(xpath="//table[@class='wikitable sortable']") %>%
    .[[1]] %>% html_table(dec=",")
  for (i in 1:ncol(tabela)) {
    if (is.character(tabela[[i]])) {
      Encoding(tabela[[i]]) <- "UTF-8"
    }
  }
  colnames(tabela) <- c("obcina", "povrsina", "prebivalci", "gostota", "naselja",
                        "ustanovitev", "pokrajina", "regija", "odcepitev")
  tabela$obcina <- gsub("Slovenskih", "Slov.", tabela$obcina)
  tabela$obcina[tabela$obcina == "Kanal ob Soči"] <- "Kanal"
  tabela$obcina[tabela$obcina == "Loški potok"] <- "Loški Potok"
  for (col in c("povrsina", "prebivalci", "gostota", "naselja", "ustanovitev")) {
    tabela[[col]] <- parse_number(tabela[[col]], na="-", locale=sl)
  }
  for (col in c("obcina", "pokrajina", "regija")) {
    tabela[[col]] <- factor(tabela[[col]])
  }
  return(tabela)
}

# Funkcija, ki uvozi podatke iz datoteke druzine.csv
uvozi.druzine <- function(obcine) {
  data <- read_csv2("podatki/druzine.csv", col_names=c("obcina", 1:4),
                    locale=locale(encoding="Windows-1250"))
  data$obcina <- data$obcina %>% strapplyc("^([^/]*)") %>% unlist() %>%
    strapplyc("([^ ]+)") %>% sapply(paste, collapse=" ") %>% unlist()
  data$obcina[data$obcina == "Sveti Jurij"] <- "Sveti Jurij ob Ščavnici"
  data <- data %>% melt(id.vars="obcina", variable.name="velikost.druzine",
                        value.name="stevilo.druzin")
  data$velikost.druzine <- parse_number(data$velikost.druzine)
  data$obcina <- factor(data$obcina, levels=obcine)
  return(data)
}

# Zapišimo podatke v razpredelnico obcine
obcine <- uvozi.obcine()

# Zapišimo podatke v razpredelnico druzine.
druzine <- uvozi.druzine(levels(obcine$obcina))

# Če bi imeli več funkcij za uvoz in nekaterih npr. še ne bi
# potrebovali v 3. fazi, bi bilo smiselno funkcije dati v svojo
# datoteko, tukaj pa bi klicali tiste, ki jih potrebujemo v
# 2. fazi. Seveda bi morali ustrezno datoteko uvoziti v prihodnjih
# fazah.

Tabela_1_OVADBE_SPOL_POLNOLETNI <- read_csv2("podatki/Tabela 1-OVADBE,SPOL,POLNOLETNI.csv", locale=locale(encoding="Windows-1250"), skip = 6)
View(Tabela_1_OVADBE_SPOL_POLNOLETNI)

Tabela_1.1_OVADBE_SPOL_POLNOLETNI <- read_csv2("podatki/Tabela 1-OVADBE,SPOL,POLNOLETNI.csv", locale=locale(encoding="Windows-1250"), skip = 7, n_max = 7)
View(Tabela_1.1_OVADBE_SPOL_POLNOLETNI)

Tabela_1.2_OVADBE_moski_POLNOLETNI <- read.csv2("podatki/Tabela 1-OVADBE,SPOL,POLNOLETNI.csv", locale=locale(encoding="Windows-1250"), skip = 17, n_max = 7)
View(Tabela_1.2_OVADBE_SPOL_POLNOLETNI)

Tabela_1.3_OVADBE_zenske_POLNOLETNI <- read_csv2("podatki/Tabela 1-OVADBE,SPOL,POLNOLETNI.csv", locale=locale(encoding="Windows-1250"), skip = 27, n_max = 7)
View(Tabela_1.3_OVADBE_SPOL_POLNOLETNI)

Tabela_2_OBTOZBE_SPOL_POLNOLETNI <- read_csv2("podatki/Tabela 2-OBTOZBE,SPOL,POLNOLETNI.csv", locale=locale(encoding="Windows-1250"), skip = 4)
View(Tabela_2_OBTOZBE_SPOL_POLNOLETNI)

Tabela_3_OBSODBE_SPOL_POLNOLETNI <- read_csv2("podatki/Tabela 3-OBSODBE,SPOL,POLNOLETNI.csv", locale=locale(encoding="Windows-1250"), skip = 4)
View(Tabela_3_OBSODBE_SPOL_POLNOLETNI)

Tabela_4_OVADBE_SPOL_MLADOLETNI <- read_csv2("podatki/Tabela 4-OVADBE,SPOL,MLADOLETNI.csv", locale=locale(encoding="Windows-1250"), skip = 6, n_max = 8)
View(Tabela_4_OVADBE_SPOL_MLADOLETNI)

Tabela_5_OBTOZBE_SPOL_MLADOLETNI <- read_csv2("podatki/Tabela 5-OBTOZBE,SPOL,MLADOLETNI.csv", locale=locale(encoding="Windows-1250"), skip = 4)
View(Tabela_5_OBTOZBE_SPOL_MLADOLETNI)

Tabela_6_OBSODBE_SPOL_MLADOLETNI <- read_csv2("podatki/Tabela 6-OBSODBE,SPOL,MLADOLETNI.csv", locale=locale(encoding="Windows-1250"), skip = 4)
View(Tabela_6_OBSODBE_SPOL_MLADOLETNI)

Tabela_7_IZOBRAZBA_AKTIVNOST <- read_csv2("podatki/Tabela 7-IZOBRAZBA, AKTIVNOST.csv", locale=locale(encoding="Windows-1250"), skip = 4)
View(Tabela_7_IZOBRAZBA_AKTIVNOST)

Tabela_8_REGIJE <- read.csv2("podatki/Tabela 8-REGIJE.csv", locale=locale(encoding="Windows-1250"), skip = 4)
View(Tabela_8_REGIJE)

Tabela_9_OBSODBE_SPOL_POLNOLETNI_ARHIV <- read_csv2("podatki/Tabela 9-OBSODBE,SPOL,POLNOLETNI,ARHIV.csv", locale=locale(encoding="Windows-1250"), skip = 5)
View(Tabela_9_OBSODBE_SPOL_POLNOLETNI_ARHIV)

Tabela_10_OBSODBE_SPOL_MLADOLETNI_ARHIV <- read_csv2("podatki/Tabela 10-OBSODBE,SPOL,MLADOLETNI,ARHIV.csv", locale=locale(encoding="Windows-1250"), skip = 4)
View(Tabela_10_OBSODBE_SPOL_MLADOLETNI_ARHIV)

library(dplyr)
library(rgdal)
library(rgeos)
library(mosaic)
library(maptools)
library(reshape2)


#Ciscenje
#Tabela 1
Tabela_1.2_OVADBE_moski_POLNOLETNI
Tabela_1.2_OVADBE_moski_POLNOLETNI$spol <- c("moški")
View(Tabela_1.2_OVADBE_moski_POLNOLETNI)

#Tabela 2

#Tabela 3
Tabela.3 <- Tabela_8_REGIJE %>% melt(id.variable = "X1", value.name = "leto", value.name = "kolicina")
View(Tabela.3)
#Tabela 4









