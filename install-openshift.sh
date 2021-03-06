#!/bin/bash

## This script is intended to be run:
##     on the control host (ie: workstation)
##     CWD =  ~root/OCP-Workshop


case "$1" in
    "3.9")
        OCP_VERSION="3.9"
        ;;
         
    "3.11")
        OCP_VERSION="3.11"
        ;;

    *)
        OCP_VERSION="3.9"
        ;;

esac         


case "$OCP_VERSION" in
    "3.9")
         myInventory="./configs/ocp-3.9-workshop"
         myPlaybooks=" \
           ./playbooks/ocp-3.9-prep-workstation.yml \
           ./playbooks/ocp-3.9-prep-cluster.yml \
           /usr/share/ansible/openshift-ansible/playbooks/deploy_cluster.yml \
           ./playbooks/ocp-3.9-post-cluster.yml"
         ;;
         
    "3.11")
         myInventory="./configs/ocp-3.11-workshop"
         myPlaybooks=" \
           ./playbooks/ocp-3.11-prep-workstation.yml \
           ./playbooks/ocp-3.11-prep-cluster.yml \
           /usr/share/ansible/openshift-ansible/playbooks/prerequisites.yml \
           /usr/share/ansible/openshift-ansible/playbooks/deploy_cluster.yml \
           ./playbooks/ocp-3.11-post-cluster.yml"
         ;;
esac         

if [ ! -e "${myInventory}" ] ; then
    echo "ERROR: Are you in the right directory? Can not find ${myInventory}" ; exit
    exit
fi

## *** WARNING *** WARNING *** WARNING *** WARNING *** WARNING ***
##  We have to break up the workstation and cluster playbook runs because the 
##  workstation playbook (above) installs ansible libraries.  So ansible needs 
##  to exit to run properly the next time (below).  Don't consolidate!!!
## *** WARNING *** WARNING *** WARNING *** WARNING *** WARNING ***

for i in ${myPlaybooks} ; do
    time ansible-playbook -i ${myInventory} -f 20 ${i} 
   
    ## If previous cmd exited non-zero then exit
    if [ "$?" -ne "0" ] ; then
      echo "ERROR: previous command exited non-zero, check errors and try again"
      exit
    fi
done
   
