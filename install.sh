#!/bin/bash
EJABBERD_SRC=/lib/ejabberd/include
MODULE=./mod_stanza_ack/mod_stanza_ack

cp /var/log/ejabberd/ejabberd.log /var/log/ejabberd/ejabberd_$(date +%Y%m%d%H%M%S).log
rm /var/log/ejabberd/ejabberd.log
touch /var/log/ejabberd/ejabberd.log

erlc -I ${EJABBERD_SRC} ${MODULE}.erl
mv ${MODULE}.beam /lib/ejabberd/ebin
