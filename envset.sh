#!/bin/bash
##############################################
# to copy environment to configuration files

echo "data-dir=$QPID_DATA_DIR
log-enable=$QPID_LOG_ENABLE
log-time=yes
log-thread=yes
log-to-file=/var/log/qpid/qpid.log
pid-dir=/tmp/qpidpid
worker-threads=$QPID_WORKER_THREADS
default-queue-limit=1024000000
auth=no
num-jfiles=$QPID_NUM_JFILES
jfile-size-pgs=$QPID_JFILE_SIZE
ha-cluster=$QPID_HA_CLUSTER
ha-brokers-url=$QPID_HA_BROKERS_URL
"
