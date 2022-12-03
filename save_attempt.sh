path=$PWD;
outfile=outfile_`date +%F_%X`
check_time=`date -d'25min ago' '+%x %X'`;
if [ -f $path/migrated_cli_list ];then
        echo -e "Found the client list at $path/migrated_cli_list"
if [ -f $path/firstcheck ];then
        for cli in `cat migrated_cli_list`;do nsr_render_log -lachmy /nsr/logs/daemon.raw -S "$check_time"|grep -v index|grep -i $cli >/dev/null 2>/dev/null; b=$?; if [ $b = 0 ];then echo "Check the configuration in $cli">>$path/$outfile;fi;done
        echo -e "Selected Check time is  $check_time" >>$path/$outfile
else
        {
                c_date=`date "+%x %X"`;
                sleep 25m
                for cli in `cat migrated_cli_list`;do nsr_render_log -lachmy /nsr/logs/daemon.raw -S "$c_date"|grep -v index|grep -i $cli >/dev/null 2>/dev/null; b=$?; if [ $b = 0 ];then echo "Check the configuration in $cli" >>$path/firstcheck;fi;done
                echo -e "first check is done at $c_date" >>$path/firstcheck
        }
fi
else
echo -e "Please park the client list under $path/migrated_cli_list"
fi
