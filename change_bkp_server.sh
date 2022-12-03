
#MaxDB System
if [ "$(df -h|grep -i "/sapdb " >/dev/null; echo $?)" -eq "0" ]; then 
    echo "Maxdb system"
    file=`ls /var/spool/cron/tabs/ | grep -i sqd | grep -v '.bak'`
    agentpath=`cat /var/spool/cron/tabs/$file | grep "backup_agent" | sed 's/[^/]*\(\/[^> ]*\).*/\1/g' | sed 's/\(.*\)\/.*/\1/g'`
    echo "Agentpath: $agentpath"
    cd $agentpath
    echo -e "Before Change\n----------------"
    cat ./SapAgent.conf|egrep "BackupServer|ArchiveServer"
    echo -e "After change\n----------------------------------"
    sed -i '/BackupServer/d' ./SapAgent.conf 
    sed -i '10 a\BackupServer="azenwsoutheastasiaecsneez3db011.sin.hec.sap.biz"' ./SapAgent.conf
    sed -i '/ArchiveServer/d' ./SapAgent.conf 
    sed -i '10 a\ArchiveServer="azenwsoutheastasiaecsneez3db011.sin.hec.sap.biz"' ./SapAgent.conf
    cat ./SapAgent.conf|egrep "BackupServer|ArchiveServer"
    sed -i '/NSR_HOST/d' ./env
    sed -i '4 a\NSR_HOST  "azenwsoutheastasiaecsneez3db011.sin.hec.sap.biz"' ./env
    echo -e "Changed server in env file\n--------"
    cat ./env |grep  "NSR_HOST" 
 #HANA system
 elif [ "$(df -h|egrep -i "\/hana|\/hdb" >/dev/null; echo $?)" -eq "0" ]; then 
    saps=/usr/sap/sapservices
        if [[ -r $saps ]]; then 
            sidinfo=$( awk '/^LD_LIBRARY_PATH=.*HDB[0-9][0-9]/{ for(i=1;i<=NF;i++) { if ( $i ~ /pf=/) {n=split($i,a,"/");print a[n]}}}' $saps )
            echo "HANA system | $sidinfo"
            sid=$( echo $sidinfo | awk -F"_" '{print $1}')
            insnr=$( echo $sidinfo | awk -F"_" '{print $2}' | sed 's!HDB!!g' )
            lsid=`echo ${sid}|tr '[:upper:]' '[:lower:]'`
                if [[ -d /usr/sap/$sid/home ]]; then 
                  echo -e " ----> Path /usr/sap/$sid/home/ exist\n" 
                  cd /usr/sap/$sid/home/sapscripts/monitor2 
                  echo -e "Before configuration change\n-------------------"
                  cat SapAgent.conf|grep -i server
                  sed -i '/ArchiveServer=/d' SapAgent.conf 
                  sed -i '2 a\ArchiveServer="azenwsoutheastasiaecsneez3db011.sin.hec.sap.biz"' SapAgent.conf
                  sed -i '/BackupServer=/d' SapAgent.conf
                  sed -i '2 a\BackupServer="azenwsoutheastasiaecsneez3db011.sin.hec.sap.biz"' SapAgent.conf
                  echo -e "After configuration change\n-------------------"
                  cat /usr/sap/$sid/home/sapscripts/monitor2/SapAgent.conf|grep -i server
                     if [[ -d /usr/sap/$sid/SYS/global/hdb/opt ]]; then 
                        echo -e " ----> Path /usr/sap/$sid/SYS/global/hdb/opt exist..\n"
                        cd /usr/sap/$sid/SYS/global/hdb/opt/
                        sed -i '/server/d' init${sid}.utl
                        sed -i '1 a\server='azenwsoutheastasiaecsneez3db011.sin.hec.sap.biz'' init${sid}.utl
                        cat /usr/sap/$sid/SYS/global/hdb/opt/init${sid}.utl
                      else echo -e "Cannot determine global path, Edit the init file manually"
                      fi
                else echo -e "Cannot determine home path, do configuration change manually"
                fi
          fi          
  #Sybase system
  elif [ $(ls /var/spool/cron/tabs/ | egrep -i "syb|sqd"  | grep -v '.bak'>/dev/null;echo $?) == 0 ]; then
      echo "SYBASE system"
      file=`ls /var/spool/cron/tabs/ | egrep -i "syb|sqd"  | grep -v '.bak'`
      agentpath=`cat /var/spool/cron/tabs/$file | grep "backup_agent" | sed 's/[^/]*\(\/[^> ]*\).*/\1/g' | sed 's/\(.*\)\/.*/\1/g'`
      printf "Agentpath: $agentpath"
      cd $agentpath
      echo -e "\nChanging Backup server in SapAgent\n-------------------"
      sed -i '/ArchiveServer=/d' SapAgent.conf 
      sed -i '2 a\ArchiveServer="azenwsoutheastasiaecsneez3db011.sin.hec.sap.biz"' SapAgent.conf
      sed -i '/BackupServer=/d' SapAgent.conf 
      sed -i '2 a\BackupServer="azenwsoutheastasiaecsneez3db011.sin.hec.sap.biz"' SapAgent.conf
      cat ./SapAgent.conf|grep -i server
      echo -e "\nChanging Backup server in NMDA file\n-------------------"
      sed -i '/NSR_SERVER/d' ./nmda_sybase*.cfg
      sed -i '1 a\NSR_SERVER=azenwsoutheastasiaecsneez3db011.sin.hec.sap.biz' ./nmda_sybase*.cfg
      cat ./nmda_sybase*.cfg |grep SERVER
   #DB2 system
   elif [ "$(df -h|grep -i "/db2" >/dev/null; echo $?)" -eq "0" ]; then 
      echo "DB2 system"
      file=`ls /var/spool/cron/tabs/ | grep -i db2 | grep -v '.bak'`
      agentpath=`cat /var/spool/cron/tabs/$file | grep "backup_agent"|head -1 | sed 's/[^/]*\(\/[^> ]*\).*/\1/g' | sed 's/\(.*\)\/.*/\1/g'`
      echo "Agentpath: $agentpath"
      cd $agentpath
      echo -e "Before Change\n----------------"
      cat ./SapAgent.conf|egrep "BackupServer|ArchiveServer"
      echo -e "After change\n----------------------------------"
      sed -i '/BackupServer/d' ./SapAgent.conf 
      sed -i '10 a\BackupServer="azenwsoutheastasiaecsneez3db011.sin.hec.sap.biz"' ./SapAgent.conf
      sed -i '/ArchiveServer/d' ./SapAgent.conf 
      sed -i '10 a\ArchiveServer="azenwsoutheastasiaecsneez3db011.sin.hec.sap.biz"' ./SapAgent.conf
      cat ./SapAgent.conf|egrep "BackupServer|ArchiveServer"
   else echo "DB type must be MSSQL or Oracle.. Please change the configuration manually"
   fi
