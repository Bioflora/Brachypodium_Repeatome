#!/usr/bin/env python3
import sys
from collections import defaultdict
# count species specific hits
species = {
            'AA':0,
            'AC':0,
            'AD':0,
            'AB':0,
            'AE':0,
            'AF':0,
            'AG':0,
            'AH':0,
            'AI':0,
            'AK':0,
            'AL':0,
            'AM':0,
            'AN':0,
            'AO':0,
            'AP':0,
            'AQ':0,
            'AS':0,
            'AT':0,
            'AR':0,
            'AU':0,
            'AV':0,
            'AW':0,
            'AX':0,
            'AY':0,
            'AZ':0,
            'BA':0,
            'BC':0,
            'BD':0,
            'BE':0,
            'BF':0,
            'BG':0,
            'BH':0,
            'BI':0,
            'BJ':0,
            'BL':0,
            'BP':0,
            'BX':0,
            'BY':0,
            'MB':0,
            'MD':0,
            'MC':0,
            'DA':0,
            'SA':0,
            'HA':0
            }

counts = defaultdict(lambda: {
                     'AA':0,
                     'AC':0,
                     'AD':0,
                     'AB':0,
                     'AE':0,
                     'AF':0,
                     'AG':0,
                     'AH':0,
                     'AI':0,
                     'AK':0,
                     'AL':0,
                     'AM':0,
                     'AN':0,
                     'AO':0,
                     'AP':0,
                     'AQ':0,
                     'AS':0,
                     'AT':0,
                     'AR':0,
                     'AU':0,
                     'AV':0,
                     'AW':0,
                     'AX':0,
                     'AY':0,
                     'AZ':0,
                     'BA':0,
                     'BC':0,
                     'BD':0,
                     'BE':0,
                     'BF':0,
                     'BG':0,
                     'BH':0,
                     'BI':0,
                     'BJ':0,
                     'BL':0,
                     'BP':0,
                     'BX':0,
                     'BY':0,
                     'MB':0,
                     'MD':0,
                     'MC':0,
                     'DA':0,
                     'SA':0,
                     'HA':0
            } )

while True:
    line=sys.stdin.readline()
    if not line:
        break
    a,b,score = line.split()
    print(a)
    print(b)
    counts[a][b[:2]] += 1
    counts[b][a[:2]] += 1
    
    
with open(sys.argv[1], 'w') as f:
    keys = species.keys()
    header = "\t".join([str(i) for i in keys])+"\n"
    f.write(header)
    for l in counts:
        lineout = l+"\t"+"\t".join([str(counts[l][i]) for i in keys ])+"\n"
        f.write(lineout)
    
        
        
    
