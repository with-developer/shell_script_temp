#!/bin/bash

# 출력 파일 지정
FILE="Scan_Result".txt

# 시스템 정보 체크
echo > $FILE 2>&1
echo "───────────────────────────────────────────────────────────┓" >> $FILE 2>&1
echo "                                                           │" >> $FILE 2>&1
echo "                       [System info]                       │" >> $FILE 2>&1
echo "                                                           │ " >> $FILE 2>&1
system_info=`rpm --query centos-release`
echo "System Version: $system_info" >> $FILE 2>&1
echo "                                                           │ " >> $FILE 2>&1

system_ip=`hostname -I | awk '{print $1}'`
# 시스템 IP 출력
echo "System IP: $system_ip" >> $FILE 2>&1
echo "                                                           │ " >> $FILE 2>&1

sudo ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime
# KST 시간대로 변경
now_time=`date +%c`
echo "Now Time: $now_time" >> $FILE 2>&1
echo "                                                           │ " >> $FILE 2>&1
echo "───────────────────────────────────────────────────────────┛" >> $FILE 2>&1
echo " " >> $FILE 2>&1
echo " " >> $FILE 2>&1
echo " " >> $FILE 2>&1

# 취약점 진단 시작
echo "───────────────────────────────────────────────────────────┓" >> $FILE 2>&1
echo "                                                           │" >> $FILE 2>&1
echo "                    [01.Default ID Check]                  │ " >> $FILE 2>&1
echo "                                                           │ " >> $FILE 2>&1
echo "────────────────────[현재 시스템 상황]─────────────────────┫" >> $FILE 2>&1
echo "                                                           │ " >> $FILE 2>&1
cat /etc/passwd | sed -e ':a;N;$!ba;s/\n/\\n/g' > temp.txt
code_result_1=`cat ./temp.txt`
if [ `cat /etc/passwd | egrep "lp:|uucp:|nuucp:" |wc -l` -eq 0 ]
        then
		code_result_message_1="Default 계정이 존재하지 않습니다."
		result_1="양호"
                echo "$code_result_message_1" >> $FILE 2>&1
        else
                code_result_message_1=`cat /etc/passwd | egrep "lp|uucp|nuucp" | awk -F: '{print $1}' | xargs echo | sed 's/ /,/g'`
		result_1="취약"
		code_result_message_1=$code_result_message_1"계정이 존재합니다."
		echo $code_result_message_1 >> $FILE 2>&1
fi
echo "                                                           │ " >> $FILE 2>&1
echo "───────────────────────[점검 결과]─────────────────────────┫" >> $FILE 2>&1
echo "                                                           │ " >> $FILE 2>&1
echo "$result_1" >> $FILE 2>&1
echo "                                                           │ " >> $FILE 2>&1
echo "───────────────────────────────────────────────────────────┛" >> $FILE 2>&1
echo " " >> $FILE 2>&1
echo " " >> $FILE 2>&1

echo "───────────────────────────────────────────────────────────┓" >> $FILE 2>&1
echo "                                                           │" >> $FILE 2>&1
echo "                     [02.Root Mgm Check]                   │ " >> $FILE 2>&1
echo "                                                           │ " >> $FILE 2>&1
echo "────────────────────[현재 시스템 상황]─────────────────────┫" >> $FILE 2>&1
echo "                                                           │ " >> $FILE 2>&1
code_result_2=`cat /etc/passwd | grep "^root"`
cat /etc/passwd | grep "^root" | xargs echo | sed 's/ /\\n/g' > temp.txt
code_result_2=`cat ./temp.txt`

if [[ `awk -F: '$3==0' /etc/passwd`=="root" ]]
	then
		if [ `awk -F: '$3==0' /etc/passwd | wc -l` -eq 1 ]
		then
			result_2="양호"
		else
			result_2="취약"
		fi
	else
		result_2="취약"
fi
awk -F: '$3==0 {print $1 "계정의 UID는" $3" 입니다." }' /etc/passwd | sed -e ':a;N;$!ba;s/\n/\\n/g'> temp.txt
code_result_message_2=`cat ./temp.txt`
echo -e "$code_result_message_2" >> $FILE 2>&1
echo "                                                           │ " >> $FILE 2>&1
echo "───────────────────────[점검 결과]─────────────────────────┫" >> $FILE 2>&1
echo "                                                           │ " >> $FILE 2>&1
echo "$result_2" >> $FILE 2>&1
echo "                                                           │ " >> $FILE 2>&1
echo "───────────────────────────────────────────────────────────┛" >> $FILE 2>&1
echo " " >> $FILE 2>&1
echo " " >> $FILE 2>&1



echo "───────────────────────────────────────────────────────────┓" >> $FILE 2>&1
echo "                                                           │" >> $FILE 2>&1
echo "             [03.Passwd File Permission Check]             │ " >> $FILE 2>&1
echo "                                                           │ " >> $FILE 2>&1
echo "────────────────────[현재 시스템 상황]─────────────────────┫" >> $FILE 2>&1
echo "                                                           │ " >> $FILE 2>&1
code_result_3=`ls -alL /etc/passwd`
if [ -f /etc/passwd ]
	then

		if [ `ls -alL /etc/passwd | awk '{print $1}' | grep ".rw-r--r--" | wc -l` -eq 1 ]
        		then
				code_result_message_3=`ls -alL /etc/passwd | awk '{print "/etc/passwd파일의 권한은 "$1"입니다."}'`
				result_3="양호"
				echo "$code_result_message_3" >> $FILE 2>&1
        		else
				code_result_message_3=`ls -alL /etc/passwd | awk '{print "/etc/passwd파일의 권한은 "$1"입니다."}`
				result_3"취약"
				echo "$code_result_message_3" >> $FILE 2>&1
		fi
	else
		code_result_3="/etc/passwd 파일이 존재하지 않습니다."
		code_result_message_3="/etc/passwd 파일이 존재하지 않습니다."
		result_3="취약"
		echo "$code_result_message_3" >> $FILE 2>&1
fi
echo "                                                           │ " >> $FILE 2>&1
echo "───────────────────────[점검 결과]─────────────────────────┫" >> $FILE 2>&1
echo "                                                           │ " >> $FILE 2>&1
echo "$result_3" >> $FILE 2>&1
echo "                                                           │ " >> $FILE 2>&1
echo "───────────────────────────────────────────────────────────┛" >> $FILE 2>&1
echo " " >> $FILE 2>&1
echo " " >> $FILE 2>&1


echo "───────────────────────────────────────────────────────────┓" >> $FILE 2>&1
echo "                                                           │" >> $FILE 2>&1
echo "             [04.Group File Permission Check]              │ " >> $FILE 2>&1
echo "                                                           │ " >> $FILE 2>&1
echo "────────────────────[현재 시스템 상황]─────────────────────┫" >> $FILE 2>&1
echo "                                                           │ " >> $FILE 2>&1
code_result_4=`ls -alL /etc/group`
if [ -f /etc/group ]
        then

                if [ `ls -alL /etc/group | awk '{print $1}' | grep ".rw-r--r--" | wc -l` -eq 1 ]
                        then
                                code_result_message_4=`ls -alL /etc/group | awk '{print "/etc/group파일의 권한은 "$1"입니다."}'`
                                result_4="양호"
                                echo "$code_result_message_4" >> $FILE 2>&1
                        else
                                code_result_message_4=`ls -alL /etc/group | awk '{print "/etc/group파일의 권한은 "$1"입니다."}`
                                result_4"취약"
                                echo "$code_result_message_4" >> $FILE 2>&1
                fi
        else
                code_result_4="/etc/group 파일이 존재하지 않습니다."
                code_result_message_4="/etc/group 파일이 존재하지 않습니다."
                result_4="취약"
		echo "$code_result_message_4" >> $FILE 2>&1
fi
echo "                                                           │ " >> $FILE 2>&1
echo "───────────────────────[점검 결과]─────────────────────────┫" >> $FILE 2>&1
echo "                                                           │ " >> $FILE 2>&1
echo "$result_4" >> $FILE 2>&1
echo "                                                           │ " >> $FILE 2>&1
echo "───────────────────────────────────────────────────────────┛" >> $FILE 2>&1
echo " " >> $FILE 2>&1
echo " " >> $FILE 2>&1



echo "───────────────────────────────────────────────────────────┓" >> $FILE 2>&1
echo "                                                           │" >> $FILE 2>&1
echo "                  [05.Passwd Rule Check]                   │ " >> $FILE 2>&1
echo "                                                           │ " >> $FILE 2>&1
echo "────────────────────[현재 시스템 상황]─────────────────────┫" >> $FILE 2>&1
echo "                                                           │ " >> $FILE 2>&1

if [ -f /etc/login.defs ]
	then
		pass_min_len=`cat /etc/login.defs | grep -i "PASS_MIN_LEN"| grep -v "#" | awk '{print $2}'`
	        pass_max_days=`cat /etc/login.defs | grep -i "PASS_MAX_DAYS"| grep -v "#" | awk '{print $2}'`
	        pass_min_days=`cat /etc/login.defs | grep -i "PASS_MIN_DAYS"| grep -v "#" | awk '{print $2}'`
		code_result_message_5="패스워드 최소 길이: $pass_min_len\n패스워드 최대 사용 기간: $pass_max_days\n패스워드 최소 사용 기간: $pass_min_days\n"
		cat /etc/login.defs | grep -v "#" | egrep -i "PASS_MIN_LEN|PASS_MAX_DAYS|PASS_MIN_DAYS" | sed -e ':a;N;$!ba;s/\t/\\t/g' | sed -e ':a;N;$!ba;s/\n/\\n/g'  > temp.txt
		code_result_5=`cat ./temp.txt`
		#echo "$code_result_message" >> $FILE 2>&1
		echo -e "$code_result_message_5" >> $FILE 2>&1
		if [[ -z $pass_min_len ]] || [[ -z $pass_max_days ]] || [[ -z $pass_min_days ]]
			then
				result_5="취약"
	                else
				if [[ $pass_min_len -ge 8 ]] && [[ $pass_max_days -le 70 ]] && [[ $pass_min_days -ge 7 ]]
                                	then
						result_5="양호"
                                	else
						result_5="취약"
                                        	if [ $pass_min_len -lt 8 ];
							then
								code_result_message_5_temp="패스워드 최소 길이가 기준치 이하입니다. (기준치: 8글자 이상)"
								echo "$code_result_message_5_temp" >> $FILE 2>&1
								code_result_message_5=$code_result_message_5$code_result_message_5_temp"\n"
						fi
                                        	if [ $pass_max_days -gt 70 ];
							then
								code_result_message_5_temp="패스워드 최대 사용 기간이 기준치 이상입니다. (기준치: 70일 이하)"
								echo "$code_result_message_5_temp" >> $FILE 2>&1
								code_result_message_5=$code_result_message_5$code_result_message_5_temp"\n"
						fi
                                        	if [ $pass_min_days -lt 7 ];
							then
								code_result_message_5_temp="패스워드 최소 사용 기간이 기준치 이하입니다. (기준치: 7일 이상)"
								echo "$code_result_message_5_temp" >> $FILE 2>&1
								code_result_message_5=$code_result_message_5$code_result_message_5_temp"\n"
						fi
                        	fi


		fi

	else
		result_5="취약"
		code_result_5="/etc/login.defs 파일이 존재하지 않습니다."
		code_result_message_5="/etc/login.defs 파일이 존재하지 않습니다."
        	echo "$code_result_message_5" >> $FILE 2>&1
fi
echo "                                                           │ " >> $FILE 2>&1
echo "───────────────────────[점검 결과]─────────────────────────┫" >> $FILE 2>&1
echo "                                                           │ " >> $FILE 2>&1
echo "$result_5" >> $FILE 2>&1
echo "                                                           │ " >> $FILE 2>&1
echo "───────────────────────────────────────────────────────────┛" >> $FILE 2>&1
echo " " >> $FILE 2>&1
echo " " >> $FILE 2>&1



echo "───────────────────────────────────────────────────────────┓" >> $FILE 2>&1
echo "                                                           │" >> $FILE 2>&1
echo "                     [06.Shell Check]                      │ " >> $FILE 2>&1
echo "                                                           │ " >> $FILE 2>&1
echo "────────────────────[현재 시스템 상황]─────────────────────┫" >> $FILE 2>&1
echo "                                                           │ " >> $FILE 2>&1
code_result_6=`cat /etc/passwd | egrep "^daemon|^bin|^sys|^adm|^listen|^nobody|^nobody4|^noaccess|^diag|^operator|^games|^gopher" | grep -v "admin"`
cat /etc/passwd | egrep "^daemon|^bin|^sys|^adm|^listen|^nobody|^nobody4|^noaccess|^diag|^operator|^games|^gopher" | grep -v "admin" | sed -e ':a;N;$!ba;s/\n/\\n/g' > temp.txt
code_result_6=`cat ./temp.txt`
if [ -f /etc/passwd ]
	then
		if [ `cat /etc/passwd | egrep "^daemon|^bin|^sys|^adm|^listen|^nobody|^nobody4|^noaccess|^diag|^operator|^games|^gopher" | grep -v "admin" | egrep -v "false|nologin" | wc -l` -eq 0 ]
		        then
				awk -F: '{print $1" => "$7}' /etc/passwd | egrep "^daemon|^bin|^sys|^adm|^listen|^nobody|^nobody4|^noaccess|^diag|^operator|^games|^gopher" | grep -v "admin" | sed -e ':a;N;$!ba;s/\n/\\n/g' > temp.txt
				code_result_message_6=`cat ./temp.txt`
				echo -e "$code_result_message_6" >> $FILE 2>&1
				result_6="양호"
        		else
				awk -F: '{print $1" => "$7}' /etc/passwd | egrep "^daemon|^bin|^sys|^adm|^listen|^nobody|^nobody4|^noaccess|^diag|^operator|^games|^gopher" | grep -v "admin" | sed -e ':a;N;$!ba;s/\n/\\n/g' > temp.txt
                                code_result_message_6=`cat ./temp.txt`
                                echo -e "$code_result_message_6" >> $FILE 2>&1
				result_6="취약"
		fi
	else
		result_6="취약"
		code_result_message_6="/etc/passwd 파일을 찾을 수 없습니다."
		code_result_6="/etc/passwd 파일을 찾을 수 없습니다."
		echo "$code_result_message_6" >> $FILE 2>&1
fi
echo "                                                           │ " >> $FILE 2>&1
echo "───────────────────────[점검 결과]─────────────────────────┫" >> $FILE 2>&1
echo "                                                           │ " >> $FILE 2>&1
echo "$result_6" >> $FILE 2>&1
echo "                                                           │ " >> $FILE 2>&1
echo "───────────────────────────────────────────────────────────┛" >> $FILE 2>&1
echo " " >> $FILE 2>&1
echo " " >> $FILE 2>&1

echo "───────────────────────────────────────────────────────────┓" >> $FILE 2>&1
echo "                                                           │" >> $FILE 2>&1
echo "                       [07.SU Check]                       │ " >> $FILE 2>&1
echo "                                                           │ " >> $FILE 2>&1
echo "────────────────────[현재 시스템 상황]─────────────────────┫" >> $FILE 2>&1
echo "                                                           │ " >> $FILE 2>&1
echo -n "(1) /etc/pam.d/su File\n\n" > temp2.txt
cat /etc/pam.d/su | sed -e ':a;N;$!ba;s/\n/\\n/g' | sed 's/\t/\\t/g' >> temp2.txt
echo -n "\n\n(2) /etc/group File\n\n" >> temp2.txt
cat /etc/group | sed -e ':a;N;$!ba;s/\n/\\n/g' | sed 's/\t/\\t/g'  >> temp2.txt
cat ./temp2.txt | sed -e ':a;N;$!ba;s/\n/\\n/g' | sed 's/\"//g' > temp.txt
code_result_7=`cat ./temp.txt`
if [ -f /etc/pam.d/su ]
        then
                if [ -f /etc/group ]
                        then
                                if [ `cat /etc/pam.d/su | grep -v 'trust' | grep 'pam_wheel.so' | grep 'use_uid' | grep -v '^#' | wc -l` -eq 1 ]
                                        then
						cat /etc/pam.d/su | grep -v 'trust' | grep 'pam_wheel.so' | grep 'use_uid' | sed 's/\t/\\t/g' > temp.txt
						code_result_message_7=`cat ./temp.txt`
						code_result_message_7=$code_result_message_7"\n안전한 설정값이 적용되어 있습니다."
						echo -e "$code_result_message_7" >> $FILE 2>&1
						result_7="양호"
                                        else
						cat /etc/pam.d/su | grep -v 'trust' | grep 'pam_wheel.so' | grep 'use_uid' | sed 's/\t/\\t/g' > temp.txt
                                                code_result_message_7=`cat ./temp.txt`
                                                code_result_message_7=$code_result_message_7"\n취약한 설정값이 적용되어 있습니다."
						echo -e "$code_result_message_7" >> $FILE 2>&1
						result_7="취약"
                                fi
                        else
				result_7="취약"
				code_result_7="/etc/group 파일을 찾을 수 없습니다."
				code_result_message_7="/etc/group 파일을 찾을 수 없습니다."
                                echo "$code_result_message_7" >> $FILE 2>&1
                fi
        else
		result_7="취약"
		code_result_7="/etc/pam.d/su 파일을 찾을 수 없습니다."
		code_result_message_7="/etc/pam.d/su 파일을 찾을 수 없습니다."
                echo "$code_result_message_7" >> $FILE 2>&1
fi
echo "                                                           │ " >> $FILE 2>&1
echo "───────────────────────[점검 결과]─────────────────────────┫" >> $FILE 2>&1
echo "                                                           │ " >> $FILE 2>&1
echo "$result_7" >> $FILE 2>&1
echo "                                                           │ " >> $FILE 2>&1
echo "───────────────────────────────────────────────────────────┛" >> $FILE 2>&1
echo " " >> $FILE 2>&1
echo " " >> $FILE 2>&1

# 취약점 진단 종료

# temp 파일 삭제
rm -rf ./temp.txt
rm -rf ./temp2.txt

echo "───────────────────────────────────────────────────────────┓" >> $FILE 2>&1
echo "                                                           │" >> $FILE 2>&1
echo "            취약점 진단이 완료되었습니다.                  │" >> $FILE 2>&1
echo "상세 내용은 http://49.50.160.189/ 에서 확인할 수 있습니다. │" >> $FILE 2>&1
echo "                                                           │" >> $FILE 2>&1
echo "───────────────────────────────────────────────────────────┛" >> $FILE 2>&1

# 디버깅용 코드. 아래 주석 해제시 디버깅 모드.
#echo -E "$result_1" >> $FILE 2>&1
#echo -E "$code_result_message_1" >> $FILE 2>&1
#echo -E "$code_result_1" >> $FILE 2>&1
#echo -E "$result_2" >> $FILE 2>&1
#echo -E "$code_result_message_2" >> $FILE 2>&1
#echo -E "$code_result_2" >> $FILE 2>&1
#echo -E "$result_3" >> $FILE 2>&1
#echo -E "$code_result_message_3" >> $FILE 2>&1
#echo -E "$code_result_3" >> $FILE 2>&1
#echo -E "$result_4" >> $FILE 2>&1
#echo -E "$code_result_message_4" >> $FILE 2>&1
#echo -E "$code_result_4" >> $FILE 2>&1
#echo -E "$result_5" >> $FILE 2>&1
#echo -E "$code_result_message_5" >> $FILE 2>&1
#echo -E "$code_result_5" >> $FILE 2>&1
#echo -E "$result_6" >> $FILE 2>&1
#echo -E "$code_result_message_6" >> $FILE 2>&1
#echo -E "$code_result_6" >> $FILE 2>&1
#echo -E "$result_7" >> $FILE 2>&1
#echo -E "$code_result_message_7" >> $FILE 2>&1
#echo -E "$code_result_7" >> $FILE 2>&1


# 진단 항목별 양호/취약 여부 갯수 체크

# 양호/취약 카운트 초기화
good=0
bad=0

# 양호/취약 카운트 시작
if [ $result_1 == '양호' ]
	then
		good=$((good+1))
	else
		bad=$((bad+1))
fi
if [ $result_2 == '양호' ]
    then
		good=$((good+1))
    else
		bad=$((bad+1))
fi
if [ $result_3 == '양호' ]
    then
		good=$((good+1))
    else
		bad=$((bad+1))
fi
if [ $result_4 == '양호' ]
	then
		good=$((good+1))
	else
		bad=$((bad+1))
fi
if [ $result_5 == '양호' ]
	then
		good=$((good+1))
	else
		bad=$((bad+1))
fi
if [ $result_6 == '양호' ]
	then
		good=$((good+1))
	else
		bad=$((bad+1))
fi
if [ $result_7 == '양호' ]
	then
		good=$((good+1))
	else
		bad=$((bad+1))
fi
# 양호/취약 카운트 종료


# 위 결과를 Json 형식으로 변환
generate_post_data()
{
  cat <<EOF
{
  "system_info" : "$system_info",
  "system_ip" : "$system_ip",
  "now_time" : "$now_time",
  "good_count" : "$good",
  "bad_count" : "$bad",
  "result_1" : "$result_1",
  "code_result_1" : "$code_result_1",
  "code_result_message_1" : "$code_result_message_1",
  "result_2" : "$result_2",
  "code_result_2" : "$code_result_2",
  "code_result_message_2" : "$code_result_message_2",
  "result_3" : "$result_3",
  "code_result_3" : "$code_result_3",
  "code_result_message_3" : "$code_result_message_3",
  "result_4" : "$result_4",
  "code_result_4" : "$code_result_4",
  "code_result_message_4" : "$code_result_message_4",
  "result_5" : "$result_5",
  "code_result_5" : "$code_result_5",
  "code_result_message_5" : "$code_result_message_5",
  "result_6" : "$result_6",
  "code_result_6" : "$code_result_6",
  "code_result_message_6" : "$code_result_message_6",
  "result_7" : "$result_7",
  "code_result_7" : "$code_result_7",
  "code_result_message_7" : "$code_result_message_7"
}
EOF
}

# 클라우드 데이터베이스로 결과 전송
curl \
-H "Accept: application/json" \
-H "Content-Type:application/json" \
-X POST -s -f --data "$(generate_post_data)" "http://49.50.160.189/upload"


cat ./$FILE