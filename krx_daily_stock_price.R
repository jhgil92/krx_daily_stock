# 주가 일자별 크롤링

library(rvest)
library(dplyr)
library(httr)
library(readr)

date = "20190627"

get_daily_stock <- function(date){
  get_market <- function(date, market){
    POST(url = "http://marketdata.krx.co.kr/contents/COM/GenerateOTP.jspx",
         query = list(
           name         = 'filedown',
           filetype     = 'csv',
           url          = 'MKD/04/0404/04040200/mkd04040200_01',
           market_gubun = market,
           indx_ind_cd  = "",
           sect_tp_cd   = "",
           schdate      = date,
           pagePath     = "/contents/MKD/04/0404/04040200/MKD04040200.jsp"
         )) -> otp
    otp = content(otp, "text")
    
    POST(url = "http://file.krx.co.kr/download.jspx",
         query = list(
           code = otp
         ),
         add_headers(referer = "http://marketdata.krx.co.kr/contents/COM/GenerateOTP.jspx")
    ) %>%
      read_html %>%
      html_text %>%
      read_csv -> data1
    data1 <- cbind(일자 = date, 구분 = market, data1)
    data1 <- data1[-3]
    Sys.sleep(5)
    return(data1)
  }
  
  STK <- get_market(date = date, market = "STK")
  KSQ <- get_market(date = date, market = "KSQ")
  KNX <- get_market(date = date, market = "KNX")
  
  data1 <- rbind(STK, KSQ, KNX)
  
  assign(paste0("stock_", date), data1, envir = .GlobalEnv)
}

get_daily_stock(date)
