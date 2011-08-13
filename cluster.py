import subprocess
import math

Np = 600
lstdatasetCode=[1,2,3,4,5,6,7]
config=[];

#standard configurations (for phase 1)
#-----------------------
#config.append('16      8  2  1000     3 2');
#config.append('32      8  4  1000     4 2');
#config.append('64      8  8  1000     5 2');
#config.append('128     8  16 1000     6 2');


#additional RVQ configuration
config.append('2      16  16  1000     1 2');
lstNw = [2]

#lstNw = [2,4,8,16,32,64,128,10000]
lstw = [0]




i=0;

for w in lstw:
    for Nw in lstNw:
        for j in config:
            for datasetCode in lstdatasetCode:
                strD = str(datasetCode)
                str1 = 'qsub cluster.script    600 ' + ('%05d' % Nw) + ' ' + str(w) +   '     ' + j + '      0 0 1 '  + '      ' + strD
                i=i+1;
                print ('%03d' % i) + '    ' + str1
                subprocess.call(str1, shell=True)




















'''
bWeighting=0
i=1


#PCA
lstpca_maxBasis = [2, 4, 8, 16]

#RVQ
lstrvq_maxT = [8]
#lstrvq_S = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]
lstrvq_S = [2,4,8]
lstrvq_targetSNR=[1000]

#TSVQ
lsttsvq_T=[1, 2, 3, 4]            
tsvq_M=2
lstdatasetCode=[1,2,3,4,5,6,7]

bUsemyPCA = 0
bUseRVQ = 1
bUseTSVQ = 0
'''


'''
#PCA
#---
for datasetCode in lstdatasetCode:
    txt1 = str(datasetCode)
    for Nw in lstNw:
        for pca_maxBasis in lstpca_maxBasis:
            cmd= 'qsub cluster.script ' +\
                 str(Np) + ' ' +\
                 str(Nw)+ '   ' +\
                 str(pca_maxBasis)+  '   ' +\
                 str(-1) + ' ' +\
                 str(-1) +  ' ' +\
                 str(-1) +  '   ' +\
                 str(-1)+  '   ' + \
                 str(-1)+  '   ' + \
                 str(1)+  ' ' + \
                 str(0)+  ' ' + \
                 str(0)+  '   ' + \
                 txt1
            print str(i) + ' ' + cmd    
            subprocess.call(cmd, shell=True)
            i=i+1

'''

'''
#RVQ
#---
for datasetCode in lstdatasetCode:
    txt1 = str(datasetCode)
    for Nw in lstNw:
        for rvq_targetSNR in lstrvq_targetSNR:
            for rvq_S in lstrvq_S:
                for rvq_maxT in lstrvq_maxT:
                    cmd= 'qsub cluster.script ' +\
                             str(Np) + ' ' +\
                             str(Nw)+ '   ' +\
                             str(bWeighting)+ '   ' +\
                             str(16)+  '   ' +\
                             str(rvq_maxT) + ' ' +\
                             str(rvq_S) +  ' ' +\
                             str(rvq_targetSNR) +  '   ' +\
                             str(-1)+  '   ' + \
                             str(-1)+  '   ' + \
                             str(0)+  ' ' + \
                             str(1)+  ' ' + \
                             str(0)+  '   ' + \
                             txt1
                    print str(i) + ' ' + cmd    
                    subprocess.call(cmd, shell=True)
                    i=i+1
'''



'''
#TSVQ
#----
for datasetCode in lstdatasetCode:
    txt1 = str(datasetCode)
    for Nw in lstNw:
        for tsvq_T in lsttsvq_T:            
            cmd= 'qsub cluster.script ' +\
                     str(Np) + ' ' +\
                     str(Nw)+ '   ' +\
                     str(16)+  '   ' +\
                     str(-1) + ' ' +\
                     str(-1) +  '   ' +\
                     str(-1) +  '   ' +\
                     str(tsvq_T)+  '   ' + \
                     str(tsvq_M)+  '   ' + \
                     str(0)+  ' ' + \
                     str(0)+  ' ' + \
                     str(1)+  '   ' + \
                     txt1
            print str(i) + ' ' + cmd    
            subprocess.call(cmd, shell=True)
            i=i+1

'''

            
#            tsvq_T = int(math.log10(pca_maxBasis)/math.log10(2))
            
'''
                    dir_out = \
                        'results_'  + txt1 +\
                        '_Np_'      + str(Np) +\
                        '_Nw_'    + str(Nw) +\
                        '_PCA_'     + str(pca_maxBasis) +\
                        '_maxT_'    + str(rvq_maxT) +\
                        '_S_'       + str(rvq_S)  +\
                        '_tgtSNR_'  + str(rvq_targetSNR)  +\
                        '_tsvqT_'   + str(tsvq_T) +\
                        '_' + txt2


                        
    if (datasetCode==1):
        txt2 = 'Dudek'
    elif (datasetCode==2):
        txt2 = 'davidin300'
    elif (datasetCode==3):
        txt2 = 'sylv'
    elif (datasetCode==4):
        txt2 = 'trellis70'
    elif (datasetCode==5):
        txt2 = 'fish'
    elif (datasetCode==6):
        txt2 = 'car4'
    elif (datasetCode==7):
        txt2 = 'car11'
'''        
