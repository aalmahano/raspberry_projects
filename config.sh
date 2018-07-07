#!/bin/bash

#   Pasos automatizados de configuracion del sistema:
#	establece ip estatica / reinicia red
#	actualiza apt-get, instala aplicaciones winbind y samba 
#	cambia hostname y actualiza el fichero hosts
#	cambia el puerto ssh
#   Si es una  maquina virtual hay que poner la red en Ethernet en lugar de compartida

echo "Iniciando la configuracion automatica de raspbian"

dhcpcd_file=/etc/dhcpcd.conf
ip=192.168.115.111
router=192.168.115.1
server=192.168.115.1

# modifica dhcpcd para tener ip estatica
sudo sed -i '41 s/^#//' ${dhcpcd_file}
sudo sed -i '42 s/.*/static ip_address='${ip}'\/24/' ${dhcpcd_file}
sudo sed -i '44 s/.*/static routers='${router}'/' ${dhcpcd_file}
sudo sed -i '45 s/.*/static domain_name_servers='${server}'/' ${dhcpcd_file}

#echo "- ahora la ip es estatica: "${ip}
# reinicia el servicio de red
sudo systemctl restart networking
sudo ifdown -a
sudo ifup -a
echo "- red reiniciada"

# instala las aplicaciones necesarias para poder acceder desde windows al host
#sudo apt-get update -y
#sudo apt-get install winbind samba -y
#echo "- se ha instalado winbind y samba"

# modifica nsswitch para completar el acceso desde windows
nsswitch=/etc/nsswitch.conf
# comenta la linea del hosts
#sudo sed -i '12 s/^/#/' ${nsswitch}
# inserta una nueva linea
#sudo sed -i '13i hosts: files wins dns' ${nsswitch}
echo "- actualizado " ${nsswitch}

# modifica el fichero hosts
host_path=/etc/hosts
nuevo_hostname="raspberry-angel"
#sudo sed -i '6 s/^/#/' ${host_path}
#sudo sed -i "6i 127.0.0.1\t $nuevo_hostname" ${host_path}
echo "- actualizado " ${host_path}

# modifica el hostname sin reiniciar
#sudo hostnamectl set-hostname ${nuevo_hostname}
echo '- ahora ya se puede acceder desde windows con el hostname: '${nuevo_hostname}

# modifica el puerto ssh
#ssh_path=/etc/ssh/sshd_config
ssh_port=2222
#sudo sed -i "13i Port $ssh_port" ${ssh_path}
echo "- puerto ssh modificado a " ${ssh_port}
