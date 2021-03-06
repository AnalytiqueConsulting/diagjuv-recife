#====================================================#
# DIAGN?STICO DA JUVENTUDE NA CIDADE DO RECIFE       #              
#====================================================#
# SAUDE E MEIO AMBIENTE                              #
#----------------------------------------------------#
# Secretaria Executiva de Juventude                  #
#----------------------------------------------------#
# Recife 2018                                        #
#----------------------------------------------------#
# Claudio A. Monteiro                                #
# claudiomonteiro@gmail.com                          #
#----------------------------------------------------#
# Qualquer duvida contate o desenvolvedor            #
# #UseSoftwareLivre                                  #
#----------------------------------------------------#


#======================================================#
#------------------------------------------------------#
# Abra e execute o arquivo 'funcoes_gerais.R'
#------------------------------------------------------#
#======================================================#

# instalar pacotes necessarios
# install.packages(c("devtools", "readxl", "dplyr", "viridis"))

library(readxl); library(devtools); library(dplyr);  library(ggrepel); library(dplyr); library(viridis)
library(purrr); library(ggplot2);library(stringi); library(rgdal); library(ggplot2); 
library(maps); library(mapdata); library(raster); library(ggmap);
library(readxl); library(devtools)

# carregar shapefile 1 (completo)
shp_recife1 <- shapefile("Dados Gerais/bases_cartograficas/Bairros.shp")

#=================================#
#            SANEAMENTO
#=================================#

# carregar bases
esgoto2000 <- read_excel("Saude e Meio Ambiente/dados/esgotamento-CENSO2000[bairrosPE].xls", col_names = FALSE)
esgoto2010 <- read_excel("Saude e Meio Ambiente/dados/esgotamento-CENSO2010[bairrosPE].xls", col_names = FALSE)

# selecionar bairros do Recife
esgoto2000 <- esgoto2000[712:805,]
esgoto2010 <- esgoto2010[1018:1111,]

# Transformar "-" em "0"
esgoto2010 <- data.frame(sapply(esgoto2010, function(x) gsub("-", "0", as.character(x))), stringsAsFactors = F)

# transformar em numeric
esgoto2000 <- data.frame(esgoto2000[,1], lapply(esgoto2000[,2:11], as.numeric))
esgoto2010 <- data.frame(esgoto2010[,1], lapply(esgoto2010[,2:8], as.numeric))

# renomear variaveis
colnames(esgoto2000) <- c("localidade", "total_domicilios", "possui_banheiro_total", "esgotamento_geral_pluvial", 
                          "esgotamento_fossa_septica","esgotamento_fossa_rudimentar","esgotamento_vala", "esgotamento_rio_lago_mar", 
                          "esgotamento_outro", "nao_possui_banheiro", "codigo")

colnames(esgoto2010) <- c("localidade", "total_domicilios", "possui_banheiro_total", "esgotamento_geral_pluvial", 
                          "esgotamento_fossa_septica", "esgotamento_outro", "nao_possui_banheiro", "codigo")

# calcular percent de domicilios com esgotamento sanitario
esgoto2000 <- mutate(esgoto2000, taxa_esgotamento = round((possui_banheiro_total / total_domicilios), 3)*100 )
esgoto2010 <- mutate(esgoto2010, taxa_esgotamento = round((possui_banheiro_total / total_domicilios), 3)*100 )

#====== mapa taxa esgotamento =======#
mapa_esgoto_2000 <- mapa.funcao(shp_recife1, esgoto2000, esgoto2000$taxa_esgotamento, "2000", "Taxa de Esgotamento Sanitário", "D")
mapa_esgoto_2000

mapa_esgoto_2010 <- mapa.funcao(shp_recife1, esgoto2010, esgoto2010$taxa_esgotamento, "2010","Taxa de Esgotamento Sanit?rio", "D")

# cambinar e salvar mapas
mapa_taxa_esgotamento <- ggarrange(mapa_esgoto_2000, mapa_esgoto_2010, ncol = 2, common.legend = T, legend = "bottom")
ggsave("capa.png", path = "Saude e Meio Ambiente/resultados", width = 7, height = 11, units = "in")






