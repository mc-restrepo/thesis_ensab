/**************************************************************************************************
* * ConstruccionIndices20141101.SAS
* * 
* * 
* * IV ENSAB 
* * DESCRIPCIÓN: Construcción de los indicadores clínicos 
* *              
* * 
* * INPUTS: Bases en formato SAS generadas de 00Datos
* * 
* * OUTPUTS: Bases con los indicadores calculados
* * 
* * FILE HISTORY:
* * 	20140403: CREACIÓN
* *		20140901: REVISIÓN DE LA PARTE DE ICDAS 3 CONTRA COP
* *     20141028: INCLUSIÓN DE FÓRMULAS DE FLUOROSIS ..
* *     20141101: REVISIÓN DE INDICADORES
* *	
* * ToDo: 
**************************************************************************************************/

/**************************************************************************************************
* * LIBRERIAS CON LA INFORMACION
**************************************************************************************************/
*%LET PATH = D:\proyectos\2014\SEI;
*%LET PATH = G:\SEI;

*LIBNAME IN  "&PATH\input\datos20141112";  * * LIBRERIA CON LAS BASES EN FORMATO SAS;
*LIBNAME OUT "&PATH\output\SAS\BD";  * *LIBRERIA CON LAS BASES PROCESADAS PARA GENERAR INDICADORAS;
*LIBNAME RES "&PATH\output\SAS\RESULTADOS";

options notes;
OPTIONS PS = 500;
/**************************************************************************************************
* * FIJAR PARÁMETROS PARA EL CÁLCULO DE INDICADORES
**************************************************************************************************/
*** ESI;
%LET KPRO_ESI1 = 3;  * * MAYOR A 3MM EN PROFUNDIDAD;
%LET KPRO_ESI2 = 6;  * * MAYOR A 6MM EN PROFUNDIDAD;
%LET KMCA_ESI1 = -1;  * * MENOR O IGUAL A -1MM EN MLCA;
%LET KMCA_ESI2 = 1;  * * MENOR A 1MM EN MLCA;
%LET KINS_ESI1 = 1;  * * MAYOR A 1MM EN NIC;
%LET KINS_ESI2 = 3;  * * MAYOR A 3MM EN NIC;

*** DAI;
%LET K01_DAI = 5.76;  * * Number of missing visible teeth (incisors, canines, and premolars in the maxillary and mandibular arches);
%LET K02_DAI = 1.15;  * * Assessment of crowding in the incisal segments;
%LET K03_DAI = 1.31;  * * Assessment of spacing in the incisal segments;
%LET K04_DAI = 3.13;  * * Measurement of any midline diastema in mm;
%LET K05_DAI = 1.34;  * * Largest anterior irregularity on the maxilla in mm;
%LET K06_DAI = 0.75;  * * Largest anterior irregularity on the mandible in mm;
%LET K07_DAI = 1.62;  * * Measurement of anterior maxillary overjet in mm;
%LET K08_DAI = 3.68;  * * Measurement of anterior mandibular overjet in mm;
%LET K09_DAI = 3.69;  * * Measurement of vertical anterior openbite in mm;
%LET K10_DAI = 2.69;  * * Assessment of anteroposterior molar relation;
%LET K11_DAI = 13.36; * * Constant;

%LET MRAP0 = 0;  * * VALOR ASIGNADO AL 0 DE RELACIÓN ANTERO POSTERIOR PARA EL DAI;
%LET MRAP1 = 2;  * * VALOR ASIGNADO AL 1 DE RELACIÓN ANTERO POSTERIOR PARA EL DAI;
%LET MRAP2 = 2;  * * VALOR ASIGNADO AL 2 DE RELACIÓN ANTERO POSTERIOR PARA EL DAI;

*** FLUOROSIS;
%LET K0_FLU = 0  ;* Normal;
%LET K1_FLU = 0.5;* Discutible/Dudosa/Cuestionable;
%LET K2_FLU = 1  ;* Muy leve;
%LET K3_FLU = 2  ;* Leve;
%LET K4_FLU = 3  ;* Moderada;
%LET K5_FLU = 4  ;* Severa;
/**************************************************************************************************
* * EVALUACIÓN CLÍNICA A NIÑOS DE 1 Y 3 AÑOS
**************************************************************************************************/
DATA M4_EXAMEN_1;
	SET IN.M4_EXAMEN_1;

	**************************************************CARIES
	******* MODIFICACIÓN DEL 20140620
	

	****************************************************************************************** FORMULA 1
    ** Variables a usar: MA_305A -- MA_305J MA_307A -- MA_307J
	*** PC_COP_ = "Prevalencia de caries en COP"
		VALORES 1+2 Ó B+C;
    PC_COP_T = 0; * TEMPORALES;
	PC_COP_P = 0; * PERMANENTES;
	PC_COP_J = 0; * JUNTOS;

	****************************************************************************************** FORMULA 2
	*** PC_ICDAS_ = "Prevalencia de caries en ICDAS"
		VALORES  2, 3, 4, 5 o 6;
    PC_ICDAS_T = 0; * TEMPORALES;
	PC_ICDAS_P = 0; * PERMANENTES;
	PC_ICDAS_J = 0; * JUNTOS;

	****************************************************************************************** FORMULA 3
	*** PC_ICDAS_V_SEV = "Por niveles de severidad a partir de ICDAS"
		VALORES  2, 3, 4, 5 y 6
	*** VALORES  2;
	PC_ICDAS_T_SEV2 = 0; * TEMPORALES;
	PC_ICDAS_P_SEV2 = 0; * PERMANENTES;
	PC_ICDAS_J_SEV2 = 0; * JUNTOS;

	*** VALORES  3;
	PC_ICDAS_T_SEV3 = 0; * TEMPORALES;
	PC_ICDAS_P_SEV3 = 0; * PERMANENTES;
	PC_ICDAS_J_SEV3 = 0; * JUNTOS;

	*** VALORES  4;
	PC_ICDAS_T_SEV4 = 0; * TEMPORALES;
	PC_ICDAS_P_SEV4 = 0; * PERMANENTES;
	PC_ICDAS_J_SEV4 = 0; * JUNTOS;

	*** VALORES  5;
	PC_ICDAS_T_SEV5 = 0; * TEMPORALES;
	PC_ICDAS_P_SEV5 = 0; * PERMANENTES;
	PC_ICDAS_J_SEV5 = 0; * JUNTOS;

	*** VALORES 6;
	PC_ICDAS_T_SEV6 = 0; * TEMPORALES;
	PC_ICDAS_P_SEV6 = 0; * PERMANENTES;
	PC_ICDAS_J_SEV6 = 0; * JUNTOS;

	****************************************************************************************** FORMULA 4
	PC= % personas con COP (1 o 2) o ICDAS (2, 3, 4, 5 o 6)  
	PC= % personas con COP (B o C) o ICDAS (2, 3, 4, 5 o 6)  ;
	PC_COP_ICDAS_T = 0; * TEMPORALES;
	PC_COP_ICDAS_P = 0; * PERMANENTES;
	PC_COP_ICDAS_J = 0; * JUNTOS;

	****************************************************************************************** FORMULA 5
	EC_COP_ = "Experiencia de caries en COP"
	VALORES (1, 2, 3 o 4) o (B, C, D o E);
	EC_COP_T = 0; * TEMPORALES;
	EC_COP_P = 0; * PERMANENTES;
	EC_COP_J = 0; * JUNTOS;

	****************************************************************************************** FORMULA 2
	
	****************************************************************************************** FORMULA 6
	EC = % personas con COP (1, 2, 3 o 4) o ICDAS (2, 3, 4, 5 o 6)  
	EC = % personas con COP (B, C, D o E) o ICDAS (2, 3, 4, 5 o 6);
	EC_COP_ICDAS_T = 0; * TEMPORALES;
	EC_COP_ICDAS_P = 0; * PERMANENTES;
	EC_COP_ICDAS_J = 0; * JUNTOS; 

	****************************************************************************************** FORMULA 7
	IDS = "Índice de dientes sanos"
	IDS = % personas con 0 ó A;
	IDS_POR_COP_T = 0; * TEMPORALES;
	IDS_POR_COP_P = 0; * PERMANENTES;
	IDS_POR_COP_J = 0; * JUNTOS;
	****************************************************************************************** FORMULA 8
	IDS = % suma 0/n;
	IDS_PRO_COP_T = 0; * TEMPORALES;
	IDS_PRO_COP_P = 0; * PERMANENTES;
	IDS_PRO_COP_J = 0; * JUNTOS;
	****************************************************************************************** FORMULA 9
	IDC = "Índice de dientes cariados"
	IDC= suma 1 + 2/n, IDC= suma B + C/n;
	IDC_COP_T = 0; * TEMPORALES;
	IDC_COP_P = 0; * PERMANENTES;
	IDC_COP_J = 0; * JUNTOS;

	****************************************************************************************** FORMULA 10
	IDC= suma 2+3+4+5+6/n;
	IDC_ICDAS_T = 0; * TEMPORALES;
	IDC_ICDAS_P = 0; * PERMANENTES;
	IDC_ICDAS_J = 0; * JUNTOS;

	*IDC= suma 2+3/n (lesiones tempranas);
	IDC_LT_ICDAS_T = 0; * TEMPORALES;
	IDC_LT_ICDAS_P = 0; * PERMANENTES;
	IDC_LT_ICDAS_J = 0; * JUNTOS;
	****************************************************************************************** FORMULA 11
	IDC= suma COP (1 + 2) + ICDAS (2, 3) /n, IDC= suma COP (B + C) + + ICDAS (2, 3) /n;
	IDC_COP_ICDAS_T = 0; * TEMPORALES;
	IDC_COP_ICDAS_P = 0; * PERMANENTES;
	IDC_COP_ICDAS_J = 0; * JUNTOS;

	****************************************************************************************** FORMULA 11.5
	IDC= suma ICDAS (2, 3, 4, 5, 6) no COP(1,2,3,4) /n, IDC= suma COP (B + C) + + ICDAS (2, 3) /n;
	/*IDC_ICDAS_SCOP_T = 0; * TEMPORALES;
	IDC_ICDAS_SCOP_P = 0; * PERMANENTES;
	IDC_ICDAS_SCOP_J = 0; * JUNTOS;
	
	PC_ICDAS_SCOP_T = 0; * TEMPORALES;
	PC_ICDAS_SCOP_P = 0; * PERMANENTES;
	PC_ICDAS_SCOP_J = 0; * JUNTOS;*/

	****************************************************************************************** FORMULA 12
	IDO= % personas con 3 ó D;
	IDO_POR_COP_T = 0; * TEMPORALES;
	IDO_POR_COP_P = 0; * PERMANENTES;
	IDO_POR_COP_J = 0; * JUNTOS;

	****************************************************************************************** FORMULA 13
	IDO= suma 3/n ó D/n;
	IDO_PRO_COP_T = 0; * TEMPORALES;
	IDO_PRO_COP_P = 0; * PERMANENTES;
	IDO_PRO_COP_J = 0; * JUNTOS;

	****************************************************************************************** FORMULA 14
	IDP= % personas con 4 ó E;
	IDP_POR_COP_T = 0; * TEMPORALES;
	IDP_POR_COP_P = 0; * PERMANENTES;
	IDP_POR_COP_J = 0; * JUNTOS;

	****************************************************************************************** FORMULA 15
	IDP= suma 4/n ó E/n;
	IDP_PRO_COP_T = 0; * TEMPORALES;
	IDP_PRO_COP_P = 0; * PERMANENTES;
	IDP_PRO_COP_J = 0; * JUNTOS;

	****************************************************************************************** FORMULA 16
	IDC niveles de severidad = (2.3.4.5. ó 6)/n.  
	*** VALORES  2;
	IDC_ICDAS_T_SEV2 = 0; * TEMPORALES;
	IDC_ICDAS_P_SEV2 = 0; * PERMANENTES;
	IDC_ICDAS_J_SEV2 = 0; * JUNTOS;

	*** VALORES  3;
	IDC_ICDAS_T_SEV3 = 0; * TEMPORALES;
	IDC_ICDAS_P_SEV3 = 0; * PERMANENTES;
	IDC_ICDAS_J_SEV3 = 0; * JUNTOS;

	*** VALORES  4;
	IDC_ICDAS_T_SEV4 = 0; * TEMPORALES;
	IDC_ICDAS_P_SEV4 = 0; * PERMANENTES;
	IDC_ICDAS_J_SEV4 = 0; * JUNTOS;

	*** VALORES  5;
	IDC_ICDAS_T_SEV5 = 0; * TEMPORALES;
	IDC_ICDAS_P_SEV5 = 0; * PERMANENTES;
	IDC_ICDAS_J_SEV5 = 0; * JUNTOS;

	*** VALORES 6;
	IDC_ICDAS_T_SEV6 = 0; * TEMPORALES;
	IDC_ICDAS_P_SEV6 = 0; * PERMANENTES;
	IDC_ICDAS_J_SEV6 = 0; * JUNTOS;

	****************************************************************************************** FORMULA 17, 18 y 19
	Indice CPO-d apartir de COP, 
	VALORES 1,2,3 + 4/n, ó B,C,D + E/n;
	CPO_D_T = 0; * TEMPORALES; 
	CPO_D_P = 0; * PERMANENTES;
	CPO_D_J = 0; * JUNTOS;

	****************************************************************************************** FORMULA 20 y 21
	COP (1 + 2 + 4 + 3)+ ICDAS (2 + 3 + 4 + 5 + 6)/ n o COP (B + C+ E + D)+ ICDAS (2 + 3 + 4 + 5 + 6) / n;
	CPO_D_MOD_T = 0; * TEMPORALES;
	CPO_D_MOD_P = 0; * PERMANENTES;
	CPO_D_MOD_J = 0; * JUNTOS;

	****************************************************************************************** FORMULA(2) 22 Y 23
	ISC= Suma CPO-d 5 años tercil más afectado/ n 5 años;
	ISC_T = .;
	ISC_P = .;
	ISC_J = .;
	
	****************************************************************************************** FORMULA(3) 24
	IPMPSanos = suma 0 (16+26+36+46) / n 12 años, COP;
	*IPMP_S_T = .;
	IPMP_S_P = .;
	*IPMP_S_J = .;

	****************************************************************************************** FORMULA(3) 25
	IPMPPerdidos = suma 4 (16+26+36+46) / n 12 años, COP;
	*IPMP_P_T = .;
	IPMP_P_P = .;
	*IPMP_P_J = .;

	****************************************************************************************** FORMULA(3) 26
	IPMPCariados = suma COP (1+2) (16+26+36+46) / n 12 años;
	*IPMP_C_T = .;
	IPMP_C_P = .;
	*IPMP_C_J = .;

	****************************************************************************************** FORMULA(3) 27
	IPMPCariados = suma ICDAS (2+3) (16+26+36+46) / n 12 años;
	*IPMP_ICDAS_C_T = .;
	IPMP_ICDAS_C_P = .;
	*IPMP_ICDAS_C_J = .;

	****************************************************************************************** FORMULA(3) 28
	IPMPCariados = suma COP (1+2) + ICDAS (2+3) (16+26+36+46) / n 12 años;
	*IPMP_COP_ICDAS_C_T = .;
	IPMP_COP_ICDAS_C_P = .;
	*IPMP_COP_ICDAS_C_J = .;

	****************************************************************************************** FORMULA(3) 29
	IPMPObturados = suma 3 (16+26+36+46) / n 12 años;
	*IPMP_O_T = .;
	IPMP_O_P = .;
	*IPMP_O_J = .;

	****************************************************************************************** FORMULA(3) 30
	IPMPCariados severidad= suma ICDAS 2 o 3 o 4 o 5 o 6 (16+26+36+46) / n 12 años 
	(se calcula la sumatoria por cada nivel de severidad en los 1eros molares);
	*** VALORES  2;
	IPMP_ICDAS_P_SEV2 = .; * PERMANENTES;
	
	*** VALORES  3;
	IPMP_ICDAS_P_SEV3 = .; * PERMANENTES;
	
	*** VALORES  4;
	IPMP_ICDAS_P_SEV4 = .; * PERMANENTES;
	
	*** VALORES  5;
	IPMP_ICDAS_P_SEV5 = .; * PERMANENTES;
	
	*** VALORES 6;
	IPMP_ICDAS_P_SEV6 = .; * PERMANENTES;
	
	**************************************************************************************PETICION SANDRA;
	SELL_POR_T = 0;
	SELL_POR_P = 0;
	SELL_POR_J = 0;

	SELL_PRO_T = 0;
	SELL_PRO_P = 0;
	SELL_PRO_J = 0;

	****************************************************************************************** FORMULA 15

	****************************************************************************************** FORMULA 14

	****************************************************************************************** FORMULA 31
	PDPC = suma 5 /n cada grupo de edad de 5, 12, 15, 18, 20 y más años;
	*PDPC_T = .;
	PDPC_P = .;
	*PDPC_J = .;

	****************************************************************************************** FORMULA(5) 32
	IRC = suma de 1 + 2 / n, Caries radicular en personas de 35 años y más;
	*IRC_T = .;
	IRC_P = .;
	*IRC_J = .;

	****************************************************************************************** FORMULA(5) 33
	IRO = suma de 3 / n;
	*IRO_T = .;
	IRO_P = .;
	*IRO_J = .;

	****************************************************************************************** FORMULA(5) 34
	IROC = suma de 3 + 1 + 2 / n;
	*IROC_T = .;
	IROC_P = .;
	*IROC_J = .;

	****************************************************************************************** FORMULA(5) 35
	PCR= % personas con 1 o 2;
	*PCR_T = .;
	PCR_P = .;
	*PCR_J = .;

	****************************************************************************************** FORMULA(5) 
	PADB 28 = % personas con 28 dientes en boca (0,1,2,3,6,7);
	*PADB_28_T = .;
	DIE_BOCAP = 0;
	DIE_BOCAT = 0;
	DIE_BOCAJ = 0;
	*PADB_28_P = .;
	*PADB_28_J = .;

	****************************************************************************************** FORMULA(5) 
	PADB < 20 = % personas con < 20 dientes en boca (0,1,2,3,6,7);
	*PADB_M_20_T = .;
	PADB_M_20_P = .;
	*PADB_M_20_J = .;

	**************************************************PERIODONTAL
	****************************************************************************************** FORMULA 39
	Edéntulismo parcial= % personas edéntulas parciales con códigos 4 o 5 en uno o varios dientes;
	ED_P = 0;

	****************************************************************************************** FORMULA 42
	IIP= sumar los implantes 7 y (4, 45) / n;
	IIP = 0;
	
	****************************************************************************************** FORMULA 40
	Tramo posterior= % personas parcialmente edéntula en los tramos posteriores / n 
	para maxilar superior, maxilar inferior, maxilares superior e inferior simultáneo
	Tramo Anterior= % personas parcialmente edéntula en el tramo anterior  / n 
	para maxilar superior, maxilar inferior, maxilares superior e inferior simultáneo

	Tramo= % personas con tramo corto, o mediano, o largo / n;
	T_P = 0;
	T_A = 0;
	
	****************************************************************************************** FORMULA 43
	En COP criterios 4 o 5 _ E
	IDA= suma dientes ausentes / n
	IDA= suma dientes ausentes / n por tipo diente;
	*IDA_T = 0;
	IDA_P = 0;
	*IDA_J = 0;

	****************************************************************************************** FORMULA 44
	PDF= % personas > 21 dientes / n;
	PDF = 0;

	****************************************************************************************** FORMULA 45
	Índice de Extensión de pérdida de Inserción
	Extensión = % sitios con NIC > 1 mm / n sitios sondeados;
	IEPI_T = 0;

	****************************************************************************************** FORMULA 46
	Índice de Severidad de pérdida de Inserción
	Severidad = Suma valores NIC > 1 mm / n sitios NCI > 1 mm;
	ISPI_T = 0;

	****************************************************************************************** FORMULA 47
	ESI de pérdida de inserción en sitios interproximales
	Extensión = % sitios interproximales (mb, db, ml, dl) NIC > 1 mm / n sitios interproximales X 100;
	ESI_PISI_POR_T = 0;

	*Severidad = Suma valores interproximales (mb, db, ml, dl) NIC > 1 mm / n sitios NCI > 1 mm;
	ESI_PISI_PRO_T = 0;

	****************************************************************************************** FORMULA 48
	Índice de Extensión de la profundidad clínica al sondaje (bolsa)
	Extensión = % bolsas > 4 mm / n sitios sondeados;
	IEPCS_T = 0;

	****************************************************************************************** FORMULA 49
	Índice de Severidad de la profundidad clínica al sondaje
	Severidad = Suma valores bolsas > 4 mm / n sitios sondeados;
	ISPCS_T = 0;

	****************************************************************************************** FORMULA 50
	Índice de Extensión de la profundidad clínica al sondaje peri-implantar
	Extensión = % bolsas peri-implantares > 4 mm / n sitios sondeados;
	IEPCSP_T = 0;

	****************************************************************************************** FORMULA 51
	Índice de Severidad de la profundidad clínica al sondaje peri-implantar
	Severidad = Suma valores bolsas > 4 mm / n sitios sondeados;
	ISPCSP_T = 0;

	****************************************************************************************** FORMULA 52
	ESI de recesión gingival (margen)
	Extensión = % recesión gingival = 1 mm/ n sitios sondeados;
	ESI_RG_POR_T = 0;


	****************************************************************************************** FORMULA 53
	ESI de recesión gingival (margen)
	Severidad = Suma valores recesión gingival = 1 mm/ n sitios sondeados;
	ESI_RG_PRO_T = 0;

	****************************************************************************************** FORMULA 54

	****************************************************************************************** FORMULA 55

	**********OCLUSION 


    **********OPACIDAD;
	****************************************************************************************** FORMULA 119;
	POE = 0;
	POE_IC = 0;
	POE_MP = 0;
		
	POE_7 = 0;
	POE_IC_7 = 0;
	POE_MP_7 = 0;
	
	POE_8 = 0;
	POE_IC_8 = 0;
	POE_MP_8 = 0;

	POE_C = 0;
	POE_IC_C = 0;
	POE_MP_C = 0;	
	
	*** ;
	*EDENTULISMO = 0;*DPER;
	PERMANENTES = 0;
	TEMPORALES  = 0;
	EVALUADOS   = 0;  * * EVALUADOS;

	* * * * * ICDAS1;
	ARRAY ICDAS {4, 5}
		 MA_304E MA_304D MA_304C MA_304B MA_304A
		 MA_304F MA_304G MA_304H MA_304I MA_304J
		 MA_306F MA_306G MA_306H MA_306I MA_306J
		 MA_306E MA_306D MA_306C MA_306B MA_306A
	;
	* * * * * OPAC1;
	ARRAY OPAC {4, 5}
		 MA_304E1 MA_304D1 MA_304C1 MA_304B1 MA_304A1
		 MA_304F1 MA_304G1 MA_304H1 MA_304I1 MA_304J1
		 MA_306F1 MA_306G1 MA_306H1 MA_306I1 MA_306J1
		 MA_306E1 MA_306D1 MA_306C1 MA_306B1 MA_306A1
	;
	* * * * * cop1;
	ARRAY cop {4, 5}
		 MA_305E MA_305D MA_305C MA_305B MA_305A
		 MA_305F MA_305G MA_305H MA_305I MA_305J
		 MA_307F MA_307G MA_307H MA_307I MA_307J
		 MA_307E MA_307D MA_307C MA_307B MA_307A
	;
			
	DO P = 1 TO 4;
		DO M = 1 TO DIM(COP, 2);

			IF COP[P, M] IN('A', 'B', 'C', 'D', 'E', 'F', 'G') THEN TEMPORALES + 1;	
			IF COP[P, M] IN('0', '1', '2', '3', '4', '5', '6', '7', 
							'A', 'B', 'C', 'D', 'E', 'F', 'G') THEN EVALUADOS + 1;	

			IF	COP[P, M] IN('B', 'C') THEN DO;
				PC_COP_T = 1; * TEMPORALES;
				PC_COP_J = 1; * JUNTOS;
			END;

			IF	ICDAS[P, M] IN(2, 3, 4, 5, 6) THEN DO;
				PC_ICDAS_T = 1; * TEMPORALES;
				PC_ICDAS_J = 1; * JUNTOS;
			END;
	
			IF	ICDAS[P ,M] IN(2) THEN DO;
				 PC_ICDAS_T_SEV2 = 1; * TEMPORALES;
				 PC_ICDAS_J_SEV2 = 1; * JUNTOS;
			END;
			IF	 ICDAS[P ,M] IN(3) THEN DO;
				 PC_ICDAS_T_SEV3 = 1; * TEMPORALES;
				 PC_ICDAS_J_SEV3 = 1; * JUNTOS;
			END;
			IF	 ICDAS[P ,M] IN(4) THEN DO;
				 PC_ICDAS_T_SEV4 = 1; * TEMPORALES;
				 PC_ICDAS_J_SEV4 = 1; * JUNTOS;
			END;
			IF	 ICDAS[P ,M] IN(5) THEN DO;
				 PC_ICDAS_T_SEV5 = 1; * TEMPORALES;
				 PC_ICDAS_J_SEV5 = 1; * JUNTOS;
			END;
			IF	 ICDAS[P ,M] IN(6) THEN DO;
				 PC_ICDAS_T_SEV6 = 1; * TEMPORALES;
				 PC_ICDAS_J_SEV6 = 1; * JUNTOS;
			END; 	 

			/*IF ICDAS[P, M] IN(2, 3, 4, 5, 6) OR COP[P, M] IN('B', 'C') 
				THEN DO; 
				PC_COP_ICDAS_T = 1; * TEMPORALES;
				PC_COP_ICDAS_J = 1; * JUNTOS;
			END;*/

			IF	 COP[P ,M]	IN('B', 'C', 'D', 'E') THEN DO;
				EC_COP_T = 1; * TEMPORALES;
				EC_COP_J = 1; * JUNTOS;
			END;

			IF ICDAS[P, M] IN(2, 3, 4, 5, 6) OR COP[P, M] IN('B', 'C', 'D', 'E') THEN DO; 
				EC_COP_ICDAS_T = 1; * TEMPORALES;
				EC_COP_ICDAS_J = 1; * JUNTOS;
			END;

			IF COP[P ,M] IN('A', 'F')  THEN DO;		
				IDS_POR_COP_T = 1; * TEMPORALES;
				IDS_POR_COP_J = 1; * JUNTOS;
				
				IDS_PRO_COP_T + 1; * TEMPORALES;
				IDS_PRO_COP_J + 1; * JUNTOS;
			END;
			
			IF COP[P ,M] IN('F')  THEN DO;		
				SELL_POR_T = 1; * TEMPORALES;
				SELL_POR_J = 1; * JUNTOS;
				
				SELL_PRO_T + 1; * TEMPORALES;
				SELL_PRO_J + 1; * JUNTOS;
			END;
			
			IF	COP[P, M] IN('B', 'C') THEN DO;
				IDC_COP_T + 1; * TEMPORALES;
				IDC_COP_J + 1; * JUNTOS;
			END;

			IF	ICDAS[P, M] IN(2, 3, 4, 5, 6) THEN DO;
				IDC_ICDAS_T + 1; * TEMPORALES;
				IDC_ICDAS_J + 1; * JUNTOS;
			END;

			IF	ICDAS[P, M] IN(2) THEN DO;
				IDC_LT_ICDAS_T + 1; * TEMPORALES;
				IDC_LT_ICDAS_J + 1; * JUNTOS;
			END;

			/*IF COP[P, M] IN('B', 'C') OR ICDAS[P, M] IN(2, 3, 4, 5, 6)  
				THEN DO; 
				IDC_COP_ICDAS_T + 1; * TEMPORALES;
				IDC_COP_ICDAS_J + 1; * JUNTOS;
			END;*/

			IF ICDAS[P, M] IN(2, 3, 4, 5, 6) AND COP[P, M] NOT IN('B', 'C', 'D', 'E') 
				THEN DO; 
				/*IDC_ICDAS_SCOP_T + 1; * TEMPORALES;
				IDC_ICDAS_SCOP_J + 1; * JUNTOS;
				PC_ICDAS_SCOP_P  = 1;
				PC_ICDAS_SCOP_J  = 1;*/
				IDC_COP_ICDAS_T + 1; * TEMPORALES;
				IDC_COP_ICDAS_J + 1; * JUNTOS;
				PC_COP_ICDAS_T = 1; * TEMPORALES;
				PC_COP_ICDAS_J = 1; * JUNTOS;				
			END;
			
			IF COP[P, M] IN('D') THEN DO;
				IDO_POR_COP_T = 1; * TEMPORALES;
				IDO_POR_COP_J = 1; * JUNTOS;
				IDO_PRO_COP_T + 1; * TEMPORALES;
				IDO_PRO_COP_J + 1; * JUNTOS;
			END;

			IF COP[P, M] IN('E') THEN DO;
				IDP_POR_COP_T = 1; * TEMPORALES;
				IDP_POR_COP_J = 1; * JUNTOS;
				IDP_PRO_COP_T + 1; * TEMPORALES;
				IDP_PRO_COP_J + 1; * JUNTOS;
			END;

			IF ICDAS[P, M] IN(2) THEN DO;
				IDC_ICDAS_T_SEV2 + 1; * TEMPORALES;
				IDC_ICDAS_J_SEV2 + 1; * JUNTOS;
			END;

			IF ICDAS[P, M] IN(3) THEN DO;
				IDC_ICDAS_T_SEV3 + 1; * TEMPORALES;
				IDC_ICDAS_J_SEV3 + 1; * JUNTOS;
			END;

			IF ICDAS[P, M] IN(4) THEN DO;
				IDC_ICDAS_T_SEV4 + 1; * TEMPORALES;
				IDC_ICDAS_J_SEV4 + 1; * JUNTOS;
			END;

			IF ICDAS[P, M] IN(5) THEN DO;
				IDC_ICDAS_T_SEV5 + 1; * TEMPORALES;
				IDC_ICDAS_J_SEV5 + 1; * JUNTOS;
			END;

			IF ICDAS[P, M] IN(6) THEN DO;
				IDC_ICDAS_T_SEV6 + 1; * TEMPORALES;
				IDC_ICDAS_J_SEV6 + 1; * JUNTOS;
			END;

			IF COP[P, M] IN('B', 'C', 'D', 'E') THEN DO;
				CPO_D_T + 1; * TEMPORALES;
				CPO_D_J + 1; * JUNTOS;
			END;

			IF COP[P, M] IN('B', 'C', 'D', 'E') OR ICDAS[P, M] IN(2, 3, 4, 5, 6) THEN DO;
				CPO_D_MOD_T + 1; * TEMPORALES;
				CPO_D_MOD_P + 1; * JUNTOS;
			END;
			
			***;
			IF COP[P, M] IN('0', '1', '2', '3', '6', '7') THEN DO;
				DIE_BOCAP + 1;
			END;
			
			IF COP[P, M] IN('A', 'B', 'C', 'D', 'F', 'G') THEN DO;
				DIE_BOCAT + 1;
			END;
			
			IF COP[P, M] IN('0', '1', '2', '3', '6', '7',
							'A', 'B', 'C', 'D', 'F', 'G') THEN DO;
				DIE_BOCAJ + 1;
			END;
			
			************ OPACIDAD;
			IF OPAC[P, M] IN(7, 8) THEN DO;
				POE = 1;
				POE_C + 1;
				IF OPAC[P, M] IN(7) THEN POE_7 + 1;
				IF OPAC[P, M] IN(8) THEN POE_8 + 1;
				
				IF M IN(1, 2, 3) 		THEN DO;
					POE_IC = 1;
					POE_IC_C + 1;
					IF OPAC[P, M] IN(7) THEN POE_IC_7 + 1;
					IF OPAC[P, M] IN(8) THEN POE_IC_8 + 1;
				END;
				IF M IN(4, 5, 6, 7, 8) 	THEN DO;
					POE_MP = 1;
					POE_MP_C + 1;
					IF OPAC[P, M] IN(7) THEN POE_MP_7 + 1;
					IF OPAC[P, M] IN(8) THEN POE_MP_8 + 1;
				END;
			END;
	
			
		END;
	END;

	DROP P M;
RUN;

/**************************************************************************************************
* * EVALUACIÓN CLÍNICA A NIÑOS DE 5 AÑOS
**************************************************************************************************/

DATA M4_EXAMEN_2;
	SET IN.M4_EXAMEN_2;

	* * * * * DIEEVAL2, diente evaluado? diferencia permanente de temporal;
	ARRAY DIEEVAL {4, 6}
		 MB_D6 MB_D5 MB_D4 MB_D3 MB_D2 MB_D1
		 MB_D7 MB_D8 MB_D9 MB_D10 MB_D11 MB_D12
		 MB_D19 MB_D20 MB_D21 MB_D22 MB_D23 MB_D24
		 MB_D18 MB_D17 MB_D16 MB_D15 MB_D14 MB_D13
	;

	**************************************************CARIES
	*** PC= Prevalencia Caries;

	****************************************************************************************** FORMULA 1
    ** Variables a usar: MA_305A -- MA_305J MA_307A -- MA_307J
	*** PC_COP_ = "Prevalencia de caries en COP"
		VALORES 1+2 Ó B+C;
    PC_COP_T = 0; * TEMPORALES;
	PC_COP_P = 0; * PERMANENTES;
	PC_COP_J = 0; * JUNTOS;

	****************************************************************************************** FORMULA 2
	*** PC_ICDAS_ = "Prevalencia de caries en ICDAS"
		VALORES  2, 3, 4, 5 o 6;
    PC_ICDAS_T = 0; * TEMPORALES;
	PC_ICDAS_P = 0; * PERMANENTES;
	PC_ICDAS_J = 0; * JUNTOS;

	****************************************************************************************** FORMULA 3
	*** PC_ICDAS_V_SEV = "Por niveles de severidad a partir de ICDAS"
		VALORES  2, 3, 4, 5 y 6
	*** VALORES  2;
	PC_ICDAS_T_SEV2 = 0; * TEMPORALES;
	PC_ICDAS_P_SEV2 = 0; * PERMANENTES;
	PC_ICDAS_J_SEV2 = 0; * JUNTOS;

	*** VALORES  3;
	PC_ICDAS_T_SEV3 = 0; * TEMPORALES;
	PC_ICDAS_P_SEV3 = 0; * PERMANENTES;
	PC_ICDAS_J_SEV3 = 0; * JUNTOS;

	*** VALORES  4;
	PC_ICDAS_T_SEV4 = 0; * TEMPORALES;
	PC_ICDAS_P_SEV4 = 0; * PERMANENTES;
	PC_ICDAS_J_SEV4 = 0; * JUNTOS;

	*** VALORES  5;
	PC_ICDAS_T_SEV5 = 0; * TEMPORALES;
	PC_ICDAS_P_SEV5 = 0; * PERMANENTES;
	PC_ICDAS_J_SEV5 = 0; * JUNTOS;

	*** VALORES 6;
	PC_ICDAS_T_SEV6 = 0; * TEMPORALES;
	PC_ICDAS_P_SEV6 = 0; * PERMANENTES;
	PC_ICDAS_J_SEV6 = 0; * JUNTOS;

	****************************************************************************************** FORMULA 4
	PC= % personas con COP (1 o 2) o ICDAS (2, 3, 4, 5 o 6)  
	PC= % personas con COP (B o C) o ICDAS (2, 3, 4, 5 o 6)  ;
	PC_COP_ICDAS_T = 0; * TEMPORALES;
	PC_COP_ICDAS_P = 0; * PERMANENTES;
	PC_COP_ICDAS_J = 0; * JUNTOS;

	****************************************************************************************** FORMULA 5
	EC_COP_ = "Experiencia de caries en COP"
	VALORES (1, 2, 3 o 4) o (B, C, D o E);
	EC_COP_T = 0; * TEMPORALES;
	EC_COP_P = 0; * PERMANENTES;
	EC_COP_J = 0; * JUNTOS;

	****************************************************************************************** FORMULA 2
	
	****************************************************************************************** FORMULA 6
	EC = % personas con COP (1, 2, 3 o 4) o ICDAS (2, 3, 4, 5 o 6)  
	EC = % personas con COP (B, C, D o E) o ICDAS (2, 3, 4, 5 o 6);
	EC_COP_ICDAS_T = 0; * TEMPORALES;
	EC_COP_ICDAS_P = 0; * PERMANENTES;
	EC_COP_ICDAS_J = 0; * JUNTOS; 

	****************************************************************************************** FORMULA 7
	IDS = "Índice de dientes sanos"
	IDS = % personas con 0 ó A;
	IDS_POR_COP_T = 0; * TEMPORALES;
	IDS_POR_COP_P = 0; * PERMANENTES;
	IDS_POR_COP_J = 0; * JUNTOS;
	****************************************************************************************** FORMULA 8
	IDS = % suma 0/n;
	IDS_PRO_COP_T = 0; * TEMPORALES;
	IDS_PRO_COP_P = 0; * PERMANENTES;
	IDS_PRO_COP_J = 0; * JUNTOS;
	****************************************************************************************** FORMULA 9
	IDC = "Índice de dientes cariados"
	IDC= suma 1 + 2/n, IDC= suma B + C/n;
	IDC_COP_T = 0; * TEMPORALES;
	IDC_COP_P = 0; * PERMANENTES;
	IDC_COP_J = 0; * JUNTOS;

	****************************************************************************************** FORMULA 10
	IDC= suma 2+3+4+5+6/n;
	IDC_ICDAS_T = 0; * TEMPORALES;
	IDC_ICDAS_P = 0; * PERMANENTES;
	IDC_ICDAS_J = 0; * JUNTOS;

	*IDC= suma 2+3/n (lesiones tempranas);
	IDC_LT_ICDAS_T = 0; * TEMPORALES;
	IDC_LT_ICDAS_P = 0; * PERMANENTES;
	IDC_LT_ICDAS_J = 0; * JUNTOS;
	****************************************************************************************** FORMULA 11
	IDC= suma COP (1 + 2) + ICDAS (2, 3) /n, IDC= suma COP (B + C) + + ICDAS (2, 3) /n;
	IDC_COP_ICDAS_T = 0; * TEMPORALES;
	IDC_COP_ICDAS_P = 0; * PERMANENTES;
	IDC_COP_ICDAS_J = 0; * JUNTOS;

	****************************************************************************************** FORMULA 11.5
	IDC= suma ICDAS (2, 3, 4, 5, 6) no COP(1,2,3,4) /n, IDC= suma COP (B + C) + + ICDAS (2, 3) /n;
	/*IDC_ICDAS_SCOP_T= 0; * TEMPORALES;
	IDC_ICDAS_SCOP_P= 0; * PERMANENTES;
	IDC_ICDAS_SCOP_J= 0; * JUNTOS;
	
	PC_ICDAS_SCOP_T = 0; * TEMPORALES;
	PC_ICDAS_SCOP_P = 0; * PERMANENTES;
	PC_ICDAS_SCOP_J = 0; * JUNTOS;*/

	****************************************************************************************** FORMULA 12
	IDO= % personas con 3 ó D;
	IDO_POR_COP_T = 0; * TEMPORALES;
	IDO_POR_COP_P = 0; * PERMANENTES;
	IDO_POR_COP_J = 0; * JUNTOS;

	****************************************************************************************** FORMULA 13
	IDO= suma 3/n ó D/n;
	IDO_PRO_COP_T = 0; * TEMPORALES;
	IDO_PRO_COP_P = 0; * PERMANENTES;
	IDO_PRO_COP_J = 0; * JUNTOS;

	****************************************************************************************** FORMULA 14
	IDP= % personas con 4 ó E;
	IDP_POR_COP_T = 0; * TEMPORALES;
	IDP_POR_COP_P = 0; * PERMANENTES;
	IDP_POR_COP_J = 0; * JUNTOS;

	****************************************************************************************** FORMULA 15
	IDP= suma 4/n ó E/n;
	IDP_PRO_COP_T = 0; * TEMPORALES;
	IDP_PRO_COP_P = 0; * PERMANENTES;
	IDP_PRO_COP_J = 0; * JUNTOS;

	****************************************************************************************** FORMULA 16
	IDC niveles de severidad = (2.3.4.5. ó 6)/n.  
	*** VALORES  2;
	IDC_ICDAS_T_SEV2 = 0; * TEMPORALES;
	IDC_ICDAS_P_SEV2 = 0; * PERMANENTES;
	IDC_ICDAS_J_SEV2 = 0; * JUNTOS;

	*** VALORES  3;
	IDC_ICDAS_T_SEV3 = 0; * TEMPORALES;
	IDC_ICDAS_P_SEV3 = 0; * PERMANENTES;
	IDC_ICDAS_J_SEV3 = 0; * JUNTOS;

	*** VALORES  4;
	IDC_ICDAS_T_SEV4 = 0; * TEMPORALES;
	IDC_ICDAS_P_SEV4 = 0; * PERMANENTES;
	IDC_ICDAS_J_SEV4 = 0; * JUNTOS;

	*** VALORES  5;
	IDC_ICDAS_T_SEV5 = 0; * TEMPORALES;
	IDC_ICDAS_P_SEV5 = 0; * PERMANENTES;
	IDC_ICDAS_J_SEV5 = 0; * JUNTOS;

	*** VALORES 6;
	IDC_ICDAS_T_SEV6 = 0; * TEMPORALES;
	IDC_ICDAS_P_SEV6 = 0; * PERMANENTES;
	IDC_ICDAS_J_SEV6 = 0; * JUNTOS;

	****************************************************************************************** FORMULA 17, 18 y 19
	Indice CPO-d apartir de COP, 
	VALORES 1,2,3 + 4/n, ó B,C,D + E/n;
	CPO_D_T = 0; * TEMPORALES; 
	CPO_D_P = 0; * PERMANENTES;
	CPO_D_J = 0; * JUNTOS;

	****************************************************************************************** FORMULA 20 y 21
	CPO-d = COP (1+2+3+4)+ ICDAS (2+3)/n ó COP (B+C+E+D)+ ICDAS (2+3)/n;
	CPO_D_MOD_T = 0; * TEMPORALES;
	CPO_D_MOD_P = 0; * PERMANENTES;
	CPO_D_MOD_J = 0; * JUNTOS;

	****************************************************************************************** FORMULA(3) 22
	ISC= Suma CPO-d 12 años tercil más afectado/ n 12 años;
	****************************************************************************************** FORMULA(2) 23
	ISC= Suma CPO-d 5 años tercil más afectado/ n 5 años;
	ISC_T = 0;
	ISC_P = 0;
	ISC_J = 0;

	****************************************************************************************** FORMULA(3) 24
	IPMPSanos = suma 0 (16+26+36+46) / n 12 años, COP;
	*IPMP_S_T = .;
	IPMP_S_P = .;
	*IPMP_S_J = .;

	****************************************************************************************** FORMULA(3) 25
	IPMPPerdidos = suma 4 (16+26+36+46) / n 12 años, COP;
	*IPMP_P_T = .;
	IPMP_P_P = .;
	*IPMP_P_J = .;

	****************************************************************************************** FORMULA(3) 26
	IPMPCariados = suma COP (1+2) (16+26+36+46) / n 12 años;
	*IPMP_C_T = .;
	IPMP_C_P = .;
	*IPMP_C_J = .;

	****************************************************************************************** FORMULA(3) 27
	IPMPCariados = suma ICDAS (2+3) (16+26+36+46) / n 12 años;
	*IPMP_ICDAS_C_T = .;
	IPMP_ICDAS_C_P = .;
	*IPMP_ICDAS_C_J = .;

	****************************************************************************************** FORMULA(3) 28
	IPMPCariados = suma COP (1+2) + ICDAS (2+3) (16+26+36+46) / n 12 años;
	*IPMP_COP_ICDAS_C_T = .;
	IPMP_COP_ICDAS_C_P = .;
	*IPMP_COP_ICDAS_C_J = .;

	****************************************************************************************** FORMULA(3) 29
	IPMPObturados = suma 3 (16+26+36+46) / n 12 años;
	*IPMP_O_T = .;
	IPMP_O_P = .;
	*IPMP_O_J = .;

	****************************************************************************************** FORMULA(3) 30
	IPMPCariados severidad= suma ICDAS 2 o 3 o 4 o 5 o 6 (16+26+36+46) / n 12 años 
	(se calcula la sumatoria por cada nivel de severidad en los 1eros molares);
	*** VALORES  2;
	IPMP_ICDAS_P_SEV2 = .; * PERMANENTES;
	
	*** VALORES  3;
	IPMP_ICDAS_P_SEV3 = .; * PERMANENTES;
	
	*** VALORES  4;
	IPMP_ICDAS_P_SEV4 = .; * PERMANENTES;
	
	*** VALORES  5;
	IPMP_ICDAS_P_SEV5 = .; * PERMANENTES;
	
	*** VALORES 6;
	IPMP_ICDAS_P_SEV6 = .; * PERMANENTES;

	**************************************************************************************PETICION SANDRA;
	SELL_POR_T = 0;
	SELL_POR_P = 0;
	SELL_POR_J = 0;

	SELL_PRO_T = 0;
	SELL_PRO_P = 0;
	SELL_PRO_J = 0;

	****************************************************************************************** FORMULA 15

	****************************************************************************************** FORMULA 14

	****************************************************************************************** FORMULA 31
	PDPC = suma 5 /n cada grupo de edad de 5, 12, 15, 18, 20 y más años;
	*PDPC_T = .;
	PDPC_P = .;
	*PDPC_J = .;

	****************************************************************************************** FORMULA(5) 32
	IRC = suma de 1 + 2 / n, Caries radicular en personas de 35 años y más;
	*IRC_T = .;
	IRC_P = .;
	*IRC_J = .;

	****************************************************************************************** FORMULA(5) 33
	IRO = suma de 3 / n;
	*IRO_T = .;
	IRO_P = .;
	*IRO_J = .;

	****************************************************************************************** FORMULA(5) 34
	IROC = suma de 3 + 1 + 2 / n;
	*IROC_T = .;
	IROC_P = .;
	*IROC_J = .;

	****************************************************************************************** FORMULA(5) 35
	PCR= % personas con 1 o 2;
	*PCR_T = .;
	PCR_P = .;
	*PCR_J = .;

	****************************************************************************************** FORMULA(5) 36
	PADB 28 = % personas con 28 dientes en boca (0,1,2,3,6,7);
	*PADB_28_T = .;
	DIE_BOCAP = 0;
	DIE_BOCAT = 0;
	DIE_BOCAJ = 0;
	*PADB_28_P = .;
	*PADB_28_J = .;

	****************************************************************************************** FORMULA(5) 37
	PADB < 20 = % personas con < 20 dientes en boca (0,1,2,3,6,7);
	*PADB_M_20_T = .;
	PADB_M_20_P = .;
	*PADB_M_20_J = .;

	****************************************************************************************** FORMULA 39
	Edéntulismo parcial= % personas edéntulas parciales con códigos 4 o 5 en uno o varios dientes;
	ED_P = 0;
	
	****************************************************************************************** FORMULA 42
	IIP= sumar los implantes 7 y (4, 45) / n;
	IIP = 0;
	
	****************************************************************************************** FORMULA 44
	PDF= % personas > 21 dientes / n;
	PDF = 0;
	
	**********OPACIDAD;
	****************************************************************************************** FORMULA 119;
	POE = 0;
	POE_IC = 0;
	POE_MP = 0;
	
	POE_7 = 0;
	POE_IC_7 = 0;
	POE_MP_7 = 0;
	
	POE_8 = 0;
	POE_IC_8 = 0;
	POE_MP_8 = 0;

	POE_C = 0;
	POE_IC_C = 0;
	POE_MP_C = 0;	
	
	PERMANENTES = 0;
	TEMPORALES  = 0;
	EVALUADOS   = 0;

	* * * * * ICDAS2;
	ARRAY ICDAS {4, 6}
		 MB_304f MB_304e MB_304d MB_304c MB_304b MB_304a
		 MB_304g MB_304h MB_304i MB_304j MB_304k MB_304l
		 MB_306g MB_306h MB_306i MB_306j MB_306k MB_306l
		 MB_306f MB_306e MB_306d MB_306c MB_306b MB_306a
	;
	* * * * * OPAC2;
	ARRAY OPAC {4, 6}
		 MB_304f1 MB_304e1 MB_304d1 MB_304c1 MB_304b1 MB_304a1
		 MB_304g1 MB_304h1 MB_304i1 MB_304j1 MB_304k1 MB_304l1
		 MB_306g1 MB_306h1 MB_306i1 MB_306j1 MB_306k1 MB_306l1
		 MB_306f1 MB_306e1 MB_306d1 MB_306c1 MB_306b1 MB_306a1
	;
	* * * * * cop2;
	ARRAY cop {4, 6}
		 MB_305f MB_305e MB_305d MB_305c MB_305b MB_305a
		 MB_305g MB_305h MB_305i MB_305j MB_305k MB_305l
		 MB_307g MB_307h MB_307i MB_307j MB_307k MB_307l
		 MB_307f MB_307e MB_307d MB_307c MB_307b MB_307a
	;
	
	DO P = 1 TO 4;
		DO M = 1 TO DIM(COP, 2);
			IF	SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') 
				AND COP[P, M] IN('0', '1', '2', '3', '4', '5', '6', '7') THEN PERMANENTES + 1;
			IF	SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') 
				AND COP[P, M] IN('A', 'B', 'C', 'D', 'E', 'F', 'G') THEN TEMPORALES + 1;	
			IF COP[P, M] IN('0', '1', '2', '3', '4', '5', '6', '7', 
							'A', 'B', 'C', 'D', 'E', 'F', 'G') THEN EVALUADOS + 1;	


			IF	SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') 
				AND COP[P, M] IN('B', 'C') THEN DO;
				PC_COP_T = 1; * TEMPORALES;
			END;

			IF	SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') 
				AND COP[P, M] IN('1', '2') THEN DO;
				PC_COP_P = 1; * PERMANENTES;
			END;

			IF	COP[P, M] IN('B', 'C', '1', '2') THEN DO;
				PC_COP_J = 1; * JUNTOS;
			END;

			***;
			IF	SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') 
				AND ICDAS[P, M] IN(2, 3, 4, 5, 6) THEN DO;
				PC_ICDAS_T = 1; * TEMPORALES;
			END;

			IF	SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') 
				AND ICDAS[P, M] IN(2, 3, 4, 5, 6) THEN DO;
				PC_ICDAS_P = 1; * PERMANENTE;
			END;

			IF	ICDAS[P, M] IN(2, 3, 4, 5, 6) THEN DO;
				PC_ICDAS_J = 1; * JUNTOS;
			END;
	
			***;
			IF	 ICDAS[P ,M] IN(2) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				 PC_ICDAS_T_SEV2 = 1; * TEMPORALES;
			END;
			IF	 ICDAS[P ,M] IN(2) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				 PC_ICDAS_P_SEV2 = 1; * PERMANENTE;
			END;
			IF	 ICDAS[P ,M] IN(2) THEN DO;
				 PC_ICDAS_J_SEV2 = 1; * JUNTOS;
			END;
			IF	 ICDAS[P ,M] IN(3) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				 PC_ICDAS_T_SEV3 = 1; * TEMPORALES;
			END;
			IF	 ICDAS[P ,M] IN(3) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				 PC_ICDAS_P_SEV3 = 1; * PERMANENTE;
			END;
			IF	 ICDAS[P ,M] IN(3) THEN DO;
				 PC_ICDAS_J_SEV3 = 1; * JUNTOS;
			END;
			IF	 ICDAS[P ,M] IN(4) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				 PC_ICDAS_T_SEV4 = 1; * TEMPORALES;
			END;
			IF	 ICDAS[P ,M] IN(4) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				 PC_ICDAS_P_SEV4 = 1; * PERMANENTE;
			END;
			IF	 ICDAS[P ,M] IN(4) THEN DO;
				 PC_ICDAS_J_SEV4 = 1; * JUNTOS;
			END;
			IF	 ICDAS[P ,M] IN(5) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				 PC_ICDAS_T_SEV5 = 1; * TEMPORALES;
			END;
			IF	 ICDAS[P ,M] IN(5) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				 PC_ICDAS_P_SEV5 = 1; * PERMANENTE;
			END;
			IF	 ICDAS[P ,M] IN(5) THEN DO;
				 PC_ICDAS_J_SEV5 = 1; * JUNTOS;
			END;
			IF	 ICDAS[P ,M] IN(6) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				 PC_ICDAS_T_SEV6 = 1; * TEMPORALES;
			END;
			IF	 ICDAS[P ,M] IN(6) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				 PC_ICDAS_P_SEV6 = 1; * PERMANENTE;
			END; 
			IF	 ICDAS[P ,M] IN(6) THEN DO;
				 PC_ICDAS_J_SEV6 = 1; * JUNTOS;
			END;

			***;
			/*IF	SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') 
				AND (ICDAS[P, M] IN(2, 3, 4, 5, 6) OR COP[P, M] IN('1', '2')) THEN DO;
				PC_COP_ICDAS_T = 1; * TEMPORALES;
			END;

			IF	SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') 
				AND (ICDAS[P, M] IN(2, 3, 4, 5, 6) OR COP[P, M] IN('B', 'C')) THEN DO;
				PC_COP_ICDAS_P = 1; * PERMANENTE;
			END;

			IF	(ICDAS[P, M] IN(2, 3, 4, 5, 6) OR COP[P, M] IN('B', 'C', '1', '2')) THEN DO;
				PC_COP_ICDAS_J = 1; * JUNTOS;
			END;*/
			
			***;
			IF	SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8')
				AND COP[P ,M]	IN('B', 'C', 'D', 'E') THEN DO;
				EC_COP_T = 1; * TEMPORALES;
			END;

			IF	SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4')
				AND COP[P ,M]	IN('1', '2', '3', '4') THEN DO;
				EC_COP_P = 1; * PERMANENTE;
			END;

			IF	COP[P ,M]	IN('B', 'C', 'D', 'E', '1', '2', '3', '4') THEN DO;
				EC_COP_J = 1; * JUNTOS;
			END;

			***;
			IF ICDAS[P, M] IN(2, 3, 4, 5, 6) OR COP[P, M] IN('B', 'C', 'D', 'E')
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO; 
				EC_COP_ICDAS_T = 1; * TEMPORALES;
			END;

			IF ICDAS[P, M] IN(2, 3, 4, 5, 6) OR COP[P, M] IN('1', '2', '3', '4')
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO; 
				EC_COP_ICDAS_P = 1; * PERMANENTE;
			END;

			IF ICDAS[P, M] IN(2, 3, 4, 5, 6) OR COP[P, M] IN('B', 'C', 'D', 'E', '1', '2', '3', '4') 
				THEN DO; 
				EC_COP_ICDAS_J = 1; * JUNTOS;
			END;

			***;
			IF COP[P, M] IN('A', 'F') 
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;		
				IDS_POR_COP_T = 1; * TEMPORALES;
				
				IDS_PRO_COP_T + 1; * TEMPORALES;
			END;

			IF COP[P ,M] IN('0', '6') 
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;		
				IDS_POR_COP_P = 1; * PERMANENTE;
				
				IDS_PRO_COP_P + 1; * PERMANENTE;
			END;

			IF COP[P ,M] IN('A', '0', 'F', '6')  THEN DO;		
				IDS_POR_COP_J = 1; * JUNTOS;
				
				IDS_PRO_COP_J + 1; * JUNTOS;
			END;
			
			***;
			IF COP[P, M] IN('F') 
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;		
				SELL_POR_T = 1; * TEMPORALES;
				
				SELL_PRO_T + 1; * TEMPORALES;
			END;

			IF COP[P ,M] IN('6') 
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;		
				SELL_POR_P = 1; * PERMANENTE;
				
				SELL_PRO_P + 1; * PERMANENTE;
			END;

			IF COP[P ,M] IN('F', '6')  THEN DO;		
				SELL_POR_J = 1; * JUNTOS;
				
				SELL_PRO_J + 1; * JUNTOS;
			END;
			
			***;
			IF	COP[P, M] IN('B', 'C')
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				IDC_COP_T + 1; * TEMPORALES;
			END;

			IF	COP[P, M] IN('1', '2')
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				IDC_COP_P + 1; * PERMANENTE;
			END;

			IF	COP[P, M] IN('B', 'C', '1', '2') THEN DO;
				IDC_COP_J + 1; * JUNTOS;
			END;

			***;
			IF	ICDAS[P, M] IN(2, 3, 4, 5, 6) 
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				IDC_ICDAS_T + 1; * TEMPORALES;
			END;

			IF	ICDAS[P, M] IN(2, 3, 4, 5, 6) 
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				IDC_ICDAS_P + 1; * PERMANENTE;
			END;

			IF	ICDAS[P, M] IN(2, 3, 4, 5, 6) THEN DO;
				IDC_ICDAS_J + 1; * JUNTOS;
			END;

			***;

			IF	ICDAS[P, M] IN(2)
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				IDC_LT_ICDAS_T + 1; * TEMPORALES;
			END;

			IF	ICDAS[P, M] IN(2) 
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				IDC_LT_ICDAS_P + 1; * PERMANENTE;
			END;

			IF	ICDAS[P, M] IN(2) THEN DO;
				IDC_LT_ICDAS_J + 1; * JUNTOS;
			END;

			***;
			/*IF (COP[P, M] IN('B', 'C') OR ICDAS[P, M] IN(2, 3, 4, 5, 6))  
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8')  
				THEN DO; 
				IDC_COP_ICDAS_T + 1; * TEMPORALES;
			END;

			IF (COP[P, M] IN('1', '2') OR ICDAS[P, M] IN(2, 3, 4, 5, 6))   
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') 
				THEN DO; 
				IDC_COP_ICDAS_P + 1; * PERMANENTE;
			END;

			IF (COP[P, M] IN('B', 'C', '1', '2') OR ICDAS[P, M] IN(2, 3, 4, 5, 6))   
				THEN DO; 
				IDC_COP_ICDAS_J + 1; * JUNTOS;
			END;*/

			***;
			IF (ICDAS[P, M] IN(2, 3, 4, 5, 6) AND COP[P, M] NOT IN('B', 'C', 'D', 'E'))  
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8')  
				THEN DO; 
				/*IDC_ICDAS_SCOP_T + 1; * TEMPORALES;
				PC_ICDAS_SCOP_T  = 1;*/
				IDC_COP_ICDAS_T + 1; * TEMPORALES;
				PC_COP_ICDAS_T = 1; * TEMPORALES;
			END;

			IF (ICDAS[P, M] IN(2, 3, 4, 5, 6) AND COP[P, M] NOT IN('1', '2', '3', '4'))   
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') 
				THEN DO; 
				/*IDC_ICDAS_SCOP_P + 1; * PERMANENTE;
				PC_ICDAS_SCOP_P  = 1;*/
				IDC_COP_ICDAS_P + 1; * TEMPORALES;
				PC_COP_ICDAS_P  = 1; * TEMPORALES;
			END;

			IF (ICDAS[P, M] IN(2, 3, 4, 5, 6) AND 
				COP[P, M] NOT IN('B', 'C', 'D', 'E', '1', '2', '3', '4'))   
				THEN DO; 
				/*IDC_ICDAS_SCOP_J + 1; * JUNTOS;
				PC_ICDAS_SCOP_J  = 1;*/
				IDC_COP_ICDAS_J + 1; * TEMPORALES;
				PC_COP_ICDAS_J  = 1; * TEMPORALES;
			END;
			
			***;
			IF COP[P, M] IN('D')
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				IDO_POR_COP_T = 1; * TEMPORALES;
				IDO_PRO_COP_T + 1; * TEMPORALES;
			END;

			IF COP[P, M] IN('3')
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				IDO_POR_COP_P = 1; * PERMANENTE;
				IDO_PRO_COP_P + 1; * PERMANENTE;
			END;

			IF COP[P, M] IN('D', '3') THEN DO;
				IDO_POR_COP_J = 1; * JUNTOS;
				IDO_PRO_COP_J + 1; * JUNTOS;
			END;

			***;
			IF COP[P, M] IN('E')
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				IDP_POR_COP_T = 1; * TEMPORALES;
				IDP_PRO_COP_T + 1; * TEMPORALES;
			END;

			IF COP[P, M] IN('4')
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				IDP_POR_COP_P = 1; * PERMANENTE;
				IDP_PRO_COP_P + 1; * PERMANENTE;
			END;

			IF COP[P, M] IN('E', '4') THEN DO;
				IDP_POR_COP_J = 1; * JUNTOS;
				IDP_PRO_COP_J + 1; * JUNTOS;
			END;

			***;
			IF	 ICDAS[P ,M] IN(2) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				 IDC_ICDAS_T_SEV2 + 1; * TEMPORALES;
			END;
			IF	 ICDAS[P ,M] IN(2) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				 IDC_ICDAS_P_SEV2 + 1; * PERMANENTE;
			END;
			IF	 ICDAS[P ,M] IN(2) THEN DO;
				 IDC_ICDAS_J_SEV2 + 1; * JUNTOS;
			END;
			IF	 ICDAS[P ,M] IN(3) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				 IDC_ICDAS_T_SEV3 + 1; * TEMPORALES;
			END;
			IF	 ICDAS[P ,M] IN(3) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				 IDC_ICDAS_P_SEV3 + 1; * PERMANENTE;
			END;
			IF	 ICDAS[P ,M] IN(3) THEN DO;
				 IDC_ICDAS_J_SEV3 + 1; * JUNTOS;
			END;
			IF	 ICDAS[P ,M] IN(4) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				 IDC_ICDAS_T_SEV4 + 1; * TEMPORALES;
			END;
			IF	 ICDAS[P ,M] IN(4) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				 IDC_ICDAS_P_SEV4 + 1; * PERMANENTE;
			END;
			IF	 ICDAS[P ,M] IN(4) THEN DO;
				 IDC_ICDAS_J_SEV4 + 1; * JUNTOS;
			END;
			IF	 ICDAS[P ,M] IN(5) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				 IDC_ICDAS_T_SEV5 + 1; * TEMPORALES;
			END;
			IF	 ICDAS[P ,M] IN(5) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				 IDC_ICDAS_P_SEV5 + 1; * PERMANENTE;
			END;
			IF	 ICDAS[P ,M] IN(5) THEN DO;
				 IDC_ICDAS_J_SEV5 + 1; * JUNTOS;
			END;
			IF	 ICDAS[P ,M] IN(6) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				 IDC_ICDAS_T_SEV6 + 1; * TEMPORALES;
			END;
			IF	 ICDAS[P ,M] IN(6) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				 IDC_ICDAS_P_SEV6 + 1; * PERMANENTE;
			END; 
			IF	 ICDAS[P ,M] IN(6) THEN DO;
				 IDC_ICDAS_J_SEV6 + 1; * JUNTOS;
			END;

			***; 
			IF COP[P, M] IN('B', 'C', 'D', 'E')
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				CPO_D_T + 1; * TEMPORALES;
			END;

			IF COP[P, M] IN('1', '2', '3', '4')
				 AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				CPO_D_P + 1; * PERMANENTE;
			END;

			IF COP[P, M] IN('B', 'C', 'D', 'E', '1', '2', '3', '4') THEN DO;
				CPO_D_J + 1; * JUNTOS;
			END;

			***;
			IF (COP[P, M] IN('B', 'C', 'D', 'E') OR ICDAS[P, M] IN(2, 3, 4, 5, 6))
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				CPO_D_MOD_T + 1; * TEMPORALES;
			END;

			IF (COP[P, M] IN('1', '2', '3', '4') OR ICDAS[P, M] IN(2, 3, 4, 5, 6))
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				CPO_D_MOD_P + 1; * PERMANENTE;
			END;

			IF COP[P, M] IN('B', 'C', 'D', 'E', '1', '2', '3', '4') OR ICDAS[P, M] IN(2, 3, 4, 5, 6) THEN DO;
				CPO_D_MOD_J + 1; * JUNTOS;
			END;

			***;
			IF COP[P, M] IN('5') AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				PDPC_P + 1; * PERMANENTE;
			END;
			
			***;
			IF COP[P, M] IN('0', '1', '2', '3', '6', '7') AND
				SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				DIE_BOCAP + 1;
			END;
			
			IF COP[P, M] IN('A', 'B', 'C', 'D', 'F', 'G') AND
				SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				DIE_BOCAT + 1;
			END;
			
			IF COP[P, M] IN('0', '1', '2', '3', '6', '7',
							'A', 'B', 'C', 'D', 'F', 'G') THEN DO;
				DIE_BOCAJ + 1;
			END;
			
		************ EDENTULISMO;
			IF COP[P, M] IN('4', '5') AND 
				SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				ED_P = 1;
				IDA_P + 1;
			END;
			************ OPACIDAD;
			IF OPAC[P, M] IN(7, 8) THEN DO;
				POE = 1;
				POE_C + 1;
				IF OPAC[P, M] IN(7) THEN POE_7 + 1;
				IF OPAC[P, M] IN(8) THEN POE_8 + 1;
				
				IF M IN(1, 2, 3) 		THEN DO;
					POE_IC = 1;
					POE_IC_C + 1;
					IF OPAC[P, M] IN(7) THEN POE_IC_7 + 1;
					IF OPAC[P, M] IN(8) THEN POE_IC_8 + 1;
				END;
				IF M IN(4, 5, 6, 7, 8) 	THEN DO;
					POE_MP = 1;
					POE_MP_C + 1;
					IF OPAC[P, M] IN(7) THEN POE_MP_7 + 1;
					IF OPAC[P, M] IN(8) THEN POE_MP_8 + 1;
				END;
			END;
	
		END;
	END;
	
	IF DIE_BOCAP >= 21 THEN PDF = 1;

	**************************************************ICF
	*** Índice Comunitario de Fluorosis
	*** el cálculo para la población corresponde a el 
		promedio con las ponderaciones dadas por los expertos;

	****************************************************************** FORMULA 121;
	PFE = 0;
	****************************************************************** FORMULA 124;
	/*PDSF = 0;
	PDCF = 0;
	PDFD = 0;
	PDFML = 0;
	PDFL = 0;
	PDFM = 0;*/
	PDFS = 0;
	
	DIENTE_FLUO = 0;
	****************************************************************** FORMULA 125;
	DEAN_III = 0;
	PFE_III  = 0;
	PDF_III  = 0;
	
	DIENTE_FLUO_III = 0;
	
	***** VARIABLES A USAR:
	*** Para el cálculo del ICF a partir de la información recolectada del
		maxilar superior MB_313A -- MB_313J
		maxilar inferior (inferior a partir de 2014)
	*** Valor reportado por el odóntologo Índice Dean MB_314;
	
	* * * * * vicm2;
	ARRAY vicm {2, 2, 5}
		 MB_313e MB_313d MB_313c MB_313b MB_313a
		 MB_313f MB_313g MB_313h MB_313i MB_313j
		 MB_313p MB_313q MB_313r MB_313s MB_313t
		 MB_313o MB_313n MB_313m MB_313l MB_313k
			;  * * VALORES DE FLUOROSIS DENTAL POR DIENTE;

	ARRAY pa {2, 5}
		 P11 P12 P13 P14 P15
		 P21 P22 P23 P24 P25
			;  * * VALOR MÍNIMO EN LA PAREJA;

	ARRAY MP {6} MP11 MP12 MP13 MP14 MP15 MP16;  * * VALOR MAXÍMO DE LA PAREJA;

	ARRAY DISTR {2, 0:5}
		PDSF PDFD PDFML PDFL PDFM PDFS
		D20 D21 D22 D23 D24 D25
			;  * * DISTRIBUCIÓN DE VALORES VÁLIDOS -> MODA;

	ARRAY ICF  {2} ICF_S  ICF_I (2 * 0); * * VALOR DEL ÍNDICE COMUNITARIO DE FLUOROSIS POR MANDIBULA;
	ARRAY MODA {2} MODA_S MODA_I (2 * 0);  * * MODA EN LA MANDIBULA;
	ARRAY MAXI {2} MAX_S MAX_I (2 * 0);  * * VALOR MÁXIMO EN LA MANDIBULA;
	ARRAY DP {2} DP_S DP_I (2 * 0);  * * CANTIDAD DE PAREJAS CON DIFERENCIAS MAYORES A 1;
	ARRAY PD {2} PD_S PD_I (2 * 0);  * * CANTIDAD DE PAREJAS DISPAREJAS;
	ARRAY NONA {2} NONA_S NONA_I (2 * 0); * * CANTIDAD DE DIENTES SIN VALOR;
	ARRAY ESP {2} ESP_S ESP_I (2 * 0);  * * CANTIDAD REPORTADA COMO ESPEJO;

	DO I = 1 TO 2;  * * MAXILAR 1 = SUPERIOR, 2 = INFERIOR;
		
		DO L = 1 TO DIM(VICM, 3); * * CANTIDAD DE PAREJAS (5 AÑOS = 5, 12 Y 15 AÑOS = 6);
			
			DO J = 1 TO DIM(VICM, 2); * * CUADRANTE EN EL QUE SE UBICA EL DIENTE SIGUIENDO NOMENCLATURA FDI;
				IF VICM[I, J, L] NOT IN(., 8, 9) THEN DO;
					MAXI[I] = MAX(MAXI[I], VICM[I, J, L]);  * * MÁXIMO VALOR REPORTADO EN EL MAXILAR;

					DISTR[I, VICM[I, J, L]] + 1;  * *CALCULANDO FRECUENCIAS ABSOLUTAS DE VALORES EN EL MAXILAR;
					
					IF L IN(1,2,3,5) AND I = 1 THEN DO;
						DIENTE_FLUO_III + 1;
						IF VICM[I, J, L] IN(1,2,3,4,5) THEN DO;
							PDF_III + 1;
							PFE_III = 1;
						END;
					END;
				END;
				ELSE NONA[I] + 1;  * * CONTEO DE VALORES AUSENTES REPORTADOS EN EN EL MAXILAR;
				
			END;

			SELECT;
				WHEN (VICM[I, 1, L] NOT IN(., 8, 9) AND VICM[I, 2, L] NOT IN(., 8, 9)) DO; 
					PA[I, L] = MIN(VICM[I, 1, L], VICM[I, 2, L]); * * VALOR MÍNIMO REPORTADO EN LA PAREJA;
					MP[L] = MAX(VICM[I, 1, L], VICM[I, 2, L]); * * VALOR MÁXIMO REPORTADO EN LA PAREJA;
					
					IF ABS(VICM[I, 1, L] - VICM[I, 2, L]) > 1 THEN DP[I] + 1;  * * CONTEO DE PAREJAS CON DIFERENCIAS MAYORES A 1;
					IF VICM[I, 1, L] = VICM[I, 2, L] THEN ESP[I] + 1;  * * CONTEO DE PAREJAS REPORTADAS COMO ESPEJO;

					IF MAXI[I] = VICM[I, 1, L] OR MAXI[I] = VICM[I, 2, L]
						THEN ICF[I] = MAX(ICF[I], PA[I, L]); * * CÁLCULO DEL ICF PARA EL MAXILAR, 
						
							EN TODAS LAS PAREJAS QUE TENGAN REPORTADO EL MÁXIMO SE DEJA EL MÁXIMO DE LOS MÍNIMOS EN LAS PAREJAS;
							
				END;
				WHEN (VICM[I, 1, L]     IN(., 8, 9) AND VICM[I, 2, L] NOT IN(., 8, 9)) DO;
					PD[I] + 1;  * * CONTEO DE DIENTES SIN PAREJAS;
					PA[I, L] = VICM[I, 2, L]; * * VALOR MÍNIMO REPORTADO EN LA PAREJA;
					MP[L] = VICM[I, 2, L]; * * VALOR MÁXIMO REPORTADO EN LA PAREJA;
					
					IF MAXI[I] = VICM[I, 2, L]
						THEN ICF[I] = MAX(ICF[I], PA[I, L]); * * CÁLCULO DEL ICF PARA EL MAXILAR; 
				END;
				WHEN (VICM[I, 1, L] NOT IN(., 8, 9) AND VICM[I, 2, L]     IN(., 8, 9)) DO;
					PD[I] + 1;  * * CONTEO DE DIENTES SIN PAREJAS;
					PA[I, L] = VICM[I, 1, L]; * * VALOR MÍNIMO REPORTADO EN LA PAREJA;
					MP[L] = VICM[I, 1, L]; * * VALOR MÁXIMO REPORTADO EN LA PAREJA;
					
					IF MAXI[I] = VICM[I, 1, L]
						THEN ICF[I] = MAX(ICF[I], PA[I, L]); * * CÁLCULO DEL ICF PARA EL MAXILAR; 
				END;
				WHEN (VICM[I, 1, L] = VICM[I, 2, L])
					ESP[I] + 1;  * CONTEO DE PAREJAS REPORTADAS COMO ESPEJO EN VALORES AUSENTE;
				OTHERWISE ESP[I] + 0;
			END;
		END;
		
		IF NONA[I] NE DIM(VICM, 3) * 2 THEN DO;
			MAXD = 0; * * CÁLCULO DEL VALOR MODAL, EN CASO DE EMPATE SE DEJA EL MÁS ALTO;
			DO K = 0 TO 5;
				MAXD = MAX(MAXD, DISTR[I, K]);
				IF DISTR[I, K] = MAXD THEN MODA[I] = K;	
			END;
		END;
		ELSE IF  NONA[I] = DIM(VICM, 3) * 2 THEN DO; * * SI NO HAY DIENTES REPORTADOS SE DEJA COMO AUSENTE EL CÁLCULO DEL ICF;
			MODA[I] = .;
			ICF[I] = .;
			MAXI[I] = .;
			DP[I] = .;
			PD[I] = .;
			ESP[I] = .;
		END;
	END;
	
	IF MP11 NE . OR MP12 NE . OR MP13 NE . OR MP15 NE . THEN DO;
		MAXIII = MAX(MP11, MP12, MP13, MP15);
		MINIII = MIN(MP11, MP12, MP13, MP15);
		
		IF MAXIII = MINIII THEN DEAN_III = MAXIII;
		ELSE DO;
			DEAN_III = 0;
			DO L= 1, 2, 3, 5;
				IF MP[L] NE . AND MP[L] NE MAXIII THEN DEAN_III = MAX(DEAN_III, MP[L]);
			END;
		END;
	END;
	
	*0     1    2     3    4   5;
	*PDSF PDFD PDFML PDFL PDFM PDFS;
	IF PDFML > 0 OR PDFL > 0 OR PDFM > 0 OR PDFS > 0 THEN DO;
		PFE = 1;
	END;
	ELSE DO;
		PFE = 0;
	END;

	IF PDFD > 0 OR PDFML > 0 OR PDFL > 0 OR PDFM > 0 OR PDFS > 0 THEN DO;
		PDCF = SUM(PDFD, PDFML, PDFL, PDFM, PDFS);
	END;
	ELSE DO;
		PDCF = 0;
	END;
	
	IF PDSF > 0 OR PDFD > 0 OR PDFML > 0 OR PDFL > 0 OR PDFM > 0 OR PDFS > 0 THEN 
		DIENTE_EVAL = SUM(PDSF, PDFD, PDFML, PDFL, PDFM, PDFS);
	ELSE DIENTE_EVAL = 0;
	
	IF PDFD > 0 OR PDFML > 0 OR PDFL > 0 OR PDFM > 0 OR PDFS > 0 THEN DO;
		DIENTE_FLUO = SUM(PDFD, PDFML, PDFL, PDFM, PDFS);
		PFEA = 1;
	END;
	ELSE DO;
		DIENTE_FLUO = 0;
		PFEA = 0;
	END;

			* * ASIGNACIÓN DE LAS PONDERACIONES PARA EL CÁLCULO DEL ICF EN AGREGADOS;
	SELECT;
		WHEN (ICF_S = 0) ICF_PAR = &K0_FLU;
		WHEN (ICF_S = 1) ICF_PAR = &K1_FLU;
		WHEN (ICF_S = 2) ICF_PAR = &K2_FLU;
		WHEN (ICF_S = 3) ICF_PAR = &K3_FLU;
		WHEN (ICF_S = 4) ICF_PAR = &K4_FLU;
		WHEN (ICF_S = 5) ICF_PAR = &K5_FLU;
		OTHERWISE        ICF_PAR = .;
	END;

	SELECT;
		WHEN (MB_314 = 0) ICF_DEAN = &K0_FLU;
		WHEN (MB_314 = 1) ICF_DEAN = &K1_FLU;
		WHEN (MB_314 = 2) ICF_DEAN = &K2_FLU;
		WHEN (MB_314 = 3) ICF_DEAN = &K3_FLU;
		WHEN (MB_314 = 4) ICF_DEAN = &K4_FLU;
		WHEN (MB_314 = 5) ICF_DEAN = &K5_FLU;
		OTHERWISE         ICF_DEAN = .;
	END;
	OUTPUT;
	
	
	********************* erosion;
	IF MB_315A IN(1,2,3) THEN PED = 1; ELSE PED = 0;
	

	* * REINICIALIZA CONTADORES PARA EL SIGUIENTE REGISTRO;

	DO I = 1 TO 2;
		DO K = 0 TO 5;
			DISTR[I, K] = 0;
		END;
		MAXI[I] = 0;
		PD[I] = 0;
		DP[I] = 0;
		ICF[I] = 0;
		NONA[I] = 0;
		ESP[I] = 0;
	END; 	
RUN;

PROC UNIVARIATE DATA = M4_EXAMEN_2 NOPRINT;
	VAR	CPO_D_T;
	OUTPUT OUT = PERCENTILT_2
		PCTLPTS  = 66
		PCTLPRE  = QCOP_T
  		PCTLNAME = P;
   BY M4_104;
   WEIGHT Fex_fin;
   WHERE PERMANENTES = 0 & TEMPORALES > 0; 
RUN;
PROC UNIVARIATE DATA = M4_EXAMEN_2 NOPRINT;
	VAR	CPO_D_P;
	OUTPUT OUT = PERCENTILP_2
		PCTLPTS  = 66
		PCTLPRE  = QCOP_P
  		PCTLNAME = P;
   BY M4_104;
   WEIGHT Fex_fin;
   WHERE PERMANENTES > 0 & TEMPORALES = 0; 
RUN;
PROC UNIVARIATE DATA = M4_EXAMEN_2 NOPRINT;
	VAR	CPO_D_J;
	OUTPUT OUT = PERCENTILJ_2
		PCTLPTS  = 66
		PCTLPRE  = QCOP_J
  		PCTLNAME = P;
   BY M4_104;
   WEIGHT Fex_fin;
   WHERE PERMANENTES > 0 & TEMPORALES > 0; 
RUN;

DATA M4_EXAMEN_2;
	MERGE M4_EXAMEN_2 
		PERCENTILP_2 PERCENTILT_2 PERCENTILJ_2;
	BY M4_104;

	IF M4_104 = 5 THEN DO;
		IF TEMPORALES > 0 AND PERMANENTES = 0 AND
			CPO_D_T >= QCOP_TP THEN DO;
			ISC_T = CPO_D_T;
			ISC_T_DEN = 1;
		END;
		ISC_P_DEN = .;
		IF TEMPORALES > 0 AND PERMANENTES > 0 AND
			CPO_D_J >= QCOP_JP THEN DO;
			ISC_J = CPO_D_J;
			ISC_J_DEN = 1;
		END;	
	END;
	
	DROP P M I L J K;
RUN;
/**************************************************************************************************
* * EVALUACIÓN CLÍNICA A JÓVENES DE 12 Y 15 AÑOS
**************************************************************************************************/
DATA M4_EXAMEN_3;
	SET IN.M4_EXAMEN_3;

	* * * * * DIEEVAL3;
	ARRAY DIEEVAL {4, 7}
		 MC_D7 MC_D6 MC_D5 MC_D4 MC_D3 MC_D2 MC_D1
		 MC_D8 MC_D9 MC_D10 MC_D11 MC_D12 MC_D13 MC_D14
		 MC_D22 MC_D23 MC_D24 MC_D25 MC_D26 MC_D27 MC_D28
		 MC_D21 MC_D20 MC_D19 MC_D18 MC_D17 MC_D16 MC_D15
	;
	**************************************************CARIES
	*** PC= Prevalencia Caries;

	****************************************************************************************** FORMULA 1
    ** Variables a usar: MA_305A -- MA_305J MA_307A -- MA_307J
	*** PC_COP_ = "Prevalencia de caries en COP"
		VALORES 1+2 Ó B+C;
    PC_COP_T = 0; * TEMPORALES;
	PC_COP_P = 0; * PERMANENTES;
	PC_COP_J = 0; * JUNTOS;

	****************************************************************************************** FORMULA 2
	*** PC_ICDAS_ = "Prevalencia de caries en ICDAS"
		VALORES  2, 3, 4, 5 o 6;
    PC_ICDAS_T = 0; * TEMPORALES;
	PC_ICDAS_P = 0; * PERMANENTES;
	PC_ICDAS_J = 0; * JUNTOS;

	****************************************************************************************** FORMULA 3
	*** PC_ICDAS_V_SEV = "Por niveles de severidad a partir de ICDAS"
		VALORES  2, 3, 4, 5 y 6
	*** VALORES  2;
	PC_ICDAS_T_SEV2 = 0; * TEMPORALES;
	PC_ICDAS_P_SEV2 = 0; * PERMANENTES;
	PC_ICDAS_J_SEV2 = 0; * JUNTOS;

	*** VALORES  3;
	PC_ICDAS_T_SEV3 = 0; * TEMPORALES;
	PC_ICDAS_P_SEV3 = 0; * PERMANENTES;
	PC_ICDAS_J_SEV3 = 0; * JUNTOS;

	*** VALORES  4;
	PC_ICDAS_T_SEV4 = 0; * TEMPORALES;
	PC_ICDAS_P_SEV4 = 0; * PERMANENTES;
	PC_ICDAS_J_SEV4 = 0; * JUNTOS;

	*** VALORES  5;
	PC_ICDAS_T_SEV5 = 0; * TEMPORALES;
	PC_ICDAS_P_SEV5 = 0; * PERMANENTES;
	PC_ICDAS_J_SEV5 = 0; * JUNTOS;

	*** VALORES 6;
	PC_ICDAS_T_SEV6 = 0; * TEMPORALES;
	PC_ICDAS_P_SEV6 = 0; * PERMANENTES;
	PC_ICDAS_J_SEV6 = 0; * JUNTOS;

	****************************************************************************************** FORMULA 4
	PC= % personas con COP (1 o 2) o ICDAS (2, 3, 4, 5 o 6)  
	PC= % personas con COP (B o C) o ICDAS (2, 3, 4, 5 o 6)  ;
	PC_COP_ICDAS_T = 0; * TEMPORALES;
	PC_COP_ICDAS_P = 0; * PERMANENTES;
	PC_COP_ICDAS_J = 0; * JUNTOS;

	****************************************************************************************** FORMULA 5
	EC_COP_ = "Experiencia de caries en COP"
	VALORES (1, 2, 3 o 4) o (B, C, D o E);
	EC_COP_T = 0; * TEMPORALES;
	EC_COP_P = 0; * PERMANENTES;
	EC_COP_J = 0; * JUNTOS;

	****************************************************************************************** FORMULA 2
	
	****************************************************************************************** FORMULA 6
	EC = % personas con COP (1, 2, 3 o 4) o ICDAS (2, 3, 4, 5 o 6)  
	EC = % personas con COP (B, C, D o E) o ICDAS (2, 3, 4, 5 o 6);
	EC_COP_ICDAS_T = 0; * TEMPORALES;
	EC_COP_ICDAS_P = 0; * PERMANENTES;
	EC_COP_ICDAS_J = 0; * JUNTOS; 

	****************************************************************************************** FORMULA 7
	IDS = "Índice de dientes sanos"
	IDS = % personas con 0 ó A;
	IDS_POR_COP_T = 0; * TEMPORALES;
	IDS_POR_COP_P = 0; * PERMANENTES;
	IDS_POR_COP_J = 0; * JUNTOS;
	****************************************************************************************** FORMULA 8
	IDS = % suma 0/n;
	IDS_PRO_COP_T = 0; * TEMPORALES;
	IDS_PRO_COP_P = 0; * PERMANENTES;
	IDS_PRO_COP_J = 0; * JUNTOS;
	****************************************************************************************** FORMULA 9
	IDC = "Índice de dientes cariados"
	IDC= suma 1 + 2/n, IDC= suma B + C/n;
	IDC_COP_T = 0; * TEMPORALES;
	IDC_COP_P = 0; * PERMANENTES;
	IDC_COP_J = 0; * JUNTOS;

	****************************************************************************************** FORMULA 10
	IDC= suma 2+3+4+5+6/n;
	IDC_ICDAS_T = 0; * TEMPORALES;
	IDC_ICDAS_P = 0; * PERMANENTES;
	IDC_ICDAS_J = 0; * JUNTOS;

	*IDC= suma 2+3/n (lesiones tempranas);
	IDC_LT_ICDAS_T = 0; * TEMPORALES;
	IDC_LT_ICDAS_P = 0; * PERMANENTES;
	IDC_LT_ICDAS_J = 0; * JUNTOS;
	****************************************************************************************** FORMULA 11
	IDC= suma COP (1 + 2) + ICDAS (2, 3) /n, IDC= suma COP (B + C) + + ICDAS (2, 3) /n;
	IDC_COP_ICDAS_T = 0; * TEMPORALES;
	IDC_COP_ICDAS_P = 0; * PERMANENTES;
	IDC_COP_ICDAS_J = 0; * JUNTOS;

	****************************************************************************************** FORMULA 11.5
	IDC= suma ICDAS (2, 3, 4, 5, 6) no COP(1,2,3,4) /n, IDC= suma COP (B + C) + + ICDAS (2, 3) /n;
	/*IDC_ICDAS_SCOP_T= 0; * TEMPORALES;
	IDC_ICDAS_SCOP_P= 0; * PERMANENTES;
	IDC_ICDAS_SCOP_J= 0; * JUNTOS;
	
	PC_ICDAS_SCOP_T = 0; * TEMPORALES;
	PC_ICDAS_SCOP_P = 0; * PERMANENTES;
	PC_ICDAS_SCOP_J = 0; * JUNTOS;*/

	****************************************************************************************** FORMULA 12
	IDO= % personas con 3 ó D;
	IDO_POR_COP_T = 0; * TEMPORALES;
	IDO_POR_COP_P = 0; * PERMANENTES;
	IDO_POR_COP_J = 0; * JUNTOS;

	****************************************************************************************** FORMULA 13
	IDO= suma 3/n ó D/n;
	IDO_PRO_COP_T = 0; * TEMPORALES;
	IDO_PRO_COP_P = 0; * PERMANENTES;
	IDO_PRO_COP_J = 0; * JUNTOS;

	****************************************************************************************** FORMULA 14
	IDP= % personas con 4 ó E;
	IDP_POR_COP_T = 0; * TEMPORALES;
	IDP_POR_COP_P = 0; * PERMANENTES;
	IDP_POR_COP_J = 0; * JUNTOS;

	****************************************************************************************** FORMULA 15
	IDP= suma 4/n ó E/n;
	IDP_PRO_COP_T = 0; * TEMPORALES;
	IDP_PRO_COP_P = 0; * PERMANENTES;
	IDP_PRO_COP_J = 0; * JUNTOS;

	****************************************************************************************** FORMULA 16
	IDC niveles de severidad = (2.3.4.5. ó 6)/n.  
	*** VALORES  2;
	IDC_ICDAS_T_SEV2 = 0; * TEMPORALES;
	IDC_ICDAS_P_SEV2 = 0; * PERMANENTES;
	IDC_ICDAS_J_SEV2 = 0; * JUNTOS;

	*** VALORES  3;
	IDC_ICDAS_T_SEV3 = 0; * TEMPORALES;
	IDC_ICDAS_P_SEV3 = 0; * PERMANENTES;
	IDC_ICDAS_J_SEV3 = 0; * JUNTOS;

	*** VALORES  4;
	IDC_ICDAS_T_SEV4 = 0; * TEMPORALES;
	IDC_ICDAS_P_SEV4 = 0; * PERMANENTES;
	IDC_ICDAS_J_SEV4 = 0; * JUNTOS;

	*** VALORES  5;
	IDC_ICDAS_T_SEV5 = 0; * TEMPORALES;
	IDC_ICDAS_P_SEV5 = 0; * PERMANENTES;
	IDC_ICDAS_J_SEV5 = 0; * JUNTOS;

	*** VALORES 6;
	IDC_ICDAS_T_SEV6 = 0; * TEMPORALES;
	IDC_ICDAS_P_SEV6 = 0; * PERMANENTES;
	IDC_ICDAS_J_SEV6 = 0; * JUNTOS;

	****************************************************************************************** FORMULA 17, 18 y 19
	Indice CPO-d apartir de COP, 
	VALORES 1,2,3 + 4/n, ó B,C,D + E/n;
	CPO_D_T = 0; * TEMPORALES; 
	CPO_D_P = 0; * PERMANENTES;
	CPO_D_J = 0; * JUNTOS;

	****************************************************************************************** FORMULA 20 y 21
	CPO-d = COP (1+2+3+4)+ ICDAS (2+3)/n ó COP (B+C+E+D)+ ICDAS (2+3)/n;
	CPO_D_MOD_T = 0; * TEMPORALES;
	CPO_D_MOD_P = 0; * PERMANENTES;
	CPO_D_MOD_J = 0; * JUNTOS;

	****************************************************************************************** FORMULA(3) 22
	ISC= Suma CPO-d 12 años tercil más afectado/ n 12 años;
	****************************************************************************************** FORMULA(2) 23
	ISC= Suma CPO-d 5 años tercil más afectado/ n 5 años;
	ISC_T = 0;
	ISC_P = 0;
	ISC_J = 0;

	****************************************************************************************** FORMULA(3) 24
	IPMPSanos = suma 0 (16+26+36+46) / n 12 años, COP;
	*IPMP_S_T = .;
	IPMP_S_P = 0;
	*IPMP_S_J = .;

	****************************************************************************************** FORMULA(3) 25
	IPMPPerdidos = suma 4 (16+26+36+46) / n 12 años, COP;
	*IPMP_P_T = .;
	IPMP_P_P = 0;
	*IPMP_P_J = .;

	****************************************************************************************** FORMULA(3) 26
	IPMPCariados = suma COP (1+2) (16+26+36+46) / n 12 años;
	*IPMP_C_T = .;
	IPMP_C_P = 0;
	*IPMP_C_J = .;

	****************************************************************************************** FORMULA(3) 27
	IPMPCariados = suma ICDAS (2+3) (16+26+36+46) / n 12 años;
	*IPMP_ICDAS_C_T = .;
	IPMP_ICDAS_C_P = 0;
	*IPMP_ICDAS_C_J = .;

	****************************************************************************************** FORMULA(3) 28
	IPMPCariados = sumar o contar los dientes con códigos COP (1 o 2) + ICDAS (2, 3, 4, 5 o 6) (16, 26, 36, 46) / n 12 años;
	*IPMP_COP_ICDAS_C_T = .;
	IPMP_COP_ICDAS_C_P = 0;
	*IPMP_COP_ICDAS_C_J = .;

	**************************************************************************	
	IPMPCariados = sumar o contar los dientes con códigos COP (1 o 2) + ICDAS (2) (16, 26, 36, 46) / n 12 años;
	IPMP_COP_ICDAS_2_C_P = 0;	


	****************************************************************************************** FORMULA(3) 29
	IPMPObturados = suma 3 (16+26+36+46) / n 12 años;
	*IPMP_O_T = .;
	IPMP_O_P = 0;
	*IPMP_O_J = .;

	****************************************************************************************** FORMULA(3) 30
	IPMPCariados severidad= suma ICDAS 2 o 3 o 4 o 5 o 6 (16+26+36+46) / n 12 años 
	(se calcula la sumatoria por cada nivel de severidad en los 1eros molares);
	*** VALORES  2;
	IPMP_ICDAS_P_SEV2 = 0; * PERMANENTES;
	
	*** VALORES  3;
	IPMP_ICDAS_P_SEV3 = 0; * PERMANENTES;
	
	*** VALORES  4;
	IPMP_ICDAS_P_SEV4 = 0; * PERMANENTES;
	
	*** VALORES  5;
	IPMP_ICDAS_P_SEV5 = 0; * PERMANENTES;
	
	*** VALORES 6;
	IPMP_ICDAS_P_SEV6 = 0; * PERMANENTES;
	
	**************************************************************************************PETICION SANDRA;
	SELL_POR_T = 0;
	SELL_POR_P = 0;
	SELL_POR_J = 0;

	SELL_PRO_T = 0;
	SELL_PRO_P = 0;
	SELL_PRO_J = 0;

	****************************************************************************************** FORMULA 15

	****************************************************************************************** FORMULA 14

	****************************************************************************************** FORMULA 31
	PDPC = suma 5 /n cada grupo de edad de 5, 12, 15, 18, 20 y más años;
	*PDPC_T = 0;
	PDPC_P = 0;
	*PDPC_J = 0;

	****************************************************************************************** FORMULA(5) 32
	IRC = suma de 1 + 2 / n, Caries radicular en personas de 35 años y más;
	*IRC_T = .;
	IRC_P = .;
	*IRC_J = .;

	****************************************************************************************** FORMULA(5) 33
	IRO = suma de 3 / n;
	*IRO_T = .;
	IRO_P = .;
	*IRO_J = .;

	****************************************************************************************** FORMULA(5) 34
	IROC = suma de 3 + 1 + 2 / n;
	*IROC_T = .;
	IROC_P = .;
	*IROC_J = .;

	****************************************************************************************** FORMULA(5) 35
	PCR= % personas con 1 o 2;
	*PCR_T = .;
	PCR_P = .;
	*PCR_J = .;

	****************************************************************************************** FORMULA(5) 
	PADB 28 = % personas con 28 dientes en boca (0,1,2,3,6,7);
	*PADB_28_T = .;
	DIE_BOCAP = 0;
	DIE_BOCAT = 0;
	DIE_BOCAJ = 0;

	****************************************************************************************** FORMULA 44
	PDF= % personas > 21 dientes / n;
	PDF = 0;
	
	PAATD_P = 0;
	PADB_28_P = 0;
	PADB_M_20_P = 0; * PADB < 20 = % personas con < 20 dientes en boca (0,1,2,3,6,7);
	
	*******************************************************************************************
	. Parcialmente edéntulo (PE)
   . Tramo posterior: (PETP)
       Inferior: (PETPI)
         Derecho:  (PETPID (47, 46, 45, 44))                           
         Izquierdo: (PETPII (37, 36, 35, 34))                           
      Superior: (PETPS):                                 
         Derecho:  (PETPSD (17, 16, 15, 14))                         
         Izquierdo: (PETPSI (27, 26, 25, 24))                                                             
    . Tramo anterior: (PETA) 
       Inferior: (PETAI  (43, 42, 41, 31, 32, 33))                                                                                        
       Superior: (PETAS (13, 12, 11, 21, 22, 23));
	PETPID_POR = 0;
	PETPID_PRO = 0;
	PETPII_POR  = 0;
	PETPII_PRO  = 0;
	PETPSD_POR  = 0;
	PETPSD_PRO  = 0;
	PETPSI_POR  = 0;
	PETPSI_PRO  = 0;
	PETAI_POR  = 0;
	PETAI_PRO  = 0;
	PETAS_POR  = 0;
	PETAS_PRO  = 0; 
	
	PETPID_EVAL = 0;
	PETPID_TE = 0;
	PETPII_EVAL  = 0;
	PETPII_TE  = 0;
	PETPSD_EVAL  = 0;
	PETPSD_TE  = 0;
	PETPSI_EVAL  = 0;
	PETPSI_TE  = 0;
	PETAI_EVAL  = 0;
	PETAI_TE  = 0;
	PETAS_EVAL  = 0;
	PETAS_TE  = 0; 

	****************************************************************************************** FORMULA 36
	Edéntulismo parcial PE= % personas edéntulas parciales con códigos 4 o 5 en uno o varios dientes;

	****************************************************************************************** FORMULA 37
	Tramo posterior PET= % personas parcialmente edéntulas en los tramos posteriores derecho y/o izquierdo/ n 
	para maxilar superior, maxilar inferior, maxilares superior e inferior simultáneo
	Tramo Anterior PET = % personas parcialmente edéntulas en el tramo anterior  / n 
	para maxilar superior, maxilar inferior, maxilares superior e inferior simultáneo;


	****************************************************************************************** FORMULA 38
	Dientes ausentes por tramo DAT= sumar o contar los dientes con códigos 4 o 5 por tramo / n;


	****************************************************************************************** FORMULA 39
	Edentulismo total ET= % personas con 4 o 5 en todos los dientes / n;

	****************************************************************************************** FORMULA 40
	PADB por rango= % personas por rango optimo o adecuado o satisfactoria o mínima
	o no funcional o ausencia total (0,1,2,3,6,7) / n;

	****************************************************************************************** FORMULA 43
	IDA= sumar los dientes ausentes / n,  COP(4,5);
	IDA_P = 0;

	****************************************************************************************** FORMULA(5) 
	PAATD = % personas con 4 o 5 en todos los dientes, en esta parte se usa como cantidad de dientes perdidos para DAI;
	*PAATD_T = .;

	****************************************************************************************** FORMULA 39
	Edéntulismo parcial= % personas edéntulas parciales con códigos 4 o 5 en uno o varios dientes;
	ED_P = 0;
	
	* * dientes incisios caninos premolares y perdidos;
	ED_DAI = 0;
	
	****************************************************************************************** FORMULA 42
	IIP= sumar los implantes 7 y (4, 45) / n;
	IIP = 0;
	
	****************************************************************************************** FORMULA 44
	PDF= % personas > 21 dientes / n;
	PDF = 0;
   
 	**********OPACIDAD;
	****************************************************************************************** FORMULA 119;
	POE = 0;
	POE_IC = 0;
	POE_MP = 0;
	
	
	POE_7 = 0;
	POE_IC_7 = 0;
	POE_MP_7 = 0;
	
	POE_8 = 0;
	POE_IC_8 = 0;
	POE_MP_8 = 0;

	POE_C = 0;
	POE_IC_C = 0;
	POE_MP_C = 0;	
	
	*EDENTULISMO = 0;*DPER;
	PERMANENTES = 0;
	TEMPORALES  = 0;
	EVALUADOS   = 0;

	* * * * * ICDAS3;
	ARRAY ICDAS {4, 7}
		 MC_304g MC_304f MC_304e MC_304d MC_304c MC_304b MC_304a
		 MC_304h MC_304i MC_304j MC_304k MC_304l MC_304m MC_304n
		 MC_306h MC_306i MC_306j MC_306k MC_306l MC_306m MC_306n
		 MC_306g MC_306f MC_306e MC_306d MC_306c MC_306b MC_306a
	;
	* * * * * OPAC3;
	ARRAY OPAC {4, 7}
		 MC_304g1 MC_304f1 MC_304e1 MC_304d1 MC_304c1 MC_304b1 MC_304a1
		 MC_304h1 MC_304i1 MC_304j1 MC_304k1 MC_304l1 MC_304m1 MC_304n1
		 MC_306h1 MC_306i1 MC_306j1 MC_306k1 MC_306l1 MC_306m1 MC_306n1
		 MC_306g1 MC_306f1 MC_306e1 MC_306d1 MC_306c1 MC_306b1 MC_306a1
	;
	* * * * * cop3;
	ARRAY cop {4, 7}
		 MC_305g MC_305f MC_305e MC_305d MC_305c MC_305b MC_305a
		 MC_305h MC_305i MC_305j MC_305k MC_305l MC_305m MC_305n
		 MC_307h MC_307i MC_307j MC_307k MC_307l MC_307m MC_307n
		 MC_307g MC_307f MC_307e MC_307d MC_307c MC_307b MC_307a
	;

	DO P = 1 TO 4;
		DO M = 1 TO DIM(COP, 2);

			*IF M = 6 AND M4_104 = 12 AND COP[P, M] in( '0') AND "PERMANENTE" THEN DO;*ESTO EQUIVALENTE A 16+26+36+46;
			*IF M4_104 >= 35.......;
			IF	SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') 
				AND COP[P, M] IN('0', '1', '2', '3', '4', '5', '6', '7') THEN PERMANENTES + 1;
			IF	SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') 
				AND COP[P, M] IN('A', 'B', 'C', 'D', 'E', 'F', 'G') THEN TEMPORALES + 1;	
			IF COP[P, M] IN('0', '1', '2', '3', '4', '5', '6', '7', 
							'A', 'B', 'C', 'D', 'E', 'F', 'G') THEN EVALUADOS + 1;	

			IF	SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') 
				AND COP[P, M] IN('B', 'C') THEN DO;
				PC_COP_T = 1; * TEMPORALES;
			END;

			IF	SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') 
				AND COP[P, M] IN('1', '2') THEN DO;
				PC_COP_P = 1; * PERMANENTES;
			END;

			IF	COP[P, M] IN('B', 'C', '1', '2') THEN DO;
				PC_COP_J = 1; * JUNTOS;
			END;

			***;
			IF	SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') 
				AND ICDAS[P, M] IN(2, 3, 4, 5, 6) THEN DO;
				PC_ICDAS_T = 1; * TEMPORALES;
			END;

			IF	SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') 
				AND ICDAS[P, M] IN(2, 3, 4, 5, 6) THEN DO;
				PC_ICDAS_P = 1; * PERMANENTE;
			END;

			IF	ICDAS[P, M] IN(2, 3, 4, 5, 6) THEN DO;
				PC_ICDAS_J = 1; * JUNTOS;
			END;
	
			***;
			IF	 ICDAS[P ,M] IN(2) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				 PC_ICDAS_T_SEV2 = 1; * TEMPORALES;
			END;
			IF	 ICDAS[P ,M] IN(2) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				 PC_ICDAS_P_SEV2 = 1; * PERMANENTE;
			END;
			IF	 ICDAS[P ,M] IN(2) THEN DO;
				 PC_ICDAS_J_SEV2 = 1; * JUNTOS;
			END;
			IF	 ICDAS[P ,M] IN(3) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				 PC_ICDAS_T_SEV3 = 1; * TEMPORALES;
			END;
			IF	 ICDAS[P ,M] IN(3) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				 PC_ICDAS_P_SEV3 = 1; * PERMANENTE;
			END;
			IF	 ICDAS[P ,M] IN(3) THEN DO;
				 PC_ICDAS_J_SEV3 = 1; * JUNTOS;
			END;
			IF	 ICDAS[P ,M] IN(4) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				 PC_ICDAS_T_SEV4 = 1; * TEMPORALES;
			END;
			IF	 ICDAS[P ,M] IN(4) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				 PC_ICDAS_P_SEV4 = 1; * PERMANENTE;
			END;
			IF	 ICDAS[P ,M] IN(4) THEN DO;
				 PC_ICDAS_J_SEV4 = 1; * JUNTOS;
			END;
			IF	 ICDAS[P ,M] IN(5) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				 PC_ICDAS_T_SEV5 = 1; * TEMPORALES;
			END;
			IF	 ICDAS[P ,M] IN(5) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				 PC_ICDAS_P_SEV5 = 1; * PERMANENTE;
			END;
			IF	 ICDAS[P ,M] IN(5) THEN DO;
				 PC_ICDAS_J_SEV5 = 1; * JUNTOS;
			END;
			IF	 ICDAS[P ,M] IN(6) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				 PC_ICDAS_T_SEV6 = 1; * TEMPORALES;
			END;
			IF	 ICDAS[P ,M] IN(6) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				 PC_ICDAS_P_SEV6 = 1; * PERMANENTE;
			END; 
			IF	 ICDAS[P ,M] IN(6) THEN DO;
				 PC_ICDAS_J_SEV6 = 1; * JUNTOS;
			END;

			***;
			/*IF	SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') 
				AND (ICDAS[P, M] IN(2, 3, 4, 5, 6) OR COP[P, M] IN('1', '2')) THEN DO;
				PC_COP_ICDAS_T = 1; * TEMPORALES;
			END;

			IF	SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') 
				AND (ICDAS[P, M] IN(2, 3, 4, 5, 6) OR COP[P, M] IN('B', 'C')) THEN DO;
				PC_COP_ICDAS_P = 1; * PERMANENTE;
			END;

			IF	(ICDAS[P, M] IN(2, 3, 4, 5, 6) OR COP[P, M] IN('B', 'C', '1', '2')) THEN DO;
				PC_COP_ICDAS_J = 1; * JUNTOS;
			END;*/
			
			***;
			IF	SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8')
				AND COP[P ,M]	IN('B', 'C', 'D', 'E') THEN DO;
				EC_COP_T = 1; * TEMPORALES;
			END;

			IF	SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4')
				AND COP[P ,M]	IN('1', '2', '3', '4') THEN DO;
				EC_COP_P = 1; * PERMANENTE;
			END;

			IF	COP[P ,M]	IN('B', 'C', 'D', 'E', '1', '2', '3', '4') THEN DO;
				EC_COP_J = 1; * JUNTOS;
			END;

			***;
			IF ICDAS[P, M] IN(2, 3, 4, 5, 6) OR COP[P, M] IN('B', 'C', 'D', 'E')
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO; 
				EC_COP_ICDAS_T = 1; * TEMPORALES;
			END;

			IF ICDAS[P, M] IN(2, 3, 4, 5, 6) OR COP[P, M] IN('1', '2', '3', '4')
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO; 
				EC_COP_ICDAS_P = 1; * PERMANENTE;
			END;

			IF ICDAS[P, M] IN(2, 3, 4, 5, 6) OR COP[P, M] IN('B', 'C', 'D', 'E', '1', '2', '3', '4') 
				THEN DO; 
				EC_COP_ICDAS_J = 1; * JUNTOS;
			END;

			***;
			IF COP[P, M] IN('A', 'F') 
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;		
				IDS_POR_COP_T = 1; * TEMPORALES;
				
				IDS_PRO_COP_T + 1; * TEMPORALES;
			END;

			IF COP[P ,M] IN('0', '6') 
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;		
				IDS_POR_COP_P = 1; * PERMANENTE;
				
				IDS_PRO_COP_P + 1; * PERMANENTE;
			END;

			IF COP[P ,M] IN('A', '0', 'F', '6')   THEN DO;		
				IDS_POR_COP_J = 1; * JUNTOS;
				
				IDS_PRO_COP_J + 1; * JUNTOS;
			END;
			
			***;
			IF COP[P, M] IN('F') 
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;		
				SELL_POR_T = 1; * TEMPORALES;
				
				SELL_PRO_T + 1; * TEMPORALES;
			END;

			IF COP[P ,M] IN('6') 
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;		
				SELL_POR_P = 1; * PERMANENTE;
				
				SELL_PRO_P + 1; * PERMANENTE;
			END;

			IF COP[P ,M] IN('F', '6')  THEN DO;		
				SELL_POR_J = 1; * JUNTOS;
				
				SELL_PRO_J + 1; * JUNTOS;
			END;
			
			***;
			IF	COP[P, M] IN('B', 'C')
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				IDC_COP_T + 1; * TEMPORALES;
			END;

			IF	COP[P, M] IN('1', '2')
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				IDC_COP_P + 1; * PERMANENTE;
			END;

			IF	COP[P, M] IN('B', 'C', '1', '2') THEN DO;
				IDC_COP_J + 1; * JUNTOS;
			END;

			***;
			IF	ICDAS[P, M] IN(2, 3, 4, 5, 6) 
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				IDC_ICDAS_T + 1; * TEMPORALES;
			END;

			IF	ICDAS[P, M] IN(2, 3, 4, 5, 6) 
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				IDC_ICDAS_P + 1; * PERMANENTE;
			END;

			IF	ICDAS[P, M] IN(2, 3, 4, 5, 6) THEN DO;
				IDC_ICDAS_J + 1; * JUNTOS;
			END;

			***;

			IF	ICDAS[P, M] IN(2)
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				IDC_LT_ICDAS_T + 1; * TEMPORALES;
			END;

			IF	ICDAS[P, M] IN(2) 
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				IDC_LT_ICDAS_P + 1; * PERMANENTE;
			END;

			IF	ICDAS[P, M] IN(2) THEN DO;
				IDC_LT_ICDAS_J + 1; * JUNTOS;
			END;

			***;
			/*IF (COP[P, M] IN('B', 'C') OR ICDAS[P, M] IN(2, 3, 4, 5, 6))  
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8')  
				THEN DO; 
				IDC_COP_ICDAS_T + 1; * TEMPORALES;
			END;

			IF (COP[P, M] IN('1', '2') OR ICDAS[P, M] IN(2, 3, 4, 5, 6))   
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') 
				THEN DO; 
				IDC_COP_ICDAS_P + 1; * PERMANENTE;
			END;

			IF (COP[P, M] IN('B', 'C', '1', '2') OR ICDAS[P, M] IN(2, 3, 4, 5, 6))   
				THEN DO; 
				IDC_COP_ICDAS_J + 1; * JUNTOS;
			END;*/

			***;
			IF (ICDAS[P, M] IN(2, 3, 4, 5, 6) AND COP[P, M] NOT IN('B', 'C', 'D', 'E'))  
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8')  
				THEN DO; 
				/*IDC_ICDAS_SCOP_T + 1; * TEMPORALES;
				PC_ICDAS_SCOP_T  = 1;*/
				IDC_COP_ICDAS_T + 1; * TEMPORALES;
				PC_COP_ICDAS_T = 1; * TEMPORALES;
			END;

			IF (ICDAS[P, M] IN(2, 3, 4, 5, 6) AND COP[P, M] NOT IN('1', '2', '3', '4'))   
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') 
				THEN DO; 
				/*IDC_ICDAS_SCOP_P + 1; * PERMANENTE;
				PC_ICDAS_SCOP_P  = 1;*/
				IDC_COP_ICDAS_P + 1; * TEMPORALES;
				PC_COP_ICDAS_P  = 1; * TEMPORALES;
			END;

			IF (ICDAS[P, M] IN(2, 3, 4, 5, 6) AND 
				COP[P, M] NOT IN('B', 'C', 'D', 'E', '1', '2', '3', '4'))   
				THEN DO; 
				/*IDC_ICDAS_SCOP_J + 1; * JUNTOS;
				PC_ICDAS_SCOP_J  = 1;*/
				IDC_COP_ICDAS_J + 1; * TEMPORALES;
				PC_COP_ICDAS_J  = 1; * TEMPORALES;
			END;
			
			***;
			IF COP[P, M] IN('D')
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				IDO_POR_COP_T = 1; * TEMPORALES;
				IDO_PRO_COP_T + 1; * TEMPORALES;
			END;

			IF COP[P, M] IN('3')
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				IDO_POR_COP_P = 1; * PERMANENTE;
				IDO_PRO_COP_P + 1; * PERMANENTE;
			END;

			IF COP[P, M] IN('D', '3') THEN DO;
				IDO_POR_COP_J = 1; * JUNTOS;
				IDO_PRO_COP_J + 1; * JUNTOS;
			END;

			***;
			IF COP[P, M] IN('E')
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				IDP_POR_COP_T = 1; * TEMPORALES;
				IDP_PRO_COP_T + 1; * TEMPORALES;
			END;

			IF COP[P, M] IN('4')
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				IDP_POR_COP_P = 1; * PERMANENTE;
				IDP_PRO_COP_P + 1; * PERMANENTE;
			END;

			IF COP[P, M] IN('E', '4') THEN DO;
				IDP_POR_COP_J = 1; * JUNTOS;
				IDP_PRO_COP_J + 1; * JUNTOS;
			END;

			***;
			IF	 ICDAS[P ,M] IN(2) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				 IDC_ICDAS_T_SEV2 + 1; * TEMPORALES;
			END;
			IF	 ICDAS[P ,M] IN(2) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				 IDC_ICDAS_P_SEV2 + 1; * PERMANENTE;
			END;
			IF	 ICDAS[P ,M] IN(2) THEN DO;
				 IDC_ICDAS_J_SEV2 + 1; * JUNTOS;
			END;
			IF	 ICDAS[P ,M] IN(3) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				 IDC_ICDAS_T_SEV3 + 1; * TEMPORALES;
			END;
			IF	 ICDAS[P ,M] IN(3) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				 IDC_ICDAS_P_SEV3 + 1; * PERMANENTE;
			END;
			IF	 ICDAS[P ,M] IN(3) THEN DO;
				 IDC_ICDAS_J_SEV3 + 1; * JUNTOS;
			END;
			IF	 ICDAS[P ,M] IN(4) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				 IDC_ICDAS_T_SEV4 + 1; * TEMPORALES;
			END;
			IF	 ICDAS[P ,M] IN(4) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				 IDC_ICDAS_P_SEV4 + 1; * PERMANENTE;
			END;
			IF	 ICDAS[P ,M] IN(4) THEN DO;
				 IDC_ICDAS_J_SEV4 + 1; * JUNTOS;
			END;
			IF	 ICDAS[P ,M] IN(5) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				 IDC_ICDAS_T_SEV5 + 1; * TEMPORALES;
			END;
			IF	 ICDAS[P ,M] IN(5) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				 IDC_ICDAS_P_SEV5 + 1; * PERMANENTE;
			END;
			IF	 ICDAS[P ,M] IN(5) THEN DO;
				 IDC_ICDAS_J_SEV5 + 1; * JUNTOS;
			END;
			IF	 ICDAS[P ,M] IN(6) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				 IDC_ICDAS_T_SEV6 + 1; * TEMPORALES;
			END;
			IF	 ICDAS[P ,M] IN(6) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				 IDC_ICDAS_P_SEV6 + 1; * PERMANENTE;
			END; 
			IF	 ICDAS[P ,M] IN(6) THEN DO;
				 IDC_ICDAS_J_SEV6 + 1; * JUNTOS;
			END;

			***; 
			IF COP[P, M] IN('B', 'C', 'D', 'E')
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				CPO_D_T + 1; * TEMPORALES;
			END;

			IF COP[P, M] IN('1', '2', '3', '4')
				 AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				CPO_D_P + 1; * PERMANENTE;
			END;

			IF COP[P, M] IN('B', 'C', 'D', 'E', '1', '2', '3', '4') THEN DO;
				CPO_D_J + 1; * JUNTOS;
			END;

			***;
			IF (COP[P, M] IN('B', 'C', 'D', 'E') OR ICDAS[P, M] IN(2, 3, 4, 5, 6))
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				CPO_D_MOD_T + 1; * TEMPORALES;
			END;

			IF (COP[P, M] IN('1', '2', '3', '4') OR ICDAS[P, M] IN(2, 3, 4, 5, 6))
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				CPO_D_MOD_P + 1; * PERMANENTE;
			END;

			IF COP[P, M] IN('B', 'C', 'D', 'E', '1', '2', '3', '4') OR ICDAS[P, M] IN(2, 3, 4, 5, 6) THEN DO;
				CPO_D_MOD_J + 1; * JUNTOS;
			END;

			***;
			IF M4_104 = 12 AND M = 6 AND COP[P, M] IN('0', '6') AND
				SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				IPMP_S_P + 1; * PERMANENTE;
			END;

			***;
			IF M4_104 = 12 AND M = 6 AND COP[P, M] IN('4') AND
				SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				IPMP_P_P + 1; * PERMANENTE;
			END;

			***;
			IF M4_104 = 12 AND M = 6 AND COP[P, M] IN('1', '2') AND
				SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				IPMP_C_P + 1; * PERMANENTE;
			END;

			***IN(2, 3);
			IF M4_104 = 12 AND M = 6 AND ICDAS[P, M] IN(2) AND
				SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				IPMP_ICDAS_C_P + 1; * PERMANENTE;
			END;

			***;
			IF M4_104 = 12 AND M = 6 AND (ICDAS[P, M] IN(2, 3, 4, 5, 6) AND COP[P, M] NOT IN('1', '2', '3', '4')) AND
				SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				IPMP_COP_ICDAS_C_P + 1; * PERMANENTE;
			END;

			IF M4_104 = 12 AND M = 6 AND (ICDAS[P, M] IN(2) OR COP[P, M] IN('1', '2')) AND
				SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				IPMP_COP_ICDAS_2_C_P + 1; * PERMANENTE;
			END;

			***;
			IF M4_104 = 12 AND M = 6 AND COP[P, M] IN('3') AND
				SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				IPMP_O_P + 1; * PERMANENTE;
			END;

			***;
			IF M4_104 = 12 AND M = 6 AND ICDAS[P, M] IN(2) AND
				SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				IPMP_ICDAS_P_SEV2 + 1; * PERMANENTE;
			END;
	
			IF M4_104 = 12 AND M = 6 AND ICDAS[P, M] IN(3) AND
				SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				IPMP_ICDAS_P_SEV3 + 1; * PERMANENTE;
			END;

			IF M4_104 = 12 AND M = 6 AND ICDAS[P, M] IN(4) AND
				SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				IPMP_ICDAS_P_SEV4 + 1; * PERMANENTE;
			END;

			IF M4_104 = 12 AND M = 6 AND ICDAS[P, M] IN(5) AND
				SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				IPMP_ICDAS_P_SEV5 + 1; * PERMANENTE;
			END;

			IF M4_104 = 12 AND M = 6 AND ICDAS[P, M] IN(6) AND
				SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				IPMP_ICDAS_P_SEV6 + 1; * PERMANENTE;
			END;

			***;
			IF COP[P, M] IN('5') AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				PDPC_P + 1; * PERMANENTE;
			END;
			
			***;
			IF COP[P, M] IN('0', '1', '2', '3', '6', '7') AND
				SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				DIE_BOCAP + 1;
			END;
			
			IF COP[P, M] IN('A', 'B', 'C', 'D', 'F', 'G') AND
				SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				DIE_BOCAT + 1;
			END;
			
			IF COP[P, M] IN('0', '1', '2', '3', '6', '7',
							'A', 'B', 'C', 'D', 'F', 'G') THEN DO;
				DIE_BOCAJ + 1;
			END;

	************ EDENTULISMO;		
			IF COP[P, M] IN('4', '5') AND 
				SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				ED_P = 1;
				IDA_P + 1;
				
				IF M NOT IN(6, 7) THEN ED_DAI + 1;
			END;

		IF M4_104 = 15 THEN DO;	
			* * *Parcialmente edéntulo Tramo posterior Inferior Derecho;
			IF P = 4 AND M IN(4, 5, 6, 7) THEN DO;
				IF COP[P, M] IN('0', '1', '2', '3', '4', '5', '6', '7', 
							'A', 'B', 'C', 'D', 'E', 'F', 'G') THEN PETPID_EVAL + 1;
				IF COP[P, M] IN('4', '5') THEN DO;
					PETPID_POR = 1;
					PETPID_PRO + 1;
				END;
			END;

			* * *Parcialmente edéntulo Tramo posterior Inferior Izquierdo;
			IF P = 3 AND M IN(4, 5, 6, 7) THEN DO;
				IF COP[P, M] IN('0', '1', '2', '3', '4', '5', '6', '7', 
							'A', 'B', 'C', 'D', 'E', 'F', 'G') THEN PETPII_EVAL + 1;
				IF COP[P, M] IN('4', '5') THEN DO;
					PETPII_POR = 1;
					PETPII_PRO + 1;
				END;
			END;

			* * *Parcialmente edéntulo Tramo posterior Superior Derecho;
			IF P = 1 AND M IN(4, 5, 6, 7) THEN DO;
				IF COP[P, M] IN('0', '1', '2', '3', '4', '5', '6', '7', 
							'A', 'B', 'C', 'D', 'E', 'F', 'G') THEN PETPSD_EVAL + 1;
				IF COP[P, M] IN('4', '5') THEN DO;
					PETPSD_POR = 1;
					PETPSD_PRO + 1;
				END;
			END;

			* * *Parcialmente edéntulo Tramo posterior Superior Izquierdo;
			IF P = 2 AND M IN(4, 5, 6, 7) THEN DO; 
				IF COP[P, M] IN('0', '1', '2', '3', '4', '5', '6', '7', 
							'A', 'B', 'C', 'D', 'E', 'F', 'G') THEN PETPSI_EVAL + 1;			
				IF COP[P, M] IN('4', '5') THEN DO;
					PETPSI_POR = 1;
					PETPSI_PRO + 1;
				END;
			END;

			* * *Parcialmente edéntulo Tramo anterior Izquierdo;
			IF P in(3, 4) AND M IN(1, 2, 3) THEN DO; 
				IF COP[P, M] IN('0', '1', '2', '3', '4', '5', '6', '7', 
							'A', 'B', 'C', 'D', 'E', 'F', 'G') THEN PETAI_EVAL + 1;			
				IF COP[P, M] IN('4', '5') THEN DO;
					PETAI_POR = 1;
					PETAI_PRO + 1;
				END;
			END;

			* * *Parcialmente edéntulo Tramo anterior Derecho;
			IF P in(1, 2) AND M IN(1, 2, 3) THEN DO; 
				IF COP[P, M] IN('0', '1', '2', '3', '4', '5', '6', '7', 
							'A', 'B', 'C', 'D', 'E', 'F', 'G') THEN PETAS_EVAL + 1;				
				IF COP[P, M] IN('4', '5') THEN DO;
					PETAS_POR = 1;
					PETAS_PRO + 1;
				END;
			END;

		END;
			************ OPACIDAD;
			IF OPAC[P, M] IN(7, 8) THEN DO;
				POE = 1;
				POE_C + 1;
				IF OPAC[P, M] IN(7) THEN POE_7 + 1;
				IF OPAC[P, M] IN(8) THEN POE_8 + 1;
				
				IF M IN(1, 2, 3) 		THEN DO;
					POE_IC = 1;
					POE_IC_C + 1;
					IF OPAC[P, M] IN(7) THEN POE_IC_7 + 1;
					IF OPAC[P, M] IN(8) THEN POE_IC_8 + 1;
				END;
				IF M IN(4, 5, 6, 7, 8) 	THEN DO;
					POE_MP = 1;
					POE_MP_C + 1;
					IF OPAC[P, M] IN(7) THEN POE_MP_7 + 1;
					IF OPAC[P, M] IN(8) THEN POE_MP_8 + 1;
				END;
			END;
			
		END;
	END;
	
	
	IF IDA_P = PERMANENTES THEN PAATD_P = 1;
	IF DIE_BOCAP = 28  THEN PADB_28_P = 1;
	IF DIE_BOCAP < 20  THEN PADB_M_20_P = 1;
	IF DIE_BOCAP >= 21 THEN PDF = 1;
	
	IF M4_104 = 15 THEN DO;
	SELECT;
	    WHEN (DIE_BOCAP = . ) EDEN_CLA = 9;
		WHEN (DIE_BOCAP = 0 ) EDEN_CLA = 0;
		WHEN (DIE_BOCAP < 16) EDEN_CLA = 1;
		WHEN (DIE_BOCAP < 20) EDEN_CLA = 2;
		WHEN (DIE_BOCAP < 24) EDEN_CLA = 3;
		WHEN (DIE_BOCAP < 28) EDEN_CLA = 4;
		WHEN (DIE_BOCAP = 28) EDEN_CLA = 5;
		OTHERWISE            EDEN_CLA =  9;
	END;
	END;

	IF PETPID_EVAL = PETPID_PRO THEN PETPID_TE = 1;
	IF PETPII_EVAL = PETPII_PRO THEN PETPII_TE = 1;
	IF PETPSD_EVAL = PETPSD_PRO THEN PETPSD_TE = 1;
	IF PETPSI_EVAL = PETPSI_PRO THEN PETPSI_TE = 1;
	IF PETAI_EVAL  = PETAI_PRO  THEN PETAI_TE  = 1;
	IF PETAS_EVAL  = PETAS_PRO  THEN PETAS_TE  = 1;
	
	***************************************************DAI
	*** Dental Aesthetic Index. The DAI links the clinical and 
			esthetic components mathematically to produce a single
			score that combines the physical and the esthetic aspects 
			of occlusion;

	***** VARIABLES A USAR:
	*** DIENTES PERDIDOS POR CARIES (4) U OTRA RAZÓN (5) EN DIENTES PERMANENTES PARA 
			INCISIVOS, CANINOS, Y PREMOLARES
			EN MAXILAR SUPERIOR 15-25 MC_305C -- MC_305L
			EN MAXILAR INFERIOR 45-35 MC_307C -- MC_307L;
	*** APIÑAMIENTO EN REGIÓN INCISAL: 
		0 = no segments crowded, 1 = 1 segment crowded, 2 = 2 segments crowded: MC_310;
	*** ESPACIOS EN REGION INCISAL:
		0 = no segments spaced, 1 = 1 segment spaced, 2 = 2 segments spaced: MC_311;
	*** DIASTEMA INCISAL SUPERIOR (MM): MC_312;
	*** MAL POSICIÓN MAXILAR ANTERIOR (MM): MC_313;
	*** MAL POSICIÓN MANDIBULAR ANTERIOR (MM): MC_314;
	*** OVERJET MAXILAR ANTERIOR (MM): MC_315 Measurement of anterior maxillary overjet;
	*** MORDIDA CRUZADA ANTERIOR (MM): MC_316 Measurement of anterior mandibular overjet;
	*** SOBREMORDIDA VERTICAL -> MORDIDA ABIERTA (MM): MC_319A Measurement of vertical anterior openbite;
	*** RELACIÓN MOLAR ANTERO POSTERIOR: MAX(MC_317A, MC_317B)
		0 =normal, 1 = 1/2 cusp either mesial or distal, 1 = 1 full cusp or more either mesial or distal
		NO SE PUEDE DETERMINAR EL 2 SEGÚN EL EXPERTO;

	
	IF MC_308 = 2 THEN DO;
		DEN_OCLU = 1;
		*IF MC_309 = 1 THEN DO;

		SELECT;
			WHEN (MC_315A = .) AUSENTE = 1;
			WHEN (MC_315A = 1) MC_316 = 0;
			WHEN (MC_315A = 2) DO;
				MC_315 = 0;
				MC_316 = 0;
			END;
			WHEN (MC_315A = 3) MC_315 = 0;
			OTHERWISE AUSENTE = 1;
		END;
		
		IF MC_319 NOT IN(., 0, 9) THEN MC_319A = 0;

		SELECT;
			WHEN (MC_317A NOT IN(., 9) AND MC_317B NOT IN (. , 9)) MAX_RAPP = MAX(MC_317A, MC_317B);
			WHEN (MC_317A     IN(., 9) AND MC_317B NOT IN (. , 9)) MAX_RAPP =              MC_317B ;
			WHEN (MC_317A NOT IN(., 9) AND MC_317B     IN (. , 9)) MAX_RAPP =     MC_317A          ;
			OTHERWISE 											   MAX_RAPP = .;
		END;

		SELECT;
			WHEN (MAX_RAPP = .) MAX_RAP = .;
			WHEN (MAX_RAPP = 0) MAX_RAP = &MRAP0;
			WHEN (MAX_RAPP = 1) MAX_RAP = &MRAP1;
			WHEN (MAX_RAPP = 2) MAX_RAP = &MRAP2;
			OTHERWISE			MAX_RAP = .;
		END;
			
		*;
		SELECT;
			WHEN (MC_315A = 2) HORIZONTAL = 0;
			WHEN (MC_315A = 1) HORIZONTAL = MC_315;
			WHEN (MC_315A = 3) HORIZONTAL = -MC_316;
			OTHERWISE 			HORIZONTAL = .;
		END;

		SELECT;
			WHEN (MC_319 = 1) VERTICAL = 0;
			WHEN (MC_319 = 0) VERTICAL = -MC_319A;
			WHEN (MC_319 = 2) VERTICAL = MC_319B;
			OTHERWISE 		VERTICAL = .;
		END;
		
		* * FÓRMULAS 63 64;
		IF MC_312 > 0 AND MC_312 NE 99 THEN DIS  = 1; ELSE DIS  = 0;
		IF MC_312 = 1 AND MC_312 NE 99 THEN DIS1 = 1; ELSE DIS1 = 0;
		IF MC_312 = 2 AND MC_312 NE 99 THEN DIS2 = 1; ELSE DIS2 = 0;
		IF MC_312 > 2 AND MC_312 NE 99 THEN DIS3 = 1; ELSE DIS3 = 0;
		
		SELECT;
			WHEN (MC_312 IN(99, .)) DISCL = 9;
			WHEN (MC_312 = 0)		DISCL = 0;
			WHEN (MC_312 = 1)		DISCL = 1;
			WHEN (MC_312 = 2)		DISCL = 2;
			OTHERWISE 				DISCL = 3;
		END;
			
		
		* * FÓRMULAS 65 66;
		IF MC_313 > 0 THEN FPMAS  = 1; ELSE FPMAS  = 0;
		IF MC_313 = 1 THEN FPMAS1 = 1; ELSE FPMAS1 = 0;
		IF MC_313 = 2 THEN FPMAS2 = 1; ELSE FPMAS2 = 0;
		IF MC_313 = 3 THEN FPMAS3 = 1; ELSE FPMAS3 = 0;
		IF MC_313 > 3 THEN FPMAS4 = 1; ELSE FPMAS4 = 0;
		
		SELECT;
			WHEN (MC_313 = 0) FPMASCL = 0;
			WHEN (MC_313 = 1) FPMASCL = 1;
			WHEN (MC_313 = 2) FPMASCL = 2;
			OTHERWISE 		  FPMASCL = 3;
		END;
		
		
		* * FÓRMULAS 67 68;
		IF MC_314 > 0 THEN FPMAI  = 1; ELSE FPMAI  = 0;
		IF MC_314 = 1 THEN FPMAI1 = 1; ELSE FPMAI1 = 0;
		IF MC_314 = 2 THEN FPMAI2 = 1; ELSE FPMAI2 = 0;
		IF MC_314 > 2 THEN FPMAI3 = 1; ELSE FPMAI3 = 0;
		
		SELECT;
			WHEN (MC_314 = 0) FPMAICL = 0;
			WHEN (MC_314 = 1) FPMAICL = 1;
			WHEN (MC_314 = 2) FPMAICL = 2;
			OTHERWISE 		  FPMAICL = 3;
		END;
		
		* * FÓRMULAS 70;
		IF MC_315 > 0 THEN SH  = 1; ELSE SH  = 0;
		IF MC_315 = 1 THEN SH1 = 1; ELSE SH1 = 0;
		IF MC_315 = 2 THEN SH2 = 1; ELSE SH2 = 0;
		IF MC_315 = 3 THEN SH3 = 1; ELSE SH3 = 0;
		IF MC_315 = 4 THEN SH4 = 1; ELSE SH4 = 0;
		IF MC_315 > 4 THEN SH5 = 1; ELSE SH5 = 0;
	
		IF MC_315A = 1 THEN SH_DEN = 1; ELSE SH_DEN = 0;
		SELECT;
			WHEN (MC_315A NE 1) SHCL = 9;
			WHEN (MC_315 = 0) 	SHCL = 0;
			WHEN (MC_315 = 1) 	SHCL = 1;
			WHEN (MC_315 = 2) 	SHCL = 2;
			WHEN (MC_315 = 3) 	SHCL = 3;
			WHEN (MC_315 = 4) 	SHCL = 4;
			OTHERWISE 		  	SHCL = 5;
		END;
		
		* * FÓRMULAS 75;
		IF MC_319 = 0 THEN SVA_DEN = 1; ELSE SVA_DEN = 0;
		
		IF MC_319A > 0 THEN SV_a  = 1; ELSE SV_a  = 0;
		IF MC_319A = 1 THEN SV_a1 = 1; ELSE SV_a1 = 0;
		IF MC_319A = 2 THEN SV_a2 = 1; ELSE SV_a2 = 0;
		IF MC_319A = 3 THEN SV_a3 = 1; ELSE SV_a3 = 0;
		IF MC_319A = 4 THEN SV_a4 = 1; ELSE SV_a4 = 0;
		IF MC_319A > 4 THEN SV_a5 = 1; ELSE SV_a5 = 0;
		
		SELECT;
			WHEN (MC_319 NE 0)  SVACL = 9;
			WHEN (MC_319A = 0) 	SVACL = 0;
			WHEN (MC_319A = 1) 	SVACL = 1;
			WHEN (MC_319A = 2) 	SVACL = 2;
			WHEN (MC_319A = 3) 	SVACL = 3;
			WHEN (MC_319A = 4) 	SVACL = 4;
			OTHERWISE 		  	SVACL = 5;
		END;
		
		* * FÓRMULAS 75;
		IF MC_319B > 0 THEN SV_b  = 1; ELSE SV_b  = 0;
		IF MC_319B = 1 THEN SV_b1 = 1; ELSE SV_b1 = 0;
		IF MC_319B = 2 THEN SV_b2 = 1; ELSE SV_b2 = 0;
		IF MC_319B = 3 THEN SV_b3 = 1; ELSE SV_b3 = 0;
		IF MC_319B = 4 THEN SV_b4 = 1; ELSE SV_b4 = 0;
		IF MC_319B > 4 THEN SV_b5 = 1; ELSE SV_b5 = 0;

		
		
		* * PSV 77;
		IF MC_319 = 2 THEN DO; 
			SVB_DEN = 1; 
			SVBCL = 9;
		END;	
		ELSE SVB_DEN = 0;
		IF MC_319B1 > 0 AND MC_319B NE . THEN DO;
			PSV = MC_319B / MC_319B1;
			SELECT; * 77;
				WHEN (PSV <= .2) PSV_CL = 'Menos del 20%     ';
				WHEN (PSV <= .3) PSV_CL = 'Entre el 21% y 30%';
				WHEN (PSV <= .4) PSV_CL = 'Entre el 31% y 40%';
				WHEN (PSV <= .5) PSV_CL = 'Entre el 41% y 50%';
				OTHERWISE		 PSV_CL = 'Más del 50%';
			END;
			SELECT; * 77;
				*WHEN (PSV );
				WHEN (PSV <= .2) SVBCL = 1;
				WHEN (PSV <= .3) SVBCL = 2;
				WHEN (PSV <= .4) SVBCL = 3;
				WHEN (PSV <= .5) SVBCL = 4;
				OTHERWISE		 SVBCL = 5;
			END;
		END;
		ELSE SVBCL = 9;
		
		*;
		IF MC_310 NOT IN(., 9) & MC_311 NOT IN(., 9) 
		 & MC_312 NOT IN(., 99) & MC_313 NE . & MC_314 NE . 
		 & MC_315 NE . & MC_316 NE . & MC_319A NE .
		 & MAX_RAP NE .
		THEN DO;
			DEN_DAI = 1;
			DAI = &k11_DAI + &k01_DAI * ED_DAI + &k02_DAI * MC_310 + &k03_DAI * MC_311  + 
				  			 &k04_DAI * MC_312 + &k05_DAI * MC_313 + &k06_DAI * MC_314  + 
				  			 &k07_DAI * MC_315 + &k08_DAI * MC_316 + &k09_DAI * MC_319A +
							 &k10_DAI * MAX_RAP;
							 
			SELECT;
				WHEN (DAI  =  .)    DAI_CL = '                         ';
				WHEN (DAI <= 25) 	DAI_CL = 'Maloclusión mínima       ';
				WHEN (DAI <= 30) 	DAI_CL = 'Maloclusión definida'		;
				WHEN (DAI <= 35) 	DAI_CL = 'Maloclusión severa'		;
				OTHERWISE 			DAI_CL = 'Maloclusión incapacitante';
			END;
			SELECT;
				WHEN (DAI  =  .)    DAI_CLn = .;
				WHEN (DAI <= 25) 	DAI_CLn = 1;
				WHEN (DAI <= 30) 	DAI_CLn = 2;
				WHEN (DAI <= 35) 	DAI_CLn = 3;
				OTHERWISE 			DAI_CLn = 4;
			END;
		END;
		ELSE DO;
			AUSENTE = 1;
			DEN_DAI = 0;
		END;
	END;
	ELSE DO;
		DEN_OCLU 	= 0;
		SH_DEN 		= 0;
		SVA_DEN 	= 0;
		SVB_DEN 	= 0;
	END;



	**************************************************ICF
	*** Índice Comunitario de Fluorosis
	*** el cálculo para la población corresponde a el 
		promedio con las ponderaciones dadas por los expertos;

	****************************************************************** FORMULA 121;
	PFE = 0;
	****************************************************************** FORMULA 124;
	/*PDSF = 0;
	PDCF = 0;
	PDFD = 0;
	PDFML = 0;
	PDFL = 0;
	PDFM = 0;*/
	PDFS = 0;
	
	DIENTE_FLUO = 0;
	****************************************************************** FORMULA 125;
	DEAN_III = 0;
	PFE_III  = 0;
	PDF_III  = 0;
	
	DIENTE_FLUO_III = 0;
	
	***** VARIABLES A USAR:
	*** Para el cálculo del ICF a partir de la información recolectada del
		maxilar superior MB_313A -- MB_313J
		maxilar inferior (inferior a partir de 2014)
	*** Valor reportado por el odóntologo Índice Dean MB_314;
	
	* * * * * vicm2;
	ARRAY vicm {2, 2,6}
		 MC_320f MC_320e MC_320d MC_320c MC_320b MC_320a
		 MC_320g MC_320h MC_320i MC_320j MC_320k MC_320l
		 MC_320s MC_320t MC_320u MC_320v MC_320w MC_320x
		 MC_320r MC_320q MC_320p MC_320o MC_320n MC_320m
			;  * * VALORES DE FLUOROSIS DENTAL POR DIENTE;

	ARRAY pa {2, 6}
		 P11 P12 P13 P14 P15 P16
		 P21 P22 P23 P24 P25 P26
			;  * * VALOR MÍNIMO EN LA PAREJA;
			
	ARRAY MP {6} MP11 MP12 MP13 MP14 MP15 MP16;  * * VALOR MAXÍMO DE LA PAREJA;

	ARRAY DISTR {2, 0:5}
		PDSF PDFD PDFML PDFL PDFM PDFS
		D20 D21 D22 D23 D24 D25
			;  * * DISTRIBUCIÓN DE VALORES VÁLIDOS -> MODA;

	ARRAY ICF  {2} ICF_S  ICF_I (2 * 0); * * VALOR DEL ÍNDICE COMUNITARIO DE FLUOROSIS POR MANDIBULA;
	ARRAY MODA {2} MODA_S MODA_I (2 * 0);  * * MODA EN LA MANDIBULA;
	ARRAY MAXI {2} MAX_S MAX_I (2 * 0);  * * VALOR MÁXIMO EN LA MANDIBULA;
	ARRAY DP {2} DP_S DP_I (2 * 0);  * * CANTIDAD DE PAREJAS CON DIFERENCIAS MAYORES A 1;
	ARRAY PD {2} PD_S PD_I (2 * 0);  * * CANTIDAD DE PAREJAS DISPAREJAS;
	ARRAY NONA {2} NONA_S NONA_I (2 * 0); * * CANTIDAD DE DIENTES SIN VALOR;
	ARRAY ESP {2} ESP_S ESP_I (2 * 0);  * * CANTIDAD REPORTADA COMO ESPEJO;

	DO I = 1 TO 2;  * * MAXILAR 1 = SUPERIOR, 2 = INFERIOR;
		
		DO L = 1 TO DIM(VICM, 3); * * CANTIDAD DE PAREJAS (5 AÑOS = 5, 12 Y 15 AÑOS = 6);
			
			DO J = 1 TO DIM(VICM, 2); * * CUADRANTE EN EL QUE SE UBICA EL DIENTE SIGUIENDO NOMENCLATURA FDI;
				IF VICM[I, J, L] NOT IN(., 8, 9) THEN DO;
					MAXI[I] = MAX(MAXI[I], VICM[I, J, L]);  * * MÁXIMO VALOR REPORTADO EN EL MAXILAR;

					DISTR[I, VICM[I, J, L]] + 1;  * *CALCULANDO FRECUENCIAS ABSOLUTAS DE VALORES EN EL MAXILAR;
					
					IF L IN(1,2,3,5) AND I = 1 THEN DO;
						DIENTE_FLUO_III + 1;
						IF VICM[I, J, L] IN(1,2,3,4,5) THEN DO;
							PDF_III + 1;
							PFE_III = 1;
						END;
					END;
				END;
				ELSE NONA[I] + 1;  * * CONTEO DE VALORES AUSENTES REPORTADOS EN EN EL MAXILAR;
				
			END;

			SELECT;
				WHEN (VICM[I, 1, L] NOT IN(., 8, 9) AND VICM[I, 2, L] NOT IN(., 8, 9)) DO; 
					PA[I, L] = MIN(VICM[I, 1, L], VICM[I, 2, L]); * * VALOR MÍNIMO REPORTADO EN LA PAREJA;
					MP[L] = MAX(VICM[I, 1, L], VICM[I, 2, L]); * * VALOR MÁXIMO REPORTADO EN LA PAREJA;
					
					IF ABS(VICM[I, 1, L] - VICM[I, 2, L]) > 1 THEN DP[I] + 1;  * * CONTEO DE PAREJAS CON DIFERENCIAS MAYORES A 1;
					IF VICM[I, 1, L] = VICM[I, 2, L] THEN ESP[I] + 1;  * * CONTEO DE PAREJAS REPORTADAS COMO ESPEJO;

					IF MAXI[I] = VICM[I, 1, L] OR MAXI[I] = VICM[I, 2, L]
						THEN ICF[I] = MAX(ICF[I], PA[I, L]); * * CÁLCULO DEL ICF PARA EL MAXILAR, 
						
							EN TODAS LAS PAREJAS QUE TENGAN REPORTADO EL MÁXIMO SE DEJA EL MÁXIMO DE LOS MÍNIMOS EN LAS PAREJAS;
							
				END;
				WHEN (VICM[I, 1, L]     IN(., 8, 9) AND VICM[I, 2, L] NOT IN(., 8, 9)) DO;
					PD[I] + 1;  * * CONTEO DE DIENTES SIN PAREJAS;
					PA[I, L] = VICM[I, 2, L]; * * VALOR MÍNIMO REPORTADO EN LA PAREJA;
					MP[L] = VICM[I, 2, L]; * * VALOR MÁXIMO REPORTADO EN LA PAREJA;
					
					IF MAXI[I] = VICM[I, 2, L]
						THEN ICF[I] = MAX(ICF[I], PA[I, L]); * * CÁLCULO DEL ICF PARA EL MAXILAR; 
				END;
				WHEN (VICM[I, 1, L] NOT IN(., 8, 9) AND VICM[I, 2, L]     IN(., 8, 9)) DO;
					PD[I] + 1;  * * CONTEO DE DIENTES SIN PAREJAS;
					PA[I, L] = VICM[I, 1, L]; * * VALOR MÍNIMO REPORTADO EN LA PAREJA;
					MP[L] = VICM[I, 1, L]; * * VALOR MÁXIMO REPORTADO EN LA PAREJA;
					
					IF MAXI[I] = VICM[I, 1, L]
						THEN ICF[I] = MAX(ICF[I], PA[I, L]); * * CÁLCULO DEL ICF PARA EL MAXILAR; 
				END;
				WHEN (VICM[I, 1, L] = VICM[I, 2, L])
					ESP[I] + 1;  * CONTEO DE PAREJAS REPORTADAS COMO ESPEJO EN VALORES AUSENTE;
				OTHERWISE ESP[I] + 0;
			END;
		END;
		
		IF NONA[I] NE DIM(VICM, 3) * 2 THEN DO;
			MAXD = 0; * * CÁLCULO DEL VALOR MODAL, EN CASO DE EMPATE SE DEJA EL MÁS ALTO;
			DO K = 0 TO 5;
				MAXD = MAX(MAXD, DISTR[I, K]);
				IF DISTR[I, K] = MAXD THEN MODA[I] = K;	
			END;
		END;
		ELSE IF  NONA[I] = DIM(VICM, 3) * 2 THEN DO; * * SI NO HAY DIENTES REPORTADOS SE DEJA COMO AUSENTE EL CÁLCULO DEL ICF;
			MODA[I] = .;
			ICF[I] = .;
			MAXI[I] = .;
			DP[I] = .;
			PD[I] = .;
			ESP[I] = .;
		END;
	END;
	
	IF MP11 NE . OR MP12 NE . OR MP13 NE . OR MP15 NE . THEN DO;
		MAXIII = MAX(MP11, MP12, MP13, MP15);
		MINIII = MIN(MP11, MP12, MP13, MP15);
		
		IF MAXIII = MINIII THEN DEAN_III = MAXIII;
		ELSE DO;
			DEAN_III = 0;
			DO L= 1, 2, 3, 5;
				IF MP[L] NE . AND MP[L] NE MAXIII THEN DEAN_III = MAX(DEAN_III, MP[L]);
			END;
		END;
	END;
	
	*0     1    2     3    4   5;
	*PDSF PDFD PDFML PDFL PDFM PDFS;
	IF PDFML > 0 OR PDFL > 0 OR PDFM > 0 OR PDFS > 0 THEN DO;
		PFE = 1;
	END;
	ELSE DO;
		PFE = 0;
	END;

	IF PDFD > 0 AND PDFML > 0 OR PDFL > 0 OR PDFM > 0 OR PDFS > 0 THEN DO;
		PDCF = SUM(PDFD, PDFML, PDFL, PDFM, PDFS);
	END;
	ELSE DO;
		PDCF = 0;
	END;
	
	IF PDSF > 0 OR PDFD > 0 OR PDFML > 0 OR PDFL > 0 OR PDFM > 0 OR PDFS > 0 THEN 
		DIENTE_EVAL = SUM(PDSF, PDFD, PDFML, PDFL, PDFM, PDFS);
	ELSE DIENTE_EVAL = 0;
	
	IF PDFD > 0 OR PDFML > 0 OR PDFL > 0 OR PDFM > 0 OR PDFS > 0 THEN DO;
		DIENTE_FLUO = SUM(PDFD, PDFML, PDFL, PDFM, PDFS);
		PFEA = 1;
	END;
	ELSE DO;
		DIENTE_FLUO = 0;
		PFEA = 0;
	END;
	

			* * ASIGNACIÓN DE LAS PONDERACIONES PARA EL CÁLCULO DEL ICF EN AGREGADOS;
	SELECT;
		WHEN (ICF_S = 0) ICF_PAR = &K0_FLU;
		WHEN (ICF_S = 1) ICF_PAR = &K1_FLU;
		WHEN (ICF_S = 2) ICF_PAR = &K2_FLU;
		WHEN (ICF_S = 3) ICF_PAR = &K3_FLU;
		WHEN (ICF_S = 4) ICF_PAR = &K4_FLU;
		WHEN (ICF_S = 5) ICF_PAR = &K5_FLU;
		OTHERWISE        ICF_PAR = .;
	END;

	SELECT;
		WHEN (MC_321 = 0) ICF_DEAN = &K0_FLU;
		WHEN (MC_321 = 1) ICF_DEAN = &K1_FLU;
		WHEN (MC_321 = 2) ICF_DEAN = &K2_FLU;
		WHEN (MC_321 = 3) ICF_DEAN = &K3_FLU;
		WHEN (MC_321 = 4) ICF_DEAN = &K4_FLU;
		WHEN (MC_321 = 5) ICF_DEAN = &K5_FLU;
		OTHERWISE         ICF_DEAN = .;
	END;
	OUTPUT;
	
	
	********************* erosion;
	IF MC_322A IN(1,2,3) THEN PED = 1; ELSE PED = 0;
	

	* * REINICIALIZA CONTADORES PARA EL SIGUIENTE REGISTRO;

	DO I = 1 TO 2;
		DO K = 0 TO 5;
			DISTR[I, K] = 0;
		END;
		MAXI[I] = 0;
		PD[I] = 0;
		DP[I] = 0;
		ICF[I] = 0;
		NONA[I] = 0;
		ESP[I] = 0;
	END; 	
RUN;

PROC SORT DATA = M4_EXAMEN_3;BY M4_104;RUN;

PROC UNIVARIATE DATA = M4_EXAMEN_3 NOPRINT;
	VAR	CPO_D_T;
	OUTPUT OUT = PERCENTILT_3
		PCTLPTS  = 66
		PCTLPRE  = QCOP_T
  		PCTLNAME = P;
   BY M4_104;
   WEIGHT Fex_fin;
   WHERE PERMANENTES = 0 & TEMPORALES > 0; 
RUN;
PROC UNIVARIATE DATA = M4_EXAMEN_3 NOPRINT;
	VAR	CPO_D_P;
	OUTPUT OUT = PERCENTILP_3
		PCTLPTS  = 66
		PCTLPRE  = QCOP_P
  		PCTLNAME = P;
   BY M4_104;
   WEIGHT Fex_fin;
   WHERE PERMANENTES > 0 & TEMPORALES = 0; 
RUN;
PROC UNIVARIATE DATA = M4_EXAMEN_3 NOPRINT;
	VAR	CPO_D_J;
	OUTPUT OUT = PERCENTILJ_3
		PCTLPTS  = 66
		PCTLPRE  = QCOP_J
  		PCTLNAME = P;
   BY M4_104;
   WEIGHT Fex_fin;
   WHERE PERMANENTES > 0 & TEMPORALES > 0; 
RUN;

DATA M4_EXAMEN_3;
	MERGE M4_EXAMEN_3 
		PERCENTILP_3 PERCENTILT_3 PERCENTILJ_3;
	BY M4_104;

	IF M4_104 = 12 THEN DO;
		IPMP_DEN = 1;
		ISC_T_DEN = .;
		IF TEMPORALES = 0 AND PERMANENTES > 0 AND
			CPO_D_P >= QCOP_PP THEN DO;
			ISC_P = CPO_D_P;
			ISC_P_DEN = 1;
		END;
		IF TEMPORALES > 0 AND PERMANENTES > 0 AND
			CPO_D_J >= QCOP_JP THEN DO;
			ISC_J = CPO_D_J;
			ISC_J_DEN = 1;
		END;	
	END;
	
	DROP P M I L J K;
RUN;
/**************************************************************************************************
* * EVALUACIÓN CLÍNICA A JÓVENES DE 18 AÑOS
**************************************************************************************************/
DATA M4_EXAMEN_4;
	SET IN.M4_EXAMEN_4;
	
	* * * * * DIEEVAL4;
	ARRAY DIEEVAL {4, 7}
		 MD_D7 MD_D6 MD_D5 MD_D4 MD_D3 MD_D2 MD_D1
		 MD_D8 MD_D9 MD_D10 MD_D11 MD_D12 MD_D13 MD_D14
		 MD_D22 MD_D23 MD_D24 MD_D25 MD_D26 MD_D27 MD_D28
		 MD_D21 MD_D20 MD_D19 MD_D18 MD_D17 MD_D16 MD_D15
	;

    **************************************************CARIES
	*** PC= Prevalencia Caries;

	****************************************************************************************** FORMULA 1
    ** Variables a usar: MA_305A -- MA_305J MA_307A -- MA_307J
	*** PC_COP_ = "Prevalencia de caries en COP"
		VALORES 1+2 Ó B+C;
    PC_COP_T = 0; * TEMPORALES;
	PC_COP_P = 0; * PERMANENTES;
	PC_COP_J = 0; * JUNTOS;

	****************************************************************************************** FORMULA 2
	*** PC_ICDAS_ = "Prevalencia de caries en ICDAS"
		VALORES  2, 3, 4, 5 o 6;
    PC_ICDAS_T = 0; * TEMPORALES;
	PC_ICDAS_P = 0; * PERMANENTES;
	PC_ICDAS_J = 0; * JUNTOS;

	****************************************************************************************** FORMULA 3
	*** PC_ICDAS_V_SEV = "Por niveles de severidad a partir de ICDAS"
		VALORES  2, 3, 4, 5 y 6
	*** VALORES  2;
	PC_ICDAS_T_SEV2 = 0; * TEMPORALES;
	PC_ICDAS_P_SEV2 = 0; * PERMANENTES;
	PC_ICDAS_J_SEV2 = 0; * JUNTOS;

	*** VALORES  3;
	PC_ICDAS_T_SEV3 = 0; * TEMPORALES;
	PC_ICDAS_P_SEV3 = 0; * PERMANENTES;
	PC_ICDAS_J_SEV3 = 0; * JUNTOS;

	*** VALORES  4;
	PC_ICDAS_T_SEV4 = 0; * TEMPORALES;
	PC_ICDAS_P_SEV4 = 0; * PERMANENTES;
	PC_ICDAS_J_SEV4 = 0; * JUNTOS;

	*** VALORES  5;
	PC_ICDAS_T_SEV5 = 0; * TEMPORALES;
	PC_ICDAS_P_SEV5 = 0; * PERMANENTES;
	PC_ICDAS_J_SEV5 = 0; * JUNTOS;

	*** VALORES 6;
	PC_ICDAS_T_SEV6 = 0; * TEMPORALES;
	PC_ICDAS_P_SEV6 = 0; * PERMANENTES;
	PC_ICDAS_J_SEV6 = 0; * JUNTOS;

	****************************************************************************************** FORMULA 4
	PC= % personas con COP (1 o 2) o ICDAS (2, 3, 4, 5 o 6)  
	PC= % personas con COP (B o C) o ICDAS (2, 3, 4, 5 o 6)  ;
	PC_COP_ICDAS_T = 0; * TEMPORALES;
	PC_COP_ICDAS_P = 0; * PERMANENTES;
	PC_COP_ICDAS_J = 0; * JUNTOS;

	****************************************************************************************** FORMULA 5
	EC_COP_ = "Experiencia de caries en COP"
	VALORES (1, 2, 3 o 4) o (B, C, D o E);
	EC_COP_T = 0; * TEMPORALES;
	EC_COP_P = 0; * PERMANENTES;
	EC_COP_J = 0; * JUNTOS;

	****************************************************************************************** FORMULA 2
	
	****************************************************************************************** FORMULA 6
	EC = % personas con COP (1, 2, 3 o 4) o ICDAS (2, 3, 4, 5 o 6)  
	EC = % personas con COP (B, C, D o E) o ICDAS (2, 3, 4, 5 o 6);
	EC_COP_ICDAS_T = 0; * TEMPORALES;
	EC_COP_ICDAS_P = 0; * PERMANENTES;
	EC_COP_ICDAS_J = 0; * JUNTOS; 

	****************************************************************************************** FORMULA 7
	IDS = "Índice de dientes sanos"
	IDS = % personas con 0 ó A;
	IDS_POR_COP_T = 0; * TEMPORALES;
	IDS_POR_COP_P = 0; * PERMANENTES;
	IDS_POR_COP_J = 0; * JUNTOS;
	****************************************************************************************** FORMULA 8
	IDS = % suma 0/n;
	IDS_PRO_COP_T = 0; * TEMPORALES;
	IDS_PRO_COP_P = 0; * PERMANENTES;
	IDS_PRO_COP_J = 0; * JUNTOS;
	****************************************************************************************** FORMULA 9
	IDC = "Índice de dientes cariados"
	IDC= suma 1 + 2/n, IDC= suma B + C/n;
	IDC_COP_T = 0; * TEMPORALES;
	IDC_COP_P = 0; * PERMANENTES;
	IDC_COP_J = 0; * JUNTOS;

	****************************************************************************************** FORMULA 10
	IDC= suma 2+3+4+5+6/n;
	IDC_ICDAS_T = 0; * TEMPORALES;
	IDC_ICDAS_P = 0; * PERMANENTES;
	IDC_ICDAS_J = 0; * JUNTOS;

	*IDC= suma 2+3/n (lesiones tempranas);
	IDC_LT_ICDAS_T = 0; * TEMPORALES;
	IDC_LT_ICDAS_P = 0; * PERMANENTES;
	IDC_LT_ICDAS_J = 0; * JUNTOS;
	****************************************************************************************** FORMULA 11
	IDC= suma COP (1 + 2) + ICDAS (2, 3) /n, IDC= suma COP (B + C) + + ICDAS (2, 3) /n;
	IDC_COP_ICDAS_T = 0; * TEMPORALES;
	IDC_COP_ICDAS_P = 0; * PERMANENTES;
	IDC_COP_ICDAS_J = 0; * JUNTOS;

	****************************************************************************************** FORMULA 11.5
	IDC= suma ICDAS (2, 3, 4, 5, 6) no COP(1,2,3,4) /n, IDC= suma COP (B + C) + + ICDAS (2, 3) /n;
	/*IDC_ICDAS_SCOP_T= 0; * TEMPORALES;
	IDC_ICDAS_SCOP_P= 0; * PERMANENTES;
	IDC_ICDAS_SCOP_J= 0; * JUNTOS;
	
	PC_ICDAS_SCOP_T = 0; * TEMPORALES;
	PC_ICDAS_SCOP_P = 0; * PERMANENTES;
	PC_ICDAS_SCOP_J = 0; * JUNTOS;*/

	****************************************************************************************** FORMULA 12
	IDO= % personas con 3 ó D;
	IDO_POR_COP_T = 0; * TEMPORALES;
	IDO_POR_COP_P = 0; * PERMANENTES;
	IDO_POR_COP_J = 0; * JUNTOS;

	****************************************************************************************** FORMULA 13
	IDO= suma 3/n ó D/n;
	IDO_PRO_COP_T = 0; * TEMPORALES;
	IDO_PRO_COP_P = 0; * PERMANENTES;
	IDO_PRO_COP_J = 0; * JUNTOS;

	****************************************************************************************** FORMULA 14
	IDP= % personas con 4 ó E;
	IDP_POR_COP_T = 0; * TEMPORALES;
	IDP_POR_COP_P = 0; * PERMANENTES;
	IDP_POR_COP_J = 0; * JUNTOS;

	****************************************************************************************** FORMULA 15
	IDP= suma 4/n ó E/n;
	IDP_PRO_COP_T = 0; * TEMPORALES;
	IDP_PRO_COP_P = 0; * PERMANENTES;
	IDP_PRO_COP_J = 0; * JUNTOS;

	****************************************************************************************** FORMULA 16
	IDC niveles de severidad = (2.3.4.5. ó 6)/n.  
	*** VALORES  2;
	IDC_ICDAS_T_SEV2 = 0; * TEMPORALES;
	IDC_ICDAS_P_SEV2 = 0; * PERMANENTES;
	IDC_ICDAS_J_SEV2 = 0; * JUNTOS;

	*** VALORES  3;
	IDC_ICDAS_T_SEV3 = 0; * TEMPORALES;
	IDC_ICDAS_P_SEV3 = 0; * PERMANENTES;
	IDC_ICDAS_J_SEV3 = 0; * JUNTOS;

	*** VALORES  4;
	IDC_ICDAS_T_SEV4 = 0; * TEMPORALES;
	IDC_ICDAS_P_SEV4 = 0; * PERMANENTES;
	IDC_ICDAS_J_SEV4 = 0; * JUNTOS;

	*** VALORES  5;
	IDC_ICDAS_T_SEV5 = 0; * TEMPORALES;
	IDC_ICDAS_P_SEV5 = 0; * PERMANENTES;
	IDC_ICDAS_J_SEV5 = 0; * JUNTOS;

	*** VALORES 6;
	IDC_ICDAS_T_SEV6 = 0; * TEMPORALES;
	IDC_ICDAS_P_SEV6 = 0; * PERMANENTES;
	IDC_ICDAS_J_SEV6 = 0; * JUNTOS;

	****************************************************************************************** FORMULA 17, 18 y 19
	Indice CPO-d apartir de COP, 
	VALORES 1,2,3 + 4/n, ó B,C,D + E/n;
	CPO_D_T = 0; * TEMPORALES; 
	CPO_D_P = 0; * PERMANENTES;
	CPO_D_J = 0; * JUNTOS;

	****************************************************************************************** FORMULA 20 y 21
	CPO-d = COP (1+2+3+4)+ ICDAS (2+3)/n ó COP (B+C+E+D)+ ICDAS (2+3)/n;
	CPO_D_MOD_T = 0; * TEMPORALES;
	CPO_D_MOD_P = 0; * PERMANENTES;
	CPO_D_MOD_J = 0; * JUNTOS;

	****************************************************************************************** FORMULA(3) 22
	ISC= Suma CPO-d 12 años tercil más afectado/ n 12 años;
	****************************************************************************************** FORMULA(2) 23
	ISC= Suma CPO-d 5 años tercil más afectado/ n 5 años;
	ISC_T = .;
	ISC_P = .;
	ISC_J = .;

	****************************************************************************************** FORMULA(3) 24
	IPMPSanos = suma 0 (16+26+36+46) / n 12 años, COP;
	*IPMP_S_T = .;
	IPMP_S_P = .;
	*IPMP_S_J = .;

	****************************************************************************************** FORMULA(3) 25
	IPMPPerdidos = suma 4 (16+26+36+46) / n 12 años, COP;
	*IPMP_P_T = .;
	IPMP_P_P = .;
	*IPMP_P_J = .;

	****************************************************************************************** FORMULA(3) 26
	IPMPCariados = suma COP (1+2) (16+26+36+46) / n 12 años;
	*IPMP_C_T = .;
	IPMP_C_P = .;
	*IPMP_C_J = .;

	****************************************************************************************** FORMULA(3) 27
	IPMPCariados = suma ICDAS (2+3) (16+26+36+46) / n 12 años;
	*IPMP_ICDAS_C_T = .;
	IPMP_ICDAS_C_P = .;
	*IPMP_ICDAS_C_J = .;

	****************************************************************************************** FORMULA(3) 28
	IPMPCariados = suma COP (1+2) + ICDAS (2+3) (16+26+36+46) / n 12 años;
	*IPMP_COP_ICDAS_C_T = .;
	IPMP_COP_ICDAS_C_P = .;
	*IPMP_COP_ICDAS_C_J = .;

	****************************************************************************************** FORMULA(3) 29
	IPMPObturados = suma 3 (16+26+36+46) / n 12 años;
	*IPMP_O_T = .;
	IPMP_O_P = .;
	*IPMP_O_J = .;

	****************************************************************************************** FORMULA(3) 30
	IPMPCariados severidad= suma ICDAS 2 o 3 o 4 o 5 o 6 (16+26+36+46) / n 12 años 
	(se calcula la sumatoria por cada nivel de severidad en los 1eros molares);
	*** VALORES  2;
	IPMP_ICDAS_P_SEV2 = .; * PERMANENTES;
	
	*** VALORES  3;
	IPMP_ICDAS_P_SEV3 = .; * PERMANENTES;
	
	*** VALORES  4;
	IPMP_ICDAS_P_SEV4 = .; * PERMANENTES;
	
	*** VALORES  5;
	IPMP_ICDAS_P_SEV5 = .; * PERMANENTES;
	
	*** VALORES 6;
	IPMP_ICDAS_P_SEV6 = .; * PERMANENTES;
	
	**************************************************************************************PETICION SANDRA;
	SELL_POR_T = 0;
	SELL_POR_P = 0;
	SELL_POR_J = 0;

	SELL_PRO_T = 0;
	SELL_PRO_P = 0;
	SELL_PRO_J = 0;


	****************************************************************************************** FORMULA 15

	****************************************************************************************** FORMULA 14

	****************************************************************************************** FORMULA 31
	PDPC = suma 5 /n cada grupo de edad de 5, 12, 15, 18, 20 y más años;
	*PDPC_T = 0;
	PDPC_P = 0;
	*PDPC_J = 0;

	****************************************************************************************** FORMULA(5) 32
	IRC = suma de 1 + 2 / n, Caries radicular en personas de 35 años y más;
	*IRC_T = .;
	IRC_P = .;
	*IRC_J = .;

	****************************************************************************************** FORMULA(5) 33
	IRO = suma de 3 / n;
	*IRO_T = .;
	IRO_P = .;
	*IRO_J = .;

	****************************************************************************************** FORMULA(5) 34
	IROC = suma de 3 + 1 + 2 / n;
	*IROC_T = .;
	IROC_P = .;
	*IROC_J = .;

	****************************************************************************************** FORMULA(5) 35
	PCR= % personas con 1 o 2;
	*PCR_T = .;
	PCR_P = .;
	*PCR_J = .;

	****************************************************************************************** FORMULA(5)
	PADB 28 = % personas con 28 dientes en boca (0,1,2,3,6,7);
	*PADB_28_T = .;
	DIE_BOCAP = 0;
	DIE_BOCAT = 0;
	DIE_BOCAJ = 0;
	*PADB_28_P = .;
	*PADB_28_J = .;

	****************************************************************************************** FORMULA(5) 
	PADB < 20 = % personas con < 20 dientes en boca (0,1,2,3,6,7);
	*PADB_M_20_T = .;
	PADB_M_20_P = .;
	*PADB_M_20_J = .;

	****************************************************************************************** FORMULA 39
	Edéntulismo parcial= % personas edéntulas parciales con códigos 4 o 5 en uno o varios dientes;
	ED_P = 0;
	
	*******************************************************************************************
	. Parcialmente edéntulo (PE)
   . Tramo posterior: (PETP)
       Inferior: (PETPI)
         Derecho:  (PETPID (47, 46, 45, 44))                           
         Izquierdo: (PETPII (37, 36, 35, 34))                           
      Superior: (PETPS):                                 
         Derecho:  (PETPSD (17, 16, 15, 14))                         
         Izquierdo: (PETPSI (27, 26, 25, 24))                                                             
    . Tramo anterior: (PETA) 
       Inferior: (PETAI  (43, 42, 41, 31, 32, 33))                                                                                        
       Superior: (PETAS (13, 12, 11, 21, 22, 23));
	PETPID_POR = 0;
	PETPID_PRO = 0;
	PETPII_POR  = 0;
	PETPII_PRO  = 0;
	PETPSD_POR  = 0;
	PETPSD_PRO  = 0;
	PETPSI_POR  = 0;
	PETPSI_PRO  = 0;
	PETAI_POR  = 0;
	PETAI_PRO  = 0;
	PETAS_POR  = 0;
	PETAS_PRO  = 0; 

	PETPID_EVAL = 0;
	PETPID_TE = 0;
	PETPII_EVAL  = 0;
	PETPII_TE  = 0;
	PETPSD_EVAL  = 0;
	PETPSD_TE  = 0;
	PETPSI_EVAL  = 0;
	PETPSI_TE  = 0;
	PETAI_EVAL  = 0;
	PETAI_TE  = 0;
	PETAS_EVAL  = 0;
	PETAS_TE  = 0; 
	****************************************************************************************** FORMULA 36
	Edéntulismo parcial PE= % personas edéntulas parciales con códigos 4 o 5 en uno o varios dientes;

	****************************************************************************************** FORMULA 37
	Tramo posterior PET= % personas parcialmente edéntulas en los tramos posteriores derecho y/o izquierdo/ n 
	para maxilar superior, maxilar inferior, maxilares superior e inferior simultáneo
	Tramo Anterior PET = % personas parcialmente edéntulas en el tramo anterior  / n 
	para maxilar superior, maxilar inferior, maxilares superior e inferior simultáneo;


	****************************************************************************************** FORMULA 38
	Dientes ausentes por tramo DAT= sumar o contar los dientes con códigos 4 o 5 por tramo / n;


	****************************************************************************************** FORMULA 39
	Edentulismo total ET= % personas con 4 o 5 en todos los dientes / n;

	****************************************************************************************** FORMULA 40
	PADB por rango= % personas por rango optimo o adecuado o satisfactoria o mínima
	o no funcional o ausencia total (0,1,2,3,6,7) / n;

	****************************************************************************************** FORMULA 42
	IIP= sumar los implantes 7 y (4, 45) / n;
	IIP = 0;

	****************************************************************************************** FORMULA 43
	IDA= sumar los dientes ausentes / n,  COP(4,5);
	IDA_P = 0;

	****************************************************************************************** FORMULA 44
	PDF= % personas > 21 dientes / n;
	PDF = 0;
	
	PAATD_P = 0;
	PADB_28_P = 0;
	PADB_M_20_P = 0;


**************PROTESIS
	Maxilar superior, (17,16,15,14,13,12,11,21,22,23,24,25,26,27)
	Maxilar inferior, (47,46,45,44,43,42,41,31,32,33,34,35,36,37) 

	****************************************************************************************** FORMULA 85
	PP= % personas con algún tipo de prótesis dental (1, 2, 3 y 4) / n
	PP= % personas con cada tipo de prótesis dental 1, o 2, o 3, o 4 / n;
	PP_AT = 0;
	PP_CT_1 = 0;
	PP_CT_2 = 0;
	PP_CT_3 = 0;
	PP_CT_4 = 0;
	*PP_CT_45 = 0;
	
	****************************************************************************************** FORMULA 86;
	PP_C	 = 0;
	PP_CT_15 = 0;
	PP_CT_25 = 0;
	PP_CT_35 = 0;
	PP_CT_45 = 0;


	****************************************************************************************** FORMULA 87
	UPMS= % personas con prótesis Fija (1, 4), removible (2 o 3) o ambas (1, 2, 3, 4) maxilar superior / n;
	UPMS        = 0;
	UPMS_F		= 0;
	UPMS_R		= 0;
	UPMS_C		= 0;
	UPMS_C_F	= 0;
	UPMS_C_R	= 0;

	
	****************************************************************************************** FORMULA 89
	UPMI= % personas con prótesis Fija (1, 4), removible (2 o 3) o ambas (1,2, 3, 4) maxilar inferior / n;
	UPMI     = 0;
	UPMI_F	 = 0;
	UPMI_R	 = 0;
	UPMI_C	 = 0;
	UPMI_C_F = 0;
	UPMI_C_R = 0;

	
	****************************************************************************************** FORMULA 91;
	UPPAM_S = 0;
	UPPAM_I = 0;
	UPPAM   = 0;
	
	****************************************************************************************** FORMULA 92;
	UPPAM_CS = 0;
	UPPAM_CI = 0;
	UPPAM_C  = 0;
	
	****************************************************************************************** FORMULA 93 - 94;
	*UPTMS= % personas con prótesis total (3) superior / n;
	UPTMS     = 0;
	UPTMS_C   = 0;
	
	UPTMS_D   = 0;
	UPTMS_C_D = 0;

	****************************************************************************************** FORMULA 95 - 96
	UPMTI= % personas con prótesis total (3) inferior / n;
	UPMTI     = 0;
	UPTMI_C   = 0;

	UPTMI_D   = 0;
	UPTMI_C_D = 0;

	****************************************************************************************** FORMULA 95
	UPMI= % personas con prótesis total (3) inferior / n;
	UPMI = 0;
	UPTMI_C = 0;

	****************************************************************************************** FORMULA 97
	UPTMS / PFoRMI= % personas con prótesis total (3) superior con prótesis fija 
	o removible (1, 2, 4) en el maxilar inferior / n;
	*PFORMI_F_R = 0;

	****************************************************************************************** FORMULA 99
	UPFoRMS / PTMI= % personas con prótesis total (3) inferior con prótesis fija 
	o removible (1, 2, 4) en el maxilar superior / n;
	*PFORMS_F_R = 0;

	****************************************************************************************** FORMULA 101
	UPTBM= % personas con prótesis total (3) en ambos maxilares / n;
	UPTBM = 0;
	UPTBM_C = 0;

	****************************************************************************************** FORMULA 103
	Uso Prótesis= % personas con implantes (4) / n;
	*UPTAM = 0;

	****************************************************************************************** FORMULA 104
	PO= suma de pares oclusales presentes en boca con dientes naturales / n;
	PAR_OCLU = 0;
	PAR_OCLU_R = 0;
	
	****************************************************************************************** FORMULA 126;
	NPTMAM = 0;
	NPTMS  = 0;*?;
	NPTMI  = 0;*?;
	
	NPTMAM_C = 0;*?;
	NPTMS_C  = 0;*?;
	NPTMI_C  = 0;*?;
	
	****************************************************************************************** FORMULA 127;
	NPPMAM  = 0;
	NPPMS   = 0;
	NPPMS_C = 0;
	NPPMI   = 0;
	NPPMI_C = 0;
	
	
	REGS_C  = 0;
	REGI_C  = 0;


	**********OPACIDAD;
	****************************************************************************************** FORMULA 119;
	POE = 0;
	POE_IC = 0;
	POE_MP = 0;
	
	POE_7 = 0;
	POE_IC_7 = 0;
	POE_MP_7 = 0;
	
	POE_8 = 0;
	POE_IC_8 = 0;
	POE_MP_8 = 0;

	POE_C = 0;
	POE_IC_C = 0;
	POE_MP_C = 0;	
	
		*** ;
	PERMANENTES = 0;
	TEMPORALES 	= 0;
	EVALUADOS 	= 0;

	* * * * * ICDAS4;
	ARRAY ICDAS {4, 7}
		 MD_304g MD_304f MD_304e MD_304d MD_304c MD_304b MD_304a
		 MD_304h MD_304i MD_304j MD_304k MD_304l MD_304m MD_304n
		 MD_307h MD_307i MD_307j MD_307k MD_307l MD_307m MD_307n
		 MD_307g MD_307f MD_307e MD_307d MD_307c MD_307b MD_307a
	;
	* * * * * OPAC4;
	ARRAY OPAC {4, 7}
		 MD_304g1 MD_304f1 MD_304e1 MD_304d1 MD_304c1 MD_304b1 MD_304a1
		 MD_304h1 MD_304i1 MD_304j1 MD_304k1 MD_304l1 MD_304m1 MD_304n1
		 MD_307h1 MD_307i1 MD_307j1 MD_307k1 MD_307l1 MD_307m1 MD_307n1
		 MD_307g1 MD_307f1 MD_307e1 MD_307d1 MD_307c1 MD_307b1 MD_307a1
	;

	* * * * * cop4;
	ARRAY cop {4, 7}
		 MD_305g MD_305f MD_305e MD_305d MD_305c MD_305b MD_305a
		 MD_305h MD_305i MD_305j MD_305k MD_305l MD_305m MD_305n
		 MD_308h MD_308i MD_308j MD_308k MD_308l MD_308m MD_308n
		 MD_308g MD_308f MD_308e MD_308d MD_308c MD_308b MD_308a
	;

	* * * * * pro4 protesis;
	ARRAY prot {4, 7}
		 MD_306g MD_306f MD_306e MD_306d MD_306c MD_306b MD_306a
		 MD_306h MD_306i MD_306j MD_306k MD_306l MD_306m MD_306n
		 MD_309h MD_309i MD_309j MD_309k MD_309l MD_309m MD_309n
		 MD_309g MD_309f MD_309e MD_309d MD_309c MD_309b MD_309a
	;

	

	DO P = 1 TO 4;
		DO M = 1 TO DIM(COP, 2);
			
			IF	SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') 
				AND COP[P, M] IN('0', '1', '2', '3', '4', '5', '6', '7') THEN PERMANENTES + 1;
			IF	SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') 
				AND COP[P, M] IN('A', 'B', 'C', 'D', 'E', 'F') THEN TEMPORALES + 1;	
			IF COP[P, M] IN('0', '1', '2', '3', '4', '5', '6', '7', 
							'A', 'B', 'C', 'D', 'E', 'F') THEN EVALUADOS + 1;	

			IF	SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') 
				AND COP[P, M] IN('B', 'C') THEN DO;
				PC_COP_T = 1; * TEMPORALES;
			END;

			IF	SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') 
				AND COP[P, M] IN('1', '2') THEN DO;
				PC_COP_P = 1; * PERMANENTES;
			END;

			IF	COP[P, M] IN('B', 'C', '1', '2') THEN DO;
				PC_COP_J = 1; * JUNTOS;
			END;

			***;
			IF	SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') 
				AND ICDAS[P, M] IN(2, 3, 4, 5, 6) THEN DO;
				PC_ICDAS_T = 1; * TEMPORALES;
			END;

			IF	SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') 
				AND ICDAS[P, M] IN(2, 3, 4, 5, 6) THEN DO;
				PC_ICDAS_P = 1; * PERMANENTE;
			END;

			IF	ICDAS[P, M] IN(2, 3, 4, 5, 6) THEN DO;
				PC_ICDAS_J = 1; * JUNTOS;
			END;
	
			***;
			IF	 ICDAS[P ,M] IN(2) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				 PC_ICDAS_T_SEV2 = 1; * TEMPORALES;
			END;
			IF	 ICDAS[P ,M] IN(2) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				 PC_ICDAS_P_SEV2 = 1; * PERMANENTE;
			END;
			IF	 ICDAS[P ,M] IN(2) THEN DO;
				 PC_ICDAS_J_SEV2 = 1; * JUNTOS;
			END;
			IF	 ICDAS[P ,M] IN(3) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				 PC_ICDAS_T_SEV3 = 1; * TEMPORALES;
			END;
			IF	 ICDAS[P ,M] IN(3) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				 PC_ICDAS_P_SEV3 = 1; * PERMANENTE;
			END;
			IF	 ICDAS[P ,M] IN(3) THEN DO;
				 PC_ICDAS_J_SEV3 = 1; * JUNTOS;
			END;
			IF	 ICDAS[P ,M] IN(4) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				 PC_ICDAS_T_SEV4 = 1; * TEMPORALES;
			END;
			IF	 ICDAS[P ,M] IN(4) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				 PC_ICDAS_P_SEV4 = 1; * PERMANENTE;
			END;
			IF	 ICDAS[P ,M] IN(4) THEN DO;
				 PC_ICDAS_J_SEV4 = 1; * JUNTOS;
			END;
			IF	 ICDAS[P ,M] IN(5) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				 PC_ICDAS_T_SEV5 = 1; * TEMPORALES;
			END;
			IF	 ICDAS[P ,M] IN(5) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				 PC_ICDAS_P_SEV5 = 1; * PERMANENTE;
			END;
			IF	 ICDAS[P ,M] IN(5) THEN DO;
				 PC_ICDAS_J_SEV5 = 1; * JUNTOS;
			END;
			IF	 ICDAS[P ,M] IN(6) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				 PC_ICDAS_T_SEV6 = 1; * TEMPORALES;
			END;
			IF	 ICDAS[P ,M] IN(6) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				 PC_ICDAS_P_SEV6 = 1; * PERMANENTE;
			END; 
			IF	 ICDAS[P ,M] IN(6) THEN DO;
				 PC_ICDAS_J_SEV6 = 1; * JUNTOS;
			END;

			***;
			/*IF	SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') 
				AND (ICDAS[P, M] IN(2, 3, 4, 5, 6) OR COP[P, M] IN('1', '2')) THEN DO;
				PC_COP_ICDAS_T = 1; * TEMPORALES;
			END;

			IF	SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') 
				AND (ICDAS[P, M] IN(2, 3, 4, 5, 6) OR COP[P, M] IN('B', 'C')) THEN DO;
				PC_COP_ICDAS_P = 1; * PERMANENTE;
			END;

			IF	(ICDAS[P, M] IN(2, 3, 4, 5, 6) OR COP[P, M] IN('B', 'C', '1', '2')) THEN DO;
				PC_COP_ICDAS_J = 1; * JUNTOS;
			END;*/
			
			***;
			IF	SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8')
				AND COP[P ,M]	IN('B', 'C', 'D', 'E') THEN DO;
				EC_COP_T = 1; * TEMPORALES;
			END;

			IF	SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4')
				AND COP[P ,M]	IN('1', '2', '3', '4') THEN DO;
				EC_COP_P = 1; * PERMANENTE;
			END;

			IF	COP[P ,M]	IN('B', 'C', 'D', 'E', '1', '2', '3', '4') THEN DO;
				EC_COP_J = 1; * JUNTOS;
			END;

			***;
			IF ICDAS[P, M] IN(2, 3, 4, 5, 6) OR COP[P, M] IN('B', 'C', 'D', 'E')
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO; 
				EC_COP_ICDAS_T = 1; * TEMPORALES;
			END;

			IF ICDAS[P, M] IN(2, 3, 4, 5, 6) OR COP[P, M] IN('1', '2', '3', '4')
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO; 
				EC_COP_ICDAS_P = 1; * PERMANENTE;
			END;

			IF ICDAS[P, M] IN(2, 3, 4, 5, 6) OR COP[P, M] IN('B', 'C', 'D', 'E', '1', '2', '3', '4') 
				THEN DO; 
				EC_COP_ICDAS_J = 1; * JUNTOS;
			END;

			***;
			IF COP[P, M] IN('A', 'F') 
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;		
				IDS_POR_COP_T = 1; * TEMPORALES;
				
				IDS_PRO_COP_T + 1; * TEMPORALES;
			END;

			IF COP[P ,M] IN('0', '6') 
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;		
				IDS_POR_COP_P = 1; * PERMANENTE;
				
				IDS_PRO_COP_P + 1; * PERMANENTE;
			END;

			IF COP[P ,M] IN('A', '0', 'F', '6')  THEN DO;		
				IDS_POR_COP_J = 1; * JUNTOS;
				
				IDS_PRO_COP_J + 1; * JUNTOS;
			END;
			
			***;
			IF COP[P, M] IN('F') 
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;		
				SELL_POR_T = 1; * TEMPORALES;
				
				SELL_PRO_T + 1; * TEMPORALES;
			END;

			IF COP[P ,M] IN('6') 
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;		
				SELL_POR_P = 1; * PERMANENTE;
				
				SELL_PRO_P + 1; * PERMANENTE;
			END;

			IF COP[P ,M] IN('F', '6')  THEN DO;		
				SELL_POR_J = 1; * JUNTOS;
				
				SELL_PRO_J + 1; * JUNTOS;
			END;
			
			***;
			IF	COP[P, M] IN('B', 'C')
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				IDC_COP_T + 1; * TEMPORALES;
			END;

			IF	COP[P, M] IN('1', '2')
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				IDC_COP_P + 1; * PERMANENTE;
			END;

			IF	COP[P, M] IN('B', 'C', '1', '2') THEN DO;
				IDC_COP_J + 1; * JUNTOS;
			END;

			***;
			IF	ICDAS[P, M] IN(2, 3, 4, 5, 6) 
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				IDC_ICDAS_T + 1; * TEMPORALES;
			END;

			IF	ICDAS[P, M] IN(2, 3, 4, 5, 6) 
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				IDC_ICDAS_P + 1; * PERMANENTE;
			END;

			IF	ICDAS[P, M] IN(2, 3, 4, 5, 6) THEN DO;
				IDC_ICDAS_J + 1; * JUNTOS;
			END;

			***;

			IF	ICDAS[P, M] IN(2)
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				IDC_LT_ICDAS_T + 1; * TEMPORALES;
			END;

			IF	ICDAS[P, M] IN(2) 
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				IDC_LT_ICDAS_P + 1; * PERMANENTE;
			END;

			IF	ICDAS[P, M] IN(2) THEN DO;
				IDC_LT_ICDAS_J + 1; * JUNTOS;
			END;

			***;
			/*IF (COP[P, M] IN('B', 'C') OR ICDAS[P, M] IN(2, 3, 4, 5, 6))  
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8')  
				THEN DO; 
				IDC_COP_ICDAS_T + 1; * TEMPORALES;
			END;

			IF (COP[P, M] IN('1', '2') OR ICDAS[P, M] IN(2, 3, 4, 5, 6))   
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') 
				THEN DO; 
				IDC_COP_ICDAS_P + 1; * PERMANENTE;
			END;

			IF (COP[P, M] IN('B', 'C', '1', '2') OR ICDAS[P, M] IN(2, 3, 4, 5, 6))   
				THEN DO; 
				IDC_COP_ICDAS_J + 1; * JUNTOS;
			END;*/

			***;
			IF (ICDAS[P, M] IN(2, 3, 4, 5, 6) AND COP[P, M] NOT IN('B', 'C', 'D', 'E'))  
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8')  
				THEN DO; 
				/*IDC_ICDAS_SCOP_T + 1; * TEMPORALES;
				PC_ICDAS_SCOP_T  = 1;*/
				IDC_COP_ICDAS_T + 1; * TEMPORALES;
				PC_COP_ICDAS_T = 1; * TEMPORALES;
			END;

			IF (ICDAS[P, M] IN(2, 3, 4, 5, 6) AND COP[P, M] NOT IN('1', '2', '3', '4'))   
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') 
				THEN DO; 
				/*IDC_ICDAS_SCOP_P + 1; * PERMANENTE;
				PC_ICDAS_SCOP_P  = 1;*/
				IDC_COP_ICDAS_P + 1; * TEMPORALES;
				PC_COP_ICDAS_P  = 1; * TEMPORALES;
			END;

			IF (ICDAS[P, M] IN(2, 3, 4, 5, 6) AND 
				COP[P, M] NOT IN('B', 'C', 'D', 'E', '1', '2', '3', '4'))   
				THEN DO; 
				/*IDC_ICDAS_SCOP_J + 1; * JUNTOS;
				PC_ICDAS_SCOP_J  = 1;*/
				IDC_COP_ICDAS_J + 1; * TEMPORALES;
				PC_COP_ICDAS_J  = 1; * TEMPORALES;
			END;
			
			***;
			IF COP[P, M] IN('D')
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				IDO_POR_COP_T = 1; * TEMPORALES;
				IDO_PRO_COP_T + 1; * TEMPORALES;
			END;

			IF COP[P, M] IN('3')
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				IDO_POR_COP_P = 1; * PERMANENTE;
				IDO_PRO_COP_P + 1; * PERMANENTE;
			END;

			IF COP[P, M] IN('D', '3') THEN DO;
				IDO_POR_COP_J = 1; * JUNTOS;
				IDO_PRO_COP_J + 1; * JUNTOS;
			END;

			***;
			IF COP[P, M] IN('E')
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				IDP_POR_COP_T = 1; * TEMPORALES;
				IDP_PRO_COP_T + 1; * TEMPORALES;
			END;

			IF COP[P, M] IN('4')
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				IDP_POR_COP_P = 1; * PERMANENTE;
				IDP_PRO_COP_P + 1; * PERMANENTE;
			END;

			IF COP[P, M] IN('E', '4') THEN DO;
				IDP_POR_COP_J = 1; * JUNTOS;
				IDP_PRO_COP_J + 1; * JUNTOS;
			END;

			***;
			IF	 ICDAS[P ,M] IN(2) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				 IDC_ICDAS_T_SEV2 + 1; * TEMPORALES;
			END;
			IF	 ICDAS[P ,M] IN(2) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				 IDC_ICDAS_P_SEV2 + 1; * PERMANENTE;
			END;
			IF	 ICDAS[P ,M] IN(2) THEN DO;
				 IDC_ICDAS_J_SEV2 + 1; * JUNTOS;
			END;
			IF	 ICDAS[P ,M] IN(3) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				 IDC_ICDAS_T_SEV3 + 1; * TEMPORALES;
			END;
			IF	 ICDAS[P ,M] IN(3) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				 IDC_ICDAS_P_SEV3 + 1; * PERMANENTE;
			END;
			IF	 ICDAS[P ,M] IN(3) THEN DO;
				 IDC_ICDAS_J_SEV3 + 1; * JUNTOS;
			END;
			IF	 ICDAS[P ,M] IN(4) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				 IDC_ICDAS_T_SEV4 + 1; * TEMPORALES;
			END;
			IF	 ICDAS[P ,M] IN(4) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				 IDC_ICDAS_P_SEV4 + 1; * PERMANENTE;
			END;
			IF	 ICDAS[P ,M] IN(4) THEN DO;
				 IDC_ICDAS_J_SEV4 + 1; * JUNTOS;
			END;
			IF	 ICDAS[P ,M] IN(5) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				 IDC_ICDAS_T_SEV5 + 1; * TEMPORALES;
			END;
			IF	 ICDAS[P ,M] IN(5) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				 IDC_ICDAS_P_SEV5 + 1; * PERMANENTE;
			END;
			IF	 ICDAS[P ,M] IN(5) THEN DO;
				 IDC_ICDAS_J_SEV5 + 1; * JUNTOS;
			END;
			IF	 ICDAS[P ,M] IN(6) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				 IDC_ICDAS_T_SEV6 + 1; * TEMPORALES;
			END;
			IF	 ICDAS[P ,M] IN(6) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				 IDC_ICDAS_P_SEV6 + 1; * PERMANENTE;
			END; 
			IF	 ICDAS[P ,M] IN(6) THEN DO;
				 IDC_ICDAS_J_SEV6 + 1; * JUNTOS;
			END;

			***; 
			IF COP[P, M] IN('B', 'C', 'D', 'E')
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				CPO_D_T + 1; * TEMPORALES;
			END;

			IF COP[P, M] IN('1', '2', '3', '4')
				 AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				CPO_D_P + 1; * PERMANENTE;
			END;

			IF COP[P, M] IN('B', 'C', 'D', 'E', '1', '2', '3', '4') THEN DO;
				CPO_D_J + 1; * JUNTOS;
			END;

			***;
			IF (COP[P, M] IN('B', 'C', 'D', 'E') OR ICDAS[P, M] IN(2, 3, 4, 5, 6))
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				CPO_D_MOD_T + 1; * TEMPORALES;
			END;

			IF (COP[P, M] IN('1', '2', '3', '4') OR ICDAS[P, M] IN(2, 3, 4, 5, 6))
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				CPO_D_MOD_P + 1; * PERMANENTE;
			END;

			IF COP[P, M] IN('B', 'C', 'D', 'E', '1', '2', '3', '4') OR ICDAS[P, M] IN(2, 3, 4, 5, 6) THEN DO;
				CPO_D_MOD_J + 1; * JUNTOS;
			END;

			***;
			IF COP[P, M] IN('5') AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				PDPC_P + 1; * PERMANENTE;
			END;
			
			***;
			IF COP[P, M] IN('0', '1', '2', '3', '6', '7') AND
				SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				DIE_BOCAP + 1;
			END;
			
			IF COP[P, M] IN('A', 'B', 'C', 'D', 'F', 'G') AND
				SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				DIE_BOCAT + 1;
			END;
			
			IF COP[P, M] IN('0', '1', '2', '3', '6', '7',
							'A', 'B', 'C', 'D', 'F', 'G') THEN DO;
				DIE_BOCAJ + 1;
			END;

	************ EDENTULISMO;
			IF COP[P, M] IN('4', '5') AND 
				SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				ED_P = 1;
				IDA_P + 1;
			END;
	
			* * *Parcialmente edéntulo Tramo posterior Inferior Derecho;
			IF P = 4 AND M IN(4, 5, 6, 7) THEN DO;
				IF COP[P, M] IN('0', '1', '2', '3', '4', '5', '6', '7', 
							'A', 'B', 'C', 'D', 'E', 'F', 'G') THEN PETPID_EVAL + 1;
				IF COP[P, M] IN('4', '5') THEN DO;
					PETPID_POR = 1;
					PETPID_PRO + 1;
				END;
			END;

			* * *Parcialmente edéntulo Tramo posterior Inferior Izquierdo;
			IF P = 3 AND M IN(4, 5, 6, 7) THEN DO;
				IF COP[P, M] IN('0', '1', '2', '3', '4', '5', '6', '7', 
							'A', 'B', 'C', 'D', 'E', 'F', 'G') THEN PETPII_EVAL + 1;
				IF COP[P, M] IN('4', '5') THEN DO;
					PETPII_POR = 1;
					PETPII_PRO + 1;
				END;
			END;

			* * *Parcialmente edéntulo Tramo posterior Superior Derecho;
			IF P = 1 AND M IN(4, 5, 6, 7) THEN DO;
				IF COP[P, M] IN('0', '1', '2', '3', '4', '5', '6', '7', 
							'A', 'B', 'C', 'D', 'E', 'F', 'G') THEN PETPSD_EVAL + 1;
				IF COP[P, M] IN('4', '5') THEN DO;
					PETPSD_POR = 1;
					PETPSD_PRO + 1;
				END;
			END;

			* * *Parcialmente edéntulo Tramo posterior Superior Izquierdo;
			IF P = 2 AND M IN(4, 5, 6, 7) THEN DO; 
				IF COP[P, M] IN('0', '1', '2', '3', '4', '5', '6', '7', 
							'A', 'B', 'C', 'D', 'E', 'F', 'G') THEN PETPSI_EVAL + 1;			
				IF COP[P, M] IN('4', '5') THEN DO;
					PETPSI_POR = 1;
					PETPSI_PRO + 1;
				END;
			END;

			* * *Parcialmente edéntulo Tramo anterior Izquierdo;
			IF P in(3, 4) AND M IN(1, 2, 3) THEN DO; 
				IF COP[P, M] IN('0', '1', '2', '3', '4', '5', '6', '7', 
							'A', 'B', 'C', 'D', 'E', 'F', 'G') THEN PETAI_EVAL + 1;			
				IF COP[P, M] IN('4', '5') THEN DO;
					PETAI_POR = 1;
					PETAI_PRO + 1;
				END;
			END;

			* * *Parcialmente edéntulo Tramo anterior Derecho;
			IF P in(1, 2) AND M IN(1, 2, 3) THEN DO; 
				IF COP[P, M] IN('0', '1', '2', '3', '4', '5', '6', '7', 
							'A', 'B', 'C', 'D', 'E', 'F', 'G') THEN PETAS_EVAL + 1;				
				IF COP[P, M] IN('4', '5') THEN DO;
					PETAS_POR = 1;
					PETAS_PRO + 1;
				END;
			END;
			

	****************PERIODONTAL;
			***;
			IF COP[P, M] IN('7') AND PROT[P, M] IN(4, 45)
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				IIP + 1;
			END;
			
****************PROTESIS
			***85;
			IF PROT[P, M] IN(1, 2, 4, 15, 25, 45) THEN DO;
				PP_AT = 1;
			END;

			IF PROT[P, M] IN(1, 15) THEN DO;
				PP_CT_1 = 1;
			END;

			IF PROT[P, M] IN(2, 25) THEN DO;
				PP_CT_2 = 1;
			END;

			*IF PROT[P, M] IN(3, 35) THEN DO;
			*	PP_CT_3 = 1;
			*END;

			IF PROT[P, M] IN(4, 45) THEN DO;
				PP_CT_4 = 1;
			END;

			

			***86;
			IF PROT[P, M] IN(15, 25, 45) THEN DO;
				PP_C = 1;
			END;
			
			IF PROT[P, M] IN(15) THEN DO;
				PP_CT_15 = 1;
			END;
			
			IF PROT[P, M] IN(25) THEN DO;
				PP_CT_25 = 1;
			END;
			
			*IF PROT[P, M] IN(35) THEN DO;
			*	PP_CT_35 = 1;
			*END;
			
			IF PROT[P, M] IN(45) THEN DO;
				PP_CT_45 = 1;
			END;
			
			****87;
			IF P IN(1, 2) AND PROT[P, M] IN (1, 2, 4, 15, 25, 45)  THEN DO;
				UPMS = 1;
			END;
			
			IF P IN(1, 2) AND PROT[P, M] IN (1, 4, 15, 45)  THEN DO;
				UPMS_F = 1;
			END;
			
			IF P IN(1, 2) AND PROT[P, M] IN (2, 25)  THEN DO;
				UPMS_R = 1;
			END;
			
			****88;
			
			IF P IN(1, 2) AND PROT[P, M] IN (15, 25, 45)  THEN DO;
				UPMS_C = 1;
			END;
			
			IF P IN(1, 2) AND PROT[P, M] IN (15, 45)  THEN DO;
				UPMS_C_F = 1;
			END;
			
			IF P IN(1, 2) AND PROT[P, M] IN (25)  THEN DO;
				UPMS_C_R = 1;
			END;
			
			****89;
			IF P IN(3, 4) AND PROT[P, M] IN (1, 2, 4, 15, 25, 45)  THEN DO;
				UPMI = 1;
			END;
			
			IF P IN(3, 4) AND PROT[P, M] IN (1, 4, 15, 45)  THEN DO;
				UPMI_F = 1;
			END;
			
			IF P IN(3, 4) AND PROT[P, M] IN (2, 25)  THEN DO;
				UPMI_R = 1;
			END;
			
			****90;
			
			IF P IN(3, 4) AND PROT[P, M] IN (15, 25, 45)  THEN DO;
				UPMI_C = 1;
			END;
			
			IF P IN(3, 4) AND PROT[P, M] IN (15, 45)  THEN DO;
				UPMI_C_F = 1;
			END;
			
			IF P IN(3, 4) AND PROT[P, M] IN (25)  THEN DO;
				UPMI_C_R = 1;
			END;
			
			****91;
			IF P IN(1, 2) AND PROT[P, M] IN (1, 2, 4, 15, 25, 45)  THEN DO;
				UPPAM_S = 1;
			END;
			IF P IN(3, 4) AND PROT[P, M] IN (1, 2, 4, 15, 25, 45)  THEN DO;
				UPPAM_I = 1;
			END;	
			
			****92;
			IF P IN(1, 2) AND PROT[P, M] IN (15, 25, 45)  THEN DO;
				UPPAM_CS = 1;
			END;
			IF P IN(3, 4) AND PROT[P, M] IN (15, 25, 45)  THEN DO;
				UPPAM_CI = 1;
			END;

			****93;
			IF P IN(1, 2) AND PROT[P, M] IN (3, 35)  THEN DO;
				UPTMS = 1;
				UPTMS_D + 1;
			END;
			
			****94;
			IF P IN(1, 2) AND PROT[P, M] IN (35)  THEN DO;
				UPTMS_C = 1;
				UPTMS_C_D + 1;
			END;
			
			****95;
			IF P IN(3, 4) AND PROT[P, M] IN (3, 35)  THEN DO;
				UPTMI = 1;
				UPTMI_D + 1;
			END;
			
			****96;
			IF P IN(3, 4) AND PROT[P, M] IN (35)  THEN DO;
				UPTMI_C = 1;
				UPTMI_C_D + 1;
			END;
			
			****97;
			*IF P IN(1, 2) AND PROT[P, M] IN (1, 2, 4, 15, 25, 45)  THEN DO;
			*	PFORMS_F_R = 1;
			*END;			
			
			****99;
			*IF P IN(3, 4) AND PROT[P, M] IN (1, 2, 4, 15, 25, 45)  THEN DO;
			*	PFORMI_F_R = 1;
			*END;			
			
			****101;
			*IF PROT[P, M] IN (3, 35)  THEN DO;
			*	UPTBM = 1;
			*END;
			
			****102;
			*IF PROT[P, M] IN (35)  THEN DO;
			*	UPTBM_C = 1;
			*END;
			
			****103;
			*IF PROT[P, M] IN (4, 45)  THEN DO;
			*	UPTAM = 1;
			*END;
			
			****126;
			IF PROT[P, M] IN (0)  THEN NPTMAM_C + 1;
			IF P IN(1, 2) AND PROT[P, M] IN (0)  THEN NPTMS_C + 1;
			IF P IN(3, 4) AND PROT[P, M] IN (0)  THEN NPTMI_C + 1;
			
			****127;
			IF PROT[P, M] IN (0, 15, 25, 45)  THEN DO;
				NPPMAM = 1;
			END;
			IF P IN(1, 2) AND PROT[P, M] IN (0, 15, 25, 45)  THEN DO;
				NPPMS = 1;
				NPPMS_C + 1;
			END;
			IF P IN(3, 4) AND PROT[P, M] IN (0, 15, 25, 45)  THEN DO;
				NPPMI = 1;
				NPPMI_C + 1;
			END;
			
			IF P IN(1, 2) AND PROT[P, M] NE 9 THEN REGS_C + 1;
			IF P IN(3, 4) AND PROT[P, M] NE 9 THEN REGI_C + 1;

			***** oclusión pares oclusales formula 86;
			IF P IN(1,2) THEN DO;
				IF P = 1 THEN P2 = 4;
				IF P = 2 THEN P2 = 3;

				IF M = 7 THEN DO; 
					IF COP[P, M] IN('0', '1', '2', '3', '6', '7') AND 
						COP[P2, M] IN('0', '1', '2', '3', '6', '7') THEN 
						PAR_OCLU + 1;
				END;
				ELSE DO;
					IF COP[P, M] IN('0', '1', '2', '3', '6', '7') AND
						(COP[P2, M] IN('0', '1', '2', '3', '6', '7')  OR 
						COP[P2, M + 1] IN('0', '1', '2', '3', '6', '7')) THEN
							PAR_OCLU + 1;
				END;
				
				IF M = 7 THEN DO; 
					IF (COP[P, M] IN('0', '1', '2', '3', '6', '7') OR 
						PROT[P, M] IN(1, 15, 2, 25, 3, 35, 4, 45)) AND 
						(COP[P2, M] IN('0', '1', '2', '3', '6', '7') OR
						 PROT[P2, M] IN(1, 15, 2, 25, 3, 35, 4, 45)) THEN 
						PAR_OCLU_R + 1;
				END;
				ELSE DO;
					IF (COP[P, M] IN('0', '1', '2', '3', '6', '7') OR
						PROT[P, M] IN(1, 15, 2, 25, 3, 35, 4, 45)) AND
						(COP[P2, M] IN('0', '1', '2', '3', '6', '7')  OR 
						 PROT[P2, M] IN(1, 15, 2, 25, 3, 35, 4, 45) OR
						COP[P2, M + 1] IN('0', '1', '2', '3', '6', '7') OR
						PROT[P2, M + 1] IN(1, 15, 2, 25, 3, 35, 4, 45)) THEN
							PAR_OCLU_R + 1;
				END;
			END;
			
			************ OPACIDAD;
			IF OPAC[P, M] IN(7, 8) THEN DO;
				POE = 1;
				POE_C + 1;
				IF OPAC[P, M] IN(7) THEN POE_7 + 1;
				IF OPAC[P, M] IN(8) THEN POE_8 + 1;
				
				IF M IN(1, 2, 3) 		THEN DO;
					POE_IC = 1;
					POE_IC_C + 1;
					IF OPAC[P, M] IN(7) THEN POE_IC_7 + 1;
					IF OPAC[P, M] IN(8) THEN POE_IC_8 + 1;
				END;
				IF M IN(4, 5, 6, 7, 8) 	THEN DO;
					POE_MP = 1;
					POE_MP_C + 1;
					IF OPAC[P, M] IN(7) THEN POE_MP_7 + 1;
					IF OPAC[P, M] IN(8) THEN POE_MP_8 + 1;
				END;
			END;
		END;
	END;

	IF IDA_P = PERMANENTES THEN PAATD_P = 1;
	IF DIE_BOCAP = 28  THEN PADB_28_P = 1;
	IF DIE_BOCAP < 20  THEN PADB_M_20_P = 1;
	IF DIE_BOCAP >= 21 THEN PDF = 1;
	
	SELECT;
	    WHEN (DIE_BOCAP = . ) EDEN_CLA = 9;
		WHEN (DIE_BOCAP = 0 ) EDEN_CLA = 0;
		WHEN (DIE_BOCAP < 16) EDEN_CLA = 1;
		WHEN (DIE_BOCAP < 20) EDEN_CLA = 2;
		WHEN (DIE_BOCAP < 24) EDEN_CLA = 3;
		WHEN (DIE_BOCAP < 28) EDEN_CLA = 4;
		WHEN (DIE_BOCAP = 28) EDEN_CLA = 5;
		OTHERWISE            EDEN_CLA =  9;
	END;
	
	IF PETPID_EVAL = PETPID_PRO THEN PETPID_TE = 1;
	IF PETPII_EVAL = PETPII_PRO THEN PETPII_TE = 1;
	IF PETPSD_EVAL = PETPSD_PRO THEN PETPSD_TE = 1;
	IF PETPSI_EVAL = PETPSI_PRO THEN PETPSI_TE = 1;
	IF PETAI_EVAL  = PETAI_PRO  THEN PETAI_TE  = 1;
	IF PETAS_EVAL  = PETAS_PRO  THEN PETAS_TE  = 1;
	
	* * * PROTESIS;
	* * FORMULA 93 Y 95;
	IF PETPSD_TE AND PETPSI_TE AND PETAS_TE AND UPTMS THEN UPTMS = 1;ELSE UPTMS = 0;
	IF PETPID_TE AND PETPII_TE AND PETAI_TE AND UPTMI THEN UPTMI = 1;ELSE UPTMI = 0;
	
	IF UPTMS = 0 THEN UPTMS_D = 0;
	IF UPTMI = 0 THEN UPTMI_D = 0;
	
	* * FORMULA 94 Y 96;	
	IF PETPSD_TE AND PETPSI_TE AND PETAS_TE AND UPTMS_C THEN UPTMS_C = 1;ELSE UPTMS_C = 0;
	IF PETPID_TE AND PETPII_TE AND PETAI_TE AND UPTMI_C THEN UPTMI_C = 1;ELSE UPTMI_C = 0;

	IF UPTMS_C = 0 THEN UPTMS_C_D = 0;
	IF UPTMI_C = 0 THEN UPTMI_C_D = 0;
	
	* * FORMULA 85 Y 86;
	IF UPTMS   OR UPTMI   THEN PP_CT_3 =  1;ELSE PP_CT_3  = 0;
	IF UPTMS_C OR UPTMI_C THEN PP_CT_35 = 1;ELSE PP_CT_35 = 0;
	
	IF PP_CT_3  AND PP_AT = 0 THEN PP_AT = 1;
	IF PP_CT_35 AND PP_C  = 0 THEN PP_C  = 1;
	
	* * FORMULA 87 Y 88;
	IF UPTMS   AND UPMS     = 0 THEN UPMS     = 1;
	IF UPTMS   AND UPMS_R   = 0 THEN UPMS_R   = 1;
	
	IF UPTMS_C AND UPMS_C   = 0 THEN UPMS_C   = 1;
	IF UPTMS_C AND UPMS_C_R = 0 THEN UPMS_C_R = 1;
	
	* * FORMULA 89 Y 90;
	IF UPTMI   AND UPMI     = 0 THEN UPMI     = 1;
	IF UPTMI   AND UPMI_R   = 0 THEN UPMI_R   = 1;
	
	IF UPTMI_C AND UPMI_C   = 0 THEN UPMI_C   = 1;
	IF UPTMI_C AND UPMI_C_R = 0 THEN UPMI_C_R = 1;
	
	* * FORMULA 91 Y 92;
	IF UPPAM_S  = 1 AND UPPAM_I  = 1 THEN UPPAM   = 1;
	IF UPPAM_CS = 1 AND UPPAM_CI = 1 THEN UPPAM_C = 1;
	
 	* * FORMULA 97 Y 99;
	IF UPTMS = 1 AND UPPAM_I = 1 THEN PFORMI = 1;ELSE PFORMI = 0; 
	IF UPTMI = 1 AND UPPAM_S = 1 THEN PFORMS = 1;ELSE PFORMS = 0;
	
	* * FORMULA 101 Y 102;
	IF UPTMS AND UPTMI THEN UPTBM = 1;ELSE UPTBM = 0;
	IF UPTMS_C AND UPTMI_C THEN UPTBM_C = 1;ELSE UPTBM_C = 0;
	
	* * FORMULA 126;
	IF REGI_C = NPTMI_C + UPTMI_C_D AND PETPID_TE AND PETPII_TE AND PETAI_TE THEN NPTMI = 1;
	IF REGS_C = NPTMS_C + UPTMS_C_D AND PETPSD_TE AND PETPSI_TE AND PETAS_TE THEN NPTMS = 1;
	IF NPTMI AND NPTMS THEN NPTMAM = 1;
	
	* * FORMULA 127;
		* * AJUSTE PARA LOS QUE REPORTAN TODOS LOS DIENTES PARA CAMBIO;
	*IF REGS_C = NPPMS_C THEN NPPMS = 0;
	*IF REGI_C = NPPMI_C THEN NPPMI = 0;
	*IF NPPMS = 0 AND NPPMI = 0 THEN NPPMAM = 0;
		
		* * AJUSTE PARA EDENTULOS TOTALES;
	IF PETPSD_TE AND PETPSI_TE AND PETAS_TE THEN NPPMS = 0;
	IF PETPID_TE AND PETPII_TE AND PETAI_TE THEN NPPMI = 0;
	IF NPPMS = 0 AND NPPMI = 0 THEN NPPMAM = 0;
	
	* * FORMULA 128;
	IF NPTMS =  1 AND NPPMI = 1 THEN NPTSS = 1;ELSE NPTSS = 0;
	* * FORMULA 129;
	IF NPTMI =  1 AND NPPMS = 1 THEN NPTSI = 1;ELSE NPTSI = 0;
	
	***************************************************ESI
	*** EXTENSION = % DE SITIOS CON VALOR MAYOR A &K_ESI
	*** SEVERIDAD = PROMEDIO DE SITIOS CON VALOR MAYOR A &K_ESI;

	***** VARIABLES A USAR:
	*** PROFUNDIDA CLÍNICA EN SONDAJE (MM): MD312MB17--MD312DL27 MD314MB47--MD314DL37
	*** MARGEN-LÍNEA CEMENTO AMÉLICA (MM): MD313MB17--MD313DL27 MD315MB47--MD315DL37;


	* * * * * profundidad clínica 18 años ;
	ARRAY PRO {4, 7, 6}
		 MD312MB11 MD312B11 MD312DB11 MD312ML11 MD312L11 MD312DL11
		 MD312MB12 MD312B12 MD312DB12 MD312ML12 MD312L12 MD312DL12
		 MD312MB13 MD312B13 MD312DB13 MD312ML13 MD312L13 MD312DL13
		 MD312MB14 MD312B14 MD312DB14 MD312ML14 MD312L14 MD312DL14
		 MD312MB15 MD312B15 MD312DB15 MD312ML15 MD312L15 MD312DL15
		 MD312MB16 MD312B16 MD312DB16 MD312ML16 MD312L16 MD312DL16
		 MD312MB17 MD312B17 MD312DB17 MD312ML17 MD312L17 MD312DL17
		 MD312MB21 MD312B21 MD312DB21 MD312ML21 MD312L21 MD312DL21
		 MD312MB22 MD312B22 MD312DB22 MD312ML22 MD312L22 MD312DL22
		 MD312MB23 MD312B23 MD312DB23 MD312ML23 MD312L23 MD312DL23
		 MD312MB24 MD312B24 MD312DB24 MD312ML24 MD312L24 MD312DL24
		 MD312MB25 MD312B25 MD312DB25 MD312ML25 MD312L25 MD312DL25
		 MD312MB26 MD312B26 MD312DB26 MD312ML26 MD312L26 MD312DL26
		 MD312MB27 MD312B27 MD312DB27 MD312ML27 MD312L27 MD312DL27
		 MD314MB31 MD314B31 MD314DB31 MD314ML31 MD314L31 MD314DL31
		 MD314MB32 MD314B32 MD314DB32 MD314ML32 MD314L32 MD314DL32
		 MD314MB33 MD314B33 MD314DB33 MD314ML33 MD314L33 MD314DL33
		 MD314MB34 MD314B34 MD314DB34 MD314ML34 MD314L34 MD314DL34
		 MD314MB35 MD314B35 MD314DB35 MD314ML35 MD314L35 MD314DL35
		 MD314MB36 MD314B36 MD314DB36 MD314ML36 MD314L36 MD314DL36
		 MD314MB37 MD314B37 MD314DB37 MD314ML37 MD314L37 MD314DL37
		 MD314MB41 MD314B41 MD314DB41 MD314ML41 MD314L41 MD314DL41
		 MD314MB42 MD314B42 MD314DB42 MD314ML42 MD314L42 MD314DL42
		 MD314MB43 MD314B43 MD314DB43 MD314ML43 MD314L43 MD314DL43
		 MD314MB44 MD314B44 MD314DB44 MD314ML44 MD314L44 MD314DL44
		 MD314MB45 MD314B45 MD314DB45 MD314ML45 MD314L45 MD314DL45
		 MD314MB46 MD314B46 MD314DB46 MD314ML46 MD314L46 MD314DL46
		 MD314MB47 MD314B47 MD314DB47 MD314ML47 MD314L47 MD314DL47
	;
	* * * * * margen-línea cemento amélica 18 años ;
	ARRAY MCA {4, 7, 6}
		 MD313MB11 MD313B11 MD313DB11 MD313ML11 MD313L11 MD313DL11
		 MD313MB12 MD313B12 MD313DB12 MD313ML12 MD313L12 MD313DL12
		 MD313MB13 MD313B13 MD313DB13 MD313ML13 MD313L13 MD313DL13
		 MD313MB14 MD313B14 MD313DB14 MD313ML14 MD313L14 MD313DL14
		 MD313MB15 MD313B15 MD313DB15 MD313ML15 MD313L15 MD313DL15
		 MD313MB16 MD313B16 MD313DB16 MD313ML16 MD313L16 MD313DL16
		 MD313MB17 MD313B17 MD313DB17 MD313ML17 MD313L17 MD313DL17
		 MD313MB21 MD313B21 MD313DB21 MD313ML21 MD313L21 MD313DL21
		 MD313MB22 MD313B22 MD313DB22 MD313ML22 MD313L22 MD313DL22
		 MD313MB23 MD313B23 MD313DB23 MD313ML23 MD313L23 MD313DL23
		 MD313MB24 MD313B24 MD313DB24 MD313ML24 MD313L24 MD313DL24
		 MD313MB25 MD313B25 MD313DB25 MD313ML25 MD313L25 MD313DL25
		 MD313MB26 MD313B26 MD313DB26 MD313ML26 MD313L26 MD313DL26
		 MD313MB27 MD313B27 MD313DB27 MD313ML27 MD313L27 MD313DL27
		 MD315MB31 MD315B31 MD315DB31 MD315ML31 MD315L31 MD315DL31
		 MD315MB32 MD315B32 MD315DB32 MD315ML32 MD315L32 MD315DL32
		 MD315MB33 MD315B33 MD315DB33 MD315ML33 MD315L33 MD315DL33
		 MD315MB34 MD315B34 MD315DB34 MD315ML34 MD315L34 MD315DL34
		 MD315MB35 MD315B35 MD315DB35 MD315ML35 MD315L35 MD315DL35
		 MD315MB36 MD315B36 MD315DB36 MD315ML36 MD315L36 MD315DL36
		 MD315MB37 MD315B37 MD315DB37 MD315ML37 MD315L37 MD315DL37
		 MD315MB41 MD315B41 MD315DB41 MD315ML41 MD315L41 MD315DL41
		 MD315MB42 MD315B42 MD315DB42 MD315ML42 MD315L42 MD315DL42
		 MD315MB43 MD315B43 MD315DB43 MD315ML43 MD315L43 MD315DL43
		 MD315MB44 MD315B44 MD315DB44 MD315ML44 MD315L44 MD315DL44
		 MD315MB45 MD315B45 MD315DB45 MD315ML45 MD315L45 MD315DL45
		 MD315MB46 MD315B46 MD315DB46 MD315ML46 MD315L46 MD315DL46
		 MD315MB47 MD315B47 MD315DB47 MD315ML47 MD315L47 MD315DL47
	;

	* * * * * nivel de inserción clínica 18 años ;
	ARRAY INS {4, 7, 6}
		 INSMB11 INSB11 INSDB11 INSML11 INSL11 INSDL11
		 INSMB12 INSB12 INSDB12 INSML12 INSL12 INSDL12
		 INSMB13 INSB13 INSDB13 INSML13 INSL13 INSDL13
		 INSMB14 INSB14 INSDB14 INSML14 INSL14 INSDL14
		 INSMB15 INSB15 INSDB15 INSML15 INSL15 INSDL15
		 INSMB16 INSB16 INSDB16 INSML16 INSL16 INSDL16
		 INSMB17 INSB17 INSDB17 INSML17 INSL17 INSDL17
		 INSMB21 INSB21 INSDB21 INSML21 INSL21 INSDL21
		 INSMB22 INSB22 INSDB22 INSML22 INSL22 INSDL22
		 INSMB23 INSB23 INSDB23 INSML23 INSL23 INSDL23
		 INSMB24 INSB24 INSDB24 INSML24 INSL24 INSDL24
		 INSMB25 INSB25 INSDB25 INSML25 INSL25 INSDL25
		 INSMB26 INSB26 INSDB26 INSML26 INSL26 INSDL26
		 INSMB27 INSB27 INSDB27 INSML27 INSL27 INSDL27
		 INSMB31 INSB31 INSDB31 INSML31 INSL31 INSDL31
		 INSMB32 INSB32 INSDB32 INSML32 INSL32 INSDL32
		 INSMB33 INSB33 INSDB33 INSML33 INSL33 INSDL33
		 INSMB34 INSB34 INSDB34 INSML34 INSL34 INSDL34
		 INSMB35 INSB35 INSDB35 INSML35 INSL35 INSDL35
		 INSMB36 INSB36 INSDB36 INSML36 INSL36 INSDL36
		 INSMB37 INSB37 INSDB37 INSML37 INSL37 INSDL37
		 INSMB41 INSB41 INSDB41 INSML41 INSL41 INSDL41
		 INSMB42 INSB42 INSDB42 INSML42 INSL42 INSDL42
		 INSMB43 INSB43 INSDB43 INSML43 INSL43 INSDL43
		 INSMB44 INSB44 INSDB44 INSML44 INSL44 INSDL44
		 INSMB45 INSB45 INSDB45 INSML45 INSL45 INSDL45
		 INSMB46 INSB46 INSDB46 INSML46 INSL46 INSDL46
		 INSMB47 INSB47 INSDB47 INSML47 INSL47 INSDL47
	;


	* * PROFUNDIDAD MÁXIMA EN SITIOS INTERPROXIMALES PARA EL DIENTE;
	ARRAY PROM{4, 7}
		PRO11	PRO12	PRO13	PRO14	PRO15	PRO16	PRO17
		PRO21	PRO22	PRO23	PRO24	PRO25	PRO26	PRO27
		PRO31	PRO32	PRO33	PRO34	PRO35	PRO36	PRO37
		PRO41	PRO42	PRO43	PRO44	PRO45	PRO46	PRO47
		;

	* * NIVEL DE INSERCIÓN MÁXIMO EN SITIOS INTERPROXIMALES PARA EL DIENTE;
	ARRAY INSM{4, 7}
		INS11	INS12	INS13	INS14	INS15	INS16	INS17
		INS21	INS22	INS23	INS24	INS25	INS26	INS27
		INS31	INS32	INS33	INS34	INS35	INS36	INS37
		INS41	INS42	INS43	INS44	INS45	INS46	INS47
		;

	* * DIENTE CON ALGUNA MEDICIÓN;
	ARRAY MPRO{4, 7}
		MPRO11	MPRO12	MPRO13	MPRO14	MPRO15	MPRO16	MPRO17
		MPRO21	MPRO22	MPRO23	MPRO24	MPRO25	MPRO26	MPRO27
		MPRO31	MPRO32	MPRO33	MPRO34	MPRO35	MPRO36	MPRO37
		MPRO41	MPRO42	MPRO43	MPRO44	MPRO45	MPRO46	MPRO47
	;

	ARRAY MMCA{4, 7}
		MMCA11	MMCA12	MMCA13	MMCA14	MMCA15	MMCA16	MMCA17
		MMCA21	MMCA22	MMCA23	MMCA24	MMCA25	MMCA26	MMCA27
		MMCA31	MMCA32	MMCA33	MMCA34	MMCA35	MMCA36	MMCA37
		MMCA41	MMCA42	MMCA43	MMCA44	MMCA45	MMCA46	MMCA47
	;

	ARRAY MINS{4, 7}
		MINS11	MINS12	MINS13	MINS14	MINS15	MINS16	MINS17
		MINS21	MINS22	MINS23	MINS24	MINS25	MINS26	MINS27
		MINS31	MINS32	MINS33	MINS34	MINS35	MINS36	MINS37
		MINS41	MINS42	MINS43	MINS44	MINS45	MINS46	MINS47
	;
	
	* * PROFUNDIDAD MÁXIMA PARA EL DIENTE;
	ARRAY PROMM{4, 7}
		PRO11_M	PRO12_M	PRO13_M	PRO14_M	PRO15_M	PRO16_M	PRO17_M
		PRO21_M	PRO22_M	PRO23_M	PRO24_M	PRO25_M	PRO26_M	PRO27_M
		PRO31_M	PRO32_M	PRO33_M	PRO34_M	PRO35_M	PRO36_M	PRO37_M
		PRO41_M	PRO42_M	PRO43_M	PRO44_M	PRO45_M	PRO46_M	PRO47_M
		;

	* * VARIABLE PARA EL CÁLCULO DEL ESI;
	EXT_PRO = 0;
	SEV_PRO = 0;
	SIT_PRO = 0;
	DIE_PRO = 0;

	EXT_PRO_PI = 0;
	SEV_PRO_PI = 0;
	SIT_PRO_PI = 0;
	DIE_PRO_PI = 0;
	
	EXT_MCA = 0;
	SEV_MCA = 0;
	SIT_MCA = 0;
	DIE_MCA = 0;

	EXT_INS = 0;
	SEV_INS = 0;
	SIT_INS = 0;
	DIE_INS = 0;

	EXT_INS_IP = 0;
	SEV_INS_IP = 0;	
	SIT_INS_IP = 0;
	DIE_INS_IP = 0;

	* * NIC ENSAB III;
	
	EXT_INS_III = 0;
	SEV_INS_III = 0;	
	SIT_INS_III = 0;
	DIE_INS_III = 0;

	* * VARIABLES PARA EL CÁLCULO DEL CDC-AAP;
	AL3 = 0;
	AL4 = 0;
	AL5 = 0;
	AL6 = 0;
	PD4 = 0;
	PD5 = 0;

	* * VARIABLES PARA EL CÁLCULO DEL EUROPEO;
	INC = 0;
	SEV = 0;
	
	* * INDICADORES OMS;
	OMS_PRO = 0;
	OMS_PRO_CL = '';
	EXT_PRO_OMS = 0;
	SEV_PRO_OMS = 0;
	SIT_PRO_OMS = 0;
	DIE_PRO_OMS = 0;

	NEGATIVO = 0;

	DO L = 1 TO 4; * * VARIANDO POR LADO;
		DO D = 1 TO 7; * * VARIANDO POR DIENTE;
			IF COP[L, D] NOT IN('4', '5') THEN DO; * * SE EXCLUYEN LOS DIENTES QUE NO ESTAN;
				MINS_IP = 0;
				MPRO_PI = 0;
				MPRO_N  = 0;
				DO I = 1 TO 6; * * VARIANDO EN LOS SITIOS DE MEDICIÓN 'MB', 'B', 'DB', 'ML', 'L', 'DL';
					

					* * CANTIDADES PARA ESI PARA PROFUNDIDAD DE CLÍNICA DE SONDAJE;
					IF PRO[L, D, I] NOT IN(., 99) THEN DO;
						MPRO_N = 1;
						SIT_PRO + 1;
						MPRO[L, D] = MAX(MPRO[L, D], PRO[L, D, I]);
						IF PRO[L, D, I] > &kPRO_ESI1 THEN DO;
							EXT_PRO + 1;
							SEV_PRO = SEV_PRO + PRO[L, D, I] - &kPRO_ESI1;
						END;
					END;

					* * CANTIDADES PARA ESI PARA PROFUNDIDAD DE CLÍNICA DE SONDAJE
						DE SITIOS PERI-IMPLANTARES;
					IF PRO[L, D, I] NOT IN(., 99) AND 
					   COP[L, D] = '7' AND PROT[L, D] IN(4, 45) THEN DO;
						MPRO_PI = 1;
						SIT_PRO_PI + 1;
						IF PRO[L, D, I] > &kPRO_ESI1 THEN DO;
							EXT_PRO_PI + 1;
							SEV_PRO_PI = SEV_PRO_PI + PRO[L, D, I] - &kPRO_ESI1;
						END;
					END;
					
					* * CANTIDADES PARA ESI PARA MARGEN-LÍNEA CEMENTO AMÉLICA;
					IF (COP[L, D] NE '7' OR PROT[L, D] NOT IN (4, 45)) AND 
					  MCA[L, D, I] NOT IN(., 99) THEN DO;* * NO SE CONSIDERAN PROTESIS IMPLANTADO;
					  	MMCA[L, D] = 1;
						SIT_MCA + 1;
						IF MCA[L, D, I] < &kMCA_ESI1 THEN DO;
							EXT_MCA + 1;
							SEV_MCA = SEV_MCA + MCA[L, D, I] - &kMCA_ESI1;
						END;
					END;

					* * CANTIDADES PARA ESI PARA EL NIVEL CLÍNICO DE INSERCIÓN;
					IF PRO[L, D, I] NOT IN(., 99) AND 
					  ((COP[L, D] NE '7' OR PROT[L, D] NOT IN (4, 45)) AND 
					  MCA[L, D, I] NOT IN(., 99)) THEN DO;
						INS[L, D, I] = PRO[L, D, I] - MCA[L, D, I];
						MINS[L, D] = 1;
					END;* * NO SE CONSIDERAN PROTESIS IMPLANTADO;

					IF INS[L, D, I] NOT IN(., 99) THEN DO;
						SIT_INS + 1;
						IF INS[L, D, I] > &kINS_ESI1 THEN DO;
							EXT_INS + 1;
							SEV_INS = SEV_INS + INS[L, D, I] - &kINS_ESI1;
						END;
						IF INS[L, D, I] < 0 AND INS[L, D, I] NE .
							THEN NEGATIVO + 1;
					END;

					* * ESI DE NIVEL CLÍNICO DE INSERCIÓN INTERPROXIMALES;
					IF I NOT IN(2, 5) AND INS[L, D, I] NOT IN(., 99) THEN DO;
						SIT_INS_IP + 1;
						MINS_IP = 1;
						IF INS[L, D, I] > &kINS_ESI1 THEN DO;
							EXT_INS_IP + 1;
							SEV_INS_IP = SEV_INS_IP + INS[L, D, I] - &kINS_ESI1;
						END;
					END;

					IF I NOT IN(2, 5) THEN DO; * * VALORES MÁXIMOS DE PROFUNDIDAD Y NIVEL DE INSERCIÓN CLÍNICA POR DIENTE;
						IF PRO[L, D, I] NOT IN(., 99) THEN PROM[L, D] = MAX(PROM[L, D], PRO[L, D, I]);
						IF INS[L, D, I] NOT IN(., 99) THEN INSM[L, D] = MAX(INSM[L, D], INS[L, D, I]);
					END;
					
					IF PRO[L, D, I] NOT IN(., 99) THEN PROMM[L, D] = MAX(PROMM[L, D], PRO[L, D, I]);
				END;
			
				IF INSM[L, D] >= 3 THEN AL3 + 1;
				IF INSM[L, D] >= 4 THEN AL4 + 1;
				IF INSM[L, D] >= 5 THEN AL5 + 1;
				IF INSM[L, D] >= 6 THEN AL6 + 1;
				IF PROM[L, D] >= 4 THEN PD4 + 1;
				IF PROM[L, D] >= 5 THEN PD5 + 1;

				SELECT; * * CÁLCULO DEL EUROPEO;
					WHEN (D = 1) DO;
						SELECT;
							WHEN (L IN (2, 4)) DO;
								IF INSM[L, D] >= 3 AND INSM[L - 1, D] < 3 
									AND INSM[L - 1, D] NE . THEN INC + 1;
								IF INSM[L, D] >= 3 AND INSM[L - 1, D] >= 3
									AND INSM[L - 1, D + 1] >= 3 THEN INC + 1; 
							END;
							OTHERWISE DO;
								IF INSM[L, D] >= 3 THEN INC + 1; 
							END;
						END;
					END;
					WHEN (D = 2) DO;
						SELECT;
							WHEN (L IN (2, 4)) DO;
								IF INSM[L, D] >= 3 AND INSM[L, D - 1] < 3  
									AND INSM[L, D - 1] NE . THEN INC + 1; 
								IF INSM[L, D] >= 3 AND INSM[L, D - 1] >= 3
									AND INSM[L - 1, D - 1] >= 3 THEN INC + 1; 
							END;
							OTHERWISE DO;
								IF INSM[L, D] >= 3 AND INSM[L, D - 1] < 3  
									AND INSM[L, D - 1] NE . THEN INC + 1;
								IF INSM[L, D] >= 3 AND INSM[L, D - 1] >= 3
									AND INSM[L + 1, D - 1] >= 3 THEN INC + 1; 
							END;
						END;
					END;
					OTHERWISE DO;
						IF INSM[L, D] >= 3 AND INSM[L, D - 1] < 3  
									AND INSM[L, D - 1] NE . THEN INC + 1;
						IF INSM[L, D] >= 3 AND INSM[L, D - 1] >= 3
									AND INSM[L, D - 2] >= 3 THEN INC + 1;  
					END;
				END;

				* * CONTEO DE DIENTES MEDIDOS;
				IF MPRO_N = 1 THEN DIE_PRO + 1;
				IF MPRO_PI = 1 THEN DIE_PRO_PI + 1;
				IF MMCA[L, D] = 1 THEN DIE_MCA + 1;
				IF MINS[L, D] = 1 THEN DIE_INS + 1;
				IF MINS_IP = 1 THEN DIE_INS_IP + 1;
				
				* * OMS;
				*IF ;

			END; * * SE EXCLUYEN LOS DIENTES QUE NO ESTAN;	
			
		END; * * VARIANDO POR DIENTE;
		
		* * * OMS;
		SELECT;
			WHEN (PROMM[L, 7] = . AND PROMM[L, 6] = . AND 
				(PROMM[L, 5] NE . OR PROMM[L, 4] NE . OR PROMM[L, 3] NE . OR PROMM[L, 2] NE .)) 
				PROMM[L, 7] = MAX(PROMM[L, 5], PROMM[L, 4], PROMM[L, 3], PROMM[L, 2]);
			WHEN (PROMM[L, 7] = . AND PROMM[L, 6] NE .)
				PROMM[L, 7] = PROMM[L, 6];
			OTHERWISE PROMM[L, 6] = .;
		END;
		IF L IN(1, 3) AND PROMM[L, 1] = . AND 
		(PROMM[L, 5] NE . OR PROMM[L, 4] NE . OR PROMM[L, 3] NE . OR PROMM[L, 2] NE .)
			THEN PROMM[L, 1] = MAX(PROMM[L, 5], PROMM[L, 4], PROMM[L, 3], PROMM[L, 2]);
		
	END; * * VARIANDO POR LADO;
	
	* * ESI DE NIVEL CLÍNICO DE INSERCIÓN ENSAB III;
	IF COP[1, 1] NOT IN('4', '5') AND INS[1, 1, 1] NOT IN(., 99) THEN DO;
		DIE_INS_III + 1;
		SIT_INS_III + 1;
		IF INS[1, 1, 1] > &kINS_ESI1 THEN DO;
			EXT_INS_III + 1;
			SEV_INS_III = SEV_INS_III + INS[1, 1, 1] - &kINS_ESI1;
		END;
	END;
	ELSE IF COP[2, 1] NOT IN('4', '5') AND INS[2, 1, 1] NOT IN(., 99) THEN DO;
		DIE_INS_III + 1;
		SIT_INS_III + 1;
		IF INS[2, 1, 1] > &kINS_ESI1 THEN DO;
			EXT_INS_III + 1;
			SEV_INS_III = SEV_INS_III + INS[2, 1, 1] - &kINS_ESI1;
		END;
	END;
			
	IF COP[1, 6] NOT IN('4', '5') THEN DO;
		IF INS[1, 6, 1] NOT IN(., 99) OR INS[1, 6, 3] NOT IN(., 99) THEN 
			DIE_INS_III + 1;
		IF INS[1, 6, 1] NOT IN(., 99) THEN DO;
			SIT_INS_III + 1;
			IF INS[1, 6, 1] > &kINS_ESI1 THEN DO;
				EXT_INS_III + 1;
				SEV_INS_III = SEV_INS_III + INS[1, 6, 1] - &kINS_ESI1;
			END;
		END;
		IF INS[1, 6, 3] NOT IN(., 99) THEN DO;
			SIT_INS_III + 1;
			IF INS[1, 6, 3] > &kINS_ESI1 THEN DO;
				EXT_INS_III + 1;
				SEV_INS_III = SEV_INS_III + INS[1, 6, 3] - &kINS_ESI1;
			END;
		END;
	END;
	ELSE IF COP[2, 6] NOT IN('4', '5') THEN DO;
		IF INS[2, 6, 1] NOT IN(., 99) OR INS[2, 6, 3] NOT IN(., 99) THEN 
			DIE_INS_III + 1;
		IF INS[2, 6, 1] NOT IN(., 99) THEN DO;
			SIT_INS_III + 1;
			IF INS[2, 6, 1] > &kINS_ESI1 THEN DO;
				EXT_INS_III + 1;
				SEV_INS_III = SEV_INS_III + INS[2, 6, 1] - &kINS_ESI1;
			END;
		END;
		IF INS[2, 6, 3] NOT IN(., 99) THEN DO;
			SIT_INS_III + 1;
			IF INS[2, 6, 3] > &kINS_ESI1 THEN DO;
				EXT_INS_III + 1;
				SEV_INS_III = SEV_INS_III + INS[2, 6, 3] - &kINS_ESI1;
			END;
		END;
	END;
			
	IF COP[2, 3] NOT IN('4', '5') AND INS[2, 3, 1] NOT IN(., 99) THEN DO;
		DIE_INS_III + 1;
		SIT_INS_III + 1;
		IF INS[2, 3, 1] > &kINS_ESI1 THEN DO;
			EXT_INS_III + 1;
			SEV_INS_III = SEV_INS_III + INS[2, 3, 1] - &kINS_ESI1;
		END;
	END;
	ELSE IF COP[1, 3] NOT IN('4', '5') AND INS[1, 3, 1] NOT IN(., 99) THEN DO;
		DIE_INS_III + 1;
		SIT_INS_III + 1;
		IF INS[1, 3, 1] > &kINS_ESI1 THEN DO;
			EXT_INS_III + 1;
			SEV_INS_III = SEV_INS_III + INS[1, 3, 1] - &kINS_ESI1;
		END;
	END;

	IF COP[2, 5] NOT IN('4', '5') AND INS[2, 5, 3] NOT IN(., 99) THEN DO;
		DIE_INS_III + 1;
		SIT_INS_III + 1;
		IF INS[2, 5, 3] > &kINS_ESI1 THEN DO;
			EXT_INS_III + 1;
			SEV_INS_III = SEV_INS_III + INS[2, 5, 3] - &kINS_ESI1;
		END;
	END;
	ELSE IF COP[1, 5] NOT IN('4', '5') AND INS[1, 5, 3] NOT IN(., 99) THEN DO;
		DIE_INS_III + 1;
		SIT_INS_III + 1;
		IF INS[1, 5, 3] > &kINS_ESI1 THEN DO;
			EXT_INS_III + 1;
			SEV_INS_III = SEV_INS_III + INS[1, 5, 3] - &kINS_ESI1;
		END;
	END;	
	
	IF COP[3, 4] NOT IN('4', '5') AND INS[3, 4, 3] NOT IN(., 99) THEN DO;
		DIE_INS_III + 1;
		SIT_INS_III + 1;
		IF INS[3, 4, 3] > &kINS_ESI1 THEN DO;
			EXT_INS_III + 1;
			SEV_INS_III = SEV_INS_III + INS[3, 4, 3] - &kINS_ESI1;
		END;
	END;
	ELSE IF COP[4, 4] NOT IN('4', '5') AND INS[4, 4, 3] NOT IN(., 99) THEN DO;
		DIE_INS_III + 1;
		SIT_INS_III + 1;
		IF INS[4, 4, 3] > &kINS_ESI1 THEN DO;
			EXT_INS_III + 1;
			SEV_INS_III = SEV_INS_III + INS[4, 4, 3] - &kINS_ESI1;
		END;
	END;	
	
	IF COP[3, 5] NOT IN('4', '5') AND INS[3, 5, 1] NOT IN(., 99) THEN DO;
		DIE_INS_III + 1;
		SIT_INS_III + 1;
		IF INS[3, 5, 1] > &kINS_ESI1 THEN DO;
			EXT_INS_III + 1;
			SEV_INS_III = SEV_INS_III + INS[3, 5, 1] - &kINS_ESI1;
		END;
	END;
	ELSE IF COP[4, 5] NOT IN('4', '5') AND INS[4, 5, 1] NOT IN(., 99) THEN DO;
		DIE_INS_III + 1;
		SIT_INS_III + 1;
		IF INS[4, 5, 1] > &kINS_ESI1 THEN DO;
			EXT_INS_III + 1;
			SEV_INS_III = SEV_INS_III + INS[4, 5, 1] - &kINS_ESI1;
		END;
	END;
	
	IF COP[4, 1] NOT IN('4', '5') AND INS[4, 1, 1] NOT IN(., 99) THEN DO;
		DIE_INS_III + 1;
		SIT_INS_III + 1;
		IF INS[4, 1, 1] > &kINS_ESI1 THEN DO;
			EXT_INS_III + 1;
			SEV_INS_III = SEV_INS_III + INS[4, 1, 1] - &kINS_ESI1;
		END;
	END;
	ELSE IF COP[3, 1] NOT IN('4', '5') AND INS[3, 1, 1] NOT IN(., 99) THEN DO;
		DIE_INS_III + 1;
		SIT_INS_III + 1;
		IF INS[3, 1, 1] > &kINS_ESI1 THEN DO;
			EXT_INS_III + 1;
			SEV_INS_III = SEV_INS_III + INS[3, 1, 1] - &kINS_ESI1;
		END;
	END;
	
	IF COP[4, 3] NOT IN('4', '5') THEN DO;
		IF INS[4, 3, 1] NOT IN(., 99) OR INS[4, 3, 3] NOT IN(., 99) THEN 
			DIE_INS_III + 1;
		IF INS[4, 3, 1] NOT IN(., 99) THEN DO;
			SIT_INS_III + 1;
			IF INS[4, 3, 1] > &kINS_ESI1 THEN DO;
				EXT_INS_III + 1;
				SEV_INS_III = SEV_INS_III + INS[4, 3, 1] - &kINS_ESI1;
			END;
		END;
		IF INS[4, 3, 3] NOT IN(., 99) THEN DO;
			SIT_INS_III + 1;
			IF INS[4, 3, 3] > &kINS_ESI1 THEN DO;
				EXT_INS_III + 1;
				SEV_INS_III = SEV_INS_III + INS[4, 3, 3] - &kINS_ESI1;
			END;
		END;
	END;
	ELSE IF COP[3, 3] NOT IN('4', '5') THEN DO;
		IF INS[3, 3, 1] NOT IN(., 99) OR INS[3, 3, 3] NOT IN(., 99) THEN 
			DIE_INS_III + 1;
		IF INS[3, 3, 1] NOT IN(., 99) THEN DO;
			SIT_INS_III + 1;
			IF INS[3, 3, 1] > &kINS_ESI1 THEN DO;
				EXT_INS_III + 1;
				SEV_INS_III = SEV_INS_III + INS[3, 3, 1] - &kINS_ESI1;
			END;
		END;
		IF INS[3, 3, 3] NOT IN(., 99) THEN DO;
			SIT_INS_III + 1;
			IF INS[3, 3, 3] > &kINS_ESI1 THEN DO;
				EXT_INS_III + 1;
				SEV_INS_III = SEV_INS_III + INS[3, 3, 3] - &kINS_ESI1;
			END;
		END;
	END;
			* * * RECALCULO SEGUN ENSAB III;	
	
	* * * OMS;
	DB_COD0 = 0;
	DB_COD1 = 0;
	DB_COD2 = 0;
	DB_EXCL = 0;
	D_OMS = 0;
	
	DO L = 1 TO 4;
		DO D = 1,7;
			IF L IN(1, 3) AND D = 1 THEN DO;
				SELECT;
					WHEN (PROMM[L, D] =  .) DB_EXCL + 1;
					WHEN (PROMM[L, D] <= 3) DB_COD0 + 1;
					WHEN (PROMM[L, D] <= 5) DB_COD1 + 1;
					OTHERWISE 				DB_COD2 + 1;
				END;
				D_OMS + 1;
			END;
			ELSE IF D NE 1 THEN DO;
				SELECT;
					WHEN (PROMM[L, D] =  .) DB_EXCL + 1;
					WHEN (PROMM[L, D] <= 3) DB_COD0 + 1;
					WHEN (PROMM[L, D] <= 5) DB_COD1 + 1;
					OTHERWISE 				DB_COD2 + 1;
				END;
				D_OMS + 1;
			END;
		END;
	END;
	
	SELECT;
		WHEN(DB_COD2 >0) DB_CL = 3;
		WHEN(DB_COD1 >0) DB_CL = 2;
		WHEN(DB_COD0 >0) DB_CL = 1;
		WHEN(DB_EXCL >0) DB_CL = 0;
		OTHERWISE DB_CL = .;
	END;
		
		
	
	* * CÁLCULO DEL ESI PARA PROFUNDIDAD DE CLÍNICA DE SONDAJE;
	IF SIT_PRO > 0 THEN DO;
		IF EXT_PRO > 0 THEN 
			SEV_PRO = SEV_PRO / EXT_PRO;
		ELSE SEV_PRO = 0;
		EXT_PRO = EXT_PRO / SIT_PRO;
	END;
	ELSE DO;
		SEV_PRO = .;
		EXT_PRO = .;
	END;
	
	* * CÁLCULO DEL ESI PARA PROFUNDIDAD DE CLÍNICA DE SONDAJE
		SITIOS PERI-IMPLANTARES;
	IF SIT_PRO_PI > 0 THEN DO;
		IF EXT_PRO_PI > 0 THEN 
			SEV_PRO_PI = SEV_PRO_PI / EXT_PRO_PI;
		ELSE SEV_PRO_PI = 0;
		EXT_PRO_PI = EXT_PRO_PI / SIT_PRO_PI;
	END;
	ELSE DO;
		SEV_PRO_PI = .;
		EXT_PRO_PI = .;
	END;
	
	* * CÁLCULO DEL ESI PARA MARGEN-LÍNEA CEMENTO AMÉLICA;
	IF SIT_MCA > 0 THEN DO;
		IF EXT_MCA > 0 THEN 
			SEV_MCA = SEV_MCA / EXT_MCA;
		ELSE SEV_MCA = 0;
		EXT_MCA = EXT_MCA / SIT_MCA;
	END;
	ELSE DO;
		SEV_MCA = .;
		EXT_MCA = .;
	END;

	* * CÁLCULO DEL ESI PARA EL NIVEL CLÍNICO DE INSERCIÓN;
	IF SIT_INS > 0 THEN DO;
		IF EXT_INS > 0 THEN 
			SEV_INS = SEV_INS / EXT_INS;
		ELSE SEV_INS = 0;
		EXT_INS = EXT_INS / SIT_INS;
	END;
	ELSE DO;
		SEV_INS = .;
		EXT_INS = .;
	END;
	
	* * CÁLCULO DEL ESI PARA EL NIVEL CLÍNICO DE INSERCIÓN DE SITIOS INTERPROXIMALES;
	IF SIT_INS_IP > 0 THEN DO;
		IF EXT_INS_IP > 0 THEN 
			SEV_INS_IP = SEV_INS_IP / EXT_INS_IP;
		ELSE SEV_INS_IP = 0;
		EXT_INS_IP = EXT_INS_IP / SIT_INS_IP;
	END;
	ELSE DO;
		SEV_INS_IP = .;
		EXT_INS_IP = .;
	END;
	
	* * CÁLCULO DEL ESI ENSAB III;
	IF DIE_INS_III > 3 AND SIT_INS_III > 0 THEN DO;
		DEN_INSIII = 1;
		IF EXT_INS_III > 0 THEN 
			SEV_INS_III = SEV_INS_III / EXT_INS_III;
		ELSE SEV_INS_III = 0;
		EXT_INS_III = EXT_INS_III / SIT_INS_III;
	END;
	ELSE DO;
		DEN_INSIII = 0;
		SEV_INS_III = .;
		EXT_INS_III = .;
	END;

	* * * 48 Y 49;
	SELECT;
		WHEN (EXT_PRO < 0 OR EXT_PRO = .) 	CL_EXT_PRO = 9	;	
		WHEN (EXT_PRO = 0   ) 				CL_EXT_PRO = 1	;
		WHEN (EXT_PRO <= 0.3 ) 				CL_EXT_PRO = 2	;
		OTHERWISE 							CL_EXT_PRO = 3	;
	END;

	SELECT;
		WHEN (EXT_PRO = 0)					CL_SEV_PRO = 1  ;
		WHEN (SEV_PRO < 1 OR SEV_PRO = .) 	CL_SEV_PRO = 9	;
		WHEN (SEV_PRO < 3   ) 				CL_SEV_PRO = 2	;
		WHEN (SEV_PRO < 5 ) 				CL_SEV_PRO = 3  ;
		OTHERWISE 							CL_SEV_PRO = 4  ;
	END;

	* * * 52 Y 53;
	SELECT;
		WHEN (EXT_MCA < 0 OR EXT_MCA = .) 	CL_EXT_MCA = 9;
		WHEN (EXT_MCA = 0   ) 				CL_EXT_MCA = 1;
		WHEN (EXT_MCA <= 0.3 ) 				CL_EXT_MCA = 2;
		OTHERWISE 							CL_EXT_MCA = 3;
	END;

	SELECT;
		WHEN (SEV_MCA = .) 						CL_SEV_MCA = 9	;
		WHEN (SEV_MCA < -4.999 ) 				CL_SEV_MCA = 4		;
		WHEN (SEV_MCA < -2.999 ) 				CL_SEV_MCA = 3		;
		WHEN (SEV_MCA < -0.999 ) 				CL_SEV_MCA = 2			;
		OTHERWISE 								CL_SEV_MCA = 1	;
	END;
	
	* * * 45 Y 46;
	SELECT;
		WHEN (EXT_INS < 0 OR EXT_INS = .) 	CL_EXT_INS = 9;
		WHEN (EXT_INS = 0   ) 				CL_EXT_INS = 1;
		WHEN (EXT_INS <= 0.3 ) 				CL_EXT_INS = 2;
		OTHERWISE 							CL_EXT_INS = 3;
	END;

	SELECT;
		WHEN (EXT_INS = 0   ) 				CL_SEV_INS = 1;
		WHEN (SEV_INS < 1 OR SEV_INS = .) 	CL_SEV_INS = 9	;
		WHEN (SEV_INS < 3   ) 				CL_SEV_INS = 2;
		WHEN (SEV_INS < 5 ) 				CL_SEV_INS = 3	;
		OTHERWISE 							CL_SEV_INS = 4	;
	END;
	
	* * * 47;
	SELECT;
		WHEN (EXT_INS_IP < 0 OR EXT_INS_IP = .) 	CL_EXT_INS_IP = 9;
		WHEN (EXT_INS_IP = 0   ) 					CL_EXT_INS_IP = 1;
		WHEN (EXT_INS_IP <= 0.3 ) 					CL_EXT_INS_IP = 2;
		OTHERWISE 									CL_EXT_INS_IP = 3;
	END;

	SELECT;
		WHEN (EXT_INS_IP = 0   ) 					CL_SEV_INS_IP = 1;	
		WHEN (SEV_INS_IP < 1 OR SEV_INS_IP = .) 	CL_SEV_INS_IP = 9;
		WHEN (SEV_INS_IP < 3   ) 					CL_SEV_INS_IP = 2;
		WHEN (SEV_INS_IP < 5 ) 						CL_SEV_INS_IP = 3;
		OTHERWISE 									CL_SEV_INS_IP = 4;
	END;
	
	* * * 46A;
	SELECT;
		WHEN (EXT_INS_III < 0 OR EXT_INS_III = .) 	CL_EXT_INS_III = 9;
		WHEN (EXT_INS_III = 0   ) 					CL_EXT_INS_III = 1;
		WHEN (EXT_INS_III <= 0.5 ) 					CL_EXT_INS_III = 2;
		OTHERWISE 									CL_EXT_INS_III = 3;
	END;

	SELECT;
		WHEN (EXT_INS_III = 0   ) 					CL_SEV_INS_III = 1;
		WHEN (SEV_INS_III < 1 OR SEV_INS_III = .) 	CL_SEV_INS_III = 9;
		WHEN (SEV_INS_III < 3   ) 					CL_SEV_INS_III = 2;
		WHEN (SEV_INS_III < 5 ) 					CL_SEV_INS_III = 3;
		OTHERWISE 									CL_SEV_INS_III = 4;
	END;
	
	* * CÁLCULO DE INDICADOR CDC-AAP, CASE DEFINITIONS;
	SELECT;
		WHEN (DIE_INS < 2) 						   PERIODON_EKE = 9;
		WHEN (AL6 >= 2 AND PD5 >= 1) 			   PERIODON_EKE = 1;
		WHEN (AL4 >= 2 OR  PD5 >= 2) 			   PERIODON_EKE = 2;
		WHEN (AL3 >= 2 AND (PD4 >= 2 OR PD5 >= 1)) PERIODON_EKE = 3;
		OTHERWISE 					 			   PERIODON_EKE = 4;
	END;                                                          
	
	IF DIE_INS > 0 THEN POR_TON = AL5 / DIE_INS;
	ELSE POR_TON = 0;
	SELECT;
		WHEN (DIE_INS < 2) 	PERIODON_TON = 9; 
		WHEN (POR_TON >= 0.3) 
							PERIODON_TON = 1;
		WHEN (INC >= 2) 	PERIODON_TON = 2;
		OTHERWISE 			PERIODON_TON = 3;
	END;
 
	DROP P M I L D P2;

RUN;

/**************************************************************************************************
* * EVALUACIÓN CLÍNICA A ADULTOS DE 20 A 79 AÑOS
**************************************************************************************************/
DATA M4_EXAMEN_5;
	SET IN.M4_EXAMEN_5;

	* * * * * DIEEVAL5;
	ARRAY DIEEVAL {4, 7}
		 ME_D7 ME_D6 ME_D5 ME_D4 ME_D3 ME_D2 ME_D1
		 ME_D8 ME_D9 ME_D10 ME_D11 ME_D12 ME_D13 ME_D14
		 ME_D22 ME_D23 ME_D24 ME_D25 ME_D26 ME_D27 ME_D28
		 ME_D21 ME_D20 ME_D19 ME_D18 ME_D17 ME_D16 ME_D15
	;

	**************************************************CARIES
	*** PC= Prevalencia Caries;

	****************************************************************************************** FORMULA 1
    ** Variables a usar: MA_305A -- MA_305J MA_307A -- MA_307J
	*** PC_COP_ = "Prevalencia de caries en COP"
		VALORES 1+2 Ó B+C;
    PC_COP_T = 0; * TEMPORALES;
	PC_COP_P = 0; * PERMANENTES;
	PC_COP_J = 0; * JUNTOS;

	****************************************************************************************** FORMULA 2
	*** PC_ICDAS_ = "Prevalencia de caries en ICDAS"
		VALORES  2, 3, 4, 5 o 6;
    PC_ICDAS_T = 0; * TEMPORALES;
	PC_ICDAS_P = 0; * PERMANENTES;
	PC_ICDAS_J = 0; * JUNTOS;

	****************************************************************************************** FORMULA 3
	*** PC_ICDAS_V_SEV = "Por niveles de severidad a partir de ICDAS"
		VALORES  2, 3, 4, 5 y 6
	*** VALORES  2;
	PC_ICDAS_T_SEV2 = 0; * TEMPORALES;
	PC_ICDAS_P_SEV2 = 0; * PERMANENTES;
	PC_ICDAS_J_SEV2 = 0; * JUNTOS;

	*** VALORES  3;
	PC_ICDAS_T_SEV3 = 0; * TEMPORALES;
	PC_ICDAS_P_SEV3 = 0; * PERMANENTES;
	PC_ICDAS_J_SEV3 = 0; * JUNTOS;

	*** VALORES  4;
	PC_ICDAS_T_SEV4 = 0; * TEMPORALES;
	PC_ICDAS_P_SEV4 = 0; * PERMANENTES;
	PC_ICDAS_J_SEV4 = 0; * JUNTOS;

	*** VALORES  5;
	PC_ICDAS_T_SEV5 = 0; * TEMPORALES;
	PC_ICDAS_P_SEV5 = 0; * PERMANENTES;
	PC_ICDAS_J_SEV5 = 0; * JUNTOS;

	*** VALORES 6;
	PC_ICDAS_T_SEV6 = 0; * TEMPORALES;
	PC_ICDAS_P_SEV6 = 0; * PERMANENTES;
	PC_ICDAS_J_SEV6 = 0; * JUNTOS;

	****************************************************************************************** FORMULA 4
	PC= % personas con COP (1 o 2) o ICDAS (2, 3, 4, 5 o 6)  
	PC= % personas con COP (B o C) o ICDAS (2, 3, 4, 5 o 6)  ;
	PC_COP_ICDAS_T = 0; * TEMPORALES;
	PC_COP_ICDAS_P = 0; * PERMANENTES;
	PC_COP_ICDAS_J = 0; * JUNTOS;

	****************************************************************************************** FORMULA 5
	EC_COP_ = "Experiencia de caries en COP"
	VALORES (1, 2, 3 o 4) o (B, C, D o E);
	EC_COP_T = 0; * TEMPORALES;
	EC_COP_P = 0; * PERMANENTES;
	EC_COP_J = 0; * JUNTOS;

	****************************************************************************************** FORMULA 2
	
	****************************************************************************************** FORMULA 6
	EC = % personas con COP (1, 2, 3 o 4) o ICDAS (2, 3, 4, 5 o 6)  
	EC = % personas con COP (B, C, D o E) o ICDAS (2, 3, 4, 5 o 6);
	EC_COP_ICDAS_T = 0; * TEMPORALES;
	EC_COP_ICDAS_P = 0; * PERMANENTES;
	EC_COP_ICDAS_J = 0; * JUNTOS; 

	****************************************************************************************** FORMULA 7
	IDS = "Índice de dientes sanos"
	IDS = % personas con 0 ó A;
	IDS_POR_COP_T = 0; * TEMPORALES;
	IDS_POR_COP_P = 0; * PERMANENTES;
	IDS_POR_COP_J = 0; * JUNTOS;
	****************************************************************************************** FORMULA 8
	IDS = % suma 0/n;
	IDS_PRO_COP_T = 0; * TEMPORALES;
	IDS_PRO_COP_P = 0; * PERMANENTES;
	IDS_PRO_COP_J = 0; * JUNTOS;
	****************************************************************************************** FORMULA 9
	IDC = "Índice de dientes cariados"
	IDC= suma 1 + 2/n, IDC= suma B + C/n;
	IDC_COP_T = 0; * TEMPORALES;
	IDC_COP_P = 0; * PERMANENTES;
	IDC_COP_J = 0; * JUNTOS;

	****************************************************************************************** FORMULA 10
	IDC= suma 2+3+4+5+6/n;
	IDC_ICDAS_T = 0; * TEMPORALES;
	IDC_ICDAS_P = 0; * PERMANENTES;
	IDC_ICDAS_J = 0; * JUNTOS;

	*IDC= suma 2+3/n (lesiones tempranas);
	IDC_LT_ICDAS_T = 0; * TEMPORALES;
	IDC_LT_ICDAS_P = 0; * PERMANENTES;
	IDC_LT_ICDAS_J = 0; * JUNTOS;
	****************************************************************************************** FORMULA 11
	IDC= suma COP (1 + 2) + ICDAS (2, 3) /n, IDC= suma COP (B + C) + + ICDAS (2, 3) /n;
	IDC_COP_ICDAS_T = 0; * TEMPORALES;
	IDC_COP_ICDAS_P = 0; * PERMANENTES;
	IDC_COP_ICDAS_J = 0; * JUNTOS;

	****************************************************************************************** FORMULA 11.5
	IDC= suma ICDAS (2, 3, 4, 5, 6) no COP(1,2,3,4) /n, IDC= suma COP (B + C) + + ICDAS (2, 3) /n;
	/*IDC_ICDAS_SCOP_T= 0; * TEMPORALES;
	IDC_ICDAS_SCOP_P= 0; * PERMANENTES;
	IDC_ICDAS_SCOP_J= 0; * JUNTOS;
	
	PC_ICDAS_SCOP_T = 0; * TEMPORALES;
	PC_ICDAS_SCOP_P = 0; * PERMANENTES;
	PC_ICDAS_SCOP_J = 0; * JUNTOS;*/

	****************************************************************************************** FORMULA 12
	IDO= % personas con 3 ó D;
	IDO_POR_COP_T = 0; * TEMPORALES;
	IDO_POR_COP_P = 0; * PERMANENTES;
	IDO_POR_COP_J = 0; * JUNTOS;

	****************************************************************************************** FORMULA 13
	IDO= suma 3/n ó D/n;
	IDO_PRO_COP_T = 0; * TEMPORALES;
	IDO_PRO_COP_P = 0; * PERMANENTES;
	IDO_PRO_COP_J = 0; * JUNTOS;

	****************************************************************************************** FORMULA 14
	IDP= % personas con 4 ó E;
	IDP_POR_COP_T = 0; * TEMPORALES;
	IDP_POR_COP_P = 0; * PERMANENTES;
	IDP_POR_COP_J = 0; * JUNTOS;

	****************************************************************************************** FORMULA 15
	IDP= suma 4/n ó E/n;
	IDP_PRO_COP_T = 0; * TEMPORALES;
	IDP_PRO_COP_P = 0; * PERMANENTES;
	IDP_PRO_COP_J = 0; * JUNTOS;

	****************************************************************************************** FORMULA 16
	IDC niveles de severidad = (2.3.4.5. ó 6)/n.  
	*** VALORES  2;
	IDC_ICDAS_T_SEV2 = 0; * TEMPORALES;
	IDC_ICDAS_P_SEV2 = 0; * PERMANENTES;
	IDC_ICDAS_J_SEV2 = 0; * JUNTOS;

	*** VALORES  3;
	IDC_ICDAS_T_SEV3 = 0; * TEMPORALES;
	IDC_ICDAS_P_SEV3 = 0; * PERMANENTES;
	IDC_ICDAS_J_SEV3 = 0; * JUNTOS;

	*** VALORES  4;
	IDC_ICDAS_T_SEV4 = 0; * TEMPORALES;
	IDC_ICDAS_P_SEV4 = 0; * PERMANENTES;
	IDC_ICDAS_J_SEV4 = 0; * JUNTOS;

	*** VALORES  5;
	IDC_ICDAS_T_SEV5 = 0; * TEMPORALES;
	IDC_ICDAS_P_SEV5 = 0; * PERMANENTES;
	IDC_ICDAS_J_SEV5 = 0; * JUNTOS;

	*** VALORES 6;
	IDC_ICDAS_T_SEV6 = 0; * TEMPORALES;
	IDC_ICDAS_P_SEV6 = 0; * PERMANENTES;
	IDC_ICDAS_J_SEV6 = 0; * JUNTOS;

	****************************************************************************************** FORMULA 17, 18 y 19
	Indice CPO-d apartir de COP, 
	VALORES 1,2,3 + 4/n, ó B,C,D + E/n;
	CPO_D_T = 0; * TEMPORALES; 
	CPO_D_P = 0; * PERMANENTES;
	CPO_D_J = 0; * JUNTOS;

	****************************************************************************************** FORMULA 20 y 21
	CPO-d = COP (1+2+3+4)+ ICDAS (2+3)/n ó COP (B+C+E+D)+ ICDAS (2+3)/n;
	CPO_D_MOD_T = 0; * TEMPORALES;
	CPO_D_MOD_P = 0; * PERMANENTES;
	CPO_D_MOD_J = 0; * JUNTOS;

	****************************************************************************************** FORMULA(3) 22
	ISC= Suma CPO-d 12 años tercil más afectado/ n 12 años;
	****************************************************************************************** FORMULA(2) 23
	ISC= Suma CPO-d 5 años tercil más afectado/ n 5 años;
	ISC_T = .;
	ISC_P = .;
	ISC_J = .;

	****************************************************************************************** FORMULA(3) 24
	IPMPSanos = suma 0 (16+26+36+46) / n 12 años, COP;
	*IPMP_S_T = .;
	IPMP_S_P = .;
	*IPMP_S_J = .;

	****************************************************************************************** FORMULA(3) 25
	IPMPPerdidos = suma 4 (16+26+36+46) / n 12 años, COP;
	*IPMP_P_T = .;
	IPMP_P_P = .;
	*IPMP_P_J = .;

	****************************************************************************************** FORMULA(3) 26
	IPMPCariados = suma COP (1+2) (16+26+36+46) / n 12 años;
	*IPMP_C_T = .;
	IPMP_C_P = .;
	*IPMP_C_J = .;

	****************************************************************************************** FORMULA(3) 27
	IPMPCariados = suma ICDAS (2+3) (16+26+36+46) / n 12 años;
	*IPMP_ICDAS_C_T = .;
	IPMP_ICDAS_C_P = .;
	*IPMP_ICDAS_C_J = .;

	****************************************************************************************** FORMULA(3) 28
	IPMPCariados = suma COP (1+2) + ICDAS (2+3) (16+26+36+46) / n 12 años;
	*IPMP_COP_ICDAS_C_T = .;
	IPMP_COP_ICDAS_C_P = .;
	*IPMP_COP_ICDAS_C_J = .;

	****************************************************************************************** FORMULA(3) 29
	IPMPObturados = suma 3 (16+26+36+46) / n 12 años;
	*IPMP_O_T = .;
	IPMP_O_P = .;
	*IPMP_O_J = .;

	****************************************************************************************** FORMULA(3) 30
	IPMPCariados severidad= suma ICDAS 2 o 3 o 4 o 5 o 6 (16+26+36+46) / n 12 años 
	(se calcula la sumatoria por cada nivel de severidad en los 1eros molares);
	*** VALORES  2;
	IPMP_ICDAS_P_SEV2 = .; * PERMANENTES;
	
	*** VALORES  3;
	IPMP_ICDAS_P_SEV3 = .; * PERMANENTES;
	
	*** VALORES  4;
	IPMP_ICDAS_P_SEV4 = .; * PERMANENTES;
	
	*** VALORES  5;
	IPMP_ICDAS_P_SEV5 = .; * PERMANENTES;
	
	*** VALORES 6;
	IPMP_ICDAS_P_SEV6 = .; * PERMANENTES;
	
	**************************************************************************************PETICION SANDRA;
	SELL_POR_T = 0;
	SELL_POR_P = 0;
	SELL_POR_J = 0;

	SELL_PRO_T = 0;
	SELL_PRO_P = 0;
	SELL_PRO_J = 0;


	****************************************************************************************** FORMULA 15

	****************************************************************************************** FORMULA 14

	****************************************************************************************** FORMULA 31
	PDPC = suma 5 /n cada grupo de edad de 5, 12, 15, 18, 20 y más años;
	*PDPC_T = 0;
	PDPC_P = 0;
	*PDPC_J = 0;

	****************************************************************************************** FORMULA(5) 32
	IRC = suma de 1 + 2 / n, Caries radicular en personas de 35 años y más;
	*IRC_T = 0;
	IRC_P = 0;
	*IRC_J = 0;

	****************************************************************************************** FORMULA(5) 33
	IRO = suma de 3 / n;
	*IRO_T = 0;
	IRO_P = 0;
	*IRO_J = 0;

	****************************************************************************************** FORMULA(5) 34
	IROC = suma de 3 + 1 + 2 / n;
	*IROC_T = 0;
	IROC_P = 0;
	*IROC_J = 0;

	****************************************************************************************** FORMULA(5) 35
	PCR= % personas con 1 o 2;
	*PCR_T = 0;
	PCR_P = 0;
	*PCR_J = 0;

	****************************************************************************************** FORMULA(5) 36
	PADB 28 = % personas con 28 dientes en boca (0,1,2,3,6,7);
	DIE_BOCAP = 0;
	DIE_BOCAT = 0;
	DIE_BOCAJ = 0;

		*******************************************************************************************
	. Parcialmente edéntulo (PE)
   . Tramo posterior: (PETP)
       Inferior: (PETPI)
         Derecho:  (PETPID (47, 46, 45, 44))                           
         Izquierdo: (PETPII (37, 36, 35, 34))                           
      Superior: (PETPS):                                 
         Derecho:  (PETPSD (17, 16, 15, 14))                         
         Izquierdo: (PETPSI (27, 26, 25, 24))                                                             
    . Tramo anterior: (PETA) 
       Inferior: (PETAI  (43, 42, 41, 31, 32, 33))                                                                                        
       Superior: (PETAS (13, 12, 11, 21, 22, 23));
	PETPID_POR = 0;
	PETPID_PRO = 0;
	PETPII_POR  = 0;
	PETPII_PRO  = 0;
	PETPSD_POR  = 0;
	PETPSD_PRO  = 0;
	PETPSI_POR  = 0;
	PETPSI_PRO  = 0;
	PETAI_POR  = 0;
	PETAI_PRO  = 0;
	PETAS_POR  = 0;
	PETAS_PRO  = 0; 
	
	PETPID_EVAL = 0;
	PETPID_TE = 0;
	PETPII_EVAL  = 0;
	PETPII_TE  = 0;
	PETPSD_EVAL  = 0;
	PETPSD_TE  = 0;
	PETPSI_EVAL  = 0;
	PETPSI_TE  = 0;
	PETAI_EVAL  = 0;
	PETAI_TE  = 0;
	PETAS_EVAL  = 0;
	PETAS_TE  = 0; 
	****************************************************************************************** FORMULA 39
	Edéntulismo parcial= % personas edéntulas parciales con códigos 4 o 5 en uno o varios dientes;
	ED_P = 0;
	
	****************************************************************************************** FORMULA 42
	IIP= sumar los implantes 7 y (4, 45) / n;
	IIP = 0;
	
	****************************************************************************************** FORMULA 43
	IDA= sumar los dientes ausentes / n,  COP(4,5);
	IDA_P = 0;

	****************************************************************************************** FORMULA 44
	PDF= % personas > 21 dientes / n;
	PDF = 0;
	
	PAATD_P = 0;
	PADB_28_P = 0;
	PADB_M_20_P = 0; * PADB < 20 = % personas con < 20 dientes en boca (0,1,2,3,6,7);

**************PROTESIS
	Maxilar superior, (17,16,15,14,13,12,11,21,22,23,24,25,26,27)
	Maxilar inferior, (47,46,45,44,43,42,41,31,32,33,34,35,36,37) 

	****************************************************************************************** FORMULA 85
	PP= % personas con algún tipo de prótesis dental (1, 2, 3 y 4) / n
	PP= % personas con cada tipo de prótesis dental 1, o 2, o 3, o 4 / n;
	PP_AT = 0;
	PP_CT_1 = 0;
	PP_CT_2 = 0;
	PP_CT_3 = 0;
	PP_CT_4 = 0;
	*PP_CT_45 = 0;
	
	****************************************************************************************** FORMULA 86;
	PP_C	 = 0;
	PP_CT_15 = 0;
	PP_CT_25 = 0;
	PP_CT_35 = 0;
	PP_CT_45 = 0;


	****************************************************************************************** FORMULA 87
	UPMS= % personas con prótesis Fija (1, 4), removible (2 o 3) o ambas (1, 2, 3, 4) maxilar superior / n;
	UPMS        = 0;
	UPMS_F		= 0;
	UPMS_R		= 0;
	UPMS_C		= 0;
	UPMS_C_F	= 0;
	UPMS_C_R	= 0;

	
	****************************************************************************************** FORMULA 89
	UPMI= % personas con prótesis Fija (1, 4), removible (2 o 3) o ambas (1,2, 3, 4) maxilar inferior / n;
	UPMI     = 0;
	UPMI_F	 = 0;
	UPMI_R	 = 0;
	UPMI_C	 = 0;
	UPMI_C_F = 0;
	UPMI_C_R = 0;

	
	****************************************************************************************** FORMULA 91;
	UPPAM_S = 0;
	UPPAM_I = 0;
	UPPAM   = 0;
	
	****************************************************************************************** FORMULA 92;
	UPPAM_CS = 0;
	UPPAM_CI = 0;
	UPPAM_C  = 0;
	
	****************************************************************************************** FORMULA 93 - 94;
	*UPTMS= % personas con prótesis total (3) superior / n;
	UPTMS     = 0;
	UPTMS_C   = 0;
	
	UPTMS_D   = 0;
	UPTMS_C_D = 0;

	****************************************************************************************** FORMULA 95 - 96
	UPMTI= % personas con prótesis total (3) inferior / n;
	UPMTI     = 0;
	UPTMI_C   = 0;

	UPTMI_D   = 0;
	UPTMI_C_D = 0;

	****************************************************************************************** FORMULA 95
	UPMI= % personas con prótesis total (3) inferior / n;
	UPMI = 0;
	UPTMI_C = 0;

	****************************************************************************************** FORMULA 97
	UPTMS / PFoRMI= % personas con prótesis total (3) superior con prótesis fija 
	o removible (1, 2, 4) en el maxilar inferior / n;
	*PFORMI_F_R = 0;

	****************************************************************************************** FORMULA 99
	UPFoRMS / PTMI= % personas con prótesis total (3) inferior con prótesis fija 
	o removible (1, 2, 4) en el maxilar superior / n;
	*PFORMS_F_R = 0;

	****************************************************************************************** FORMULA 101
	UPTBM= % personas con prótesis total (3) en ambos maxilares / n;
	UPTBM = 0;
	UPTBM_C = 0;

	****************************************************************************************** FORMULA 103
	Uso Prótesis= % personas con implantes (4) / n;
	*UPTAM = 0;

	****************************************************************************************** FORMULA 104
	PO= suma de pares oclusales presentes en boca con dientes naturales / n;
	PAR_OCLU = 0;
	PAR_OCLU_R = 0;
	
	****************************************************************************************** FORMULA 126;
	NPTMAM = 0;
	NPTMS  = 0;*?;
	NPTMI  = 0;*?;
	
	NPTMAM_C = 0;*?;
	NPTMS_C  = 0;*?;
	NPTMI_C  = 0;*?;
	
	****************************************************************************************** FORMULA 127;
	NPPMAM  = 0;
	NPPMS   = 0;
	NPPMS_C = 0;
	NPPMI   = 0;
	NPPMI_C = 0;
	
	
	REGS_C  = 0;
	REGI_C  = 0;


	**********OPACIDAD;
	****************************************************************************************** FORMULA 119;
	POE = 0;
	POE_IC = 0;
	POE_MP = 0;

	
	POE_7 = 0;
	POE_IC_7 = 0;
	POE_MP_7 = 0;
	
	POE_8 = 0;
	POE_IC_8 = 0;
	POE_MP_8 = 0;

	POE_C = 0;
	POE_IC_C = 0;
	POE_MP_C = 0;		
	*** ;
	*EDENTULISMO = 0;*DPER;
	PERMANENTES = 0;
	TEMPORALES  = 0;
	EVALUADOS   = 0;

		* * * * * ICDAS5;
	ARRAY ICDAS {4, 7}
		 ME_306g ME_306f ME_306e ME_306d ME_306c ME_306b ME_306a
		 ME_306h ME_306i ME_306j ME_306k ME_306l ME_306m ME_306n
		 ME_310h ME_310i ME_310j ME_310k ME_310l ME_310m ME_310n
		 ME_310g ME_310f ME_310e ME_310d ME_310c ME_310b ME_310a
	;
	* * * * * OPAC5;
	ARRAY OPAC {4, 7}
		 ME_306g1 ME_306f1 ME_306e1 ME_306d1 ME_306c1 ME_306b1 ME_306a1
		 ME_306h1 ME_306i1 ME_306j1 ME_306k1 ME_306l1 ME_306m1 ME_306n1
		 ME_310h1 ME_310i1 ME_310j1 ME_310k1 ME_310l1 ME_310m1 ME_310n1
		 ME_310g1 ME_310f1 ME_310e1 ME_310d1 ME_310c1 ME_310b1 ME_310a1
	;

	* * * * * cop5;
	ARRAY cop {4, 7}
		 ME_307g ME_307f ME_307e ME_307d ME_307c ME_307b ME_307a
		 ME_307h ME_307i ME_307j ME_307k ME_307l ME_307m ME_307n
		 ME_311h ME_311i ME_311j ME_311k ME_311l ME_311m ME_311n
		 ME_311g ME_311f ME_311e ME_311d ME_311c ME_311b ME_311a
	;

	* * * * * pro5;
	ARRAY prot {4, 7}
		 ME_309g ME_309f ME_309e ME_309d ME_309c ME_309b ME_309a
		 ME_309h ME_309i ME_309j ME_309k ME_309l ME_309m ME_309n
		 ME_313h ME_313i ME_313j ME_313k ME_313l ME_313m ME_313n
		 ME_313g ME_313f ME_313e ME_313d ME_313c ME_313b ME_313a
	;
	* * * * * raiz5;
	ARRAY raiz {4, 7}
		 ME_308g ME_308f ME_308e ME_308d ME_308c ME_308b ME_308a
		 ME_308h ME_308i ME_308j ME_308k ME_308l ME_308m ME_308n
		 ME_312h ME_312i ME_312j ME_312k ME_312l ME_312m ME_312n
		 ME_312g ME_312f ME_312e ME_312d ME_312c ME_312b ME_312a
	;

	
	DO P = 1 TO 4;
		DO M = 1 TO DIM(COP, 2);

			IF	SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') 
				AND COP[P, M] IN('0', '1', '2', '3', '4', '5', '6', '7') THEN PERMANENTES + 1;
			IF	SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') 
				AND COP[P, M] IN('A', 'B', 'C', 'D', 'E', 'F', 'G') THEN TEMPORALES + 1;	
			IF COP[P, M] IN('0', '1', '2', '3', '4', '5', '6', '7', 
							'A', 'B', 'C', 'D', 'E', 'F', 'G') THEN EVALUADOS + 1;	

			IF	SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') 
				AND COP[P, M] IN('B', 'C') THEN DO;
				PC_COP_T = 1; * TEMPORALES;
			END;

			IF	SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') 
				AND COP[P, M] IN('1', '2') THEN DO;
				PC_COP_P = 1; * PERMANENTES;
			END;

			IF	COP[P, M] IN('B', 'C', '1', '2') THEN DO;
				PC_COP_J = 1; * JUNTOS;
			END;

			***;
			IF	SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') 
				AND ICDAS[P, M] IN(2, 3, 4, 5, 6) THEN DO;
				PC_ICDAS_T = 1; * TEMPORALES;
			END;

			IF	SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') 
				AND ICDAS[P, M] IN(2, 3, 4, 5, 6) THEN DO;
				PC_ICDAS_P = 1; * PERMANENTE;
			END;

			IF	ICDAS[P, M] IN(2, 3, 4, 5, 6) THEN DO;
				PC_ICDAS_J = 1; * JUNTOS;
			END;
	
			***;
			IF	 ICDAS[P ,M] IN(2) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				 PC_ICDAS_T_SEV2 = 1; * TEMPORALES;
			END;
			IF	 ICDAS[P ,M] IN(2) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				 PC_ICDAS_P_SEV2 = 1; * PERMANENTE;
			END;
			IF	 ICDAS[P ,M] IN(2) THEN DO;
				 PC_ICDAS_J_SEV2 = 1; * JUNTOS;
			END;
			IF	 ICDAS[P ,M] IN(3) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				 PC_ICDAS_T_SEV3 = 1; * TEMPORALES;
			END;
			IF	 ICDAS[P ,M] IN(3) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				 PC_ICDAS_P_SEV3 = 1; * PERMANENTE;
			END;
			IF	 ICDAS[P ,M] IN(3) THEN DO;
				 PC_ICDAS_J_SEV3 = 1; * JUNTOS;
			END;
			IF	 ICDAS[P ,M] IN(4) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				 PC_ICDAS_T_SEV4 = 1; * TEMPORALES;
			END;
			IF	 ICDAS[P ,M] IN(4) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				 PC_ICDAS_P_SEV4 = 1; * PERMANENTE;
			END;
			IF	 ICDAS[P ,M] IN(4) THEN DO;
				 PC_ICDAS_J_SEV4 = 1; * JUNTOS;
			END;
			IF	 ICDAS[P ,M] IN(5) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				 PC_ICDAS_T_SEV5 = 1; * TEMPORALES;
			END;
			IF	 ICDAS[P ,M] IN(5) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				 PC_ICDAS_P_SEV5 = 1; * PERMANENTE;
			END;
			IF	 ICDAS[P ,M] IN(5) THEN DO;
				 PC_ICDAS_J_SEV5 = 1; * JUNTOS;
			END;
			IF	 ICDAS[P ,M] IN(6) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				 PC_ICDAS_T_SEV6 = 1; * TEMPORALES;
			END;
			IF	 ICDAS[P ,M] IN(6) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				 PC_ICDAS_P_SEV6 = 1; * PERMANENTE;
			END; 
			IF	 ICDAS[P ,M] IN(6) THEN DO;
				 PC_ICDAS_J_SEV6 = 1; * JUNTOS;
			END;

			***;
			/*IF	SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') 
				AND (ICDAS[P, M] IN(2, 3, 4, 5, 6) OR COP[P, M] IN('1', '2')) THEN DO;
				PC_COP_ICDAS_T = 1; * TEMPORALES;
			END;

			IF	SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') 
				AND (ICDAS[P, M] IN(2, 3, 4, 5, 6) OR COP[P, M] IN('B', 'C')) THEN DO;
				PC_COP_ICDAS_P = 1; * PERMANENTE;
			END;

			IF	(ICDAS[P, M] IN(2, 3, 4, 5, 6) OR COP[P, M] IN('B', 'C', '1', '2')) THEN DO;
				PC_COP_ICDAS_J = 1; * JUNTOS;
			END;*/
			
			***;
			IF	SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8')
				AND COP[P ,M]	IN('B', 'C', 'D', 'E') THEN DO;
				EC_COP_T = 1; * TEMPORALES;
			END;

			IF	SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4')
				AND COP[P ,M]	IN('1', '2', '3', '4') THEN DO;
				EC_COP_P = 1; * PERMANENTE;
			END;

			IF	COP[P ,M]	IN('B', 'C', 'D', 'E', '1', '2', '3', '4') THEN DO;
				EC_COP_J = 1; * JUNTOS;
			END;

			***;
			IF ICDAS[P, M] IN(2, 3, 4, 5, 6) OR COP[P, M] IN('B', 'C', 'D', 'E')
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO; 
				EC_COP_ICDAS_T = 1; * TEMPORALES;
			END;

			IF ICDAS[P, M] IN(2, 3, 4, 5, 6) OR COP[P, M] IN('1', '2', '3', '4')
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO; 
				EC_COP_ICDAS_P = 1; * PERMANENTE;
			END;

			IF ICDAS[P, M] IN(2, 3, 4, 5, 6) OR COP[P, M] IN('B', 'C', 'D', 'E', '1', '2', '3', '4') 
				THEN DO; 
				EC_COP_ICDAS_J = 1; * JUNTOS;
			END;

			***;
			IF COP[P, M] IN('A', 'F') 
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;		
				IDS_POR_COP_T = 1; * TEMPORALES;
				
				IDS_PRO_COP_T + 1; * TEMPORALES;
			END;

			IF COP[P ,M] IN('0', '6') 
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;		
				IDS_POR_COP_P = 1; * PERMANENTE;
				
				IDS_PRO_COP_P + 1; * PERMANENTE;
			END;

			IF COP[P ,M] IN('A', '0', 'F', '6')  THEN DO;		
				IDS_POR_COP_J = 1; * JUNTOS;
				
				IDS_PRO_COP_J + 1; * JUNTOS;
			END;
			
			***;
			IF COP[P, M] IN('F') 
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;		
				SELL_POR_T = 1; * TEMPORALES;
				
				SELL_PRO_T + 1; * TEMPORALES;
			END;

			IF COP[P ,M] IN('6') 
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;		
				SELL_POR_P = 1; * PERMANENTE;
				
				SELL_PRO_P + 1; * PERMANENTE;
			END;

			IF COP[P ,M] IN('F', '6')  THEN DO;		
				SELL_POR_J = 1; * JUNTOS;
				
				SELL_PRO_J + 1; * JUNTOS;
			END;
			
			***;
			IF	COP[P, M] IN('B', 'C')
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				IDC_COP_T + 1; * TEMPORALES;
			END;

			IF	COP[P, M] IN('1', '2')
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				IDC_COP_P + 1; * PERMANENTE;
			END;

			IF	COP[P, M] IN('B', 'C', '1', '2') THEN DO;
				IDC_COP_J + 1; * JUNTOS;
			END;

			*************************************************************************************************;
			IF	ICDAS[P, M] IN(2, 3, 4, 5, 6) 
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				IDC_ICDAS_T + 1; * TEMPORALES;
			END;

			IF	ICDAS[P, M] IN(2, 3, 4, 5, 6) 
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				IDC_ICDAS_P + 1; * PERMANENTE;
			END;

			IF	ICDAS[P, M] IN(2, 3, 4, 5, 6) THEN DO;
				IDC_ICDAS_J + 1; * JUNTOS;
			END;

			***;

			IF	ICDAS[P, M] IN(2)
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				IDC_LT_ICDAS_T + 1; * TEMPORALES;
			END;

			IF	ICDAS[P, M] IN(2) 
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				IDC_LT_ICDAS_P + 1; * PERMANENTE;
			END;

			IF	ICDAS[P, M] IN(2) THEN DO;
				IDC_LT_ICDAS_J + 1; * JUNTOS;
			END;

			***;
			/*IF (COP[P, M] IN('B', 'C') OR ICDAS[P, M] IN(2, 3, 4, 5, 6))  
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8')  
				THEN DO; 
				IDC_COP_ICDAS_T + 1; * TEMPORALES;
			END;

			IF (COP[P, M] IN('1', '2') OR ICDAS[P, M] IN(2, 3, 4, 5, 6))   
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') 
				THEN DO; 
				IDC_COP_ICDAS_P + 1; * PERMANENTE;
			END;

			IF (COP[P, M] IN('B', 'C', '1', '2') OR ICDAS[P, M] IN(2, 3, 4, 5, 6))   
				THEN DO; 
				IDC_COP_ICDAS_J + 1; * JUNTOS;
			END;*/

			***;
			IF (ICDAS[P, M] IN(2, 3, 4, 5, 6) AND COP[P, M] NOT IN('B', 'C', 'D', 'E'))  
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8')  
				THEN DO; 
				/*IDC_ICDAS_SCOP_T + 1; * TEMPORALES;
				PC_ICDAS_SCOP_T  = 1;*/
				IDC_COP_ICDAS_T + 1; * TEMPORALES;
				PC_COP_ICDAS_T = 1; * TEMPORALES;
			END;

			IF (ICDAS[P, M] IN(2, 3, 4, 5, 6) AND COP[P, M] NOT IN('1', '2', '3', '4'))   
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') 
				THEN DO; 
				/*IDC_ICDAS_SCOP_P + 1; * PERMANENTE;
				PC_ICDAS_SCOP_P  = 1;*/
				IDC_COP_ICDAS_P + 1; * TEMPORALES;
				PC_COP_ICDAS_P  = 1; * TEMPORALES;
			END;

			IF (ICDAS[P, M] IN(2, 3, 4, 5, 6) AND 
				COP[P, M] NOT IN('B', 'C', 'D', 'E', '1', '2', '3', '4'))   
				THEN DO; 
				/*IDC_ICDAS_SCOP_J + 1; * JUNTOS;
				PC_ICDAS_SCOP_J  = 1;*/
				IDC_COP_ICDAS_J + 1; * TEMPORALES;
				PC_COP_ICDAS_J  = 1; * TEMPORALES;
			END;
			
			***;
			IF COP[P, M] IN('D')
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				IDO_POR_COP_T = 1; * TEMPORALES;
				IDO_PRO_COP_T + 1; * TEMPORALES;
			END;

			IF COP[P, M] IN('3')
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				IDO_POR_COP_P = 1; * PERMANENTE;
				IDO_PRO_COP_P + 1; * PERMANENTE;
			END;

			IF COP[P, M] IN('D', '3') THEN DO;
				IDO_POR_COP_J = 1; * JUNTOS;
				IDO_PRO_COP_J + 1; * JUNTOS;
			END;

			***;
				IF COP[P, M] IN('E')
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				IDP_POR_COP_T = 1; * TEMPORALES;
				IDP_PRO_COP_T + 1; * TEMPORALES;
			END;

			IF COP[P, M] IN('4')
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				IDP_POR_COP_P = 1; * PERMANENTE;
				IDP_PRO_COP_P + 1; * PERMANENTE;
			END;

			IF COP[P, M] IN('E', '4') THEN DO;
				IDP_POR_COP_J = 1; * JUNTOS;
				IDP_PRO_COP_J + 1; * JUNTOS;
			END;

			***;
			IF	 ICDAS[P ,M] IN(2) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				 IDC_ICDAS_T_SEV2 + 1; * TEMPORALES;
			END;
			IF	 ICDAS[P ,M] IN(2) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				 IDC_ICDAS_P_SEV2 + 1; * PERMANENTE;
			END;
			IF	 ICDAS[P ,M] IN(2) THEN DO;
				 IDC_ICDAS_J_SEV2 + 1; * JUNTOS;
			END;
			IF	 ICDAS[P ,M] IN(3) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				 IDC_ICDAS_T_SEV3 + 1; * TEMPORALES;
			END;
			IF	 ICDAS[P ,M] IN(3) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				 IDC_ICDAS_P_SEV3 + 1; * PERMANENTE;
			END;
			IF	 ICDAS[P ,M] IN(3) THEN DO;
				 IDC_ICDAS_J_SEV3 + 1; * JUNTOS;
			END;
			IF	 ICDAS[P ,M] IN(4) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				 IDC_ICDAS_T_SEV4 + 1; * TEMPORALES;
			END;
			IF	 ICDAS[P ,M] IN(4) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				 IDC_ICDAS_P_SEV4 + 1; * PERMANENTE;
			END;
			IF	 ICDAS[P ,M] IN(4) THEN DO;
				 IDC_ICDAS_J_SEV4 + 1; * JUNTOS;
			END;
			IF	 ICDAS[P ,M] IN(5) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				 IDC_ICDAS_T_SEV5 + 1; * TEMPORALES;
			END;
			IF	 ICDAS[P ,M] IN(5) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				 IDC_ICDAS_P_SEV5 + 1; * PERMANENTE;
			END;
			IF	 ICDAS[P ,M] IN(5) THEN DO;
				 IDC_ICDAS_J_SEV5 + 1; * JUNTOS;
			END;
			IF	 ICDAS[P ,M] IN(6) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				 IDC_ICDAS_T_SEV6 + 1; * TEMPORALES;
			END;
			IF	 ICDAS[P ,M] IN(6) AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				 IDC_ICDAS_P_SEV6 + 1; * PERMANENTE;
			END; 
			IF	 ICDAS[P ,M] IN(6) THEN DO;
				 IDC_ICDAS_J_SEV6 + 1; * JUNTOS;
			END;

			***; 
			IF COP[P, M] IN('B', 'C', 'D', 'E')
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				CPO_D_T + 1; * TEMPORALES;
			END;

			IF COP[P, M] IN('1', '2', '3', '4')
				 AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				CPO_D_P + 1; * PERMANENTE;
			END;

			IF COP[P, M] IN('B', 'C', 'D', 'E', '1', '2', '3', '4') THEN DO;
				CPO_D_J + 1; * JUNTOS;
			END;

			***;
			IF (COP[P, M] IN('B', 'C', 'D', 'E') OR ICDAS[P, M] IN(2, 3, 4, 5, 6))
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				CPO_D_MOD_T + 1; * TEMPORALES;
			END;

			IF (COP[P, M] IN('1', '2', '3', '4') OR ICDAS[P, M] IN(2, 3, 4, 5, 6))
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				CPO_D_MOD_P + 1; * PERMANENTE;
			END;

			IF COP[P, M] IN('B', 'C', 'D', 'E', '1', '2', '3', '4') OR ICDAS[P, M] IN(2, 3, 4, 5, 6) THEN DO;
				CPO_D_MOD_J + 1; * JUNTOS;
			END;

			***;
			IF COP[P, M] IN('5') AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				PDPC_P + 1; * PERMANENTE;
			END;

			***;
			IF M4_104 >= 35 AND RAIZ[P, M] IN(1, 2) AND
				SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO; 
				IRC_P + 1; * PERMANENTE;
				PCR_P = 1; * PERMANENTE;
			END;

			***;
			IF M4_104 >= 35 AND RAIZ[P, M] IN(3) AND
				SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO; 
				IRO_P + 1; * PERMANENTE;
			END;

			***;
			IF M4_104 >= 35 AND RAIZ[P, M] IN(1, 2, 3) AND
				SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO; 
				IROC_P + 1; * PERMANENTE;
			END;

			***;
			IF COP[P, M] IN('0', '1', '2', '3', '6', '7') AND
				SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				DIE_BOCAP + 1;
			END;
			
			IF COP[P, M] IN('A', 'B', 'C', 'D', 'F', 'G') AND
				SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('5', '6', '7', '8') THEN DO;
				DIE_BOCAT + 1;
			END;
			
			IF COP[P, M] IN('0', '1', '2', '3', '6', '7',
							'A', 'B', 'C', 'D', 'F', 'G') THEN DO;
				DIE_BOCAJ + 1;
			END;

	************ EDENTULISMO;
			IF COP[P, M] IN('4', '5') AND 
				SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				ED_P = 1;
				IDA_P + 1;
			END;

			* * *Parcialmente edéntulo Tramo posterior Inferior Derecho;
			IF P = 4 AND M IN(4, 5, 6, 7) THEN DO;
				IF COP[P, M] IN('0', '1', '2', '3', '4', '5', '6', '7', 
							'A', 'B', 'C', 'D', 'E', 'F', 'G') THEN PETPID_EVAL + 1;
				IF COP[P, M] IN('4', '5') THEN DO;
					PETPID_POR = 1;
					PETPID_PRO + 1;
				END;
			END;

			* * *Parcialmente edéntulo Tramo posterior Inferior Izquierdo;
			IF P = 3 AND M IN(4, 5, 6, 7) THEN DO;
				IF COP[P, M] IN('0', '1', '2', '3', '4', '5', '6', '7', 
							'A', 'B', 'C', 'D', 'E', 'F', 'G') THEN PETPII_EVAL + 1;
				IF COP[P, M] IN('4', '5') THEN DO;
					PETPII_POR = 1;
					PETPII_PRO + 1;
				END;
			END;

			* * *Parcialmente edéntulo Tramo posterior Superior Derecho;
			IF P = 1 AND M IN(4, 5, 6, 7) THEN DO;
				IF COP[P, M] IN('0', '1', '2', '3', '4', '5', '6', '7', 
							'A', 'B', 'C', 'D', 'E', 'F', 'G') THEN PETPSD_EVAL + 1;
				IF COP[P, M] IN('4', '5') THEN DO;
					PETPSD_POR = 1;
					PETPSD_PRO + 1;
				END;
			END;

			* * *Parcialmente edéntulo Tramo posterior Superior Izquierdo;
			IF P = 2 AND M IN(4, 5, 6, 7) THEN DO; 
				IF COP[P, M] IN('0', '1', '2', '3', '4', '5', '6', '7', 
							'A', 'B', 'C', 'D', 'E', 'F', 'G') THEN PETPSI_EVAL + 1;			
				IF COP[P, M] IN('4', '5') THEN DO;
					PETPSI_POR = 1;
					PETPSI_PRO + 1;
				END;
			END;

			* * *Parcialmente edéntulo Tramo anterior Izquierdo;
			IF P in(3, 4) AND M IN(1, 2, 3) THEN DO; 
				IF COP[P, M] IN('0', '1', '2', '3', '4', '5', '6', '7', 
							'A', 'B', 'C', 'D', 'E', 'F', 'G') THEN PETAI_EVAL + 1;			
				IF COP[P, M] IN('4', '5') THEN DO;
					PETAI_POR = 1;
					PETAI_PRO + 1;
				END;
			END;

			* * *Parcialmente edéntulo Tramo anterior Derecho;
			IF P in(1, 2) AND M IN(1, 2, 3) THEN DO; 
				IF COP[P, M] IN('0', '1', '2', '3', '4', '5', '6', '7', 
							'A', 'B', 'C', 'D', 'E', 'F', 'G') THEN PETAS_EVAL + 1;				
				IF COP[P, M] IN('4', '5') THEN DO;
					PETAS_POR = 1;
					PETAS_PRO + 1;
				END;
			END;

	****************PERIODONTAL;
			***;
			IF COP[P, M] IN('7') AND PROT[P, M] IN(4, 45)
				AND SUBSTR(PUT(DIEEVAL[P, M], Z2.), 1, 1) IN('1', '2', '3', '4') THEN DO;
				IIP + 1;
			END;

****************PROTESIS
			***85;
			IF PROT[P, M] IN(1, 2, 4, 15, 25, 45) THEN DO;
				PP_AT = 1;
			END;

			IF PROT[P, M] IN(1, 15) THEN DO;
				PP_CT_1 = 1;
			END;

			IF PROT[P, M] IN(2, 25) THEN DO;
				PP_CT_2 = 1;
			END;

			*IF PROT[P, M] IN(3, 35) THEN DO;
			*	PP_CT_3 = 1;
			*END;

			IF PROT[P, M] IN(4, 45) THEN DO;
				PP_CT_4 = 1;
			END;

			

			***86;
			IF PROT[P, M] IN(15, 25, 45) THEN DO;
				PP_C = 1;
			END;
			
			IF PROT[P, M] IN(15) THEN DO;
				PP_CT_15 = 1;
			END;
			
			IF PROT[P, M] IN(25) THEN DO;
				PP_CT_25 = 1;
			END;
			
			*IF PROT[P, M] IN(35) THEN DO;
			*	PP_CT_35 = 1;
			*END;
			
			IF PROT[P, M] IN(45) THEN DO;
				PP_CT_45 = 1;
			END;
			
			****87;
			IF P IN(1, 2) AND PROT[P, M] IN (1, 2, 4, 15, 25, 45)  THEN DO;
				UPMS = 1;
			END;
			
			IF P IN(1, 2) AND PROT[P, M] IN (1, 4, 15, 45)  THEN DO;
				UPMS_F = 1;
			END;
			
			IF P IN(1, 2) AND PROT[P, M] IN (2, 25)  THEN DO;
				UPMS_R = 1;
			END;
			
			****88;
			
			IF P IN(1, 2) AND PROT[P, M] IN (15, 25, 45)  THEN DO;
				UPMS_C = 1;
			END;
			
			IF P IN(1, 2) AND PROT[P, M] IN (15, 45)  THEN DO;
				UPMS_C_F = 1;
			END;
			
			IF P IN(1, 2) AND PROT[P, M] IN (25)  THEN DO;
				UPMS_C_R = 1;
			END;
			
			****89;
			IF P IN(3, 4) AND PROT[P, M] IN (1, 2, 4, 15, 25, 45)  THEN DO;
				UPMI = 1;
			END;
			
			IF P IN(3, 4) AND PROT[P, M] IN (1, 4, 15, 45)  THEN DO;
				UPMI_F = 1;
			END;
			
			IF P IN(3, 4) AND PROT[P, M] IN (2, 25)  THEN DO;
				UPMI_R = 1;
			END;
			
			****90;
			
			IF P IN(3, 4) AND PROT[P, M] IN (15, 25, 45)  THEN DO;
				UPMI_C = 1;
			END;
			
			IF P IN(3, 4) AND PROT[P, M] IN (15, 45)  THEN DO;
				UPMI_C_F = 1;
			END;
			
			IF P IN(3, 4) AND PROT[P, M] IN (25)  THEN DO;
				UPMI_C_R = 1;
			END;
			
			****91;
			IF P IN(1, 2) AND PROT[P, M] IN (1, 2, 4, 15, 25, 45)  THEN DO;
				UPPAM_S = 1;
			END;
			IF P IN(3, 4) AND PROT[P, M] IN (1, 2, 4, 15, 25, 45)  THEN DO;
				UPPAM_I = 1;
			END;	
			
			****92;
			IF P IN(1, 2) AND PROT[P, M] IN (15, 25, 45)  THEN DO;
				UPPAM_CS = 1;
			END;
			IF P IN(3, 4) AND PROT[P, M] IN (15, 25, 45)  THEN DO;
				UPPAM_CI = 1;
			END;

			****93;
			IF P IN(1, 2) AND PROT[P, M] IN (3, 35)  THEN DO;
				UPTMS = 1;
				UPTMS_D + 1;
			END;
			
			****94;
			IF P IN(1, 2) AND PROT[P, M] IN (35)  THEN DO;
				UPTMS_C = 1;
				UPTMS_C_D + 1;
			END;
			
			****95;
			IF P IN(3, 4) AND PROT[P, M] IN (3, 35)  THEN DO;
				UPTMI = 1;
				UPTMI_D + 1;
			END;
			
			****96;
			IF P IN(3, 4) AND PROT[P, M] IN (35)  THEN DO;
				UPTMI_C = 1;
				UPTMI_C_D + 1;
			END;
			
			****97;
			*IF P IN(1, 2) AND PROT[P, M] IN (1, 2, 4, 15, 25, 45)  THEN DO;
			*	PFORMS_F_R = 1;
			*END;			
			
			****99;
			*IF P IN(3, 4) AND PROT[P, M] IN (1, 2, 4, 15, 25, 45)  THEN DO;
			*	PFORMI_F_R = 1;
			*END;			
			
			****101;
			*IF PROT[P, M] IN (3, 35)  THEN DO;
			*	UPTBM = 1;
			*END;
			
			****102;
			*IF PROT[P, M] IN (35)  THEN DO;
			*	UPTBM_C = 1;
			*END;
			
			****103;
			*IF PROT[P, M] IN (4, 45)  THEN DO;
			*	UPTAM = 1;
			*END;
			
			****126;
			IF PROT[P, M] IN (0)  THEN NPTMAM_C + 1;
			IF P IN(1, 2) AND PROT[P, M] IN (0)  THEN NPTMS_C + 1;
			IF P IN(3, 4) AND PROT[P, M] IN (0)  THEN NPTMI_C + 1;
			
			****127;
			IF PROT[P, M] IN (0, 15, 25, 45)  THEN DO;
				NPPMAM = 1;
			END;
			IF P IN(1, 2) AND PROT[P, M] IN (0, 15, 25, 45)  THEN DO;
				NPPMS = 1;
				NPPMS_C + 1;
			END;
			IF P IN(3, 4) AND PROT[P, M] IN (0, 15, 25, 45)  THEN DO;
				NPPMI = 1;
				NPPMI_C + 1;
			END;
			
			IF P IN(1, 2) AND PROT[P, M] NE 9 THEN REGS_C + 1;
			IF P IN(3, 4) AND PROT[P, M] NE 9 THEN REGI_C + 1;

			***** oclusión pares oclusales formula 86;
			IF P IN(1,2) THEN DO;
				IF P = 1 THEN P2 = 4;
				IF P = 2 THEN P2 = 3;

				IF M = 7 THEN DO; 
					IF COP[P, M] IN('0', '1', '2', '3', '6', '7') AND 
						COP[P2, M] IN('0', '1', '2', '3', '6', '7') THEN 
						PAR_OCLU + 1;
				END;
				ELSE DO;
					IF COP[P, M] IN('0', '1', '2', '3', '6', '7') AND
						(COP[P2, M] IN('0', '1', '2', '3', '6', '7')  OR 
						COP[P2, M + 1] IN('0', '1', '2', '3', '6', '7')) THEN
							PAR_OCLU + 1;
				END;
				
				IF M = 7 THEN DO; 
					IF (COP[P, M] IN('0', '1', '2', '3', '6', '7') OR 
						PROT[P, M] IN(1, 15, 2, 25, 3, 35, 4, 45)) AND 
						(COP[P2, M] IN('0', '1', '2', '3', '6', '7') OR
						 PROT[P2, M] IN(1, 15, 2, 25, 3, 35, 4, 45)) THEN 
						PAR_OCLU_R + 1;
				END;
				ELSE DO;
					IF (COP[P, M] IN('0', '1', '2', '3', '6', '7') OR
						PROT[P, M] IN(1, 15, 2, 25, 3, 35, 4, 45)) AND
						(COP[P2, M] IN('0', '1', '2', '3', '6', '7')  OR 
						 PROT[P2, M] IN(1, 15, 2, 25, 3, 35, 4, 45) OR
						COP[P2, M + 1] IN('0', '1', '2', '3', '6', '7') OR
						PROT[P2, M + 1] IN(1, 15, 2, 25, 3, 35, 4, 45)) THEN
							PAR_OCLU_R + 1;
				END;
			END;
			
			************ OPACIDAD;
			IF OPAC[P, M] IN(7, 8) THEN DO;
				POE = 1;
				POE_C + 1;
				IF OPAC[P, M] IN(7) THEN POE_7 + 1;
				IF OPAC[P, M] IN(8) THEN POE_8 + 1;
				
				IF M IN(1, 2, 3) 		THEN DO;
					POE_IC = 1;
					POE_IC_C + 1;
					IF OPAC[P, M] IN(7) THEN POE_IC_7 + 1;
					IF OPAC[P, M] IN(8) THEN POE_IC_8 + 1;
				END;
				IF M IN(4, 5, 6, 7, 8) 	THEN DO;
					POE_MP = 1;
					POE_MP_C + 1;
					IF OPAC[P, M] IN(7) THEN POE_MP_7 + 1;
					IF OPAC[P, M] IN(8) THEN POE_MP_8 + 1;
				END;
			END;
		END;
	END;

	IF IDA_P = PERMANENTES THEN PAATD_P = 1;
	IF DIE_BOCAP = 28  THEN PADB_28_P = 1;
	IF DIE_BOCAP < 20  THEN PADB_M_20_P = 1;
	IF DIE_BOCAP >= 21 THEN PDF = 1;
	
	SELECT;
	    WHEN (DIE_BOCAP = . ) EDEN_CLA = 9;
		WHEN (DIE_BOCAP = 0 ) EDEN_CLA = 0;
		WHEN (DIE_BOCAP < 16) EDEN_CLA = 1;
		WHEN (DIE_BOCAP < 20) EDEN_CLA = 2;
		WHEN (DIE_BOCAP < 24) EDEN_CLA = 3;
		WHEN (DIE_BOCAP < 28) EDEN_CLA = 4;
		WHEN (DIE_BOCAP = 28) EDEN_CLA = 5;
		OTHERWISE            EDEN_CLA =  9;
	END;
	
	IF PETPID_EVAL = PETPID_PRO THEN PETPID_TE = 1;
	IF PETPII_EVAL = PETPII_PRO THEN PETPII_TE = 1;
	IF PETPSD_EVAL = PETPSD_PRO THEN PETPSD_TE = 1;
	IF PETPSI_EVAL = PETPSI_PRO THEN PETPSI_TE = 1;
	IF PETAI_EVAL  = PETAI_PRO  THEN PETAI_TE  = 1;
	IF PETAS_EVAL  = PETAS_PRO  THEN PETAS_TE  = 1;
	
* * * PROTESIS;
	* * FORMULA 93 Y 95;
	IF PETPSD_TE AND PETPSI_TE AND PETAS_TE AND UPTMS THEN UPTMS = 1;ELSE UPTMS = 0;
	IF PETPID_TE AND PETPII_TE AND PETAI_TE AND UPTMI THEN UPTMI = 1;ELSE UPTMI = 0;
	
	IF UPTMS = 0 THEN UPTMS_D = 0;
	IF UPTMI = 0 THEN UPTMI_D = 0;
	
	* * FORMULA 94 Y 96;	
	IF PETPSD_TE AND PETPSI_TE AND PETAS_TE AND UPTMS_C THEN UPTMS_C = 1;ELSE UPTMS_C = 0;
	IF PETPID_TE AND PETPII_TE AND PETAI_TE AND UPTMI_C THEN UPTMI_C = 1;ELSE UPTMI_C = 0;

	IF UPTMS_C = 0 THEN UPTMS_C_D = 0;
	IF UPTMI_C = 0 THEN UPTMI_C_D = 0;
	
	* * FORMULA 85 Y 86;
	IF UPTMS   OR UPTMI   THEN PP_CT_3 =  1;ELSE PP_CT_3  = 0;
	IF UPTMS_C OR UPTMI_C THEN PP_CT_35 = 1;ELSE PP_CT_35 = 0;
	
	IF PP_CT_3  AND PP_AT = 0 THEN PP_AT = 1;
	IF PP_CT_35 AND PP_C  = 0 THEN PP_C  = 1;
	
	* * FORMULA 87 Y 88;
	IF UPTMS   AND UPMS     = 0 THEN UPMS     = 1;
	IF UPTMS   AND UPMS_R   = 0 THEN UPMS_R   = 1;
	
	IF UPTMS_C AND UPMS_C   = 0 THEN UPMS_C   = 1;
	IF UPTMS_C AND UPMS_C_R = 0 THEN UPMS_C_R = 1;
	
	* * FORMULA 89 Y 90;
	IF UPTMI   AND UPMI     = 0 THEN UPMI     = 1;
	IF UPTMI   AND UPMI_R   = 0 THEN UPMI_R   = 1;
	
	IF UPTMI_C AND UPMI_C   = 0 THEN UPMI_C   = 1;
	IF UPTMI_C AND UPMI_C_R = 0 THEN UPMI_C_R = 1;
	
	* * FORMULA 91 Y 92;
	IF UPPAM_S  = 1 AND UPPAM_I  = 1 THEN UPPAM   = 1;
	IF UPPAM_CS = 1 AND UPPAM_CI = 1 THEN UPPAM_C = 1;
	
 	* * FORMULA 97 Y 99;
	IF UPTMS = 1 AND UPPAM_I = 1 THEN PFORMI = 1;ELSE PFORMI = 0; 
	IF UPTMI = 1 AND UPPAM_S = 1 THEN PFORMS = 1;ELSE PFORMS = 0;
	
	* * FORMULA 101 Y 102;
	IF UPTMS AND UPTMI THEN UPTBM = 1;ELSE UPTBM = 0;
	IF UPTMS_C AND UPTMI_C THEN UPTBM_C = 1;ELSE UPTBM_C = 0;
	
	* * FORMULA 126;
	IF REGI_C = NPTMI_C + UPTMI_C_D AND PETPID_TE AND PETPII_TE AND PETAI_TE THEN NPTMI = 1;
	IF REGS_C = NPTMS_C + UPTMS_C_D AND PETPSD_TE AND PETPSI_TE AND PETAS_TE THEN NPTMS = 1;
	IF NPTMI AND NPTMS THEN NPTMAM = 1;
	
	* * FORMULA 127;
		* * AJUSTE PARA LOS QUE REPORTAN TODOS LOS DIENTES PARA CAMBIO;
	*IF REGS_C = NPPMS_C THEN NPPMS = 0;
	*IF REGI_C = NPPMI_C THEN NPPMI = 0;
	*IF NPPMS = 0 AND NPPMI = 0 THEN NPPMAM = 0;
		
		* * AJUSTE PARA EDENTULOS TOTALES;
	IF PETPSD_TE AND PETPSI_TE AND PETAS_TE THEN NPPMS = 0;
	IF PETPID_TE AND PETPII_TE AND PETAI_TE THEN NPPMI = 0;
	IF NPPMS = 0 AND NPPMI = 0 THEN NPPMAM = 0;
	
	* * FORMULA 128;
	IF NPTMS =  1 AND NPPMI = 1 THEN NPTSS = 1;ELSE NPTSS = 0;
	* * FORMULA 129;
	IF NPTMI =  1 AND NPPMS = 1 THEN NPTSI = 1;ELSE NPTSI = 0;
	
	*******************************************************************PERIODONTAL
	***************************************************ESI
	*** EXTENSION = % DE SITIOS CON VALOR MAYOR A &K_ESI
	*** SEVERIDAD = PROMEDIO DE SITIOS CON VALOR MAYOR A &K_ESI;

	***** VARIABLES A USAR:
	*** PROFUNDIDA CLÍNICA EN SONDAJE (MM): MD312MB17--MD312DL27 MD314MB47--MD314DL37
	*** MARGEN-LÍNEA CEMENTO AMÉLICA (MM): MD313MB17--MD313DL27 MD315MB47--MD315DL37;


		* * * * * profundidad clínica 20 a 79 años ;
	ARRAY PRO {4, 7, 6}
		 ME316MB11 ME316B11 ME316DB11 ME316ML11 ME316L11 ME316DL11
		 ME316MB12 ME316B12 ME316DB12 ME316ML12 ME316L12 ME316DL12
		 ME316MB13 ME316B13 ME316DB13 ME316ML13 ME316L13 ME316DL13
		 ME316MB14 ME316B14 ME316DB14 ME316ML14 ME316L14 ME316DL14
		 ME316MB15 ME316B15 ME316DB15 ME316ML15 ME316L15 ME316DL15
		 ME316MB16 ME316B16 ME316DB16 ME316ML16 ME316L16 ME316DL16
		 ME316MB17 ME316B17 ME316DB17 ME316ML17 ME316L17 ME316DL17
		 ME316MB21 ME316B21 ME316DB21 ME316ML21 ME316L21 ME316DL21
		 ME316MB22 ME316B22 ME316DB22 ME316ML22 ME316L22 ME316DL22
		 ME316MB23 ME316B23 ME316DB23 ME316ML23 ME316L23 ME316DL23
		 ME316MB24 ME316B24 ME316DB24 ME316ML24 ME316L24 ME316DL24
		 ME316MB25 ME316B25 ME316DB25 ME316ML25 ME316L25 ME316DL25
		 ME316MB26 ME316B26 ME316DB26 ME316ML26 ME316L26 ME316DL26
		 ME316MB27 ME316B27 ME316DB27 ME316ML27 ME316L27 ME316DL27
		 ME318MB31 ME318B31 ME318DB31 ME318ML31 ME318L31 ME318DL31
		 ME318MB32 ME318B32 ME318DB32 ME318ML32 ME318L32 ME318DL32
		 ME318MB33 ME318B33 ME318DB33 ME318ML33 ME318L33 ME318DL33
		 ME318MB34 ME318B34 ME318DB34 ME318ML34 ME318L34 ME318DL34
		 ME318MB35 ME318B35 ME318DB35 ME318ML35 ME318L35 ME318DL35
		 ME318MB36 ME318B36 ME318DB36 ME318ML36 ME318L36 ME318DL36
		 ME318MB37 ME318B37 ME318DB37 ME318ML37 ME318L37 ME318DL37
		 ME318MB41 ME318B41 ME318DB41 ME318ML41 ME318L41 ME318DL41
		 ME318MB42 ME318B42 ME318DB42 ME318ML42 ME318L42 ME318DL42
		 ME318MB43 ME318B43 ME318DB43 ME318ML43 ME318L43 ME318DL43
		 ME318MB44 ME318B44 ME318DB44 ME318ML44 ME318L44 ME318DL44
		 ME318MB45 ME318B45 ME318DB45 ME318ML45 ME318L45 ME318DL45
		 ME318MB46 ME318B46 ME318DB46 ME318ML46 ME318L46 ME318DL46
		 ME318MB47 ME318B47 ME318DB47 ME318ML47 ME318L47 ME318DL47
	;
	* * * * * margen-línea cemento amélica 20 a 79 años ;
	ARRAY MCA {4, 7, 6}
		 ME317MB11 ME317B11 ME317DB11 ME317ML11 ME317L11 ME317DL11
		 ME317MB12 ME317B12 ME317DB12 ME317ML12 ME317L12 ME317DL12
		 ME317MB13 ME317B13 ME317DB13 ME317ML13 ME317L13 ME317DL13
		 ME317MB14 ME317B14 ME317DB14 ME317ML14 ME317L14 ME317DL14
		 ME317MB15 ME317B15 ME317DB15 ME317ML15 ME317L15 ME317DL15
		 ME317MB16 ME317B16 ME317DB16 ME317ML16 ME317L16 ME317DL16
		 ME317MB17 ME317B17 ME317DB17 ME317ML17 ME317L17 ME317DL17
		 ME317MB21 ME317B21 ME317DB21 ME317ML21 ME317L21 ME317DL21
		 ME317MB22 ME317B22 ME317DB22 ME317ML22 ME317L22 ME317DL22
		 ME317MB23 ME317B23 ME317DB23 ME317ML23 ME317L23 ME317DL23
		 ME317MB24 ME317B24 ME317DB24 ME317ML24 ME317L24 ME317DL24
		 ME317MB25 ME317B25 ME317DB25 ME317ML25 ME317L25 ME317DL25
		 ME317MB26 ME317B26 ME317DB26 ME317ML26 ME317L26 ME317DL26
		 ME317MB27 ME317B27 ME317DB27 ME317ML27 ME317L27 ME317DL27
		 ME319MB31 ME319B31 ME319DB31 ME319ML31 ME319L31 ME319DL31
		 ME319MB32 ME319B32 ME319DB32 ME319ML32 ME319L32 ME319DL32
		 ME319MB33 ME319B33 ME319DB33 ME319ML33 ME319L33 ME319DL33
		 ME319MB34 ME319B34 ME319DB34 ME319ML34 ME319L34 ME319DL34
		 ME319MB35 ME319B35 ME319DB35 ME319ML35 ME319L35 ME319DL35
		 ME319MB36 ME319B36 ME319DB36 ME319ML36 ME319L36 ME319DL36
		 ME319MB37 ME319B37 ME319DB37 ME319ML37 ME319L37 ME319DL37
		 ME319MB41 ME319B41 ME319DB41 ME319ML41 ME319L41 ME319DL41
		 ME319MB42 ME319B42 ME319DB42 ME319ML42 ME319L42 ME319DL42
		 ME319MB43 ME319B43 ME319DB43 ME319ML43 ME319L43 ME319DL43
		 ME319MB44 ME319B44 ME319DB44 ME319ML44 ME319L44 ME319DL44
		 ME319MB45 ME319B45 ME319DB45 ME319ML45 ME319L45 ME319DL45
		 ME319MB46 ME319B46 ME319DB46 ME319ML46 ME319L46 ME319DL46
		 ME319MB47 ME319B47 ME319DB47 ME319ML47 ME319L47 ME319DL47
	;
	* * * * * nivel de inserción clínica 20 a 79 años ;
	ARRAY INS {4, 7, 6}
		 INSMB11 INSB11 INSDB11 INSML11 INSL11 INSDL11
		 INSMB12 INSB12 INSDB12 INSML12 INSL12 INSDL12
		 INSMB13 INSB13 INSDB13 INSML13 INSL13 INSDL13
		 INSMB14 INSB14 INSDB14 INSML14 INSL14 INSDL14
		 INSMB15 INSB15 INSDB15 INSML15 INSL15 INSDL15
		 INSMB16 INSB16 INSDB16 INSML16 INSL16 INSDL16
		 INSMB17 INSB17 INSDB17 INSML17 INSL17 INSDL17
		 INSMB21 INSB21 INSDB21 INSML21 INSL21 INSDL21
		 INSMB22 INSB22 INSDB22 INSML22 INSL22 INSDL22
		 INSMB23 INSB23 INSDB23 INSML23 INSL23 INSDL23
		 INSMB24 INSB24 INSDB24 INSML24 INSL24 INSDL24
		 INSMB25 INSB25 INSDB25 INSML25 INSL25 INSDL25
		 INSMB26 INSB26 INSDB26 INSML26 INSL26 INSDL26
		 INSMB27 INSB27 INSDB27 INSML27 INSL27 INSDL27
		 INSMB31 INSB31 INSDB31 INSML31 INSL31 INSDL31
		 INSMB32 INSB32 INSDB32 INSML32 INSL32 INSDL32
		 INSMB33 INSB33 INSDB33 INSML33 INSL33 INSDL33
		 INSMB34 INSB34 INSDB34 INSML34 INSL34 INSDL34
		 INSMB35 INSB35 INSDB35 INSML35 INSL35 INSDL35
		 INSMB36 INSB36 INSDB36 INSML36 INSL36 INSDL36
		 INSMB37 INSB37 INSDB37 INSML37 INSL37 INSDL37
		 INSMB41 INSB41 INSDB41 INSML41 INSL41 INSDL41
		 INSMB42 INSB42 INSDB42 INSML42 INSL42 INSDL42
		 INSMB43 INSB43 INSDB43 INSML43 INSL43 INSDL43
		 INSMB44 INSB44 INSDB44 INSML44 INSL44 INSDL44
		 INSMB45 INSB45 INSDB45 INSML45 INSL45 INSDL45
		 INSMB46 INSB46 INSDB46 INSML46 INSL46 INSDL46
		 INSMB47 INSB47 INSDB47 INSML47 INSL47 INSDL47
	;

* * PROFUNDIDAD MÁXIMA EN SITIOS INTERPROXIMALES PARA EL DIENTE;
	ARRAY PROM{4, 7}
		PRO11	PRO12	PRO13	PRO14	PRO15	PRO16	PRO17
		PRO21	PRO22	PRO23	PRO24	PRO25	PRO26	PRO27
		PRO31	PRO32	PRO33	PRO34	PRO35	PRO36	PRO37
		PRO41	PRO42	PRO43	PRO44	PRO45	PRO46	PRO47
		;

	* * NIVEL DE INSERCIÓN MÁXIMO EN SITIOS INTERPROXIMALES PARA EL DIENTE;
	ARRAY INSM{4, 7}
		INS11	INS12	INS13	INS14	INS15	INS16	INS17
		INS21	INS22	INS23	INS24	INS25	INS26	INS27
		INS31	INS32	INS33	INS34	INS35	INS36	INS37
		INS41	INS42	INS43	INS44	INS45	INS46	INS47
		;

	* * DIENTE CON ALGUNA MEDICIÓN;
	ARRAY MPRO{4, 7}
		MPRO11	MPRO12	MPRO13	MPRO14	MPRO15	MPRO16	MPRO17
		MPRO21	MPRO22	MPRO23	MPRO24	MPRO25	MPRO26	MPRO27
		MPRO31	MPRO32	MPRO33	MPRO34	MPRO35	MPRO36	MPRO37
		MPRO41	MPRO42	MPRO43	MPRO44	MPRO45	MPRO46	MPRO47
	;

	ARRAY MMCA{4, 7}
		MMCA11	MMCA12	MMCA13	MMCA14	MMCA15	MMCA16	MMCA17
		MMCA21	MMCA22	MMCA23	MMCA24	MMCA25	MMCA26	MMCA27
		MMCA31	MMCA32	MMCA33	MMCA34	MMCA35	MMCA36	MMCA37
		MMCA41	MMCA42	MMCA43	MMCA44	MMCA45	MMCA46	MMCA47
	;

	ARRAY MINS{4, 7}
		MINS11	MINS12	MINS13	MINS14	MINS15	MINS16	MINS17
		MINS21	MINS22	MINS23	MINS24	MINS25	MINS26	MINS27
		MINS31	MINS32	MINS33	MINS34	MINS35	MINS36	MINS37
		MINS41	MINS42	MINS43	MINS44	MINS45	MINS46	MINS47
	;
	* * PROFUNDIDAD MÁXIMA PARA EL DIENTE;
	ARRAY PROMM{4, 7}
		PRO11_M	PRO12_M	PRO13_M	PRO14_M	PRO15_M	PRO16_M	PRO17_M
		PRO21_M	PRO22_M	PRO23_M	PRO24_M	PRO25_M	PRO26_M	PRO27_M
		PRO31_M	PRO32_M	PRO33_M	PRO34_M	PRO35_M	PRO36_M	PRO37_M
		PRO41_M	PRO42_M	PRO43_M	PRO44_M	PRO45_M	PRO46_M	PRO47_M
		;

	* * VARIABLE PARA EL CÁLCULO DEL ESI;
	EXT_PRO = 0;
	SEV_PRO = 0;
	SIT_PRO = 0;
	DIE_PRO = 0;

	EXT_PRO_PI = 0;
	SEV_PRO_PI = 0;
	SIT_PRO_PI = 0;
	DIE_PRO_PI = 0;
	
	EXT_MCA = 0;
	SEV_MCA = 0;
	SIT_MCA = 0;
	DIE_MCA = 0;

	EXT_INS = 0;
	SEV_INS = 0;
	SIT_INS = 0;
	DIE_INS = 0;

	EXT_INS_IP = 0;
	SEV_INS_IP = 0;	
	SIT_INS_IP = 0;
	DIE_INS_IP = 0;

	* * NIC ENSAB III;
	
	EXT_INS_III = 0;
	SEV_INS_III = 0;	
	SIT_INS_III = 0;
	DIE_INS_III = 0;

	* * VARIABLES PARA EL CÁLCULO DEL CDC-AAP;
	AL3 = 0;
	AL4 = 0;
	AL5 = 0;
	AL6 = 0;
	PD4 = 0;
	PD5 = 0;

	* * VARIABLES PARA EL CÁLCULO DEL EUROPEO;
	INC = 0;
	SEV = 0;
	
	* * INDICADORES OMS;
	OMS_PRO = 0;
	OMS_PRO_CL = '';
	EXT_PRO_OMS = 0;
	SEV_PRO_OMS = 0;
	SIT_PRO_OMS = 0;
	DIE_PRO_OMS = 0;

	NEGATIVO = 0;

	DO L = 1 TO 4; * * VARIANDO POR LADO;
		DO D = 1 TO 7; * * VARIANDO POR DIENTE;
			IF COP[L, D] NOT IN('4', '5') THEN DO; * * SE EXCLUYEN LOS DIENTES QUE NO ESTAN;
				MINS_IP = 0;
				MPRO_PI = 0;
				MPRO_N  = 0;
				DO I = 1 TO 6; * * VARIANDO EN LOS SITIOS DE MEDICIÓN 'MB', 'B', 'DB', 'ML', 'L', 'DL';
					

					* * CANTIDADES PARA ESI PARA PROFUNDIDAD DE CLÍNICA DE SONDAJE;
					IF PRO[L, D, I] NOT IN(., 99) THEN DO;
						MPRO_N = 1;
						SIT_PRO + 1;
						MPRO[L, D] = MAX(MPRO[L, D], PRO[L, D, I]);
						IF PRO[L, D, I] > &kPRO_ESI1 THEN DO;
							EXT_PRO + 1;
							SEV_PRO = SEV_PRO + PRO[L, D, I] - &kPRO_ESI1;
						END;
					END;

					* * CANTIDADES PARA ESI PARA PROFUNDIDAD DE CLÍNICA DE SONDAJE
						DE SITIOS PERI-IMPLANTARES;
					IF PRO[L, D, I] NOT IN(., 99) AND 
					   COP[L, D] = '7' AND PROT[L, D] IN(4, 45) THEN DO;
						MPRO_PI = 1;
						SIT_PRO_PI + 1;
						IF PRO[L, D, I] > &kPRO_ESI1 THEN DO;
							EXT_PRO_PI + 1;
							SEV_PRO_PI = SEV_PRO_PI + PRO[L, D, I] - &kPRO_ESI1;
						END;
					END;
					
					* * CANTIDADES PARA ESI PARA MARGEN-LÍNEA CEMENTO AMÉLICA;
					IF (COP[L, D] NE '7' OR PROT[L, D] NOT IN (4, 45)) AND 
					  MCA[L, D, I] NOT IN(., 99) THEN DO;* * NO SE CONSIDERAN PROTESIS IMPLANTADO;
					  	MMCA[L, D] = 1;
						SIT_MCA + 1;
						IF MCA[L, D, I] < &kMCA_ESI1 THEN DO;
							EXT_MCA + 1;
							SEV_MCA = SEV_MCA + MCA[L, D, I] - &kMCA_ESI1;
						END;
					END;

					* * CANTIDADES PARA ESI PARA EL NIVEL CLÍNICO DE INSERCIÓN;
					IF PRO[L, D, I] NOT IN(., 99) AND 
					  ((COP[L, D] NE '7' OR PROT[L, D] NOT IN (4, 45)) AND 
					  MCA[L, D, I] NOT IN(., 99)) THEN DO;
						INS[L, D, I] = PRO[L, D, I] - MCA[L, D, I];
						MINS[L, D] = 1;
					END;* * NO SE CONSIDERAN PROTESIS IMPLANTADO;

					IF INS[L, D, I] NOT IN(., 99) THEN DO;
						SIT_INS + 1;
						IF INS[L, D, I] > &kINS_ESI1 THEN DO;
							EXT_INS + 1;
							SEV_INS = SEV_INS + INS[L, D, I] - &kINS_ESI1;
						END;
						IF INS[L, D, I] < 0 AND INS[L, D, I] NE .
							THEN NEGATIVO + 1;
					END;

					* * ESI DE NIVEL CLÍNICO DE INSERCIÓN INTERPROXIMALES;
					IF I NOT IN(2, 5) AND INS[L, D, I] NOT IN(., 99) THEN DO;
						SIT_INS_IP + 1;
						MINS_IP = 1;
						IF INS[L, D, I] > &kINS_ESI1 THEN DO;
							EXT_INS_IP + 1;
							SEV_INS_IP = SEV_INS_IP + INS[L, D, I] - &kINS_ESI1;
						END;
					END;

					IF I NOT IN(2, 5) THEN DO; * * VALORES MÁXIMOS DE PROFUNDIDAD Y NIVEL DE INSERCIÓN CLÍNICA POR DIENTE;
						IF PRO[L, D, I] NOT IN(., 99) THEN PROM[L, D] = MAX(PROM[L, D], PRO[L, D, I]);
						IF INS[L, D, I] NOT IN(., 99) THEN INSM[L, D] = MAX(INSM[L, D], INS[L, D, I]);
					END;
					
					IF PRO[L, D, I] NOT IN(., 99) THEN PROMM[L, D] = MAX(PROMM[L, D], PRO[L, D, I]);
				END;
			
				IF INSM[L, D] >= 3 THEN AL3 + 1;
				IF INSM[L, D] >= 4 THEN AL4 + 1;
				IF INSM[L, D] >= 5 THEN AL5 + 1;
				IF INSM[L, D] >= 6 THEN AL6 + 1;
				IF PROM[L, D] >= 4 THEN PD4 + 1;
				IF PROM[L, D] >= 5 THEN PD5 + 1;

				SELECT; * * CÁLCULO DEL EUROPEO;
					WHEN (D = 1) DO;
						SELECT;
							WHEN (L IN (2, 4)) DO;
								IF INSM[L, D] >= 3 AND INSM[L - 1, D] < 3 
									AND INSM[L - 1, D] NE . THEN INC + 1;
								IF INSM[L, D] >= 3 AND INSM[L - 1, D] >= 3
									AND INSM[L - 1, D + 1] >= 3 THEN INC + 1; 
							END;
							OTHERWISE DO;
								IF INSM[L, D] >= 3 THEN INC + 1; 
							END;
						END;
					END;
					WHEN (D = 2) DO;
						SELECT;
							WHEN (L IN (2, 4)) DO;
								IF INSM[L, D] >= 3 AND INSM[L, D - 1] < 3  
									AND INSM[L, D - 1] NE . THEN INC + 1; 
								IF INSM[L, D] >= 3 AND INSM[L, D - 1] >= 3
									AND INSM[L - 1, D - 1] >= 3 THEN INC + 1; 
							END;
							OTHERWISE DO;
								IF INSM[L, D] >= 3 AND INSM[L, D - 1] < 3  
									AND INSM[L, D - 1] NE . THEN INC + 1;
								IF INSM[L, D] >= 3 AND INSM[L, D - 1] >= 3
									AND INSM[L + 1, D - 1] >= 3 THEN INC + 1; 
							END;
						END;
					END;
					OTHERWISE DO;
						IF INSM[L, D] >= 3 AND INSM[L, D - 1] < 3  
									AND INSM[L, D - 1] NE . THEN INC + 1;
						IF INSM[L, D] >= 3 AND INSM[L, D - 1] >= 3
									AND INSM[L, D - 2] >= 3 THEN INC + 1;  
					END;
				END;

				* * CONTEO DE DIENTES MEDIDOS;
				IF MPRO_N = 1 THEN DIE_PRO + 1;
				IF MPRO_PI = 1 THEN DIE_PRO_PI + 1;
				IF MMCA[L, D] = 1 THEN DIE_MCA + 1;
				IF MINS[L, D] = 1 THEN DIE_INS + 1;
				IF MINS_IP = 1 THEN DIE_INS_IP + 1;
				
				* * OMS;
				*IF ;

			END; * * SE EXCLUYEN LOS DIENTES QUE NO ESTAN;				
		END; * * VARIANDO POR DIENTE;
		
		* * * OMS;
		SELECT;
			WHEN (PROMM[L, 7] = . AND PROMM[L, 6] = . AND 
				(PROMM[L, 5] NE . OR PROMM[L, 4] NE . OR PROMM[L, 3] NE . OR PROMM[L, 2] NE .)) 
				PROMM[L, 7] = MAX(PROMM[L, 5], PROMM[L, 4], PROMM[L, 3], PROMM[L, 2]);
			WHEN (PROMM[L, 7] = . AND PROMM[L, 6] NE .)
				PROMM[L, 7] = PROMM[L, 6];
			OTHERWISE PROMM[L, 6] = .;
		END;
		IF L IN(1, 3) AND PROMM[L, 1] = . AND 
		(PROMM[L, 5] NE . OR PROMM[L, 4] NE . OR PROMM[L, 3] NE . OR PROMM[L, 2] NE .)
			THEN PROMM[L, 1] = MAX(PROMM[L, 5], PROMM[L, 4], PROMM[L, 3], PROMM[L, 2]);
		
	END; * * VARIANDO POR LADO;

	* * ESI DE NIVEL CLÍNICO DE INSERCIÓN ENSAB III;
	IF COP[1, 1] NOT IN('4', '5') AND INS[1, 1, 1] NOT IN(., 99) THEN DO;
		DIE_INS_III + 1;
		SIT_INS_III + 1;
		IF INS[1, 1, 1] > &kINS_ESI1 THEN DO;
			EXT_INS_III + 1;
			SEV_INS_III = SEV_INS_III + INS[1, 1, 1] - &kINS_ESI1;
		END;
	END;
	ELSE IF COP[2, 1] NOT IN('4', '5') AND INS[2, 1, 1] NOT IN(., 99) THEN DO;
		DIE_INS_III + 1;
		SIT_INS_III + 1;
		IF INS[2, 1, 1] > &kINS_ESI1 THEN DO;
			EXT_INS_III + 1;
			SEV_INS_III = SEV_INS_III + INS[2, 1, 1] - &kINS_ESI1;
		END;
	END;
			
	IF COP[1, 6] NOT IN('4', '5') THEN DO;
		IF INS[1, 6, 1] NOT IN(., 99) OR INS[1, 6, 3] NOT IN(., 99) THEN 
			DIE_INS_III + 1;
		IF INS[1, 6, 1] NOT IN(., 99) THEN DO;
			SIT_INS_III + 1;
			IF INS[1, 6, 1] > &kINS_ESI1 THEN DO;
				EXT_INS_III + 1;
				SEV_INS_III = SEV_INS_III + INS[1, 6, 1] - &kINS_ESI1;
			END;
		END;
		IF INS[1, 6, 3] NOT IN(., 99) THEN DO;
			SIT_INS_III + 1;
			IF INS[1, 6, 3] > &kINS_ESI1 THEN DO;
				EXT_INS_III + 1;
				SEV_INS_III = SEV_INS_III + INS[1, 6, 3] - &kINS_ESI1;
			END;
		END;
	END;
	ELSE IF COP[2, 6] NOT IN('4', '5') THEN DO;
		IF INS[2, 6, 1] NOT IN(., 99) OR INS[2, 6, 3] NOT IN(., 99) THEN 
			DIE_INS_III + 1;
		IF INS[2, 6, 1] NOT IN(., 99) THEN DO;
			SIT_INS_III + 1;
			IF INS[2, 6, 1] > &kINS_ESI1 THEN DO;
				EXT_INS_III + 1;
				SEV_INS_III = SEV_INS_III + INS[2, 6, 1] - &kINS_ESI1;
			END;
		END;
		IF INS[2, 6, 3] NOT IN(., 99) THEN DO;
			SIT_INS_III + 1;
			IF INS[2, 6, 3] > &kINS_ESI1 THEN DO;
				EXT_INS_III + 1;
				SEV_INS_III = SEV_INS_III + INS[2, 6, 3] - &kINS_ESI1;
			END;
		END;
	END;
			
	IF COP[2, 3] NOT IN('4', '5') AND INS[2, 3, 1] NOT IN(., 99) THEN DO;
		DIE_INS_III + 1;
		SIT_INS_III + 1;
		IF INS[2, 3, 1] > &kINS_ESI1 THEN DO;
			EXT_INS_III + 1;
			SEV_INS_III = SEV_INS_III + INS[2, 3, 1] - &kINS_ESI1;
		END;
	END;
	ELSE IF COP[1, 3] NOT IN('4', '5') AND INS[1, 3, 1] NOT IN(., 99) THEN DO;
		DIE_INS_III + 1;
		SIT_INS_III + 1;
		IF INS[1, 3, 1] > &kINS_ESI1 THEN DO;
			EXT_INS_III + 1;
			SEV_INS_III = SEV_INS_III + INS[1, 3, 1] - &kINS_ESI1;
		END;
	END;

	IF COP[2, 5] NOT IN('4', '5') AND INS[2, 5, 3] NOT IN(., 99) THEN DO;
		DIE_INS_III + 1;
		SIT_INS_III + 1;
		IF INS[2, 5, 3] > &kINS_ESI1 THEN DO;
			EXT_INS_III + 1;
			SEV_INS_III = SEV_INS_III + INS[2, 5, 3] - &kINS_ESI1;
		END;
	END;
	ELSE IF COP[1, 5] NOT IN('4', '5') AND INS[1, 5, 3] NOT IN(., 99) THEN DO;
		DIE_INS_III + 1;
		SIT_INS_III + 1;
		IF INS[1, 5, 3] > &kINS_ESI1 THEN DO;
			EXT_INS_III + 1;
			SEV_INS_III = SEV_INS_III + INS[1, 5, 3] - &kINS_ESI1;
		END;
	END;	
	
	IF COP[3, 4] NOT IN('4', '5') AND INS[3, 4, 3] NOT IN(., 99) THEN DO;
		DIE_INS_III + 1;
		SIT_INS_III + 1;
		IF INS[3, 4, 3] > &kINS_ESI1 THEN DO;
			EXT_INS_III + 1;
			SEV_INS_III = SEV_INS_III + INS[3, 4, 3] - &kINS_ESI1;
		END;
	END;
	ELSE IF COP[4, 4] NOT IN('4', '5') AND INS[4, 4, 3] NOT IN(., 99) THEN DO;
		DIE_INS_III + 1;
		SIT_INS_III + 1;
		IF INS[4, 4, 3] > &kINS_ESI1 THEN DO;
			EXT_INS_III + 1;
			SEV_INS_III = SEV_INS_III + INS[4, 4, 3] - &kINS_ESI1;
		END;
	END;	
	
	IF COP[3, 5] NOT IN('4', '5') AND INS[3, 5, 1] NOT IN(., 99) THEN DO;
		DIE_INS_III + 1;
		SIT_INS_III + 1;
		IF INS[3, 5, 1] > &kINS_ESI1 THEN DO;
			EXT_INS_III + 1;
			SEV_INS_III = SEV_INS_III + INS[3, 5, 1] - &kINS_ESI1;
		END;
	END;
	ELSE IF COP[4, 5] NOT IN('4', '5') AND INS[4, 5, 1] NOT IN(., 99) THEN DO;
		DIE_INS_III + 1;
		SIT_INS_III + 1;
		IF INS[4, 5, 1] > &kINS_ESI1 THEN DO;
			EXT_INS_III + 1;
			SEV_INS_III = SEV_INS_III + INS[4, 5, 1] - &kINS_ESI1;
		END;
	END;
	
	IF COP[4, 1] NOT IN('4', '5') AND INS[4, 1, 1] NOT IN(., 99) THEN DO;
		DIE_INS_III + 1;
		SIT_INS_III + 1;
		IF INS[4, 1, 1] > &kINS_ESI1 THEN DO;
			EXT_INS_III + 1;
			SEV_INS_III = SEV_INS_III + INS[4, 1, 1] - &kINS_ESI1;
		END;
	END;
	ELSE IF COP[3, 1] NOT IN('4', '5') AND INS[3, 1, 1] NOT IN(., 99) THEN DO;
		DIE_INS_III + 1;
		SIT_INS_III + 1;
		IF INS[3, 1, 1] > &kINS_ESI1 THEN DO;
			EXT_INS_III + 1;
			SEV_INS_III = SEV_INS_III + INS[3, 1, 1] - &kINS_ESI1;
		END;
	END;
	
	IF COP[4, 3] NOT IN('4', '5') THEN DO;
		IF INS[4, 3, 1] NOT IN(., 99) OR INS[4, 3, 3] NOT IN(., 99) THEN 
			DIE_INS_III + 1;
		IF INS[4, 3, 1] NOT IN(., 99) THEN DO;
			SIT_INS_III + 1;
			IF INS[4, 3, 1] > &kINS_ESI1 THEN DO;
				EXT_INS_III + 1;
				SEV_INS_III = SEV_INS_III + INS[4, 3, 1] - &kINS_ESI1;
			END;
		END;
		IF INS[4, 3, 3] NOT IN(., 99) THEN DO;
			SIT_INS_III + 1;
			IF INS[4, 3, 3] > &kINS_ESI1 THEN DO;
				EXT_INS_III + 1;
				SEV_INS_III = SEV_INS_III + INS[4, 3, 3] - &kINS_ESI1;
			END;
		END;
	END;
	ELSE IF COP[3, 3] NOT IN('4', '5') THEN DO;
		IF INS[3, 3, 1] NOT IN(., 99) OR INS[3, 3, 3] NOT IN(., 99) THEN 
			DIE_INS_III + 1;
		IF INS[3, 3, 1] NOT IN(., 99) THEN DO;
			SIT_INS_III + 1;
			IF INS[3, 3, 1] > &kINS_ESI1 THEN DO;
				EXT_INS_III + 1;
				SEV_INS_III = SEV_INS_III + INS[3, 3, 1] - &kINS_ESI1;
			END;
		END;
		IF INS[3, 3, 3] NOT IN(., 99) THEN DO;
			SIT_INS_III + 1;
			IF INS[3, 3, 3] > &kINS_ESI1 THEN DO;
				EXT_INS_III + 1;
				SEV_INS_III = SEV_INS_III + INS[3, 3, 3] - &kINS_ESI1;
			END;
		END;
	END;
			* * * RECALCULO SEGUN ENSAB III;	
	
	* * * OMS;
	DB_COD0 = 0;
	DB_COD1 = 0;
	DB_COD2 = 0;
	DB_EXCL = 0;
	D_OMS = 0;
	DO L = 1 TO 4;
		DO D = 1,7;
			IF L IN(1, 3) AND D = 1 THEN DO;
				SELECT;
					WHEN (PROMM[L, D] =  .) DB_EXCL + 1;
					WHEN (PROMM[L, D] <= 3) DB_COD0 + 1;
					WHEN (PROMM[L, D] <= 5) DB_COD1 + 1;
					OTHERWISE 				DB_COD2 + 1;
				END;
				D_OMS + 1;
			END;
			ELSE IF D NE 1 THEN  DO;
				SELECT;
					WHEN (PROMM[L, D] =  .) DB_EXCL + 1;
					WHEN (PROMM[L, D] <= 3) DB_COD0 + 1;
					WHEN (PROMM[L, D] <= 5) DB_COD1 + 1;
					OTHERWISE 				DB_COD2 + 1;
				END;
				D_OMS + 1;
			END;
		END;
	END;
		
	SELECT;
		WHEN(DB_COD2 >0) DB_CL = 3;
		WHEN(DB_COD1 >0) DB_CL = 2;
		WHEN(DB_COD0 >0) DB_CL = 1;
		WHEN(DB_EXCL >0) DB_CL = 0;
		OTHERWISE DB_CL = .;
	END;	
	
	* * CÁLCULO DEL ESI PARA PROFUNDIDAD DE CLÍNICA DE SONDAJE;
	IF SIT_PRO > 0 THEN DO;
		IF EXT_PRO > 0 THEN 
			SEV_PRO = SEV_PRO / EXT_PRO;
		ELSE SEV_PRO = 0;
		EXT_PRO = EXT_PRO / SIT_PRO;
	END;
	ELSE DO;
		SEV_PRO = .;
		EXT_PRO = .;
	END;
	
	* * CÁLCULO DEL ESI PARA PROFUNDIDAD DE CLÍNICA DE SONDAJE
		SITIOS PERI-IMPLANTARES;
	IF SIT_PRO_PI > 0 THEN DO;
		IF EXT_PRO_PI > 0 THEN 
			SEV_PRO_PI = SEV_PRO_PI / EXT_PRO_PI;
		ELSE SEV_PRO_PI = 0;
		EXT_PRO_PI = EXT_PRO_PI / SIT_PRO_PI;
	END;
	ELSE DO;
		SEV_PRO_PI = .;
		EXT_PRO_PI = .;
	END;
	
	* * CÁLCULO DEL ESI PARA MARGEN-LÍNEA CEMENTO AMÉLICA;
	IF SIT_MCA > 0 THEN DO;
		IF EXT_MCA > 0 THEN 
			SEV_MCA = SEV_MCA / EXT_MCA;
		ELSE SEV_MCA = 0;
		EXT_MCA = EXT_MCA / SIT_MCA;
	END;
	ELSE DO;
		SEV_MCA = .;
		EXT_MCA = .;
	END;

	* * CÁLCULO DEL ESI PARA EL NIVEL CLÍNICO DE INSERCIÓN;
	IF SIT_INS > 0 THEN DO;
		IF EXT_INS > 0 THEN 
			SEV_INS = SEV_INS / EXT_INS;
		ELSE SEV_INS = 0;
		EXT_INS = EXT_INS / SIT_INS;
	END;
	ELSE DO;
		SEV_INS = .;
		EXT_INS = .;
	END;
	
	* * CÁLCULO DEL ESI PARA EL NIVEL CLÍNICO DE INSERCIÓN DE SITIOS INTERPROXIMALES;
	IF SIT_INS_IP > 0 THEN DO;
		IF EXT_INS_IP > 0 THEN 
			SEV_INS_IP = SEV_INS_IP / EXT_INS_IP;
		ELSE SEV_INS_IP = 0;
		EXT_INS_IP = EXT_INS_IP / SIT_INS_IP;
	END;
	ELSE DO;
		SEV_INS_IP = .;
		EXT_INS_IP = .;
	END;
	
	* * CÁLCULO DEL ESI ENSAB III;
	IF DIE_INS_III > 3 AND SIT_INS_III > 0 THEN DO;
		DEN_INSIII = 1;
		IF EXT_INS_III > 0 THEN 
			SEV_INS_III = SEV_INS_III / EXT_INS_III;
		ELSE SEV_INS_III = 0;
		EXT_INS_III = EXT_INS_III / SIT_INS_III;
	END;
	ELSE DO;
		DEN_INSIII = 0;
		SEV_INS_III = .;
		EXT_INS_III = .;
	END;

	* * * 48 Y 49;
	SELECT;
		WHEN (EXT_PRO < 0 OR EXT_PRO = .) 	CL_EXT_PRO = 9	;	
		WHEN (EXT_PRO = 0   ) 				CL_EXT_PRO = 1	;
		WHEN (EXT_PRO <= 0.3 ) 				CL_EXT_PRO = 2	;
		OTHERWISE 							CL_EXT_PRO = 3	;
	END;

	SELECT;
		WHEN (EXT_PRO = 0)					CL_SEV_PRO = 1  ;
		WHEN (SEV_PRO < 1 OR SEV_PRO = .) 	CL_SEV_PRO = 9	;
		WHEN (SEV_PRO < 3   ) 				CL_SEV_PRO = 2	;
		WHEN (SEV_PRO < 5 ) 				CL_SEV_PRO = 3  ;
		OTHERWISE 							CL_SEV_PRO = 4  ;
	END;

	* * * 52 Y 53;
	SELECT;
		WHEN (EXT_MCA < 0 OR EXT_MCA = .) 	CL_EXT_MCA = 9;
		WHEN (EXT_MCA = 0   ) 				CL_EXT_MCA = 1;
		WHEN (EXT_MCA <= 0.3 ) 				CL_EXT_MCA = 2;
		OTHERWISE 							CL_EXT_MCA = 3;
	END;

	SELECT;
		WHEN (SEV_MCA = .) 						CL_SEV_MCA = 9	;
		WHEN (SEV_MCA < -4.999 ) 				CL_SEV_MCA = 4		;
		WHEN (SEV_MCA < -2.999 ) 				CL_SEV_MCA = 3		;
		WHEN (SEV_MCA < -0.999 ) 				CL_SEV_MCA = 2			;
		OTHERWISE 								CL_SEV_MCA = 1	;
	END;
	
	* * * 45 Y 46;
	SELECT;
		WHEN (EXT_INS < 0 OR EXT_INS = .) 	CL_EXT_INS = 9;
		WHEN (EXT_INS = 0   ) 				CL_EXT_INS = 1;
		WHEN (EXT_INS <= 0.3 ) 				CL_EXT_INS = 2;
		OTHERWISE 							CL_EXT_INS = 3;
	END;

	SELECT;
		WHEN (EXT_INS = 0   ) 				CL_SEV_INS = 1;
		WHEN (SEV_INS < 1 OR SEV_INS = .) 	CL_SEV_INS = 9	;
		WHEN (SEV_INS < 3   ) 				CL_SEV_INS = 2;
		WHEN (SEV_INS < 5 ) 				CL_SEV_INS = 3	;
		OTHERWISE 							CL_SEV_INS = 4	;
	END;
	
	* * * 47;
	SELECT;
		WHEN (EXT_INS_IP < 0 OR EXT_INS_IP = .) 	CL_EXT_INS_IP = 9;
		WHEN (EXT_INS_IP = 0   ) 					CL_EXT_INS_IP = 1;
		WHEN (EXT_INS_IP <= 0.3 ) 					CL_EXT_INS_IP = 2;
		OTHERWISE 									CL_EXT_INS_IP = 3;
	END;

	SELECT;
		WHEN (EXT_INS_IP = 0   ) 					CL_SEV_INS_IP = 1;	
		WHEN (SEV_INS_IP < 1 OR SEV_INS_IP = .) 	CL_SEV_INS_IP = 9;
		WHEN (SEV_INS_IP < 3   ) 					CL_SEV_INS_IP = 2;
		WHEN (SEV_INS_IP < 5 ) 						CL_SEV_INS_IP = 3;
		OTHERWISE 									CL_SEV_INS_IP = 4;
	END;
	
	* * * 46A;
	SELECT;
		WHEN (EXT_INS_III < 0 OR EXT_INS_III = .) 	CL_EXT_INS_III = 9;
		WHEN (EXT_INS_III = 0   ) 					CL_EXT_INS_III = 1;
		WHEN (EXT_INS_III <= 0.5 ) 					CL_EXT_INS_III = 2;
		OTHERWISE 									CL_EXT_INS_III = 3;
	END;

	SELECT;
		WHEN (EXT_INS_III = 0   ) 					CL_SEV_INS_III = 1;
		WHEN (SEV_INS_III < 1 OR SEV_INS_III = .) 	CL_SEV_INS_III = 9;
		WHEN (SEV_INS_III < 3   ) 					CL_SEV_INS_III = 2;
		WHEN (SEV_INS_III < 5 ) 					CL_SEV_INS_III = 3;
		OTHERWISE 									CL_SEV_INS_III = 4;
	END;
	
	* * CÁLCULO DE INDICADOR CDC-AAP, CASE DEFINITIONS;
	SELECT;
		WHEN (DIE_INS < 2) 						   PERIODON_EKE = 9;
		WHEN (AL6 >= 2 AND PD5 >= 1) 			   PERIODON_EKE = 1;
		WHEN (AL4 >= 2 OR  PD5 >= 2) 			   PERIODON_EKE = 2;
		WHEN (AL3 >= 2 AND (PD4 >= 2 OR PD5 >= 1)) PERIODON_EKE = 3;
		OTHERWISE 					 			   PERIODON_EKE = 4;
	END;                                                          
	
	IF DIE_INS > 0 THEN POR_TON = AL5 / DIE_INS;
	ELSE POR_TON = 0;
	SELECT;
		WHEN (DIE_INS < 2) 	PERIODON_TON = 9; 
		WHEN (POR_TON >= 0.3) 
							PERIODON_TON = 1;
		WHEN (INC >= 2) 	PERIODON_TON = 2;
		OTHERWISE 			PERIODON_TON = 3;
	END;
	
	DROP P M I L D P2;
RUN;

