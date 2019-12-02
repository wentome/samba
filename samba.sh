#! /bin/bash
sharePath=$1

if [ ! -n "$sharePath" ]
	then
		echo "please in put share path as paremeter"
		exit 1
	else
		echo "share path : $sharePath "
fi

yum install samba -y
cp -pf /etc/samba/smb.conf /etc/samba/smb.conf.bak
cat /dev/null > /etc/samba/smb.conf

(
cat <<EOF
[global]
workgroup = WORKGROUP
server string = Samba Server %v
netbios name = centos
security = user
map to guest = bad user
dns proxy = no
#============================ Share Definitions ============================== 
[Anonymous]
path = $sharePath
browsable =yes
writable = yes
guest ok = yes
read only = no
EOF
) >/etc/samba/smb.conf


mkdir -p $sharePath
systemctl enable smb.service
systemctl restart smb.service
chmod -R 0755 $sharePath
chown -R nobody:nobody $sharePath
echo "check firewall if can not use server"
