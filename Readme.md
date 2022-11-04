# CentOS Vulnerability Scan Script

### 설명
시스템 점검 결과는 온라인 데이터베이스에 저장됩니다.<br>
Web을 통해 저장된 결과를 손쉽게 확인할 수 있습니다.<br><br>
Web server는 현재 클라우드를 통해 구동중에 있으며, 주소는 아래와 같습니다.<br>
[VSRD](http://49.50.160.189/)<br>
(웹 페이지는 PC 환경에 최적화되어있습니다. 모바일로 접속시 깨질 수 있습니다.)<br><br>

|사용법|
```
wget https://github.com/with-developer/CentOS_Vulnerability_scan_script/archive/refs/heads/main.zip
unzip main.zip
cd CentOS_Vulnerability_scan_script-main/
chmod 777 script.sh
./script
```

### wget이 설치되어 있지 않을 때
yum install wget
<br><br>
### unzip이 설치되어 있지 않을 때
yum list unzip
<br><br><br>

### 사용된 기술
1. Shell Script 프로그래밍
2. Curl Json 데이터 전송
3. Json 데이터 정규화
4. MySQL
5. Python
6. Flask Web Framework
7. Jinja2 Template Language
8. Cloud Web Server Databases


### 진단 항목
1. 디폴트 계정 삭제
2. root 권한 관리
3. passwd 파일 권한 설정
4. group 파일 권한 설정
5. 패스워드 사용규칙 적용
6. Shell 제한
7. su 제한

### 호환되는 운영체제
Centos-release-7-7.1908.0.el7.centos.x86_64<br><br>

## 결과 사진

### 스크립트 실행 결과
![initial](https://github.com/with-developer/CentOS_Vulnerability_scan_script/blob/main/Readme_images/Script_Result.png)

<br><br>
### Web 취약점 진단 결과 리스트
![initial](https://github.com/with-developer/CentOS_Vulnerability_scan_script/blob/main/Readme_images/Main_Page.png)
<br><br>
### Web 취약점 진단 결과 상세보기
![initial](https://github.com/with-developer/CentOS_Vulnerability_scan_script/blob/main/Readme_images/Detail_Page.png)
