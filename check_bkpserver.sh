 if [ "$(df -h|grep -i "/sapdb " >/dev/null; echo $?)" -eq "0" ]; then echo "Its a Maxdb system";file=`ls /var/spool/cron/tabs/ | grep -i sqd | grep -v '.bak'`;agentpath=`cat /var/spool/cron/tabs/$file | grep "backup_agent" | sed 's/[^/]*\(\/[^> ]*\).*/\1/g' | sed 's/\(.*\)\/.*/\1/g'`;echo "Agentpath: $agentpath"; cd $agentpath;echo -e "Config details\n----------------------------------";cat ./SapAgent.conf|egrep "BackupServer|ArchiveServer"; echo -e "Server details in env file\n--------"; cat ./env |grep  "NSR_HOST" ; elif [ "$(df -h|egrep -i "\/hana|\/hdb" >/dev/null; echo $?)" -eq "0" ]; then saps=/usr/sap/sapservices; if [[ -r $saps ]];then sidinfo=$( awk '/^LD_LIBRARY_PATH=.*HDB[0-9][0-9]/{ for(i=1;i<=NF;i++) { if ( $i ~ /pf=/) {n=split($i,a,"/");print a[n]}}}' $saps );echo "HANA system $sidinfo";   sid=$( echo $sidinfo | awk -F"_" '{print $1}') ; insnr=$( echo $sidinfo | awk -F"_" '{print $2}' | sed 's!HDB!!g' ); lsid=`echo ${sid}|tr '[:upper:]' '[:lower:]'`; if [[ -d /usr/sap/$sid/home ]];then echo -e " ----> Path /usr/sap/$sid/home/ exist\n" ; cd /usr/sap/$sid/home/sapscripts/monitor2 ; echo -e "configuration Details \n-------------------";cat SapAgent.conf|grep -i server; if [[ -d /usr/sap/$sid/SYS/global/hdb/opt ]];then echo -e " ----> Path /usr/sap/$sid/SYS/global/hdb/opt exist..\n"; cd /usr/sap/$sid/SYS/global/hdb/opt/; cat /usr/sap/$sid/SYS/global/hdb/opt/init${sid}.utl; else echo -e "Cannot determine global path";fi; else echo -e "Cannot determine home path";fi;fi; elif [ $(ls /var/spool/cron/tabs/ | egrep -i "syb|sqd"  | grep -v '.bak'>/dev/null;echo $?) == 0 ];then echo "SYBASE system"; file=`ls /var/spool/cron/tabs/ | egrep -i "syb|sqd"  | grep -v '.bak'`;agentpath=`cat /var/spool/cron/tabs/$file | grep "backup_agent" | sed 's/[^/]*\(\/[^> ]*\).*/\1/g' | sed 's/\(.*\)\/.*/\1/g'`;printf "Agentpath: $agentpath"; cd $agentpath;echo -e "\nConfiguration details in SapAgent\n-------------------";cat ./SapAgent.conf|grep -i server;echo -e "\nServer name in NMDA file\n-------------------"; cat ./nmda_sybase*.cfg |grep SERVER; elif [ "$(df -h|grep -i "/db2" >/dev/null; echo $?)" -eq "0" ]; then echo "Its a DB2 system";file=`ls /var/spool/cron/tabs/ | grep -i db2 | grep -v '.bak'`;agentpath=`cat /var/spool/cron/tabs/$file | grep "backup_agent" |head -1| sed 's/[^/]*\(\/[^> ]*\).*/\1/g' | sed 's/\(.*\)\/.*/\1/g'`;echo "Agentpath: $agentpath"; cd $agentpath;echo -e "Server details \n----------------";cat ./SapAgent.conf|egrep "BackupServer|ArchiveServer"; else echo "Please check the DB type and the configuration manually";fi;
