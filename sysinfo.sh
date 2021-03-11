#!/bin/bash
######################################################
######################################################
#						                                        ##
#						                                        ##
#						                                        ##
#                   Author: Shahab                  ##
#		           sh.mandipour@gmail.com		            ##
#						                                        ##
#						                                        ##
######################################################
######################################################





main_page () {
echo "----------------SYSTEM INFO---------------"
echo
echo -e "Enter 1-8 to see informatins\n"
echo "[1] OS INFO"
echo "[2] CPU INFO"
echo "[3] MEM INFO"
echo "[4] Other Devices"
echo "[5] DISK INFO"
echo "[6] Files and Softwares INFO"
echo "[7] SERVICES"
echo "[8] NETWORK"
echo "[0] EXIT"
echo
read -p "Please enter number: " op

if [ $op == 1 ]
        then
                os_info
        elif [ $op = 2 ]
        then
                cpu_info
        elif [ $op = 3 ]
        then
                mem_info
        elif [ $op = 4 ]
        then
                o_devices
        elif [ $op = 5 ]
        then
                disk_info
        elif [ $op = 6 ]
        then
                soft_info
        elif [ $op = 7 ]
        then
                service_info
        elif [ $op = 8 ]
        then
                network_info
	elif [ $op = 0 ]
        then
		exit_os

        else
                clear
                echo " please enter correct number "
                main_page
	fi
}


return_func () {

	read -p "for back to main menu press 9: " op7
                        echo
                        if [ $op7 = 9 ]
                        then
                                clear
                                main_page
                fi
}
exit_os () {
	read -p "Are you sure?(y/n)" op10

	if [ $op10 = y ]
	then 
		return
	else
		clear
		main_page
	fi	
		


}


os_info () {

	
	echo --------------------------------------------------------------------------------------
	echo ----------------------------------OS INFO---------------------------------------------
	echo --------------------------------------------------------------------------------------
	DISTRO=$(grep -w ID /etc/os-release | awk -F= '{print $2}')


	if [ -s /lib/systemd/systemd ]
       		then
               		 echo -e "\nOS = $DISTRO\nINIT TYPE = SYSTEMD\n"
	      		 echo -e "Computer Name :$(hostname -s)"
	      		 echo -e "System Uptime :$(uptime -p)"
	       		 echo -e "Kernel : $(uname -s)"
	      		 echo -e "Kernel Version : $(uname -v)"
       		else
              		 echo -e "\nOS=$DISTRO\ninit type=sysV"
	       		 echo -e "Computer Name :$(hostname -s)"
	      		 echo -e "System Uptime :$(uptime -p)"
	      		 echo -e "Kernel : $(uname -s)"
	      		 echo -e "Kernel Version : $(uname -v)"
	fi

	if  [ -e /etc/debian_version ] 
       		then
			echo " Istalling lshw "	
  		 	apt-get install lshw -y >/dev/null 
		 else  [ -e /etc/redhat-release ]
			echo " Installing lshw "	
			yum install lshw -y >/dev/null
	fi
			echo "current path is : $PATH"
			return_func
		
}


cpu_info () {
	echo ------------------------------------------------------------------------------------------
	echo -----------------------------------CPU INFO-----------------------------------------------
	echo ------------------------------------------------------------------------------------------
	echo
	CPU=$(top -b -n1 | grep "Cpu(s)" | awk '{print $2 + $4}')
	echo

	lscpu | grep -w --color "Model name" | grep -v ^[BIOS]
	lscpu | grep -w "Architecture"
	lscpu | grep -w "Virtualization"
	lscpu | grep -w "CPU(s):" | grep -v ^[NUMA] 
	echo -e "CPU Usage =\t $CPU %\n"
	echo
	read -p "for see more detail press (m) or press enter to continue : " char
	echo    
	if [[ $char =~ ^[Mm]$ ]]
		then
    			lscpu
	fi		
	   return_func
}	


mem_info () {
	echo ------------------------------------------------------------------------------------------
	echo -----------------------------------MEM INFO-----------------------------------------------
	echo ------------------------------------------------------------------------------------------
	echo
	MEM=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
	SWAP=$(free | grep Swap | awk '{print $3/$2 * 100.0}')
	echo
	grep -w "MemTotal" /proc/meminfo 
	grep -w "MemAvailable" /proc/meminfo 
	grep -w "SwapTotal" /proc/meminfo 
	grep -w "SwapFree" /proc/meminfo
	echo -e "MEMORY Usage =\t $MEM %"
	echo -e "SWAP Usage =\t $SWAP %\n"
	echo
	read -p "for see more detail press (m)or press enter to continue: " op2
	echo
	if [[ $op2 =~ ^[Mm]$ ]]
		then
    			cat /proc/meminfo
                        echo 
        fi
           return_func

             
}


o_devices () {
	echo ------------------------------------------------------------------------------------------
	echo ----------------------------------Other Devices-------------------------------------------
	echo ------------------------------------------------------------------------------------------
	echo
	lshw -short
	read -p "for see more detail press (m) or press enter to continue : " op3
	echo
	if [[ $op3 =~ ^[Mm]$ ]]
		then
   			 lshw 
	fi

	echo
	echo
	lsblk
	echo
	return_func
}

disk_info () {

echo ------------------------------------------------------------------------------------------
echo -------------------------------------DISK INFO--------------------------------------------
echo ------------------------------------------------------------------------------------------
echo

df -h
echo
echo ----------------------------
echo ------DISK USAGE------------
echo -e "/home   $(du -sh /home)"
echo -e "/tmp    $(du -sh /tmp)"
echo -e "/usr    $(du -sh /usr)"
echo -e "/var    $(du -sh /var)" 
echo -e "/bin    $(du -sh /bin)"
echo -e "/etc    $(du -sh /etc)"

echo -------fstab--------------
cat /etc/fstab | grep ^[^#i]
echo 
 
           return_func

}


soft_info () {

echo ------------------------------------------------------------------------------------------
echo -------------------------------Softwares and Files Info-----------------------------------
echo ------------------------------------------------------------------------------------------

	DISTRO=$(grep -w ID /etc/os-release | awk -F= '{print $2}')
echo
if  [ -e /etc/debian_version ]
                then
			echo $(dpkg --list | wc -l) Packages are Installed on your $DISTRO 
			read -p "for see Package details enter package name or q for quit : " REPLY
			while [ "$REPLY" != q ]
			do
			dpkg -L  $REPLY 
			break
			done
		
		elif [ -e /etc/redhat-release ]
              		 then
			echo $(rpm -qa | wc -l) Packages are installed on your $DISTRO
		        read -p "for see Package details enter package name or q for quit : " REPLY
			while [ "$REPLY" != q ]
                         do
			 yum repoquery -a --installed | grep $REPLY
			 break
                         done

fi


echo                                    
echo -e "-----------------Files with SUID-----------------"
echo "$(find / -perm -u+s 2>/dev/null | wc -l) Files exist with SUID "
echo
read -p "for see Files with detail press (m) or press enter to continue: " -n 1 -r
echo    
if [[ $REPLY =~ ^[Mm]$ ]]
then
	find / -perm -u+s 2>/dev/null | xargs ls -lad
	echo
		
		fi
		return_func

echo

}

service_info () {

echo ------------------------------------------------------------------------------------------
echo -------------------------------------SERVICES---------------------------------------------
echo ------------------------------------------------------------------------------------------

if [ -s /lib/systemd/systemd ]
       then
	       echo -e "\n-------init type = systemd--------"
	       echo -e "-------important services---------\n"
	       echo -e "sshd\t\t\t"$(systemctl status sshd | grep -w "active")
	       echo -e "firewalld\t\t"$(systemctl status firewalld | grep -w "active")
	       echo -e "NetwokManager\t\t"$(systemctl status NetworkManager | grep -w "active")
	       echo -e "apache2\t\t\t"$(systemctl status NetworkManager | grep -w "active")
	       echo -e "postfix\t\t\t"$(systemctl status NetworkManager | grep -w "active")


	      read -p " for other running services press service name  : " char1
	      while [ $char1 != c ]
	      do 
		      systemctl list-units --state running | grep $char1
		      break
	      done
		      return_func
      else
             echo -e "\ninit type = sysV"
	       service --status-all | grep runninig
      fi
echo
}

network_info () {

echo -------------------------------------------------------------------------------------------
echo ------------------------------------Netwotk Statis-----------------------------------------
echo -------------------------------------------------------------------------------------------
echo
nmcli device show | head -n 13 | grep -w "GENERAL.DEVICE"
nmcli device show | head -n 13 | grep -w "GENERAL.TYPE"
nmcli device show | head -n 13 | grep -w "IP4.ADDRESS"
nmcli device show | head -n 13 | grep -w "IP4.GATEWAY"
echo -e "PUBLIC-IP:\t\t\t\t$(dig +short myip.opendns.com @resolver1.opendns.com)"
echo -e "--------------Checking Internet Connection-----------\n"
echo -e "please wait . . .\n "
ping -c3 8.8.8.8 >/dev/null
if [ $? -eq 0 ] 
then 
echo -e " you are connected to the Internet "
else
	echo " you are not connected to the Internet "
fi
sleep 3
echo 
echo
echo -e "----------------Routing Table--------------\n"
ip route
echo
sleep 2
echo -e "\t\t\t----------THIS PORTS ARE OPEN---------\n"
netstat -tuna
echo
sleep 2

echo ---------------------DNS------------------------
echo
cat /etc/resolv.conf | grep -v ^[#]
echo
echo --------------------HOSTS-----------------------
echo
cat /etc/hosts | grep -v ^[#]
echo

return_func
}

main_page
