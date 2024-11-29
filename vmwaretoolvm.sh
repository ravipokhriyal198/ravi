#!/bin/bash
# VMware to OLVM migration script with explicit source and destination VM names

# Set parameters (these should remain unchanged)
VMWUSER="VSPHERE.LOCAL%5cadministrator"
VMWVCENTER="vcrtm67.ivanet.net"
VMWDC="RTM"
VMWCL="RTM Production Cluster"
VMWESX="csgrtm36.ivanet.net"
ENGINE="olvmengine01.ivanet.net"
OLVMDS="FC_DS_01"
ENGINECACERT="/etc/pki/tls/certs/ca-olvmengine01.ivanet.net.pem"
VCENTERTHUMBPRINT="9E:81:04:5F:85:BB:0C:C7:04:DB:A3:9A:5D:F6:E6:DB:53:87:21:80"
ESXTHUMBPRINT="CB:8C:F1:32:09:EE:32:9C:13:A3:6E:89:39:D7:F6:22:0E:3E:A1:20"

# Enable direct access for libguestfs (improves performance)
export LIBGUESTFS_BACKEND="direct"

# Migration command with directly specified source and destination VM names
virt-v2v -v -x -ic vpx://${VMWUSER}@${VMWVCENTER}/${VMWDC}/${VMWCL}/${VMWESX}?no_verify=1 \
-ip $HOME/vmw-user-pass \
olvmmigrtm02_Clone \  # Source VMware VM
-it vddk \
-io vddk-libdir=/usr/local/vmware-vix-disklib-distrib \
-io vddk-thumbprint=${VCENTERTHUMBPRINT} \
-o rhv-upload \
-oc https://${ENGINE}/ovirt-engine/api \
-op $HOME/olvm-admin-pass \
-os ${OLVMDS} \
-of qcow2 \
-oo rhv-cafile=${ENGINECACERT} \
-oo rhv-direct \
-oo rhv-cluster=Default \
-o vmname=olvmmigrtm02_Clone \
--verbose \
--network ovirtmgmt \
2>&1 | tee -a /var/log/virt-v2v-olvmmigrtm02_Clone.log
