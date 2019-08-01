# 주가 일자별 크롤링

library(rvest)
library(dplyr)
library(httr)
library(readr)

date = "20190628"

POST(url = "http://marketdata.krx.co.kr/contents/COM/GenerateOTP.jspx",
     query = list(
       name         = 'filedown',
       filetype     = 'csv',
       url          = 'MKD/04/0404/04040200/mkd04040200_01',
       market_gubun = 'ALL',
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
