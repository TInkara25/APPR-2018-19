# 2. faza: Uvoz podatkov

# sl <- locale("sl", decimal_mark=",", grouping_mark=".")
# 
# # Funkcija, ki uvozi občine iz Wikipedije
# uvozi.obcine <- function() {
#   link <- "http://sl.wikipedia.org/wiki/Seznam_ob%C4%8Din_v_Sloveniji"
#   stran <- html_session(link) %>% read_html()
#   tabela <- stran %>% html_nodes(xpath="//table[@class='wikitable sortable']") %>%
#     .[[1]] %>% html_table(dec=",")
#   for (i in 1:ncol(tabela)) {
#     if (is.character(tabela[[i]])) {
#       Encoding(tabela[[i]]) <- "UTF-8"
#     }
#   }
#   colnames(tabela) <- c("obcina", "povrsina", "prebivalci", "gostota", "naselja",
#                         "ustanovitev", "pokrajina", "regija", "odcepitev")
#   tabela$obcina <- gsub("Slovenskih", "Slov.", tabela$obcina)
#   tabela$obcina[tabela$obcina == "Kanal ob Soči"] <- "Kanal"
#   tabela$obcina[tabela$obcina == "Loški potok"] <- "Loški Potok"
#   for (col in c("povrsina", "prebivalci", "gostota", "naselja", "ustanovitev")) {
#     tabela[[col]] <- parse_number(tabela[[col]], na="-", locale=sl)
#   }
#   for (col in c("obcina", "pokrajina", "regija")) {
#     tabela[[col]] <- factor(tabela[[col]])
#   }
#   return(tabela)
# }
# 
# # Funkcija, ki uvozi podatke iz datoteke druzine.csv
# uvozi.druzine <- function(obcine) {
#   data <- read_csv2("podatki/druzine.csv", col_names=c("obcina", 1:4),
#                     locale=locale(encoding="Windows-1250"))
#   data$obcina <- data$obcina %>% strapplyc("^([^/]*)") %>% unlist() %>%
#     strapplyc("([^ ]+)") %>% sapply(paste, collapse=" ") %>% unlist()
#   data$obcina[data$obcina == "Sveti Jurij"] <- "Sveti Jurij ob Ščavnici"
#   data <- data %>% melt(id.vars="obcina", variable.name="velikost.druzine",
#                         value.name="stevilo.druzin")
#   data$velikost.druzine <- parse_number(data$velikost.druzine)
#   data$obcina <- factor(data$obcina, levels=obcine)
#   return(data)
# }
# 
# # Zapišimo podatke v razpredelnico obcine
# obcine <- uvozi.obcine()
# 
# # Zapišimo podatke v razpredelnico druzine.
# druzine <- uvozi.druzine(levels(obcine$obcina))
# 
# # Če bi imeli več funkcij za uvoz in nekaterih npr. še ne bi
# # potrebovali v 3. fazi, bi bilo smiselno funkcije dati v svojo
# # datoteko, tukaj pa bi klicali tiste, ki jih potrebujemo v
# # 2. fazi. Seveda bi morali ustrezno datoteko uvoziti v prihodnjih
# # fazah.

#Uvoz

library(dplyr)
library(rgdal)
library(rgeos)
library(mosaic)
library(maptools)
library(reshape2)

Tabela_1_OVADBE_SPOL_POLNOLETNI <- read_csv2("podatki/Tabela 1-OVADBE,SPOL,POLNOLETNI.csv", locale=locale(encoding="Windows-1250"), skip = 6)
#View(Tabela_1_OVADBE_SPOL_POLNOLETNI)

Tabela_1.1_OVADBE_SPOL_POLNOLETNI <- read_csv2("podatki/Tabela 1-OVADBE,SPOL,POLNOLETNI.csv", locale=locale(encoding="Windows-1250"), skip = 7, n_max = 7)
#View(Tabela_1.1_OVADBE_SPOL_POLNOLETNI)

Tabela_1.2_OVADBE_moski_POLNOLETNI <- read_csv2("podatki/Tabela 1-OVADBE,SPOL,POLNOLETNI.csv", locale=locale(encoding="Windows-1250"), skip = 17, n_max = 7)
#View(Tabela_1.2_OVADBE_moski_POLNOLETNI)

Tabela_1.3_OVADBE_zenske_POLNOLETNI <- read_csv2("podatki/Tabela 1-OVADBE,SPOL,POLNOLETNI.csv", locale=locale(encoding="Windows-1250"), skip = 27, n_max = 7)
#View(Tabela_1.3_OVADBE_zenske_POLNOLETNI)

Tabela_2_OBTOZBE_SPOL_POLNOLETNI <- read_csv2("podatki/Tabela 2-OBTOZBE,SPOL,POLNOLETNI.csv", locale=locale(encoding="Windows-1250"), skip = 4)
#View(Tabela_2_OBTOZBE_SPOL_POLNOLETNI)

Tabela_3_OBSODBE_SPOL_POLNOLETNI <- read_csv2("podatki/Tabela 3-OBSODBE,SPOL,POLNOLETNI.csv", locale=locale(encoding="Windows-1250"), skip = 4)
#View(Tabela_3_OBSODBE_SPOL_POLNOLETNI)

Tabela_4.1_OVADBE_moski_MLADOLETNI <- read_csv2("podatki/Tabela 4-OVADBE,SPOL,MLADOLETNI.csv", locale=locale(encoding="Windows-1250"), skip = 7, n_max = 7)
Tabela_4.1_OVADBE_zenske_MLADOLETNI <- read_csv2("podatki/Tabela 4-OVADBE,SPOL,MLADOLETNI.csv", locale=locale(encoding="Windows-1250"), skip = 17, n_max = 7)

Tabela_5_OBTOZBE_SPOL_MLADOLETNI <- read_csv2("podatki/Tabela 5-OBTOZBE,SPOL,MLADOLETNI.csv", locale=locale(encoding="Windows-1250"), skip = 4)
#View(Tabela_5_OBTOZBE_SPOL_MLADOLETNI)

Tabela_6_OBSODBE_SPOL_MLADOLETNI <- read_csv2("podatki/Tabela 6-OBSODBE,SPOL,MLADOLETNI.csv", locale=locale(encoding="Windows-1250"), skip = 4)
#View(Tabela_6_OBSODBE_SPOL_MLADOLETNI)

Tabela_7_IZOBRAZBA_AKTIVNOST <- read_csv2("podatki/Tabela 7-IZOBRAZBA, AKTIVNOST.csv", locale=locale(encoding="Windows-1250"), skip = 4)
#View(Tabela_7_IZOBRAZBA_AKTIVNOST)

Tabela_8_REGIJE <- read_csv2("podatki/Tabela 8-REGIJE.csv", locale=locale(encoding="Windows-1250"), skip = 4)
#View(Tabela_8_REGIJE)

Tabela_9_OBSODBE_SPOL_POLNOLETNI_ARHIV <- read_csv2("podatki/Tabela 9-OBSODBE,SPOL,POLNOLETNI,ARHIV.csv", locale=locale(encoding="Windows-1250"), skip = 5)
#View(Tabela_9_OBSODBE_SPOL_POLNOLETNI_ARHIV)

Tabela_10_OBSODBE_SPOL_MLADOLETNI_ARHIV <- read_csv2("podatki/Tabela 10-OBSODBE,SPOL,MLADOLETNI,ARHIV.csv", locale=locale(encoding="Windows-1250"), skip = 4)
#View(Tabela_10_OBSODBE_SPOL_MLADOLETNI_ARHIV)


#Urejanje
#Tabela 1

Tabela_1.2_OVADBE_moski_POLNOLETNI$spol <- c("moški")
Tabela_1.2_OVADBE_moski_POLNOLETNI$vrsta <- c("ovadbe")
Tabela_1.2_OVADBE_moski_POLNOLETNI <- Tabela_1.2_OVADBE_moski_POLNOLETNI %>% melt(id.variable = "X1", 
                                                                                  variable.name = "leto",value.name = "kolicina")
colnames(Tabela_1.2_OVADBE_moski_POLNOLETNI)[1] <- "starost"
#View(Tabela_1.2_OVADBE_moski_POLNOLETNI)
Tabela_1.3_OVADBE_zenske_POLNOLETNI$spol <- c("ženski")
Tabela_1.3_OVADBE_zenske_POLNOLETNI$vrsta <- c("ovadbe")
Tabela_1.3_OVADBE_zenske_POLNOLETNI <- Tabela_1.3_OVADBE_zenske_POLNOLETNI %>% melt(id.variable = "starost", 
                                                                                    variable.name = "leto",value.name = "kolicina")
colnames(Tabela_1.3_OVADBE_zenske_POLNOLETNI)[1] <- "starost"
#View(Tabela_1.3_OVADBE_zenske_POLNOLETNI)
Tabela.1 <- rbind(Tabela_1.3_OVADBE_zenske_POLNOLETNI, Tabela_1.2_OVADBE_moski_POLNOLETNI)


Tabela_2_OBTOZBE_SPOL_POLNOLETNI <- Tabela_2_OBTOZBE_SPOL_POLNOLETNI %>% melt(id.variable = "X1", 
                                                                              variable.name = "leto",value.name = "kolicina")
colnames(Tabela_2_OBTOZBE_SPOL_POLNOLETNI)[1] <- "spol"
Tabela_2_OBTOZBE_SPOL_POLNOLETNI$vrsta <- c("obtožbe")
colnames(Tabela_2_OBTOZBE_SPOL_POLNOLETNI)[2] <- "starost"
Tabela.1 <- rbind(Tabela.1, Tabela_2_OBTOZBE_SPOL_POLNOLETNI)


Tabela_3_OBSODBE_SPOL_POLNOLETNI <- Tabela_3_OBSODBE_SPOL_POLNOLETNI %>% melt(id.variable = "X1", 
                                                                              variable.name = "leto",value.name = "kolicina")
colnames(Tabela_3_OBSODBE_SPOL_POLNOLETNI)[1] <- "spol"
Tabela_3_OBSODBE_SPOL_POLNOLETNI$vrsta <- c("obsodbe")
Tabela_3_OBSODBE_SPOL_POLNOLETNI$starost <- c("polnoletni")
Tabela.1 <- rbind(Tabela.1, Tabela_3_OBSODBE_SPOL_POLNOLETNI)


Tabela_4.1_OVADBE_moski_MLADOLETNI <- Tabela_4.1_OVADBE_moski_MLADOLETNI %>% melt(id.variable = "X1", variable.name = "leto",value.name = "kolicina")
Tabela_4.1_OVADBE_moski_MLADOLETNI$vrsta <- c("ovadbe")
colnames(Tabela_4.1_OVADBE_moski_MLADOLETNI)[1] <- "starost"
Tabela_4.1_OVADBE_moski_MLADOLETNI$spol <- c("moški")

Tabela_4.1_OVADBE_zenske_MLADOLETNI <- Tabela_4.1_OVADBE_zenske_MLADOLETNI %>% melt(id.variable = "X1", variable.name = "leto",value.name = "kolicina")
Tabela_4.1_OVADBE_zenske_MLADOLETNI$vrsta <- c("ovadbe")
colnames(Tabela_4.1_OVADBE_zenske_MLADOLETNI)[1] <- "starost"
Tabela_4.1_OVADBE_zenske_MLADOLETNI$spol <- c("ženski")

Tabela.1 <- rbind(Tabela.1, Tabela_4.1_OVADBE_moski_MLADOLETNI, Tabela_4.1_OVADBE_zenske_MLADOLETNI)


Tabela_5_OBTOZBE_SPOL_MLADOLETNI <- Tabela_5_OBTOZBE_SPOL_MLADOLETNI %>% melt(id.variable = "X1", 
                                                                              variable.name = "leto",value.name = "kolicina")
colnames(Tabela_5_OBTOZBE_SPOL_MLADOLETNI)[1] <- "spol"
Tabela_5_OBTOZBE_SPOL_MLADOLETNI$vrsta <- c("obtožbe")
Tabela_5_OBTOZBE_SPOL_MLADOLETNI$starost <- c("mladoletni")
Tabela.1 <- rbind(Tabela.1, Tabela_5_OBTOZBE_SPOL_MLADOLETNI)

Tabela_6_OBSODBE_SPOL_MLADOLETNI <- Tabela_6_OBSODBE_SPOL_MLADOLETNI %>% melt(id.variable = "X1", 
                                                                              variable.name = "leto",value.name = "kolicina")
colnames(Tabela_6_OBSODBE_SPOL_MLADOLETNI)[1] <- "spol"
Tabela_6_OBSODBE_SPOL_MLADOLETNI$vrsta <- c("obsodbe")
Tabela_6_OBSODBE_SPOL_MLADOLETNI$starost <- c("mladoletni")
Tabela.1 <- rbind(Tabela.1, Tabela_6_OBSODBE_SPOL_MLADOLETNI)

Tabela_9_OBSODBE_SPOL_POLNOLETNI_ARHIV <- Tabela_9_OBSODBE_SPOL_POLNOLETNI_ARHIV %>% melt(id.variable = "X1", 
                                                                              variable.name = "leto",value.name = "kolicina")
colnames(Tabela_9_OBSODBE_SPOL_POLNOLETNI_ARHIV)[1] <- "spol"
Tabela_9_OBSODBE_SPOL_POLNOLETNI_ARHIV$vrsta <- c("obsodbe")
Tabela_9_OBSODBE_SPOL_POLNOLETNI_ARHIV$starost <- c("polnoletni")
Tabela.1 <- rbind(Tabela.1, Tabela_9_OBSODBE_SPOL_POLNOLETNI_ARHIV)

Tabela_10_OBSODBE_SPOL_MLADOLETNI_ARHIV <- Tabela_10_OBSODBE_SPOL_MLADOLETNI_ARHIV %>% melt(id.variable = "X1", 
                                                                                          variable.name = "leto",value.name = "kolicina")
colnames(Tabela_10_OBSODBE_SPOL_MLADOLETNI_ARHIV)[1] <- "spol"
Tabela_10_OBSODBE_SPOL_MLADOLETNI_ARHIV$vrsta <- c("obsodbe")
Tabela_10_OBSODBE_SPOL_MLADOLETNI_ARHIV$starost <- c("mladoletni")
Tabela.1 <- rbind(Tabela.1, Tabela_10_OBSODBE_SPOL_MLADOLETNI_ARHIV)


View(Tabela.1)

#Tabela 2
Tabela.2 <- Tabela_7_IZOBRAZBA_AKTIVNOST %>% melt(id.variable = "X1", 
                                                  variable.name = "stopnja izobrazbe", value.name = "kolicina")
colnames(Tabela.2)[1] <- "status aktivnosti"
View(Tabela.2)

#Tabela 3
Tabela.3 <- Tabela_8_REGIJE %>% melt(id.variable = "X1", variable.name = "leto", value.name = "kolicina")
colnames(Tabela.3)[1] <- c("regija")
View(Tabela.3)

#Čiščenje

#Tabela 1
Tabela.1 <- filter(Tabela.1, starost != "Starost - SKUPAJ")
Tabela.1 <- filter(Tabela.1, spol != "Spol - SKUPAJ")
Tabela.1$spol <- gsub("Moški", "moški", Tabela.1$spol)
Tabela.1$spol <- gsub("Ženske", "ženski", Tabela.1$spol)
Tabela.1$starost <- gsub("do 20 let", "od 19 do 20 let", Tabela.1$starost)
