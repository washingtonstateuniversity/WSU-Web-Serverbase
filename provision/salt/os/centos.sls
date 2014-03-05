###########################################################
###########################################################
# Remi Repository 
###########################################################
remi-rep:
  pkgrepo.managed:
    - humanname: Remi Repository
    - baseurl: http://rpms.famillecollet.com/enterprise/6/remi/x86_64/
    - gpgcheck: 0

# Use packages from the CentOS plus repository when applicable.
centos-plus-repo:
  pkgrepo.managed:
    - humanname: CentOS-$releasever - Plus
    - baseurl: http://mirror.centos.org/centos/$releasever/centosplus/$basearch/
    - gpgcheck: 0
    - comments:
        - '#http://mirror.centos.org/centos/$releasever/centosplus/$basearch/'

# Ensure that postfix is at the latest revision.
postfix:
  pkg.latest:
    - name: postfix


###########################################################
###########################################################
# Mangage the kernel
###########################################################
kernel-headers:
  pkg.installed:
    - name: kernel-headers
