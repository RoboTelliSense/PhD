import subprocess
import math

Q=8
lst_M=[2,4,8,12,16]
tSNR=1000
lmbd=0.03
lst_tstI=[1,2,3,4]
lst_ds_code=[1]


i=0;

for M in lst_M:
    for tstI in lst_tstI:
        for ds_code in lst_ds_code:
            str1 = 'qsub cluster.script '
            str1 = str1 + '-1    ' #PCA
            str1 = str1 + str(Q) + ' ' + str(M) + ' ' + str(tSNR) + ' ' + str(lmbd) + ' ' + str(tstI) + '    '  #RVQ
            str1 = str1 + '-1 -1    ' #TSVQ
            str1 = str1 + '0 0 1 0    ' #bUseIPCA, bUseBPCA, bUseRVQ, bUseTSVQ
            str1 = str1 + str(ds_code) #dataset code
            i=i+1;
            print ('%03d' % i) + '    ' + str1
            subprocess.call(str1, shell=True)

            


