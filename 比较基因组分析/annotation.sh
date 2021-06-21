# nr数据库比对及结果导出
/plus/work/soft/bin/blast/blastdb_aliastool -db /plus/work/database/ncbi/nr/nr -dbtype 'prot'  -gilist sequence.gi -out nr
/plus/work/soft/bin/blast/blastp -query FZJTZ59M2_scaf.faa -db /plus/CCFM/stu09/pqq/nr_bsh/nr -num_threads 4  -evalue 1e-10 -outfmt 5 -out FZJTZ59M2_scaf.out
/plus/work/soft/bin/blast/Blast2table -format 10 -xmlFZJTZ59M2_scaf.out > FZJTZ59M2_scaf.xls -numhsps 1
echo -e "Score\tE-Value\tHSP-Len\t%-Ident\t%-Simil\tQuery-Name\tNum-Rds\tQ-Len\tQBegin\tQ-End\tQ-Frame\tHit-Name\tH-Len\tH-Begin\tH-End\tH-Frame\tDescription"> FZJTZ59M2_scafnr.xls
cat FZJTZ59M2_scaf.xls >> FZJTZ59M2_scafnr.xls

# COG数据库
/plus/work/soft/bin/blast/blastp -query F_SD_HZ_D3_L_5_scaf.faa -db /plus/work/soft/ncbi-blast-2.7.1+/db/cog_clean.fa -num_threads 4  -evalue 1e-5 -outfmt 5 -out F_SD_HZ_D3_L_5_scaf.out
/plus/work/soft/bin/blast/Blast2table -format 10 -xml F_SD_HZ_D3_L_5_scaf.out > F_SD_HZ_D3_L_5_scaf.xls -numhsps 1

# string数据库
/plus/work/soft/bin/blast/blastp -query FJLHD24M1_scafMS.faa -db /plus/work/whc/database/string/string -num_threads 1  -evalue 1e-10 -outfmt 5 -out teststring.out 
/plus/work/soft/bin/String2Cogedit.pl -i teststring.out t -parse_id --format blastxml -o /plus/CCFM/stu06/pqq/orthomcl -img COG,KOG -db 
/plus/work/whc/database/COG/cog.db -mblast 
/plus/work/soft/bin/blast/Blast2table -format 10 -xml teststring.out > teststring.xls -numhsps 1

# Swiss-Prot数据库
/plus/work/soft/bin/blast/blastp -query FJLHD24M1_scafMS.faa -db /plus/work/database/uniprot_sprot/uniprot_sprot -num_threads 1  -evalue 1e-10 -outfmt 5 -out testuni.out 
/plus/work/soft/bin/blast/Blast2table -format 10 -xml testuni.out > testuni.xls -numhsps 1

# CAZy数据库
  # Blast 
/plus/work/soft/bin/blast/blastp -query FJLHD24M1_scafMS.faa -db /plus/work/soft/CAZY/CAZyDB.07202017.fa -num_threads 4 -evalue 1e-10 -outfmt 5 -out dbCAN.blastp
/plus/work/soft/bin/blast/Blast2table -numhsps 20 -score 1e-5 -format 10 -xml dbCAN.blastp> dbCAN.blastp.tab
  # HMM
/plus/work/soft/hmmer-3.1/binaries/hmmscan --cpu 1 --domtblout dbCAN.hmmscan.domtblout 
/plus/work/soft/CAZY/dbCAN-fam-HMMs.txt GCF_000148815.2_ASM14881v1_protein.faa > dbCAN.hmmscan.out 
/plus/work/soft/CAZY/hmmscan-parser.sh dbCAN.hmmscan.domtblout > dbCAN.hmmscan.tab

# Card数据库
python /plus/work/soft/CARD/rgi.py -t protein -i GCF_000148815.2_ASM14881v1_protein.faa -o sample
python /plus/work/soft/CARD/convertJsonToTSV.py -i sample.json -o sample.CARD
perl /plus/work/soft/CARD/convertCARDTxtToXls.pl sample.CARD.txt sample

# 合并数据库注释结果
/plus/work/soft/bin/mergeAnnotation.pl -fa FJLHD24M1_scaf.fasta.faa -nr FJLHD24M1_scafnr.xls -cog FJLHD24M1_scafcog.xls > FJLHD24M1_scafannotation.xls