libname surv "C:\Users\Amancy\Documents\M2\Semestre 1\Modèle de Survie\DRiMGame";

options maxmemquery=6M;

data toto;
	set surv.Base_drim_p1;
run;
proc datasets library=work kill;

run;

data toto;
	set toto;
	by identifiant dtf_per_trt;
	retain periode 0;
	if first.identifiant then periode=1;
		else periode+1;
run;

proc contents data=toto;run;

%LET quanti = DT_EMM_CLI DUR_DER_IMP_REGU DUR_IMP_ENC DUR_MAX_IMP DUR_PREV_FIN
 			   MT_CREA_AP_SOL_CT MT_ECH MT_INI_FIN NB_IMP_REGU RAN_IMP_REGU 
			   RAT_APPO RAT_INC_REGU_Z_MAT RAT_MATU_Z_DUR RAT_RAN_IMP_Z_DUR
			   defaut dtd_emp dtf_per_trt;
%LET quali = CD_CANL_DISB CD_ETA_CIV CD_MOD_HABI CD_MRQ_COMM_ETF CD_PROF
 			  CD_QUAL_TY_BN CD_QUAL_VEH CD_TY_BN_FIN CD_TY_CLI_RCI IND_FCH_EXT ;

PROC MEANS DATA=toto n nmiss min max mean std;
	VAR &quanti;
RUN;

PROC FREQ DATA=TOTO;
TABLE defaut;
run;

PROC UNIVARIATE DATA=TOTO (WHERE=(defaut=1));
	VAR defaut(0);
	HISTOGRAM defaut(0) / KERNEL;
RUN;

PROC CORR DATA=TOTO best=3;
	VAR &quanti;
RUN;

/*---------------------------------------------------------*/
/*Les corrélations les + fortes sur variables quantitatives*/
/* - DUR_DER_IMP_REGU et DDUE_IMP_ENC : 0.969
   - DUR_DER_IMP_REGU et RAT_MATU_Z_DUR : 0.849
   - DUR_IMP_ENC et RAT_MATU_Z_DUR : 0.864
   - DUR_MAX_IMP et DUR_IMP_ENC : 0.782
   - DUR_MAX_IMP et RAT_MATU_Z_DUR : 0.675
   - MT_CREA_AP_SOL_CT et RAT_APPO : -0.595
   - MT_CREA_AP_SOL_CT et MT_ECH : 0.55
   - NB_IMP_REGU et RAT_INC_REGU_Z_MAT : 0.77
   - NB_IMP_REGU et defaut : 0.663
   - RAN_IMP_REGU et RAT_RAN_IMP_Z_DUR : 0.956
   - defaut et RAT_INC_REGU_Z_MAT : 0.506*/

/*Recodage des variables qualitatives codées 010000...*/

DATA surv.TOTO2 (DROP=CD_ETA_CIV CD_MOD_HABI CD_PROF);
	SET TOTO;

	IF CD_ETA_CIV = "0100000001" 				THEN CD_ETA_CIV1 = "Single   	    ";
		ELSE IF CD_ETA_CIV = "0100000002" 		THEN CD_ETA_CIV1 = "Married  	    ";
		ELSE IF CD_ETA_CIV = "0100000003" 		THEN CD_ETA_CIV1 = "Divorced 	    ";
		ELSE IF CD_ETA_CIV = "0100000004" 		THEN CD_ETA_CIV1 = "Separated	    ";
		ELSE IF CD_ETA_CIV = "0100000005" 		THEN CD_ETA_CIV1 = "Widowed  	    ";
		ELSE IF CD_ETA_CIV = "0100000006" 		THEN CD_ETA_CIV1 = "Common-law union";

	IF CD_MOD_HABI = "0100000001" 				THEN CD_MOD_HABI1 = "Owner          ";
	  	ELSE IF CD_MOD_HABI = "0100000002"      THEN CD_MOD_HABI1 = "Tenant         ";
		ELSE IF CD_MOD_HABI = "0100000003"      THEN CD_MOD_HABI1 = "Hosted         ";
		ELSE IF CD_MOD_HABI = "0100000004"      THEN CD_MOD_HABI1 = "Company housing";

	IF CD_PROF = "0100000010" 					THEN CD_PROF1 = "Agriculteurs 					 ";
		ELSE IF CD_PROF = "0100000020" 			THEN CD_PROF1 = "Artisans     					 ";
		ELSE IF CD_PROF = "0100000030" 			THEN CD_PROF1 = "Commerçants  					 ";
		ELSE IF CD_PROF = "0100000040" 			THEN CD_PROF1 = "Représentants					 ";
		ELSE IF CD_PROF = "0100000050" 			THEN CD_PROF1 = "Industriels - Chefs d'entreprise";
		ELSE IF CD_PROF = "0100000060" 			THEN CD_PROF1 = "Professions libérales			 ";
		ELSE IF CD_PROF = "0100000070" 			THEN CD_PROF1 = "Cadres ADM SUP  				 ";
		ELSE IF CD_PROF = "0100000080" 			THEN CD_PROF1 = "Cadres ADM MOY					 ";
		ELSE IF CD_PROF = "0100000090" 			THEN CD_PROF1 = "Officiers						 ";
		ELSE IF CD_PROF = "0100000100" 			THEN CD_PROF1 = "Sous-Officiers					 ";
		ELSE IF CD_PROF = "0100000110" 			THEN CD_PROF1 = "Artistes						 ";
		ELSE IF CD_PROF = "0100000120" 			THEN CD_PROF1 = "Cadres SUP						 ";
		ELSE IF CD_PROF = "0100000130" 			THEN CD_PROF1 = "Cadres							 ";
		ELSE IF CD_PROF = "0100000140" 			THEN CD_PROF1 = "Ingénieurs						 ";
		ELSE IF CD_PROF = "0100000150" 			THEN CD_PROF1 = "Techniciens					 ";
		ELSE IF CD_PROF = "0100000160" 			THEN CD_PROF1 = "Agents de maîtrise				 ";
		ELSE IF CD_PROF = "0100000170" 			THEN CD_PROF1 = "Employés						 ";
		ELSE IF CD_PROF = "0100000180" 			THEN CD_PROF1 = "Employés de commerce			 ";
		ELSE IF CD_PROF = "0100000190" 			THEN CD_PROF1 = "Autres personnel de services	 ";
		ELSE IF CD_PROF = "0100000200" 			THEN CD_PROF1 = "Gens de maison					 ";
		ELSE IF CD_PROF = "0100000210" 			THEN CD_PROF1 = "Femmes de ménage				 ";
		ELSE IF CD_PROF = "0100000220" 			THEN CD_PROF1 = "Ouvriers spécialisés			 ";
		ELSE IF CD_PROF = "0100000230" 			THEN CD_PROF1 = "Ouvriers						 ";
		ELSE IF CD_PROF = "0100000240" 			THEN CD_PROF1 = "Mineurs						 ";
		ELSE IF CD_PROF = "0100000250" 			THEN CD_PROF1 = "Marins pêcheurs				 ";
		ELSE IF CD_PROF = "0100000260" 			THEN CD_PROF1 = "Apprentis						 ";
		ELSE IF CD_PROF = "0100000270" 			THEN CD_PROF1 = "Manoeuvres						 ";
		ELSE IF CD_PROF = "0100000280" 			THEN CD_PROF1 = "Retraités						 ";
		ELSE IF CD_PROF = "0100000290" 			THEN CD_PROF1 = "Étudiants						 ";
		ELSE IF CD_PROF = "0100000300" 			THEN CD_PROF1 = "Sans profession				 ";
		ELSE IF CD_PROF = "0100000310" 			THEN CD_PROF1 = "Maîtresse de maison			 ";
		ELSE IF CD_PROF = "0100000320" 			THEN CD_PROF1 = "Pensionnés						 ";
		ELSE IF CD_PROF = "0100000330" 			THEN CD_PROF1 = "Chômeurs						 ";
		ELSE IF CD_PROF = "0100000340" 			THEN CD_PROF1 = "Gens du voyage					 ";
		ELSE IF CD_PROF = "0100000350" 			THEN CD_PROF1 = "Policiers / Assimilés			 ";
		ELSE IF CD_PROF = "0100000360" 			THEN CD_PROF1 = "Intérimaires					 ";
		ELSE IF CD_PROF = "0100000370" 			THEN CD_PROF1 = "Agents sécurité / Surveillance  ";
		ELSE IF CD_PROF = "0100000380" 			THEN CD_PROF1 = "Agents publics					 ";
		ELSE IF CD_PROF = "0100000390" 			THEN CD_PROF1 = "Auto-entrepreneurs				 ";
		ELSE IF CD_PROF = "0100000400" 			THEN CD_PROF1 = "Forains						 ";
		ELSE IF CD_PROF = "0100000410" 			THEN CD_PROF1 = "Antiquaires					 ";
		ELSE IF CD_PROF = "0100000420" 			THEN CD_PROF1 = "Joailliers						 ";
		ELSE IF CD_PROF = "0100000430" 			THEN CD_PROF1 = "Marchands d'oeuvre d'art		 ";
		ELSE IF CD_PROF = "0100000440" 			THEN CD_PROF1 = "Clerc							 ";

RUN;

/*Création des LABELS*/

DATA surv.TOTO2;
	SET TOTO2;
RUN;

PROC DATASETS LIB=surv;
	MODIFY TOTO2;
	LABEL dtf_per_trt 			= "Date d'observation"
		  defaut 				= "Défaut"
		  CD_CANL_DISB          = "Code réseau de distribution"
		  CD_MRQ_COMM_ETF       = "Code de l'établissement financier"
		  CD_QUAL_TY_BN         = "Code qualité et type de bien"
		  CD_QUAL_VEH 			= "Code qualité du véhicule"
		  CD_TY_BN_FIN			= "Code type de bien"
		  CD_TY_CLI_RCI 		= "Code type de client RCI"
		  DUR_DER_IMP_REGU	    = "Durée écoulée depuis le dernier impayé"
		  DUR_IMP_ENC			= "Durée de l'impayée en cours"
		  DUR_MAX_IMP			= "Durée maximale de l'impayée"
		  DUR_PREV_FIN			= "Durée prévisionnelle du financement"
		  IND_FCH_EXT			= "Fichage externe du client"
		  MT_CREA_AP_SOL_CT     = "Créance après la répartition soldes créditeurs"
		  NB_IMP_REGU			= "Nombre d'impayés régularisés"
		  RAN_IMP_REGU 			= "Rang du premier impayé régularisé"
		  RAT_APPO 				= "Pourcentage d'apport comptant"
		  RAT_INC_REGU_Z_MAT    = "Nombre dincidents régularisés sur maturité"
		  RAT_MATU_Z_DUR        = "Durée écoulée en portefeuille sur durée prévue"
		  RAT_RAN_IMP_Z_DUR     = "Rang du premier impayé régularisé sur durée"
		  CD_ETA_CIV1			= "État civil"
		  CD_MOD_HABI1          = "Mode d'habitation"
		  CD_PROF1				= "Profession"
		  MT_ECH				= "Montant de l'échéance"
		  MT_INI_FIN			= "Montant initial du financement"
		  DTD_EMP 				= "Date début d'emploi"
		  DT_EMM_CLI			= "Date début emménagement client";
RUN;

/*Création de formats*/

PROC FORMAT;
	
	VALUE $reseau_dist "NAG"	= "Nissan Agent			    "
					   "RCO"	= "Renault Concessionnaire  "
					   "NCO"    = "Nissan Concessionnaire   "
					   "REA"    = "Renault Europe Automobile"
					   "NSA"    = "Nissan Succursale        "
					   "VS"     = "Ventes Spéciales 		"
					   "RAG"    = "Renault Agent			"
					   "AUTR"   = "Autres					";

	VALUE $etab_fina   "DIAC"   = "Diac		     "
					   "DLOC"   = "DiacLocation  "
					   "NF"     = "Nissan Finance"
					   "OVL"    = "OverLease	 ";

	VALUE $type_qual   "VNAU"   = "Véhicule neuf ?         		 "
					   "VNVI"   = "Véhicule industriel neuf		 "
					   "VNVP"   = "Véhicule privé neuf           "
					   "VNVU"   = "Véhicule utilitaire neuf		 "
					   "VOVP"   = "Véhicule privé d'occasion	 "
					   "VOVU"   = "Véhicule utilitaire d'occasion";

	VALUE $qual 	   "03OR"   = "Véhicule d'occasion"
					   "03VO"   = "Véhicule d'occasion"
					   "03VN"   = "Véhicule neuf      "
					   "040"    = "Véhicule neuf      ";

	VALUE $type        "VP"     = "Véhicule privé     "
					   "VI"     = "Véhicule industriel"
					   "VU"     = "Véhicule utilitaire";

	VALUE $type_cli    "MGE"    = "Moyennes Grandes Entreprises		 "
					   "PM"     = "Petites Moyennes Entreprises		 "
					   "PA"     = "Particulier				   		 "
					   "PE"     = "Petites Entreprises		   		 "
					   "PP"     = "Personnes Physique Professionnelle";

	VALUE $fich 	   0        = "Pas de fichage"
	             	   1  	    = "Fichage  	 ";

RUN;

PROC FREQ DATA=TOTO2;
	TABLES (CD_ETA_CIV1 CD_MOD_HABI1 CD_PROF1)*defaut;
RUN;


/*La procédure ci-dessous compte le nombre d'identifiants différents*/
PROC SQL;
SELECT COUNT(DISTINCT identifiant) INTO :NBVAL FROM TOTO2;
QUIT;
/*Il y a 776238 différents*/ 
/*Vérifier s'ils correspondent bien à 776238 individus différents*/



/*---------------------------------------------------------------------------------------------------*/
/*Le Modèle de Cox doit vérifier deux hypothèses : 

(1) L'hypothèse de risques proportionnels :
	On vérifie que le rapport de risques instantanés de survenue de l'évènement est
	globalement constant au cours du temps. La proportionnalité des risques au cours 
	du temps est difficile à voir sur le groupe de 2 courbes de survie, correspondant
	aux deux modalités d'une variable binaire. Elle est mieux explorée par la fonction
	y = log(-log(S(t))).

	(1.1) Vérification avec les courbes de Kaplan-Meier :  

	PROC LIFETEST DATA=TOTO PLOT=(S, LLS) NOPRINT;
		TIME periode*defaut(0);
		STRATA CD_CANL_DISB; par exemmle
	RUN;

	L'hypothèse est vérifiée si les deux courbes sont parallèles. 

	(1.2) Vérification including time dependant covariates in the Cox Model
	If any of the time dependent covariates are significant then those predictors aren't
	proportional. 

	PROC PHREG DATA=TOTO;
		MODEL periode*defaut(0) = CD_CANL_DISB CD_MRQ_COMM_ETF CD_QUAL_TY_BN 
								  CD_CANL_DISBt CD_MRQ_COMM_ETFt CD_QUAL_TY_BNt;
		CD_CANL_DISBt = CD_CANL_DISB*log(periode);
		CD_MRQ_COMM_ETFt = CD_MRQ_COMM_ETF*log(periode);
		CD_QUAL_TY_BNt =  CD_QUAL_TY_BN*log(periode);
		PROPORTIONALITY_TEST : TEST CD_CANL_DISBt, CD_MRQ_COMM_ETFt, CD_QUAL_TY_BNt;
	RUN;

	(1.3). Tests and Graphs based on the Schoenfeld Residuals.
	Testing the time dependant covariates is equivalent to testing for a non-zero slope
	in a generalized linear regression of the scaled Schoenfeld residuals on functions of 
	time. A non-zero slope is an indication of a violation of the proportional hazard 
	assumptions. (Voir comment faire sous SAS si besoin). 

(2) L'hypothès de censure non-informative 
	Le modèle de Cox suppose que la censure est non-informative, c'est-à-dire que la censure
	est indépendante du risque d'acquérir un évènement. En l'absence d'indépendance, la
	relation de proportionnalité n'est plus valide et on ne peut plus, pour maximiser la 
	vraisemblance, se contenter de considérer seulement les fonctions caractéristiques des
	temps de survenue des évènements: il faudrait aussi faire intervenir les densités en 
	fonction de survie afférentes au processus de censure. 

Que faire lorsque l'hypothèse de risques proportionnels n'est pas vérifié ? 

	(1) Une stratification sur la variable en question. 
		Cette approche permet de prendre en	compte la variable mais ne permet pas d'en estimer
		l'impact pronostique. 

	(2) Une modélisation introduisant une covariable dépendante du temps. 
		Imaginons une variable ayant un impact différent en début d'observation et en fin 
		d'observation. Il est possible d'écrire un modèle où la variable, disons âge, est 
		remplacée par âget qui prend la valeur de âge sur la période où son impact est 
		significatif, et 0 ensuite.

	(3) Une modélisation par partie.

(3) L'hypothèse de log-linéarité 
	Il existe une relation log-linéaire entre fonction de risque instantané et covariables. 
	Plusieurs méthodes existent pour évaluer l'écart à la log-linéarité des variables continues. 
	Parmi celles-ci, une consiste à analyser l'ensemble des différences entre le risque
	instantané calculé par le modèle et le risque observé de défaut. Elle est basée sur
	l'analyse des résidus de la martingale. Si l'hopthèse de log-linéarité est vérifiée pour une
	variable continue, il est conseillé de la laisser continue. 

		   
/*---------------------------------------------------------------------------------------------------*/




