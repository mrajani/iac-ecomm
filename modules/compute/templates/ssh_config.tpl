# Replace with real asg address

%{ for index, ip in app_ip ~}
Host app-${format("%01d", index)}
  HostName ${ip}
%{ endfor ~}

%{ for index, ip in bastion_ip ~}
Host bastion-${format("%01d", index)}
  HostName ${ip}
%{ endfor ~}

Host app-*
  User ${ssh_user}
  IdentityFile ~/.ssh/${bastion_ssh_key}.pem
  ProxyCommand ssh -F ${ssh_config} bastion-0 -W %h:%p

Host bastion-*
  User ${ssh_user}
  IdentityFile ~/.ssh/${bastion_ssh_key}.pem
  ProxyCommand None

Host *
  StrictHostKeyChecking no
  ForwardAgent Yes
  ControlMaster auto
  ControlPath  ~/.ssh/ansible-%r@%h:%p
  ControlPersist 30m
