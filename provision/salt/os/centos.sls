###########################################################
###########################################################
# Remi Repository 
###########################################################
remi-rep:
  pkgrepo.managed:
    - humanname: Remi Repository
    - baseurl: http://rpms.famillecollet.com/enterprise/6/remi/x86_64/
    - gpgcheck: 0


###########################################################
###########################################################
# Mangage the kernel
###########################################################
kernel-headers:
  pkg.installed:
    - name: kernel-headers
