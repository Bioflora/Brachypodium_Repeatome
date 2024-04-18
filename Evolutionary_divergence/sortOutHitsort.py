#!/usr/bin/env python
import sys
import resource
from optparse import OptionParser

parser = OptionParser()
parser.add_option("-c", "--clusters", dest="clsFile", help="cls file")
parser.add_option("-H", "--hitsort", dest="hitsort", help="hitsort file",default='')
parser.add_option("-n", "--minsize", dest="minsize", help="minimal size of the cluster to report",type=int,default=1)
parser.add_option("-d", "--directory", dest="dir",help="directory for output ncol files")
options, args = parser.parse_args()

import resource
soft, hard = resource.getrlimit(resource.RLIMIT_NOFILE)


nf=soft/10*9  # max files open   , this left some room for additinal open file descriptores

#read membership file
membership={}
ncolfiles={}
i=0
clsFile=open(options.clsFile,mode='r')
c=0
while True:
    header=clsFile.readline() #header
    j=clsFile.readline()
    c+=1
    x=j.strip().split()
    if len(x)<int(options.minsize):
        break
    ncolfileName="CL"+str(c)+".ncol"
    #ncolfileName = header+".ncol"
    if nf>=c:
 # check if the number opened files will not exceed limit
        try:
            ncolfiles[ncolfileName]=open(options.dir+"/"+ncolfileName,"w")   # only largest clusters have files open
        except IOError:
            print ('cannot open')
            nf=c-6
            # some files must be closed!
            for k in range(5):
                ncolfileName="CL"+str(c-k-1)+".ncol"
                ncolfiles[ncolfileName].close()
                del ncolfiles[ncolfileName]
                print(ncolfileName)
    for id in x :
        membership[id]=c

    
ncol={}  # for smaller clusters
#scan hitsort and write it out to ncols         
hitsFile=open(options.hitsort,mode='r')
for j in hitsFile :
    edge=j.strip().split()
    if (edge[0] in membership) & (edge[1] in membership):
        mb0=membership[edge[0]]
        mb1=membership[edge[1]]
        if  mb0==mb1:
            ncolfileName="CL"+str(mb0)+".ncol"
            if mb0<=nf:
                #write edge to ncol
                ncolfiles[ncolfileName].write(j)
            else:
                #or keep it in dictionary as set
                if ncolfileName in ncol:
                    ncol[ncolfileName].add(j)
                else:
                    ncol[ncolfileName]=set([j])
#close all files:
for j in ncolfiles:
    ncolfiles[j].close()
    
# write out small ncols
for i in ncol:
    f=open(options.dir+"/"+i,'w')
    for j in ncol[i]:
        f.write(j)
    f.close()





