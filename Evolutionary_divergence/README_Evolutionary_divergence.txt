# Obtain complete hitsort.csv file (all clusters)

# 1) Make working directory

mkdir hitsort_files_clusters_Brachy

# 2) Copy all hitsort_part.csv files for each cluster

cd /seqclust/clustering/clusters

for d in dir_CL*; do cp -- $d/hitsort_part.csv Evolutionary_divergence/hitsort_files_clusters_Brachy/${d#DIR}.csv; done

# 3) Concatenate csv files

cat dir_CL*.csv > hitsort_all_clusters.csv

# 4) Extract the first three columns

cut -f 1-3 hitsort_all_clusters.csv > hitsort_all_clusters_outcol.csv

# 5) Now, we will work with histort.cls file (it is different to hitsort_part.csv files)

## From CLUSTER_TABLE.csv we prepare two columns wth the CL codes and the repeat names

cut -f1 clusters_codes_and_names.txt > CL_codes

cut -f2 clusters_codes_and_names.txt > repeat_names

dos2unix CL_codes
dos2unix repeat_names

# 6) change CL code by repeat name in hitsort.cls file

-------------------------------------------------------------------

awk '
	FILENAME == ARGV[1] { CL_codes[$1] = FNR; next }
   	FILENAME == ARGV[2] { repeat_names[FNR] = $1; next }
	{
		for (i = 1; i <= NF; i++) {
			if ($i in CL_codes) {
				$i = repeat_names[CL_codes[$i]]
			}
				}
		print
	}' CL_codes repeat_names hitsort.cls > hitsort_rename.cls

-------------------------------------------------------------------

# 7) Extract only the annotated (top) clusters (the first 342 clusters) from hitsort_rename.cls

head -684 hitsort_rename.cls > hitsort_rename_annotated.cls

grep -c "^>" hitsort_rename_annotated.cls

# Number of clusters: 342

# 8) Extract the clusters by grouping by repetitive element

>5S_rDNA
>Ale
>Alesia
>All
>Angela
>Athila
>Bianca
>CRM
>EnSpm_CACTA
>hAT
>Helitron
>Ikeros
>Ivana
>LINE
>LTR
>mitochondria
>mobile_element
>MuDR_Mutator
>Ogre
>pararetrovirus
>PIF_Harbinger
>repeat
>Retand
>satellite
>SIRE
>TAR
>Tekay
>Tork

grep -A 1 ">5S_rDNA" hitsort_rename_annotated.cls | sed '/--/d' > 5S_rDNA_hitsort.cls && \
grep -A 1 ">Ale" hitsort_rename_annotated.cls | sed '/--/d' > Ale_hitsort.cls && \
grep -A 1 ">Alesia" hitsort_rename_annotated.cls | sed '/--/d' > Alesia_hitsort.cls && \
grep -A 1 ">All" hitsort_rename_annotated.cls | sed '/--/d' > All_hitsort.cls && \
grep -A 1 ">Angela" hitsort_rename_annotated.cls | sed '/--/d' > Angela_hitsort.cls && \
grep -A 1 ">Athila" hitsort_rename_annotated.cls | sed '/--/d' > Athila_hitsort.cls && \
grep -A 1 ">Bianca" hitsort_rename_annotated.cls | sed '/--/d' > Bianca_hitsort.cls && \
grep -A 1 ">CRM" hitsort_rename_annotated.cls | sed '/--/d' > CRM_hitsort.cls && \
grep -A 1 ">EnSpm_CACTA" hitsort_rename_annotated.cls | sed '/--/d' > EnSpm_CACTA_hitsort.cls && \
grep -A 1 ">hAT" hitsort_rename_annotated.cls | sed '/--/d' > hAT_hitsort.cls && \
grep -A 1 ">Helitron" hitsort_rename_annotated.cls | sed '/--/d' > Helitron_hitsort.cls && \
grep -A 1 ">Ikeros" hitsort_rename_annotated.cls | sed '/--/d' > Ikeros_hitsort.cls && \
grep -A 1 ">Ivana" hitsort_rename_annotated.cls | sed '/--/d' > Ivana_hitsort.cls && \
grep -A 1 ">LINE" hitsort_rename_annotated.cls | sed '/--/d' > LINE_hitsort.cls && \
grep -A 1 ">LTR" hitsort_rename_annotated.cls | sed '/--/d' > LTR_hitsort.cls && \
grep -A 1 ">mitochondria" hitsort_rename_annotated.cls | sed '/--/d' > mitochondria_hitsort.cls && \
grep -A 1 ">mobile_element" hitsort_rename_annotated.cls | sed '/--/d' > mobile_element_hitsort.cls && \
grep -A 1 ">MuDR_Mutator" hitsort_rename_annotated.cls | sed '/--/d' > MuDR_Mutator_hitsort.cls && \
grep -A 1 ">Ogre" hitsort_rename_annotated.cls | sed '/--/d' > Ogre_hitsort.cls && \
grep -A 1 ">pararetrovirus" hitsort_rename_annotated.cls | sed '/--/d' > pararetrovirus_hitsort.cls && \
grep -A 1 ">PIF_Harbinger" hitsort_rename_annotated.cls | sed '/--/d' > PIF_Harbinger_hitsort.cls && \
grep -A 1 ">repeat" hitsort_rename_annotated.cls | sed '/--/d' > repeat_hitsort.cls && \
grep -A 1 ">Retand" hitsort_rename_annotated.cls | sed '/--/d' > Retand_hitsort.cls && \
grep -A 1 ">satellite" hitsort_rename_annotated.cls | sed '/--/d' > satellite_hitsort.cls && \
grep -A 1 ">SIRE" hitsort_rename_annotated.cls | sed '/--/d' > SIRE_hitsort.cls && \
grep -A 1 ">TAR" hitsort_rename_annotated.cls | sed '/--/d' > TAR_hitsort.cls && \
grep -A 1 ">Tekay" hitsort_rename_annotated.cls | sed '/--/d' > Tekay_hitsort.cls && \
grep -A 1 ">Tork" hitsort_rename_annotated.cls | sed '/--/d' > Tork_hitsort.cls

# 8) Remove repeat name (header) and convert to oneline

sed '/>5S_rDNA/d' 5S_rDNA_hitsort.cls | tr '\n' '\t' > 5S_rDNA_hitsort_online.cls && \
sed '/>Ale/d' Ale_hitsort.cls | tr '\n' '\t' > Ale_hitsort_online.cls && \
sed '/>Alesia/d' Alesia_hitsort.cls | tr '\n' '\t' > Alesia_hitsort_online.cls && \
sed '/>All/d' All_hitsort.cls | tr '\n' '\t' > All_hitsort_online.cls && \
sed '/>Angela/d' Angela_hitsort.cls | tr '\n' '\t' > Angela_hitsort_online.cls && \
sed '/>Athila/d' Athila_hitsort.cls | tr '\n' '\t' > Athila_hitsort_online.cls && \
sed '/>Bianca/d' Bianca_hitsort.cls | tr '\n' '\t' > Bianca_hitsort_online.cls && \
sed '/>CRM/d' CRM_hitsort.cls | tr '\n' '\t' > CRM_hitsort_online.cls && \
sed '/>EnSpm_CACTA/d' EnSpm_CACTA_hitsort.cls | tr '\n' '\t' > EnSpm_CACTA_hitsort_online.cls && \
sed '/>hAT/d' hAT_hitsort.cls | tr '\n' '\t' > hAT_hitsort_online.cls && \
sed '/>Helitron/d' Helitron_hitsort.cls | tr '\n' '\t' > Helitron_hitsort_online.cls && \
sed '/>Ikeros/d' Ikeros_hitsort.cls | tr '\n' '\t' > Ikeros_hitsort_online.cls && \
sed '/>Ivana/d' Ivana_hitsort.cls | tr '\n' '\t' > Ivana_hitsort_online.cls && \
sed '/>LINE/d' LINE_hitsort.cls | tr '\n' '\t' > LINE_hitsort_online.cls && \
sed '/>LTR/d' LTR_hitsort.cls | tr '\n' '\t' > LTR_hitsort_online.cls && \
sed '/>mitochondria/d' mitochondria_hitsort.cls | tr '\n' '\t' > mitochondria_hitsort_online.cls && \
sed '/>mobile_element/d' mobile_element_hitsort.cls | tr '\n' '\t' > mobile_element_hitsort_online.cls && \
sed '/>MuDR_Mutator/d' MuDR_Mutator_hitsort.cls | tr '\n' '\t' > MuDR_Mutator_hitsort_online.cls && \
sed '/>Ogre/d' Ogre_hitsort.cls | tr '\n' '\t' > Ogre_hitsort_online.cls && \
sed '/>pararetrovirus/d' pararetrovirus_hitsort.cls | tr '\n' '\t' > pararetrovirus_hitsort_online.cls && \
sed '/>PIF_Harbinger/d' PIF_Harbinger_hitsort.cls | tr '\n' '\t' > PIF_Harbinger_hitsort_online.cls && \
sed '/>repeat/d' repeat_hitsort.cls | tr '\n' '\t' > repeat_hitsort_online.cls && \
sed '/>Retand/d' Retand_hitsort.cls | tr '\n' '\t' > Retand_hitsort_online.cls && \
sed '/>satellite/d' satellite_hitsort.cls | tr '\n' '\t' > satellite_hitsort_online.cls && \
sed '/>SIRE/d' SIRE_hitsort.cls | tr '\n' '\t' > SIRE_hitsort_online.cls && \
sed '/>TAR/d' TAR_hitsort.cls | tr '\n' '\t' > TAR_hitsort_online.cls && \
sed '/>Tekay/d' Tekay_hitsort.cls | tr '\n' '\t' > Tekay_hitsort_online.cls && \
sed '/>Tork/d' Tork_hitsort.cls | tr '\n' '\t' > Tork_hitsort_online.cls

# 9) Add name of repeat in the first line

e.g. >Retand
...

## Remove intermediate files

# 10) Concatenate the most representative repeats (see genome contribution analysis) plus satelite and 5S_rDNA to downstream analysis

Retand
Ikeros
Tekay
MuDR_Mutator
Ogre
Ale
Ivana
EnSpm_CACTA
TAR
SIRE
5S_rDNA
satellite

cat Retand_hitsort_online.cls Ikeros_hitsort_online.cls Tekay_hitsort_online.cls MuDR_Mutator_hitsort_online.cls Ogre_hitsort_online.cls Ale_hitsort_online.cls \
Ivana_hitsort_online.cls EnSpm_CACTA_hitsort_online.cls TAR_hitsort_online.cls SIRE_hitsort_online.cls 5S_rDNA_hitsort_online.cls satellite_hitsort_online.cls \
> main_repeats_oneline.cls

# 11) Run python script: sortOutHitsort.py

# First create output directory: mkdir output_sortOutHitsort_script

python3 sortOutHitsort.py -c main_repeats_oneline.cls -H hitsort_all_clusters_outcol.csv -n 1 -d output_sortOutHitsort_script 

# 12) Clusters and repeat

# Check cluster and name:

e.g: grep -B 1 "AA11271f" hitsort_rename_annotated.cls | grep "^>"


CL1.ncol -> Retand
CL2.ncol -> Ikeros
CL3.ncol -> Tekay
CL4.ncol -> MuDR_Mutator
CL5.ncol -> Ogre
CL6.ncol -> Ale
CL7.ncol -> Ivana
CL8.ncol -> EnSpm_CACTA
CL9.ncol -> TAR
CL10.ncol-> SIRE
CL11.ncol-> 5S_rDNA
CL12.ncol-> satellite


# Edit headers (AA, AB,...) in analyze_hitsort_brachy.py script

# Edit Script_Brachy.R and run
