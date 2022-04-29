#!/bin/bash
RelutionHostIP=$(host relution.test | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b")

RelutionHostLine="ldap.relution:+userPassword:$RelutionHostIP"

cat > /etc/iserv/ldapusers << EOF
# List of LDAP users which should have read access to LDAP
#
# This file is generated automatically by iservchk.
# It is not recommended to make any changes to this file.
# If really necessary you can save changes permanently using:
#   iconf save /etc/iserv/ldapusers
#
# format:
# {username}:+{fieldName}:{client-ip-address}
# {username}::{client-ip-address}
# {username}:+{fieldName}
# {username}
#
# {username}: username without parent dn
# parent dn is ou=ldap,{basedn}
# {basedn} can be found in /var/lib/iserv/server-openldap/ldapdn
# so full dn will be cn={user},ou=ldap,{basedn}
# the created password can be found in the file /var/lib/iserv/server-openldap/pwd/{username}.pwd
# +{fieldName}: additional fields the user needs read acces to (i.e. userPassword)
# fieldNames without leading + are not yet supported!
# multiple fieldNames can be given as a comma seperated list.
# {client-ip-address}: ip address or ip-address/net of client(s) that should be allowed through the firewall
# multiple ip Addresses can be given as a comma seperated list.
# both fieldName and ip-address can be omitted
# local port is 10636 (636 is used by samba-ad), protocol is ldaps
#



#
# Please add additional user definitions after this comment and remember to save
# the file with iconf save.
#
$RelutionHostLine
EOF

iconf save /etc/iserv/ldapusers
iservchk ldap ferm
iservchk

if grep -q RelutionHostIP /var/log/slapd.log; then
    echo Sync klappt
else
    echo "Sync kaputt!" | mail -s"LDAP Sync" root@$HOSTNAME
fi
