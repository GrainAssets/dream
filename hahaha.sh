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
VAR_STATUS_SRC_CMBCHINA=false
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
VAR_DOMAIN_DATA_CMBCHINA=https://m.cmbchina.com/api/rate/getfxratedetail/?name=%E7%BE%8E%E5%85%83
VAR_DOMAIN_DATA_SSE=http://www.sse.com.cn
VAR_DOMAIN_DATA_SZSE=http://www.szse.cn/api/report/index/overview/onepersistenthour/szse
VAR_DOMAIN_DATA_HKEX=https://www.hkex.com.hk/eng/csm/ws/Highlightsearch.asmx/GetData?LangCode=en\&TDD=$(date +%-d)\&TMM=$(date +%-m)\&TYYYY=$(date +%Y)
VAR_DOMAIN_DATA_MACROMICRO=https://sc.macromicro.me/collections/9/us-market-relative
VAR_DOMAIN_DATA_YCHARTS=https://ycharts.com/indicators/sp_500_pe_ratio
VAR_STATUS_EXCHANGE_RATIO=false
VAR_STATUS_DATA_CN=false
VAR_STATUS_DATA_HK=false
DIR_SCRIPT=$(cd "$(dirname "${BASH_SOURCE[0]}")" || exit; pwd)

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

STRING_1="             ???????????????:"
STRING_2="           ?????????(??????):"
STRING_3="          ???????????????P/E:"
STRING_4="????????????:"
STRING_5="????????????:"
STRING_11="????????????"
STRING_12="????????????"
STRING_13="????????????"      
STRING_21="$COLOR_YELLOW ????????????,??????:"
STRING_22="$COLOR_PURPLE ????????????,??????:"

PADDING_X="----------------------------------------------------------------------------------------"
PADDING_H="                          "                                                                   # --??????[???????????? ???????????? ????????????]
PADDING_M=" "                                                                                            # --[???????????? M]??????
PADDING_N="   "                                                                                          # --[???????????? N]??????
PADDING_P="                                                     "                                        # --??????[??????/????????????]
PADDING_Q="                                                              "                               # --????????????[US/RMB]
PADDING_Y="******************** ????????????????????? $(date "+%a %d %b %Y %I:%M:%S %p %Z") ********************"

echo "$PADDING_X"

###########
# INSTALL #
###########

MKDIR_LOG(){
    if [[ ! -d "$DIR_SCRIPT/log" ]];then
        mkdir "$DIR_SCRIPT/log"
    fi
}

###########

##############
# ?????????????????? #
##############

OBTAIN_DATA_SRC_CMBCHINA(){
    VAR_TIME_START=$SECONDS
    echo "false" > "$DIR_SCRIPT"/log/STATUS_SRC_CMBCHINA.log

    VAR_DATA_CMBCHINA=$(curl -s "$VAR_DOMAIN_DATA_CMBCHINA") && \
    if [[ ${#VAR_DATA_CMBCHINA} != 0 ]];then
        echo "true" > "$DIR_SCRIPT"/log/STATUS_SRC_CMBCHINA.log
        echo "$VAR_DATA_CMBCHINA" > "$DIR_SCRIPT"/log/DATA_SRC_CMBCHINA.log
    fi

    echo -e "$VAR_DOMAIN_DATA_CMBCHINA\n??????:$((SECONDS - VAR_TIME_START)) ???" >> "$DIR_SCRIPT"/log/TIMEOUT.log
    
}

OBTAIN_DATA_SRC_SSE(){
    VAR_TIME_START=$SECONDS
    echo "false" > "$DIR_SCRIPT"/log/STATUS_SRC_SSE.log

    VAR_DATA_SSE=$(curl -s "$VAR_DOMAIN_DATA_SSE") && \
    if [[ ${#VAR_DATA_SSE} != 0 ]];then
        echo "true" > "$DIR_SCRIPT"/log/STATUS_SRC_SSE.log
        echo "$VAR_DATA_SSE" > "$DIR_SCRIPT"/log/DATA_SRC_SSE.log
    fi
    
    echo -e "$VAR_DOMAIN_DATA_SSE\n??????:$((SECONDS - VAR_TIME_START)) ???" >> "$DIR_SCRIPT"/log/TIMEOUT.log
}

OBTAIN_DATA_SRC_SZSE(){
    VAR_TIME_START=$SECONDS
    echo "false" > "$DIR_SCRIPT"/log/STATUS_SRC_SZSE.log

    VAR_DATA_SZSE=$(curl -s "$VAR_DOMAIN_DATA_SZSE") && \
    if [[ ${#VAR_DATA_SZSE} != 0 ]];then
        echo "true" > "$DIR_SCRIPT"/log/STATUS_SRC_SZSE.log
        echo "$VAR_DATA_SZSE" > "$DIR_SCRIPT"/log/DATA_SRC_SZSE.log
    fi
    
    echo -e "$VAR_DOMAIN_DATA_SZSE\n??????:$((SECONDS - VAR_TIME_START)) ???" >> "$DIR_SCRIPT"/log/TIMEOUT.log
}

OBTAIN_DATA_SRC_HKEX(){
    VAR_TIME_START=$SECONDS
    echo "false" > "$DIR_SCRIPT"/log/STATUS_SRC_HKEX.log

    VAR_DATA_HKEX=$(curl -s "$VAR_DOMAIN_DATA_HKEX") && \
    if [[ ${#VAR_DATA_HKEX} != 0 ]];then
        echo "true" > "$DIR_SCRIPT"/log/STATUS_SRC_HKEX.log
        echo "$VAR_DATA_HKEX" > "$DIR_SCRIPT"/log/DATA_SRC_HKEX.log
    fi
    
    echo -e "$VAR_DOMAIN_DATA_HKEX\n??????:$((SECONDS - VAR_TIME_START)) ???" >> "$DIR_SCRIPT"/log/TIMEOUT.log
}

OBTAIN_DATA_SRC_MACROMICRO(){
    VAR_TIME_START=$SECONDS
    echo "false" > "$DIR_SCRIPT"/log/STATUS_SRC_MACROMICRO.log

    VAR_DATA_MACROMICRO=$(curl -s "$VAR_DOMAIN_DATA_MACROMICRO") && \
    if [[ ${#VAR_DATA_MACROMICRO} != 0 ]];then
        echo "true" > "$DIR_SCRIPT"/log/STATUS_SRC_MACROMICRO.log
        echo "$VAR_DATA_MACROMICRO" > "$DIR_SCRIPT"/log/DATA_SRC_MACROMICRO.log
    fi
    
    echo -e "$VAR_DOMAIN_DATA_MACROMICRO\n??????:$((SECONDS - VAR_TIME_START)) ???" >> "$DIR_SCRIPT"/log/TIMEOUT.log
}

OBTAIN_DATA_SRC_YCHARTS(){
    VAR_TIME_START=$SECONDS
    echo "false" > "$DIR_SCRIPT"/log/STATUS_SRC_YCHARTS.log

    VAR_DATA_YCHARTS=$(curl -s "$VAR_DOMAIN_DATA_YCHARTS") && \
    if [[ ${#VAR_DATA_YCHARTS} != 0 ]];then
        echo "true" > "$DIR_SCRIPT"/log/STATUS_SRC_YCHARTS.log
        echo "$VAR_DATA_YCHARTS" > "$DIR_SCRIPT"/log/DATA_SRC_YCHARTS.log
    fi
    
    echo -e "$VAR_DOMAIN_DATA_YCHARTS\n??????:$((SECONDS - VAR_TIME_START)) ???" >> "$DIR_SCRIPT"/log/TIMEOUT.log
}

OBTAIN_DATA_SRC_ALL(){

    OBTAIN_DATA_SRC_CMBCHINA &
    OBTAIN_DATA_SRC_SSE &
    OBTAIN_DATA_SRC_SZSE &
    OBTAIN_DATA_SRC_HKEX &
    OBTAIN_DATA_SRC_MACROMICRO &
    OBTAIN_DATA_SRC_YCHARTS &
    wait

    echo -e "$PADDING_Y" >> "$DIR_SCRIPT"/log/TIMEOUT.log
    
}

##############

#######
# ?????? #
#######

# ??????????????????????????????/????????????
PARSE_DATA_SRC_CMBCHINA(){
    VAR_STATUS_SRC_CMBCHINA=$(cat "$DIR_SCRIPT"/log/STATUS_SRC_CMBCHINA.log)
    if [[ $VAR_STATUS_SRC_CMBCHINA = true ]];then
        VAR_DATA_RMB=$(cat "$DIR_SCRIPT"/log/DATA_SRC_CMBCHINA.log)
        #?????????[??????]???????????????????????????????????????
        VAR_US_RMB1=${VAR_DATA_RMB#*??????\",\"ZRtbBid\":\"} && VAR_US_RMB2=${VAR_US_RMB1%%\"*}
        if [[ $VAR_US_RMB2 =~ ^[0-9]+[.][0-9]+$ ]];then
            VAR_US_RMB=$(echo "scale=2;$VAR_US_RMB2/100" | bc | awk '{printf "%.2f\n", $0}') 
            VAR_STATUS_DATA_US_RMB=true   
        fi
        
        VAR_HK_RMB1=${VAR_DATA_RMB#*??????\",\"ZRtbBid\":\"} && VAR_HK_RMB2=${VAR_HK_RMB1%%\"*}
        if [[ $VAR_US_RMB2 =~ ^[0-9]+[.][0-9]+$ ]];then
            VAR_HK_RMB=$(echo "scale=2;$VAR_HK_RMB2/100" | bc | awk '{printf "%.2f\n", $0}') 
            VAR_STATUS_DATA_HK_RMB=true 
        fi
        
    fi
}

MACHINING_DATA_EXCHANGE_RATIO_SRC_CMBCHINA(){
    PARSE_DATA_SRC_CMBCHINA
    if [[ $VAR_STATUS_SRC_CMBCHINA = true ]];then
        # ???????????????????????????????????????????????????????????????????????????????????????????????????
        if [[ $VAR_STATUS_DATA_US_RMB = true && $VAR_STATUS_DATA_HK_RMB = true ]];then
            VAR_STATUS_EXCHANGE_RATIO=true
            STRING_4_5=$STRING_4
        else
            STRING_4_5=$STRING_5
        fi
    else
        STRING_4_5=$STRING_5
    fi
}

# ???????????????????????????????????????????????????????????????????????????
DATA_EXCHANGE_RATIO(){
    VAR_SOURCE_DATA_EXCHANGE_RATIO_NUM=1
    while :
    do
        case $VAR_SOURCE_DATA_EXCHANGE_RATIO_NUM in
        1)
            MACHINING_DATA_EXCHANGE_RATIO_SRC_CMBCHINA
            if [[ $VAR_STATUS_EXCHANGE_RATIO = true ]];then
                break
            else
                ((VAR_SOURCE_DATA_EXCHANGE_RATIO_NUM++))
            fi
            ;;
        *)
            break
        esac
    done
}

#######

###########
# ???????????? #
###########

# ??????????????????/??????????????????/P/E/????????????????????????????????????
# ?????????
PARSE_DATA_SRC_SSE(){
    VAR_STATUS_SRC_SSE=$(cat "$DIR_SCRIPT"/log/STATUS_SRC_SSE.log)
    if [[ $VAR_STATUS_SRC_SSE = true ]];then
        VAR_DATA_SSE=$(cat "$DIR_SCRIPT"/log/DATA_SRC_SSE.log)
        #??????????????????[??????]???0???????????????????????????????????????
        VAR_VALUE_SSE1=${VAR_DATA_SSE#*home_sjtj.mkt_value\ \=\ \'} && VAR_VALUE_SSE2=${VAR_VALUE_SSE1%%\'*}
        if [[ $VAR_VALUE_SSE2 =~ ^[0-9]+[.][0-9]+$ ]];then
            VAR_VALUE_SSE=$VAR_VALUE_SSE2
            VAR_COMS_SSE1=${VAR_DATA_SSE#*home_sjtj.companyNumber\ \=\ \'} && VAR_COMS_SSE=${VAR_COMS_SSE1%%\'*}
            VAR_PE_SSE1=${VAR_DATA_SSE#*home_sjtj.ratioOfPe\ \=\ \'} && VAR_PE_SSE=${VAR_PE_SSE1%%\'*}
            VAR_STATUS_DATA_VALUE_SSE=true   
        fi
    fi
}

# ?????????
PARSE_DATA_SRC_SZSE(){
    VAR_STATUS_SRC_SZSE=$(cat "$DIR_SCRIPT"/log/STATUS_SRC_SZSE.log)
    if [[ $VAR_STATUS_SRC_SZSE = true ]];then
        VAR_DATA_SZSE=$(cat "$DIR_SCRIPT"/log/DATA_SRC_SZSE.log)
        #??????????????????[??????]???0???????????????????????????????????????
        VAR_VALUE_SZSE1=${VAR_DATA_SZSE#*???????????????????????????\",\"value\":\"} && VAR_VALUE_SZSE2=${VAR_VALUE_SZSE1%%\"*}
        if [[ $VAR_VALUE_SSE2 =~ ^[0-9]+[.][0-9]+$ ]];then
            VAR_VALUE_SZSE=$VAR_VALUE_SZSE2
            VAR_COMS_SZSE1=${VAR_DATA_SZSE#*???????????????\",\"value\":\"} && VAR_COMS_SZSE=${VAR_COMS_SZSE1%%\"*}
            VAR_PE_SZSE1=${VAR_DATA_SZSE#*?????????????????????\",\"value\":\"} && VAR_PE_SZSE=${VAR_PE_SZSE1%%\"*}
            VAR_STATUS_DATA_VALUE_SZSE=true
        fi
    fi
}

# ?????????/?????????????????????
MACHINING_DATA_CN_SRC_SSE_SZSE(){
    PARSE_DATA_SRC_SSE
    PARSE_DATA_SRC_SZSE
    #?????? ????????????/?????????????????????????????????????????????
    if [[ $VAR_STATUS_DATA_VALUE_SSE = true && $VAR_STATUS_DATA_VALUE_SZSE = true ]];then
        VAR_COMS_CN=$(( VAR_COMS_SSE + VAR_COMS_SZSE ))
        VAR_VALUE_CN1=$(echo "scale=2;($VAR_VALUE_SSE+$VAR_VALUE_SZSE)" | bc | awk '{printf "%.2f\n", $0}') && \
        VAR_PE_CN=$(echo "scale=2;($VAR_PE_SSE*$VAR_PE_SZSE)*$VAR_VALUE_CN1/(($VAR_PE_SSE*$VAR_VALUE_SZSE)+($VAR_PE_SZSE*$VAR_VALUE_SSE))" \
        | bc | awk '{printf "%.2f\n", $0}')
        VAR_VALUE_CN=$(echo "scale=2;$VAR_VALUE_CN1/10000" | bc | awk '{printf "%.2f\n", $0}')
        VAR_STATUS_DATA_CN=true
    fi

}

# ???????????????????????????????????????????????????????????????????????????
DATA_CN(){
    VAR_SOURCE_DATA_CN_NUM=1
    while :
    do
        case $VAR_SOURCE_DATA_CN_NUM in
        1)
            MACHINING_DATA_CN_SRC_SSE_SZSE
            if [[ $VAR_STATUS_DATA_CN = true ]];then
                break
            else
                ((VAR_SOURCE_DATA_CN_NUM++))
            fi
            ;;
        *)
            break
        esac
    done
}

###########

###########
# ???????????? #
###########

# ???????????????????????????/??????????????????/P/E/?????????????????????????????????
# ?????????
PARSE_DATA_SRC_HKEX(){
    VAR_STATUS_SRC_HKEX=$(cat "$DIR_SCRIPT"/log/STATUS_SRC_HKEX.log)
    if [[ $VAR_STATUS_SRC_HKEX = true ]];then
        VAR_DATA_HKEX=$(cat "$DIR_SCRIPT"/log/DATA_SRC_HKEX.log)

        VAR_PE_GME1=${VAR_DATA_HKEX#*ratio\ (Times)\"\],\[\"} && VAR_PE_GME2=${VAR_PE_GME1#*\",\"} && VAR_PE_GME3=${VAR_PE_GME2%%\"*}
        # ?????????[???????????????]???0???????????????????????????????????????????????????????????????
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
}

MACHINING_DATA_HK_SRC_HKEX(){
    PARSE_DATA_SRC_HKEX

    # ??????????????????????????????????????????
    if [[ $VAR_STATUS_DATA_PE_GME = true ]];then
        VAR_COMS_HK=$(( VAR_COMS_MAIN + VAR_COMS_GME ))
        VAR_VALUE_HK1=$(echo "scale=2;($VAR_VALUE_MAIN+$VAR_VALUE_GME)" | bc | awk '{printf "%.2f\n", $0}') && \
        VAR_PE_HK=$(echo "scale=2;($VAR_PE_MAIN*$VAR_PE_GME)*$VAR_VALUE_HK1/(($VAR_PE_MAIN*$VAR_VALUE_GME)+($VAR_PE_GME*$VAR_VALUE_MAIN))" \
        | bc | awk '{printf "%.2f\n", $0}')
        VAR_VALUE_HK=$(echo "scale=2;$VAR_VALUE_HK1*10/10000*$VAR_HK_RMB" | bc | awk '{printf "%.2f\n", $0}')
        VAR_STATUS_DATA_HK=true    
    fi
}

# ???????????????????????????????????????????????????????????????????????????
DATA_HK(){
    VAR_SOURCE_DATA_HK_NUM=1
    while :
    do
        case $VAR_SOURCE_DATA_HK_NUM in
        1)
            MACHINING_DATA_HK_SRC_HKEX
            if [[ $VAR_STATUS_DATA_CN = true ]];then
                break
            else
                ((VAR_SOURCE_DATA_HK_NUM++))
            fi
            ;;
        *)
            break
        esac
    done
}

###########

###########
# ???????????? #
###########

# ???????????????M???????????????/GDP%?????????GDP??????????????????
# ????????????/GDP*100
PARSE_DATA_SRC_MACROMICRO(){
    VAR_STATUS_SRC_MACROMICRO=$(cat "$DIR_SCRIPT"/log/STATUS_SRC_MACROMICRO.log)
    if [[ $VAR_STATUS_SRC_MACROMICRO = true ]];then
        VAR_DATA_VOL_GDP_US=$(cat "$DIR_SCRIPT"/log/DATA_SRC_MACROMICRO.log) 

        #?????????[??????GDP??????]???????????????????????????????????????.
        VAR_VOL_GDP_US1=${VAR_DATA_VOL_GDP_US%%unit*} && VAR_VOL_GDP_US2=${VAR_VOL_GDP_US1##*val\"\>} && VAR_VOL_GDP_US3=${VAR_VOL_GDP_US2%%\<*}
        if [[ $VAR_VOL_GDP_US3 =~ ^[0-9]+[.][0-9]+$ ]];then
            VAR_VOL_GDP_US=$VAR_VOL_GDP_US3
            VAR_STATUS_DATA_VOL_GDP_US=true 
        fi
    fi
}

DATA_VOL_GDP_US(){
    PARSE_DATA_SRC_MACROMICRO
}


# ????????????
# ????????????
DATA_VOL_US(){
    DATA_VOL_GDP_US
    VAR_VALUE_US=$(echo "scale=2;($VAR_GCP_US*$VAR_VOL_GDP_US/100*$VAR_US_RMB)" | bc | awk '{printf "%.2f\n", $0}')
}

###############
# ??????GDP/SAAR #
###############

# ????????? #######

###############

# ??????SP&500P/E
# ?????????ycharts??????
PARSE_DATA_SRC_YCHARTS(){
    VAR_STATUS_SRC_YCHARTS=$(cat "$DIR_SCRIPT"/log/STATUS_SRC_YCHARTS.log)
    if [[ $VAR_STATUS_SRC_YCHARTS = true ]];then
        VAR_DATA_PE_US=$(cat "$DIR_SCRIPT"/log/DATA_SRC_YCHARTS.log)

        #?????????[SP&500P/E]?????????????????????????????????
        VAR_PE_US1=${VAR_DATA_PE_US#*current\ level\ of\ } && VAR_PE_US2=${VAR_PE_US1%%,*}
        if [[ $VAR_PE_US2 =~ ^[0-9]+[.][0-9]+$ ]];then
            VAR_PE_US=$VAR_PE_US2
            VAR_STATUS_DATA_PE_US=true 
        fi
    fi
}

DATA_PE_US(){
    PARSE_DATA_SRC_YCHARTS
}

DATA_US(){
    DATA_VOL_US
    DATA_PE_US
}

###########


###############
# ??????GDP/TFQ #
###############

# ????????? #######

###############

PRINT_STATUS_MARKET(){
    DATA_EXCHANGE_RATIO
    DATA_CN
    DATA_HK
    DATA_US
    echo -e "$PADDING_H $COLOR_REDS $STRING_11 $COLOR_RESET $COLOR_BLUES $STRING_12 $COLOR_RESET $COLOR_GREENS $STRING_13 $COLOR_RESET             ????????????????????????"

    echo -e "$STRING_1 $PADDING_M $COLOR_RED $VAR_COMS_CN $COLOR_RESET $PADDING_N $COLOR_BLUE $VAR_COMS_US $COLOR_RESET     $COLOR_GREEN $VAR_COMS_HK $COLOR_RESET" 
    echo -e "$STRING_2 $PADDING_M $COLOR_RED $VAR_VALUE_CN $COLOR_RESET$PADDING_N $COLOR_BLUE $VAR_VALUE_US $COLOR_RESET   $COLOR_GREEN $VAR_VALUE_HK $COLOR_RESET" 
    echo -e "$STRING_3 $PADDING_M $COLOR_RED $VAR_PE_CN$COLOR_RESET $PADDING_N $COLOR_BLUE $VAR_PE_US $COLOR_RESET    $COLOR_GREEN $VAR_PE_HK $COLOR_RESET" 
    echo -e "$PADDING_Y"

    echo "$PADDING_P $STRING_4_5"
    echo -e "$PADDING_Q $COLOR_BLUE US/RMB: $VAR_US_RMB $COLOR_RESET"
    echo -e "$PADDING_Q $COLOR_GREEN HK/RMB: $VAR_HK_RMB $COLOR_RESET"

}

##################
# ???????????????????????? #
##################

PRINT_ERROR(){
    if [[ $VAR_STATUS_SRC_CMBCHINA = false ]];then      echo -e "$COLOR_RED $(date "+%a %d %b %Y %I:%M:%S %p %Z") $STRING_21 $VAR_DOMAIN_DATA_CMBCHINA $COLOR_RESET";fi
    if [[ $VAR_STATUS_DATA_US_RMB = false ]];then       echo -e "$COLOR_RED $(date "+%a %d %b %Y %I:%M:%S %p %Z") $STRING_22 $VAR_DOMAIN_DATA_CMBCHINA $COLOR_RESET";fi
    if [[ $VAR_STATUS_DATA_HK_RMB = false ]];then       echo -e "$COLOR_RED $(date "+%a %d %b %Y %I:%M:%S %p %Z") $STRING_22 $VAR_DOMAIN_DATA_CMBCHINA $COLOR_RESET";fi
    if [[ $VAR_STATUS_SRC_SSE = false ]];then           echo -e "$COLOR_RED $(date "+%a %d %b %Y %I:%M:%S %p %Z") $STRING_21 $VAR_DOMAIN_DATA_SSE $COLOR_RESET";fi
    if [[ $VAR_STATUS_DATA_VALUE_SSE = false ]];then    echo -e "$COLOR_RED $(date "+%a %d %b %Y %I:%M:%S %p %Z") $STRING_22 $VAR_DOMAIN_DATA_SSE $COLOR_RESET";fi
    if [[ $VAR_STATUS_SRC_SZSE = false ]];then          echo -e "$COLOR_RED $(date "+%a %d %b %Y %I:%M:%S %p %Z") $STRING_21 $VAR_DOMAIN_DATA_SZSE $COLOR_RESET";fi
    if [[ $VAR_STATUS_DATA_VALUE_SZSE = false ]];then   echo -e "$COLOR_RED $(date "+%a %d %b %Y %I:%M:%S %p %Z") $STRING_22 $VAR_DOMAIN_DATA_SZSE $COLOR_RESET";fi
    if [[ $VAR_STATUS_SRC_HKEX = false ]];then          echo -e "$COLOR_RED $(date "+%a %d %b %Y %I:%M:%S %p %Z") $STRING_21 $VAR_DOMAIN_DATA_HKEX $COLOR_RESET";fi
    if [[ $VAR_STATUS_DATA_PE_GME = false ]];then       echo -e "$COLOR_RED $(date "+%a %d %b %Y %I:%M:%S %p %Z") $STRING_22 $VAR_DOMAIN_DATA_HKEX $COLOR_RESET";fi
    if [[ $VAR_STATUS_SRC_MACROMICRO = false ]];then    echo -e "$COLOR_RED $(date "+%a %d %b %Y %I:%M:%S %p %Z") $STRING_21 $VAR_DOMAIN_DATA_MACROMICRO $COLOR_RESET";fi
    if [[ $VAR_STATUS_DATA_VOL_GDP_US = false ]];then   echo -e "$COLOR_RED $(date "+%a %d %b %Y %I:%M:%S %p %Z") $STRING_22 $VAR_DOMAIN_DATA_MACROMICRO $COLOR_RESET";fi
    if [[ $VAR_STATUS_SRC_YCHARTS = false ]];then       echo -e "$COLOR_RED $(date "+%a %d %b %Y %I:%M:%S %p %Z") $STRING_21 $VAR_DOMAIN_DATA_YCHARTS $COLOR_RESET";fi
    if [[ $VAR_STATUS_DATA_PE_US = false ]];then        echo -e "$COLOR_RED $(date "+%a %d %b %Y %I:%M:%S %p %Z") $STRING_22 $VAR_DOMAIN_DATA_YCHARTS $COLOR_RESET";fi
}


##################

MKDIR_LOG

VAR_TIME_START=$SECONDS
OBTAIN_DATA_SRC_ALL
VAR_TIME_STOP=$SECONDS && echo -e "????????????:$((VAR_TIME_STOP - VAR_TIME_START)) ???" >> "$DIR_SCRIPT"/log/TIMEOUT.log

VAR_TIME_START=$SECONDS
PRINT_STATUS_MARKET
PRINT_ERROR
VAR_TIME_STOP=$SECONDS && echo -e "??????????????????:$((VAR_TIME_STOP - VAR_TIME_START)) ???\n$PADDING_Y" >> "$DIR_SCRIPT"/log/TIMEOUT.log


echo "$PADDING_X"
