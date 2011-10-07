import subprocess
import math
import time

lst_ds_code=[1]#[1,2,3,4,5,6,7]
str0 = 'qsub cluster.script '
delaysecs=5;



            

#BPCA
lst_pca_Q=[8,16,32]
i=0;
for pca_Q in lst_pca_Q:
    for ds_code in lst_ds_code:
        
        str1 = str0 + str(pca_Q) + '    ' #PCA
        str1 = str1 + '-1 -1 -1 -1 -1'  + '    '  #RVQ
        str1 = str1 + '-1 -1    ' #TSVQ
        str1 = str1 + '0 1 0 0    ' #bUseIPCA, bUseBPCA, bUseRVQ, bUseTSVQ
        str1 = str1 + str(ds_code) #dataset code
        i=i+1;
        print ('%03d' % i) + '    ' + str1
        subprocess.call(str1, shell=True)
        time.sleep(delaysecs)

###IPCA
##i=0;
##for pca_Q in lst_pca_Q:
##    for ds_code in lst_ds_code:
##        
##        str1 = str0 + str(pca_Q) + '    ' #PCA
##        str1 = str1 + '-1 -1 -1 -1 -1'  + '    '  #RVQ
##        str1 = str1 + '-1 -1    ' #TSVQ
##        str1 = str1 + '1 0 0 0    ' #bUseIPCA, bUseBPCA, bUseRVQ, bUseTSVQ
##        str1 = str1 + str(ds_code) #dataset code
##        i=i+1;
##        print ('%03d' % i) + '    ' + str1
##        subprocess.call(str1, shell=True)
##        time.sleep(delaysecs)
