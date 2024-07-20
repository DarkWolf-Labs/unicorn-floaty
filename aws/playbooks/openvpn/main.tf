module "openvpn_server" {
  source            = "../../modules/ec2/instance"
  project_name      = var.project_name
  environment       = var.environment
  instance_name     = "openvpn-server"
  ami_id            = var.ami_id
  instance_type     = var.instance_type
  key_name          = var.key_name
  subnet_id         = var.subnet_id
  security_group_id = var.security_group_id
  os_user           = "admin"
  user_data         = <<-EOF
                      #!/bin/bash
                      exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
                      echo "Starting user data script execution at $(date)"

                      set -e

                      # Update and upgrade the system
                      sudo apt-get update -y
                      sudo apt-get upgrade -y

                      # Install OpenVPN and Easy-RSA
                      sudo apt-get install -y openvpn easy-rsa

                      # Set up the EasyRSA directory
                      sudo make-cadir /etc/openvpn/easy-rsa
                      cd /etc/openvpn/easy-rsa

                      # Initialize the PKI
                      sudo ./easyrsa init-pki

                      # Create the CA (Certificate Authority)
                      sudo echo "yes" | sudo ./easyrsa build-ca nopass

                      # Generate server certificate and key
                      sudo echo "yes" | sudo ./easyrsa gen-req server nopass
                      sudo echo "yes" | sudo ./easyrsa sign-req server server

                      # Generate Diffie-Hellman parameters
                      sudo ./easyrsa gen-dh

                      # Generate TLS-Auth key
                      sudo openvpn --genkey --secret /etc/openvpn/ta.key

                      # Copy the necessary files to the OpenVPN directory
                      sudo cp pki/ca.crt pki/issued/server.crt pki/private/server.key pki/dh.pem /etc/openvpn/

                      # Create the server configuration file
                      sudo tee /etc/openvpn/server.conf > /dev/null <<EOT
                      port 1194
                      proto udp
                      dev tun
                      ca ca.crt
                      cert server.crt
                      key server.key
                      dh dh.pem
                      server 10.8.0.0 255.255.255.0
                      ifconfig-pool-persist ipp.txt
                      push "redirect-gateway def1 bypass-dhcp"
                      push "dhcp-option DNS 8.8.8.8"
                      push "dhcp-option DNS 8.8.4.4"
                      keepalive 10 120
                      tls-auth ta.key 0
                      cipher AES-256-CBC
                      auth SHA256
                      user nobody
                      group nogroup
                      persist-key
                      persist-tun
                      status openvpn-status.log
                      verb 3
                      EOT

                      # Enable IP forwarding
                      echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward
                      echo "net.ipv4.ip_forward = 1" | sudo tee -a /etc/sysctl.conf

                      # Configure iptables
                      sudo iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE
                      echo "iptables-persistent iptables-persistent/autosave_v4 boolean true" | sudo debconf-set-selections
                      echo "iptables-persistent iptables-persistent/autosave_v6 boolean true" | sudo debconf-set-selections
                      sudo apt-get install -y iptables-persistent

                      # Enable and start OpenVPN service
                      sudo systemctl enable openvpn@server
                      sudo systemctl start openvpn@server

                      echo "OpenVPN server installation and configuration completed."

                      EOF
}