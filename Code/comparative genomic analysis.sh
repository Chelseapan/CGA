# Gene Prediction with [genemark]

gmsn.pl --prok --format GFF --pdf --fnn --faa genome.seq
geneMarkS_fasta_header_modifier.pl genome.faa genome > genome.faa

————————————————————————————————————————————————————————————————————————————
# Functional Annoation
 # nr database
blast/blastdb_aliastool -db ./nr -dbtype 'prot'  -gilist sequence.gi -out nr # establish the nr database for particular speices
blastp -query sequence.faa -db ./nr -num_threads 4  -evalue 1e-10 -outfmt 5 -out sequence.out
Blast2table -format 10 -xml sequence.out > sequence.xls -numhsps 1
echo -e "Score\tE-Value\tHSP-Len\t%-Ident\t%-Simil\tQuery-Name\tNum-Rds\tQ-Len\tQBegin\tQ-End\tQ-Frame\tHit-Name\tH-Len\tH-Begin\tH-End\tH-Frame\tDescription"> sequencenr.xls
cat sequence.xls >> sequencenr.xls
 # other databases
blastp -query sequence.faa -db [./datafile] -num_threads 4  -evalue 1e-5 -outfmt 5 -out [output]
 #[./datafile]:install the database you need
	#--for COG : ./cog_clean.fa
	#--for String: ./string
	#--for Swiss-Prot: ./uniprot_sprot
	#--for CAZy: ./CAZyDB.07202017.fa
Blast2table -format 10 -xml [output] > [excel_file] -numhsps 1
echo -e "Score\tE-Value\tHSP-Len\t%-Ident\t%-Simil\tQuery-Name\tNum-Rds\tQ-Len\tQBegin\tQ-End\tQ-Frame\tHit-Name\tH-Len\tH-Begin\tH-End\tH-Frame\tDescription"> sequencenr.xls
cat [excel_file] >> [excel_file_addtitle]

	
————————————————————————————————————————————————————————————————————————————
# ortholog analysis 
orthomclAdjustFasta sequence ./sequence.faa 1
cp sequence.fasta ./ORTHOMCLV/data
./ORTHOMCLV/orthomcledit.pl --mode 1 --fa_files [input]
 # input: all the strains' sequences that you want to compare are needed,which should be convert to the fasta format,using a comma to seperate each strains' inputfile.
cp [output] ./
ls *.fasta |awk -F'.fasta' '{print $1"\t"$0}' >pep.list
/plus/work/soft/ORTHOMCLV1.4/orthomcl2speciesedit.pl all_orthomcl.out pep.list
./ORTHOMCLV1.4/Draw_largeSample_venn.pl -infile imp.list -prefix 8

————————————————————————————————————————————————————————————————————————————
# Accodring the resluts of ortholog analysis to pick out the unique genes in the phenotype-advantage strains

————————————————————————————————————————————————————————————————————————————
# Indentify genes' copy number 
 #Extract all the potential funcitonal genes and build up the database
 blast/blastdb_aliastool -db ./functional_genes -dbtype 'prot'  -gilist sequence.gi -out nr
 blastp -query sequence.faa -db ./functional_genes -num_threads 4  -evalue 1e-10 -outfmt 5 -out sequence.out
 Blast2table -format 10 -xml sequence.out > sequence.xls -numhsps 1
 echo -e "Score\tE-Value\tHSP-Len\t%-Ident\t%-Simil\tQuery-Name\tNum-Rds\tQ-Len\tQBegin\tQ-End\tQ-Frame\tHit-Name\tH-Len\tH-Begin\tH-End\tH-Frame\tDescription"> sequencenr.xls
 cat sequence.xls >> sequencenr.xls
 
 ————————————————————————————————————————————————————————————————————————————
