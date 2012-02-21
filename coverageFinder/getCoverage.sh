set -ue

#argvs
RAW_GFF=$1
UP=$2
DOWN=$3
READS=$4
SIZE=$5

#program dir
DIR=`echo $0 | sed 's/\/[^\/]*$//'`
#good gene annotation name
GFF="goodgenes.gff"
#file name
READSNAME=`echo ${READS} | awk -F"/" '{print $NF}'`

if [ $# -eq 0 ];then
	echo Usage: `basename $0` "<gff> <upsteam bp> <downsteam bp> <reads-BED format> <sizefile--BEDtools>"
	echo Example: "sh ../motif_finder/getCoverage.sh ../../ref/Pfalciparum_PlasmoDB-8.1.gff 1000 1000 ../../data/GV_tophat.bed ../../ref/size2.txt"
	exit 1
fi

#something to notice
echo NOTE: "Program needed: Bedtools, Perl, R with ggplot2 package!!"
echo NOTE: "Be Careful! flankbed has bug while using sizefile!!"
echo NOTE: "Chr names in gff and bed should be same!!"
echo



#1 create good gene reference
get_ref(){
mkdir -p 1_ref
cat ${RAW_GFF} | grep -P "\tgene\t" | grep -v "PFC10_API_IRAB" | grep -v "M76611" | awk -F ';' '{print $2"\t"$0}'| awk '{print $2"\t"$1"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9"\t."}' | sed 's/psu|//' | sed 's/Name=//'> 1_ref/${GFF}
flankBed -s -l ${UP} -r 0 -i 1_ref/${GFF} -g ${SIZE} > 1_ref/up.gff         #double check for different cases!!!
flankBed -s -l 0 -r ${DOWN} -i 1_ref/${GFF} -g ${SIZE} > 1_ref/down.gff
}

#2 
get_coverage(){
mkdir -p 2_coverage
#0) get length of each gene
cat 1_ref/${GFF} | awk 'BEGIN{FS="\t";OFS="\t"} {print $1,$2,$5-$4}' > 2_coverage/geneLength.txt

#1) find coverage
## up 
coverageBed -d -s -a ${READS} -b 1_ref/up.gff > 2_coverage/${READSNAME}_UP.coverage
## down
coverageBed -d -s -a ${READS} -b 1_ref/down.gff > 2_coverage/${READSNAME}_DOWN.coverage
}
#2) tablize...
get_table(){
perl $DIR/run.pl 2_coverage/${READSNAME}_UP.coverage up #> 2_coverage/${READSNAME}_UP.coverage.table
perl $DIR/run.pl 2_coverage/${READSNAME}_DOWN.coverage down #> 2_coverage/${READSNAME}_DOWN.coverage.table
}
#3) plot by R
get_plot(){
echo
echo Input files: 2_coverage/${READSNAME}_UP.coverage.table 2_coverage/${READSNAME}_DOWN.coverage.table
echo
Rscript $DIR/coveragePlot.R 2_coverage/${READSNAME}_UP.coverage.table 2_coverage/${READSNAME}_DOWN.coverage.table
}



#-main-
echo Step1. creating good gene reference...
echo
get_ref

echo Step2. finding coverage...
echo
get_coverage

echo Step3. generating table...
echo
get_table

echo Step4. ploting coverage..
echo
get_plot

#-end-
echo
echo ---- END ----
echo