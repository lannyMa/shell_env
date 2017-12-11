#!/bin/bash
#####################
#
# ��һ��ִ������ʱ���������Ƿ�����ȫ����,�����ȴ���һ��ȫ�ⱸ��
# �����ٴ���������ʱ��������ݽű��е��趨������֮ǰ��ȫ�ⱸ�ݽ�����������
# yao
#
####################
APP_HOME="/data/backup/xtrabackup"
cd $APP_HOME || exit 255
source /etc/profile
set -e

ScriptVersion="1.0"
ScriptAuthor="yao"
ScriptModify="20170403"

#INNOBACKUPEX������
INNOBACKUPEX_PATH=innobackupex  
#INNOBACKUPEX������·��
INNOBACKUPEXFULL="/usr/bin/${INNOBACKUPEX_PATH}"
#MySQLĿ��������Լ��û���������
MYSQL_CMD="--host=127.0.0.1 --user=root --password=zabbixroot --port=3306"
#mysql���û���������
MYSQL_UP="--user=root --password=zabbixroot -pzabbixroot"
#��־·��
TMPLOG="/tmp/innobackupex.$$.log"
#mysql�������ļ�
MY_CNF="/etc/my.cnf"
MYSQL="/usr/bin/mysql"
MYSQL_ADMIN="/usr/bin/mysqladmin"
# ���ݵ���Ŀ¼
BACKUP_DIR=${APP_HOME}/backup
mkdir -p ${BACKUP_DIR}
# ȫ�ⱸ�ݵ�Ŀ¼
FULLBACKUP_DIR=${BACKUP_DIR}/full
mkdir -p ${FULLBACKUP_DIR}
# �������ݵ�Ŀ¼
INCRBACKUP_DIR=${BACKUP_DIR}/incre
mkdir -p ${INCRBACKUP_DIR}
# ȫ�ⱸ�ݵļ�����ڣ�ʱ�䣺�룬����һ��
FULLBACKUP_INTERVAL=172800
# ���ٱ�������ȫ�ⱸ��
KEEP_FULLBACKUP_COUNT=2
# ����ɾ��������+1
KEEP_FULLBACKUP=$(($(($((${FULLBACKUP_INTERVAL}/86400))*${KEEP_FULLBACKUP_COUNT}))+1))
logfiledir=${APP_HOME}/log
mkdir -p ${logfiledir}
logfiledate=${logfiledir}/mysql_backup_`date +%Y%m%d%H%M`.log
#��ʼʱ��
STARTED_TIME=`date +%s`

#�鵵Ŀ¼
ARCHIVE_DIR=${APP_HOME}/archive
mkdir -p ${ARCHIVE_DIR}

#�����ļ���׺��
BackupExt=MySQLDB.dump.tar.gz

#����ʹ������ڴ�
USEMEM="2G"
 
#############################################################################
# ��ʾ�����˳�
#############################################################################
error()
{
    echo "$1" 1>&2
    exit 1
}
 
# ���ִ�л���
if [ ! -x ${INNOBACKUPEXFULL} ]; then
    error "$INNOBACKUPEXFULLδ��װ��δ���ӵ�/usr/bin."
fi
 
if [ ! -d ${BACKUP_DIR} ]; then
    error "����Ŀ���ļ���:$BACKUP_DIR������."
fi
 
if [ -z "`${MYSQL_ADMIN} ${MYSQL_UP} status | grep 'Uptime'`" ] ; then
    error "MySQL û����������."
fi
 
 
if ! `echo 'exit' | ${MYSQL} -s ${MYSQL_CMD}` ; then
    error "�ṩ�����ݿ��û��������벻��ȷ!"
fi

genDebug(){
echo "#----------------------------"
echo "#"
echo "# $0: MySQL���ݽű�"
echo "# ${1}��: `date +%F' '%T' ����['%w]`"
echo "#"
echo "# ScriptVersion: ${ScriptVersion}"
echo "# ScriptAuthor:  ${ScriptAuthor}"
echo "# ScriptModify:  ${ScriptModify}"
echo "#"
echo "#----------------------------"
}
# ���ݵ�ͷ����Ϣ
genDebug "��ʼ" | tee -ai ${logfiledate}

 
 
#�������µ���ȫ����
LATEST_FULL_BACKUP=`find ${FULLBACKUP_DIR} -mindepth 1 -maxdepth 1 -type d -printf "%P\n" | sort -nr | head -1`
if [ -z ${LATEST_FULL_BACKUP} ];then
    :
else
    echo -e "# ���µ���ȫ����:\t\t[ ${LATEST_FULL_BACKUP} ]" | tee -ai ${logfiledate}
fi

# ��������޸ĵ����±���
LATEST_FULL_BACKUP_CREATED_TIME=`stat -c %Y ${FULLBACKUP_DIR}/${LATEST_FULL_BACKUP}`
if [ -z ${LATEST_FULL_BACKUP} ];then
    :
else
    echo -e "# ����޸ĵ����±���:\t\t[ ${LATEST_FULL_BACKUP} ]" | tee -ai ${logfiledate}
fi

#���ȫ����Ч�����������ݷ���ִ����ȫ����
if [ "${LATEST_FULL_BACKUP}" -a `expr ${LATEST_FULL_BACKUP_CREATED_TIME} + ${FULLBACKUP_INTERVAL} + 5` -ge ${STARTED_TIME} ] ; then
    ISFullBackup=F
    # ������µ�ȫ��δ�����������µ�ȫ���ļ�����������������Ŀ¼���½�Ŀ¼
    echo "# ��ȫ���� [ ${LATEST_FULL_BACKUP} ] δ����" | tee -ai ${logfiledate}
    echo "# ������ [ ${LATEST_FULL_BACKUP} ] ������Ϊ��������Ŀ¼����" | tee -ai ${logfiledate}
    NEW_INCRDIR=${INCRBACKUP_DIR}/${LATEST_FULL_BACKUP}
    mkdir -p ${NEW_INCRDIR}
 
    # ��ʹ������������
    if [ 1 -eq 2 ];then
        # �������µ����������Ƿ����.ָ��һ�����ݵ�·����Ϊ�������ݵĻ���
        LATEST_INCR_BACKUP=`find ${NEW_INCRDIR} -mindepth 1 -maxdepth 1 -type d | sort -nr | head -1`
        if [ ! ${LATEST_INCR_BACKUP} ];then
            INCRBASEDIR=${FULLBACKUP_DIR}/${LATEST_FULL_BACKUP}
        else
            INCRBASEDIR=${LATEST_INCR_BACKUP}
        fi
    fi
    
    # ÿ�ζ�ʹ���ϴ�ȫ�����ݱ���
    INCRBASEDIR=${FULLBACKUP_DIR}/${LATEST_FULL_BACKUP}
    
    echo "----------------------------"    | tee -ai ${logfiledate}
    echo "# ʹ�� [ ${INCRBASEDIR} ] "      | tee -ai ${logfiledate}
    echo "# ��Ϊ [ ���� ] ���ݵĻ���Ŀ¼"     | tee -ai ${logfiledate}
    echo "----------------------------"    | tee -ai ${logfiledate}
    echo ${INNOBACKUPEXFULL} --defaults-file=${MY_CNF} --use-memory=${USEMEM} ${MYSQL_CMD} --incremental ${NEW_INCRDIR} --incremental-basedir ${INCRBASEDIR} >> ${logfiledate}
    ${INNOBACKUPEXFULL} --defaults-file=${MY_CNF} --use-memory=${USEMEM} ${MYSQL_CMD} --incremental ${NEW_INCRDIR} --incremental-basedir ${INCRBASEDIR} >> ${logfiledate} 2>&1
else
    ISFullBackup=T
    echo "#----------------------------"         | tee -ai ${logfiledate}
    echo "# ����ִ�� [ ��ȫ ] ����, ���Ե�..."    | tee -ai ${logfiledate}
    echo "#----------------------------"         | tee -ai ${logfiledate}
    echo ${INNOBACKUPEXFULL} --defaults-file=${MY_CNF} --use-memory=${USEMEM} ${MYSQL_CMD} ${FULLBACKUP_DIR} >> ${logfiledate}
    ${INNOBACKUPEXFULL} --defaults-file=${MY_CNF} --use-memory=${USEMEM} ${MYSQL_CMD} ${FULLBACKUP_DIR} >> ${logfiledate} 2>&1
fi


if [ -z "`tail -1 ${logfiledate} | grep 'completed OK'`" ] ; then
    echo "# ${INNOBACKUPEX}����ִ��ʧ��:"                   | tee -ai ${logfiledate}
    echo "# tail -1 ${logfiledate} | grep 'completed OK'"   | tee -ai ${logfiledate}
    exit 1
else
    THISBACKUP=`awk -- "/Backup created in directory/ { split( \\\$0, p, \"'\" ) ; print p[2] }" ${logfiledate} | tail -1`
    echo "# ���ݿ�ɹ����ݵ�:" | tee -ai ${logfiledate}
    echo "# [ ${THISBACKUP} ]" | tee -ai ${logfiledate}
fi
 

 
# ��ʾӦ�ñ����ı����ļ����
# LATEST_FULL_BACKUP=`find $FULLBACKUP_DIR -mindepth 1 -maxdepth 1 -type d -printf "%P\n" | sort -nr | head -1`
echo "# ���뱣�� [ ${KEEP_FULLBACKUP} ] ���ȫ����ȫ�� [ ${LATEST_FULL_BACKUP} ] �Ժ��������������." | tee -ai ${logfiledate}
echo "# �������µ�ȫ����Ŀ¼��ȫ���ݵ�����Ŀ¼����������Ŀ¼��鵵��:" | tee -ai ${logfiledate}
echo "# [ ${ARCHIVE_DIR} ] " | tee -ai ${logfiledate}
# ȫ��
# FULLBACKUP_DIR=$BACKUP_DIR/full
# ����
# INCRBACKUP_DIR=$BACKUP_DIR/incre


# rmlistfull=$(ls ${FULLBACKUP_DIR} | awk -vb=${FULLBACKUP_DIR} -va=$(date -d "${KEEP_FULLBACKUP} days ago" +%Y-%m-%d) -F_ '{if($1<a){print b"/"$0}}')
# rmlistincre=$(ls ${INCRBACKUP_DIR} | awk -vb=${INCRBACKUP_DIR} -va=$(date -d "${KEEP_FULLBACKUP} days ago" +%Y-%m-%d) -F_ '{if($1<a){print b"/"$0}}')

# if [ "X${rmlistfull}" = "X" ];then
    # echo "# û��Ҫɾ����[ ȫ�� ]�����ļ���" | tee -ai ${logfiledate}
# else
    # echo "${rmlistfull}"    | tee -ai ${logfiledate}
# fi

# if [ "X${rmlistincre}" = "X" ];then
    # echo "# û��Ҫɾ����[ ���� ]�����ļ���" | tee -ai ${logfiledate}
# else
    # echo "${rmlistincre}"   | tee -ai ${logfiledate}
# fi
if [ "${ISFullBackup}" = "F" ];then
    Full_Ret1=$(ls ${FULLBACKUP_DIR} | grep -v ${LATEST_FULL_BACKUP} | awk -va=${FULLBACKUP_DIR} '{print a"/"$0}')
    INCR_Ret2=$(ls ${INCRBACKUP_DIR} | grep -v ${LATEST_FULL_BACKUP} | awk -va=${INCRBACKUP_DIR} '{print a"/"$0}')


    for item in ${Full_Ret1}
    do

        DirName=`dirname ${item}`
        BaseName=`basename ${item}`
        
        echo "# ��ʼ�鵵��ʷ [ ȫ�� ] �ļ��� [ ${BaseName} ]"
        echo /bin/tar zcf ${ARCHIVE_DIR}/Full_${BaseName}.${BackupExt} ${BaseName} --remove-files >> ${logfiledate}
        cd ${DirName} && /bin/tar zcf ${ARCHIVE_DIR}/Full_${BaseName}.${BackupExt} ${BaseName} --remove-files

        
    done

    for item in ${INCR_Ret2}
    do

        DirName=`dirname ${item}`
        BaseName=`basename ${item}`
        
        echo "# ��ʼ�鵵��ʷ [ ���� ] �ļ��� [ ${BaseName} ]"
        echo /bin/tar zcf ${ARCHIVE_DIR}/incre_${BaseName}.${BackupExt} ${BaseName} --remove-files >> ${logfiledate}
        cd ${DirName} && /bin/tar zcf ${ARCHIVE_DIR}/incre_${BaseName}.${BackupExt} ${BaseName} --remove-files 
    done
fi
#����ɾ��̫Σ��
#ɾ�����ڵ�ȫ��
# echo -e "Ѱ�ҹ��ڵ�ȫ���ļ���ɾ��" | tee -ai ${logfiledate}
# for efile in $(/usr/bin/find ${FULLBACKUP_DIR}/ -mtime +6)
# do
    # if [ -d ${efile} ]; then
        # rm -rf ${efile}
        # echo -e "ɾ������ȫ��Ŀ¼:${efile}" | tee -ai ${logfiledate}
    # elif [ -f ${efile} ]; then
        # rm -rf ${efile}
        # echo -e "ɾ������ȫ���ļ�:${efile}" | tee -ai ${logfiledate}
    # fi;
 
# done
# if [ $? -eq "0" ];then
   # echo
   # echo -e "δ�ҵ�����ɾ���Ĺ���ȫ���ļ�" | tee -ai ${logfiledate}
# fi
 
genDebug "����" | tee -ai ${logfiledate}

exit 0