#!/bin/bash
source helpers.sh

#############################################################################################################


# Configure Hostname
config_host() {
echo -n " ¿Do you Wish to Set a HostName? (y/n): "; read config_host
if [ "$config_host" == "y" ]; then
    serverip=$(__get_ip)
    echo " Type a Name to Identify this server :"
    echo -n " (For Example: myserver): "; read host_name
    echo -n " ¿Type Domain Name?: "; read domain_name
    echo $host_name > /etc/hostname
    hostname -F /etc/hostname
    echo "127.0.0.1    localhost.localdomain      localhost" >> /etc/hosts
    echo "$serverip    $host_name.$domain_name    $host_name" >> /etc/hosts
 #   #Creating Legal Banner for unauthorized Access
 #   echo ""
 #  echo "Creating legal Banners for unauthorized access"
 #   spinner
 #   cat templates/motd > /etc/motd
 #   cat templates/motd > /etc/issue
 #   cat templates/motd > /etc/issue.net
 #   sed -i s/server.com/$host_name.$domain_name/g /etc/motd /etc/issue /etc/issue.net
    echo "OK "
fi
    say_done
}

##############################################################################################################

##############################################################################################################

# Configure TimeZone
config_timezone(){
   clear
   echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
   echo -e "\e[93m[+]\e[00m We will now Configure the TimeZone"
   echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
   echo ""
   sleep 10
   dpkg-reconfigure tzdata
   say_done
}

##############################################################################################################

# Update System
update_system(){
	clear
   echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
   echo -e "\e[93m[+]\e[00m We will now Update the System"
   echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
   echo ""
   sleep 10
   apt update
   apt upgrade -y
   apt install sudo -y
   apt dist-upgrade -y
   say_done
}

##############################################################################################################

# Create Privileged User
admin_user(){
    clear
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo -e "\e[93m[+]\e[00m We will now Create a New User"
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo ""
    echo -n " Type the new username: "; read username
    adduser $username
    say_continue
    adduser $username sudo
    say_done
}

##############################################################################################################

# Check for Privileged User SSH keys before hardening SSH
admin_user_ssh_keycheck(){
	clear
	if ls /home/"$username"/.ssh/authorized_keys &> /dev/null;	then
		echo -e "$username has SSH public keys installed."
		say_done
	else
		echo -e "$username does not have SSH public keys installed."
		echo -e "Please run the following command: \e[33m ssh-copy-id $username@$HOSTNAME\e[00m"
		say_continue
	fi
}

# Recheck for Privileged User SSH keys before hardening SSH
admin_user_ssh_keycheck_2(){
	clear
	if ls /home/"$username"/.ssh/authorized_keys &> /dev/null;	then
		say_done
	else
		echo -e "$username still does not have SSH public keys installed."
		echo -e "Please run the following command: \e[33m ssh-copy-id $username@$HOSTNAME\e[00m"
		echo -e "Exiting now."
		exit
	fi
}
#############################################################################################################

# Secure SSH
secure_ssh(){
    clear
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo -e "\e[93m[+]\e[00m Securing SSH"
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo ""
    echo -n " Securing SSH..."
    spinner
    cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
    cp templates/sshd_config /etc/ssh/sshd_config
    service ssh restart
    say_done
  }
config_host
config_timezone
update_system
admin_user
admin_user_ssh_keycheck
admin_user_ssh_keycheck_2
secure_ssh