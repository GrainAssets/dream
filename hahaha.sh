#!/bin/bash
####################################################################
#                                                                  #
# Market of CN,US,HK Status check for Linux or MacOS.              #
# Created by FanJialins, 2021                                      #
#                                                                  #
# This script may be freely used, copied, modified and distributed #
# under the sole condition that credits to the original author     #
# remain intact.                                                   #
#                                                                  #
# This script comes without any warranty, use it at your own risk. #
#                                                                  #
####################################################################

###############################################
# CHANGE THESE OPTIONS TO MATCH YOUR SYSTEM ! #
###############################################

LANG=en_US.UTF-8

VAR_COMS_SSE=0
VAR_COMS_SZSE=0
VAR_COMS_CN=0
VAR_COMS_MAIN=0
VAR_COMS_GME=0
VAR_COMS_HK=0
VAR_COMS_US=5718
VAR_VALUE_SSE=0
VAR_VALUE_SZSE=0
VAR_VALUE_CN=0
VAR_VALUE_MAIN=0
VAR_VALUE_GME=0
VAR_VALUE_HK=0
VAR_VALUE_US=0
VAR_PE_SSE=1
VAR_PE_SZSE=1
VAR_PE_CN=1
VAR_PE_MAIN=1
VAR_PE_GME=1
VAR_PE_HK=1
VAR_PE_US=1
VAR_GDP_CN=105.87
VAR_GCP_US=19.086
VAR_VOL_GDP_US=0
VAR_VOL_GDP_CN=0
VAR_US_RMB=6.4740
VAR_HK_RMB=0.8336
VAR_STATUS_SRC_RMB=false
VAR_STATUS_SRC_SSE=false
VAR_STATUS_SRC_SZSE=false
VAR_STATUS_SRC_HKEX=false
VAR_STATUS_SRC_MACROMICRO=false
VAR_STATUS_SRC_YCHARTS=false
VAR_STATUS_DATA_US_RMB=false
VAR_STATUS_DATA_HK_RMB=false
VAR_STATUS_DATA_VALUE_SSE=false
VAR_STATUS_DATA_VALUE_SZSE=false
VAR_STATUS_DATA_PE_GME=false
VAR_STATUS_DATA_VOL_GDP_US=false
VAR_STATUS_DATA_PE_US=false
VAR_DOMAIN_DATA_RMB=https://m.cmbchina.com/api/rate/getfxratedetail/?name=%E7%BE%8E%E5%85%83
VAR_DOMAIN_DATA_SSE=http://www.sse.com.cn
VAR_DOMAIN_DATA_SZSE=http://www.szse.cn/api/report/index/overview/onepersistenthour/szse
VAR_DOMAIN_DATA_HKEX=https://www.hkex.com.hk/eng/csm/ws/Highlightsearch.asmx/GetData?LangCode=en\&TDD=$(date +%-d)\&TMM=$(date +%-m)\&TYYYY=$(date +%Y)
VAR_DOMAIN_DATA_MACROMICRO=https://sc.macromicro.me/collections/9/us-market-relative
VAR_DOMAIN_DATA_YCHARTS=https://ycharts.com/indicators/sp_500_pe_ratio

##################
# END OF OPTIONS #
##################

COLOR_RED="\033[1;31m"
COLOR_REDS="\033[7;31m"
COLOR_GREEN="\033[1;32m"
COLOR_GREENS="\033[7;32m"
COLOR_YELLOW="\033[1;33m"
COLOR_BLUE="\033[1;34m"
COLOR_BLUES="\033[7;34m"
COLOR_PURPLE="\033[1;35m"
COLOR_RESET="\033[0m"

STRING_1="             上市公司数:"
STRING_2="           总市值(万亿):"
STRING_3="          平均市盈率P/E:"
STRING_4="实时汇率:"
STRING_5="参考汇率:"
STRING_11="中国市场"
STRING_12="美国市场"
STRING_13="香港市场"      
STRING_21="异常来源,检查:"
STRING_22="异常数据,检查:"

PADDING_X="----------------------------------------------------------------------------------------"
PADDING_H="                          "                                                                   # --填充[中国市场 美国市场 香港市场]
PADDING_M=" "                                                                                            # --[内容中间 M]填充
PADDING_N="   "                                                                                          # --[内容中间 N]填充
PADDING_P="                                                     "                                        # --填充[参考/实时汇率]
PADDING_Q="                                                              "                               # --填充内容[US/RMB]
PADDING_Y="******************** 数据获取时间： $(date "+%a %d %b %Y %I:%M:%S %p %Z") ********************"

echo "$PADDING_X"

#######
# 汇率 #
#######

# 我们取招商银行，美元/港元汇率
VAR_DATA_RMB=$(curl -s "$VAR_DOMAIN_DATA_RMB") && VAR_STATUS_SRC_RMB=true
if [[ $VAR_STATUS_SRC_RMB = true ]];then
    
    #逻辑：[汇率]浮点数字，判定数据成功
    VAR_US_RMB1=${VAR_DATA_RMB#*美元\",\"ZRtbBid\":\"} && VAR_US_RMB2=${VAR_US_RMB1%%\"*}
    if [[ $VAR_US_RMB2 =~ ^[0-9]+[.][0-9]+$ ]];then
        VAR_US_RMB=$(echo "scale=2;$VAR_US_RMB2/100" | bc | awk '{printf "%g", $0}') 
        VAR_STATUS_DATA_US_RMB=true   
    fi
    
    VAR_HK_RMB1=${VAR_DATA_RMB#*港币\",\"ZRtbBid\":\"} && VAR_HK_RMB2=${VAR_HK_RMB1%%\"*}
    if [[ $VAR_US_RMB2 =~ ^[0-9]+[.][0-9]+$ ]];then
        VAR_HK_RMB=$(echo "scale=2;$VAR_HK_RMB2/100" | bc | awk '{printf "%g", $0}') 
        VAR_STATUS_DATA_HK_RMB=true 
    fi
    
fi

# 数据成功，前段参数置“实时汇率”，否则置“参考汇率”
if [[ $VAR_STATUS_SRC_RMB = true ]];then
    if [[ $VAR_STATUS_DATA_US_RMB = true && $VAR_STATUS_DATA_HK_RMB = true ]];then
        STRING_4_5=$STRING_4
    else
        STRING_4_5=$STRING_5
    fi
else
    STRING_4_5=$STRING_5
fi

#######

###########
# 中国市场 #
###########

# 我们取深交所/上交所，市值/P/E/上市公司数，再汇总计算。
# 上交所
VAR_DATA_SSE=$(curl -s "$VAR_DOMAIN_DATA_SSE") && VAR_STATUS_SRC_SSE=true
if [[ $VAR_STATUS_SRC_SSE = true ]];then
    #逻辑：上交所[市值]非0且为浮点，判定数据成功
    VAR_VALUE_SSE1=${VAR_DATA_SSE#*home_sjtj.mkt_value\ \=\ \'} && VAR_VALUE_SSE2=${VAR_VALUE_SSE1%%\'*}
    if [[ $VAR_VALUE_SSE2 =~ ^[0-9]+[.][0-9]+$ ]];then
        VAR_VALUE_SSE=$VAR_VALUE_SSE2
        VAR_COMS_SSE1=${VAR_DATA_SSE#*home_sjtj.companyNumber\ \=\ \'} && VAR_COMS_SSE=${VAR_COMS_SSE1%%\'*}
        VAR_PE_SSE1=${VAR_DATA_SSE#*home_sjtj.ratioOfPe\ \=\ \'} && VAR_PE_SSE=${VAR_PE_SSE1%%\'*}
        VAR_STATUS_DATA_VALUE_SSE=true   
    fi
fi

# 深交所
VAR_DATA_SZSE=$(curl -s "$VAR_DOMAIN_DATA_SZSE") && VAR_STATUS_SRC_SZSE=true
if [[ $VAR_STATUS_SRC_SZSE = true ]];then
    #逻辑：深交所[市值]非0且为浮点，判定数据成功
    VAR_VALUE_SZSE1=${VAR_DATA_SZSE#*股票总市值（亿元）\",\"value\":\"} && VAR_VALUE_SZSE2=${VAR_VALUE_SZSE1%%\"*}
    if [[ $VAR_VALUE_SSE2 =~ ^[0-9]+[.][0-9]+$ ]];then
        VAR_VALUE_SZSE=$VAR_VALUE_SZSE2
        VAR_COMS_SZSE1=${VAR_DATA_SZSE#*上市公司数\",\"value\":\"} && VAR_COMS_SZSE=${VAR_COMS_SZSE1%%\"*}
        VAR_PE_SZSE1=${VAR_DATA_SZSE#*股票平均市盈率\",\"value\":\"} && VAR_PE_SZSE=${VAR_PE_SZSE1%%\"*}
        VAR_STATUS_DATA_VALUE_SZSE=true
    fi
fi

# 上交所/深交所汇总计算
if [[ $VAR_STATUS_DATA_VALUE_SSE = true && $VAR_STATUS_DATA_VALUE_SZSE = true ]];then
    VAR_COMS_CN=$(( VAR_COMS_SSE + VAR_COMS_SZSE ))
    VAR_VALUE_CN1=$(echo "scale=2;($VAR_VALUE_SSE+$VAR_VALUE_SZSE)" | bc | awk '{printf "%g", $0}') && \
    VAR_PE_CN=$(echo "scale=2;($VAR_PE_SSE*$VAR_PE_SZSE)*$VAR_VALUE_CN1/(($VAR_PE_SSE*$VAR_VALUE_SZSE)+($VAR_PE_SZSE*$VAR_VALUE_SSE))" | bc | awk '{printf "%g", $0}')
    VAR_VALUE_CN=$(echo "scale=2;$VAR_VALUE_CN1/10000" | bc | awk '{printf "%g", $0}')
fi

###########

###########
# 香港市场 #
###########

# 我们取港交所，主板/创业板，市值/P/E/上市公司数，再汇总计算
# 港交所
VAR_DATA_HKEX=$(curl -s "$VAR_DOMAIN_DATA_HKEX") && VAR_STATUS_SRC_HKEX=true
if [[ $VAR_STATUS_SRC_HKEX = true ]];then

    VAR_PE_GME1=${VAR_DATA_HKEX#*ratio\ (Times)\"\],\[\"} && VAR_PE_GME2=${VAR_PE_GME1#*\",\"} && VAR_PE_GME3=${VAR_PE_GME2%%\"*} &&
    #逻辑：[平均市盈率]非0且为浮点，判定数据成功
    if [[ $VAR_PE_GME3 =~ ^[0-9]+[.][0-9]+$ ]];then
        VAR_PE_GME=$VAR_PE_GME3
        VAR_PE_MAIN1=${VAR_DATA_HKEX#*ratio\ (Times)\"\],\[\"} && VAR_PE_MAIN=${VAR_PE_MAIN1%%\"*}
        VAR_COMS_MAIN1=${VAR_DATA_HKEX#*listed\ companies\"\],\[\"} && VAR_COMS_MAIN2=${VAR_COMS_MAIN1%%\"*} && VAR_COMS_MAIN=${VAR_COMS_MAIN2/,/}
        VAR_COMS_GME1=${VAR_DATA_HKEX#*listed\ companies\"\],\[\"} && VAR_COMS_GME2=${VAR_COMS_GME1#*\",\"} && VAR_COMS_GME=${VAR_COMS_GME2%%\"*}
        VAR_VALUE_MAIN1=${VAR_DATA_HKEX#*HKD\ } && VAR_VALUE_MAIN2=${VAR_VALUE_MAIN1%%\"*} && VAR_VALUE_MAIN=${VAR_VALUE_MAIN2/,/}
        VAR_VALUE_GME1=${VAR_DATA_HKEX#*HKD\ } && VAR_VALUE_GME2=${VAR_VALUE_GME1#*HKD\ } && VAR_VALUE_GME=${VAR_VALUE_GME2%%\"*}
        VAR_STATUS_DATA_PE_GME=true
    fi
fi

# 汇总计算
if [[ $VAR_STATUS_DATA_PE_GME = true ]];then
    VAR_COMS_HK=$(( VAR_COMS_MAIN + VAR_COMS_GME ))
    VAR_VALUE_HK1=$(echo "scale=2;($VAR_VALUE_MAIN+$VAR_VALUE_GME)" | bc | awk '{printf "%g", $0}') && \
    VAR_PE_HK=$(echo "scale=2;($VAR_PE_MAIN*$VAR_PE_GME)*$VAR_VALUE_HK1/(($VAR_PE_MAIN*$VAR_VALUE_GME)+($VAR_PE_GME*$VAR_VALUE_MAIN))" | bc | awk '{printf "%g", $0}')
    VAR_VALUE_HK=$(echo "scale=2;$VAR_VALUE_HK1*10/10000*$VAR_HK_RMB" | bc | awk '{printf "%g", $0}')
fi

###########

###########
# 美国市场 #
###########

# 我们取财经M，先取市值/GDP%，再取GDP，折中计算市值。
# 美国市值/GDP*100
VAR_DATA_VOL_GDP_US=$(curl -s "$VAR_DOMAIN_DATA_MACROMICRO") && VAR_STATUS_SRC_MACROMICRO=true
if [[ $VAR_STATUS_SRC_MACROMICRO = true ]];then
    #逻辑：[市值GDP比值]浮点数字，判定数据成功(We spend too times?)
    VAR_VOL_GDP_US1=${VAR_DATA_VOL_GDP_US%%unit*} && VAR_VOL_GDP_US2=${VAR_VOL_GDP_US1##*val\"\>} && VAR_VOL_GDP_US3=${VAR_VOL_GDP_US2%%\<*}
    if [[ $VAR_VOL_GDP_US3 =~ ^[0-9]+[.][0-9]+$ ]];then
        VAR_VOL_GDP_US=$VAR_VOL_GDP_US3
        VAR_STATUS_DATA_VOL_GDP_US=true 
    fi
fi

###############
# 美国GDP/SAAR #
###############

# 待更新 #######

###############

# GDP % VOL 汇总计算
# 美国市值
VAR_VALUE_US=$(echo "scale=2;($VAR_GCP_US*$VAR_VOL_GDP_US/100*$VAR_US_RMB)" | bc | awk '{printf "%g", $0}')

# 美国SP&500P/E
VAR_DATA_PE_US=$(curl -s "$VAR_DOMAIN_DATA_YCHARTS") && VAR_STATUS_SRC_YCHARTS=true
if [[ $VAR_STATUS_SRC_YCHARTS = true ]];then
    #逻辑：[SP&500P/E]浮点数字，判定数据成功
    VAR_PE_US1=${VAR_DATA_PE_US#*current\ level\ of\ } && VAR_PE_US2=${VAR_PE_US1%%,*}
    if [[ $VAR_PE_US2 =~ ^[0-9]+[.][0-9]+$ ]];then
        VAR_PE_US=$VAR_PE_US2
        VAR_STATUS_DATA_PE_US=true 
    fi
fi


###########


###############
# 中国GDP/TFQ #
###############

# 待更新 #######

###############


echo -e "$PADDING_H $COLOR_REDS $STRING_11 $COLOR_RESET $COLOR_BLUES $STRING_12 $COLOR_RESET $COLOR_GREENS $STRING_13 $COLOR_RESET             货币单位：人民币"

echo -e "$STRING_1 $PADDING_M $COLOR_RED $VAR_COMS_CN $COLOR_RESET $PADDING_N $COLOR_BLUE $VAR_COMS_US $COLOR_RESET     $COLOR_GREEN $VAR_COMS_HK $COLOR_RESET" 
echo -e "$STRING_2 $PADDING_M $COLOR_RED $VAR_VALUE_CN$COLOR_RESET $PADDING_N $COLOR_BLUE $VAR_VALUE_US $COLOR_RESET   $COLOR_GREEN $VAR_VALUE_HK $COLOR_RESET" 
echo -e "$STRING_3 $PADDING_M $COLOR_RED $VAR_PE_CN$COLOR_RESET $PADDING_N $COLOR_BLUE $VAR_PE_US $COLOR_RESET    $COLOR_GREEN $VAR_PE_HK $COLOR_RESET" 
echo -e "$PADDING_Y"

echo "$PADDING_P $STRING_4_5"
echo -e "$PADDING_Q $COLOR_BLUE US/RMB: $VAR_US_RMB $COLOR_RESET"
echo -e "$PADDING_Q $COLOR_GREEN HK/RMB: $VAR_HK_RMB $COLOR_RESET"

##################
# 异常调试信息输出 #
##################

if [[ $VAR_STATUS_SRC_RMB = false ]];then           echo -e "$COLOR_RED $(date "+%a %d %b %Y %I:%M:%S %p %Z") $STRING_21 $VAR_DOMAIN_DATA_RMB ";fi
if [[ $VAR_STATUS_DATA_US_RMB = false ]];then       echo -e "$COLOR_RED $(date "+%a %d %b %Y %I:%M:%S %p %Z") $STRING_22 $VAR_DOMAIN_DATA_RMB ";fi
if [[ $VAR_STATUS_DATA_HK_RMB = false ]];then       echo -e "$COLOR_RED $(date "+%a %d %b %Y %I:%M:%S %p %Z") $STRING_22 $VAR_DOMAIN_DATA_RMB ";fi
if [[ $VAR_STATUS_SRC_SSE = false ]];then           echo -e "$COLOR_RED $(date "+%a %d %b %Y %I:%M:%S %p %Z") $STRING_21 $VAR_DOMAIN_DATA_SSE ";fi
if [[ $VAR_STATUS_DATA_VALUE_SSE = false ]];then    echo -e "$COLOR_RED $(date "+%a %d %b %Y %I:%M:%S %p %Z") $STRING_22 $VAR_DOMAIN_DATA_SSE ";fi
if [[ $VAR_STATUS_SRC_SZSE = false ]];then          echo -e "$COLOR_RED $(date "+%a %d %b %Y %I:%M:%S %p %Z") $STRING_21 $VAR_DOMAIN_DATA_SZSE ";fi
if [[ $VAR_STATUS_DATA_VALUE_SZSE = false ]];then   echo -e "$COLOR_RED $(date "+%a %d %b %Y %I:%M:%S %p %Z") $STRING_22 $VAR_DOMAIN_DATA_SZSE ";fi
if [[ $VAR_STATUS_SRC_HKEX = false ]];then          echo -e "$COLOR_RED $(date "+%a %d %b %Y %I:%M:%S %p %Z") $STRING_21 $VAR_DOMAIN_DATA_HKEX ";fi
if [[ $VAR_STATUS_DATA_PE_GME = false ]];then       echo -e "$COLOR_RED $(date "+%a %d %b %Y %I:%M:%S %p %Z") $STRING_22 $VAR_DOMAIN_DATA_HKEX ";fi
if [[ $VAR_STATUS_SRC_MACROMICRO = false ]];then    echo -e "$COLOR_RED $(date "+%a %d %b %Y %I:%M:%S %p %Z") $STRING_21 $VAR_DOMAIN_DATA_MACROMICRO ";fi
if [[ $VAR_STATUS_DATA_VOL_GDP_US = false ]];then   echo -e "$COLOR_RED $(date "+%a %d %b %Y %I:%M:%S %p %Z") $STRING_22 $VAR_DOMAIN_DATA_MACROMICRO ";fi
if [[ $VAR_STATUS_SRC_YCHARTS = false ]];then       echo -e "$COLOR_RED $(date "+%a %d %b %Y %I:%M:%S %p %Z") $STRING_21 $VAR_DOMAIN_DATA_YCHARTS ";fi
if [[ $VAR_STATUS_DATA_PE_US = false ]];then        echo -e "$COLOR_RED $(date "+%a %d %b %Y %I:%M:%S %p %Z") $STRING_22 $VAR_DOMAIN_DATA_YCHARTS ";fi

echo "$PADDING_X"
