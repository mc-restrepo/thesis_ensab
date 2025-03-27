/**************************************************************************************************
* * 02MacroEstimacion.SAS
* * 
* * 
* * IV ENSAB 
* * DESCRIPCIÓN: Macro para la estimación de razones, totales y porcentajes y la estimación del
* *				 estimador de varianza considerando el diseño muestral 
* *              complejo con el que se recolecto la información
* *
* * ToDo: 
**************************************************************************************************/

/*********************************************************************************************
**	MACRO PARA ESTIMACIÓN DE RAZONES (TASAS, PROMEDIOS, PORCENTAJES)
*********************************************************************************************/

%MACRO ESTIMA_RAZON(CampoCol, CampoFil, 
					yk = uno, zk = uno, zkd = uno,
					BaseIn = Libro, BaseOut = Resultado,
					Estrato = EstratoI EstratoII EstratoIII EstratoIV EstratoV EstratoVI, 
					UM = UPM USM UTM UCM UQM UXM, 
					Diseno = DisenoI DisenoII DisenoIII DisenoIV DisenoV DisenoVI, 
					N = NI NII NIII NIV NV NVI,
					nm = nmI nmII nmIII nmIV nmV nmVI, 
					p = pI pII pIII pIV pV pVI,
					fkFinal = fkFinal,
					alphaSig = 0.05,
					useMiss = FALSE,
					verbose = FALSE);
/**************************************************************************************************
* * CALCULA ACORDE A LAS ESPECIFICACIONES DEL DISEÑO EL ESTIMADOR DE VARIANZA DEL ESTIMADOR DE
* * LA RAZÓN Y EL PROMEDIO USANDO LINEARIZACIÓN DE TAYLOR Y TODAS LAS ETAPAS Y DISEÑOS ESPECIFICADOS 
* * EN LOS ARGUMENTOS
* * 
* * ARG: 
* *   CampoCol: campo en el data set que trae la variable que define las categorías columna para el
* *             cuadro, debe ser una variable que este codificada de manera númerica, 
* *				las distribuciones  
* *   CampoFil: campo en el data set que trae la variable que define las categorías fila para el
* *             cuadro, debe ser una variable que este codificada de manera númerica
* *   yk: campo que define el numerador para el cálculo de la razón, númerica.
* *   zk: campo que define el denominador para el cálculo de la razón, númerica.
* *   zkd: campo que define el denominador para el cálculo de los porcentajes en el caso 
* *			de desagregaciones, sólo toma valores 1 o 0 
* *   BaseIn: data set con los datos de entrada, las variables fila, columna, numerador, denominador,
* *			  y variables que definen el diseño
* *	  BaseOut: data set que se crea de la macro y guarda los resultados
* *   Estrato: lista de campos en el data set, separados por espacios, que definen los estratos del 
* *			   diseño muestral de cada una de las etapas consideradas
* *   UM: lista de campos en el data set, separados por espacios, que definen los identificadores de cada
* *			   una de las etapas del diseño muestral considerado
* *   Diseno: lista de campos en el data set, separados por espacios, que definen los métodos de selección
* *			   usados en cada una de las etapas del diseño muestral considerado
* *   N: lista de campos en el data set, separados por espacios, que definen los N (total en la UM) de cada
* *			   una de las etapas del diseño muestral consideradas
* *   nm: lista de campos en el data set, separados por espacios, que definen los nm (tamaño de muestra en la UM)
* *			    de cada una de las etapas del diseño muestral consideradas 
* *   p: lista de campos en el data set, separados por espacios, que definen las probabilidades de inclusión o
* *		 selección de cada una de las etapas del diseño muestral consideradas  
* *   fkFinal: factor de expansión final a usar para el cálculo de los estimadores 
* *   alphaSig: nivel de significancia usado para el cálculo de los intervalos de confianza, por defecto se fija
* *             al 5% 
* *   useMiss: lógico, indica cuando usar o no los valores ausentes como categoría válida para el cálculo y reporte,
* *			   valor por defecto FALSE, no usar valores ausentes como válidos
* *
* * Ret: Crea el data set especificado en BaseOut con las estimaciones y estimaciones de la varianza
* *      del error
**************************************************************************************************/
	%IF &VERBOSE = FALSE %THEN %DO;
		OPTIONS NOSOURCE NONOTES;
	%END;

	* COPIA DE LA BASE INCLUYENDO LA CREACIÓN DE LA VARIABLE UNO;
	DATA DATA00; SET &BaseIn;
		UNO = 1;
		KEEP UNO &CAMPOCOL &CAMPOFIL &YK &ZK &ZKD
			&ESTRATO &UM &DISENO &N &NM &P
			&fkFinal;
	RUN;

	* CANTIDAD DE CATEGORIAS POR VARIABLES FILA, COLUMNA Y LA INTERACCION
		CREACIÓN DE DICCIONARIO CON LA CODIFICACIÓN DE VARIABLES;
	PROC SQL NOPRINT;
	CREATE TABLE _CAT AS SELECT
		&CAMPOFIL, &CAMPOCOL, COUNT(*) AS N
	FROM DATA00
	GROUP BY &CAMPOFIL, &CAMPOCOL;

	CREATE TABLE _CATF AS SELECT
		&CAMPOFIL, SUM(N) AS N
	FROM _CAT
	GROUP BY &CAMPOFIL;

	CREATE TABLE _CATC AS SELECT
		&CAMPOCOL, COUNT(*) AS N
	FROM _CAT
	GROUP BY &CAMPOCOL;

	CREATE TABLE NCAT AS 
		SELECT COUNT(*) AS NCAT, 
		count(distinct &campofil) as ncatcf, count(distinct &campocol) as ncatcc
	FROM _CAT;
	QUIT;

	DATA _CATF;
		SET _CATF;

		RETAIN ETIQUETA 0;

		%IF %UPCASE(&useMiss) = FALSE %THEN %DO;
			IF &CAMPOFIL = . OR COMPRESS(&CAMPOFIL) = '' THEN DELETE;
			ELSE ETIQUETA + 1;
		%END;	
		%ELSE %DO;
			ETIQUETA + 1;
		%END;
	RUN;

	DATA _CATC;
		SET _CATC;

		RETAIN ETIQUETA 0;

		%IF %UPCASE(&useMiss) = FALSE %THEN %DO;
			IF &CAMPOCOL = . OR COMPRESS(&CAMPOCOL) = '' THEN DELETE;
			ELSE ETIQUETA + 1;
		%END;	
		%ELSE %DO;
			ETIQUETA + 1;
		%END;
	RUN;

	PROC TRANSPOSE DATA = _CATF OUT = _CATF2 
				PREFIX = _CF_ ;
		ID ETIQUETA;
		VAR &CAMPOFIL;
	RUN;
	
	PROC SQL NOPRINT;
	SELECT TRIM(NAME) 
	INTO :DROPF SEPARATED BY ' ' 
	FROM DICTIONARY.COLUMNS
	WHERE LIBNAME='WORK' AND MEMNAME='_CATF2'
	  AND UPCASE(NAME) IN('_NAME_', '_LABEL_');
	QUIT;

	PROC TRANSPOSE DATA = _CATC OUT = _CATC2  PREFIX = _CC_;
		ID ETIQUETA;
		VAR &CAMPOCOL;
	RUN;
	
	PROC SQL NOPRINT;
	SELECT TRIM(NAME) 
	INTO :DROPC SEPARATED BY ' ' 
	FROM DICTIONARY.COLUMNS
	WHERE LIBNAME='WORK' AND MEMNAME='_CATC2'
	  AND UPCASE(NAME) IN('_NAME_', '_LABEL_');
	*QUIT;

	*PROC SQL;
	CREATE TABLE _CATFM AS SELECT 
		MAX(ETIQUETA) as ncatcf
	FROM _CATF;

	CREATE TABLE _CATCM AS SELECT 
		MAX(ETIQUETA) as NCATCC
	FROM _CATC;
	QUIT;	
	* GUARDAR LAS CANTIDADES DE CATEGORIAS EN VARIABLES MACRO PARA POSTERIOR USO;
	DATA _NULL_;
		SET NCAT;
		call symput('NCAT',trim(left(put(NCAT, 8.))));
	RUN;
	DATA _NULL_;
		SET _CATFM;
		call symput('NCATCF',trim(left(put(NCATCF + 1, 8.))));
	RUN;
	DATA _NULL_;
		SET _CATCM;
		call symput('NCATCC',trim(left(put(NCATCC + 1, 8.))));
	RUN;
	
	* CREACIÓN DE LA BASE DE INDICADORAS DE CAMPOFILA * CAMPOCOL Y DE CAMPOCOL;

	* * CREACIÓN DE VARIABLES DUMMY PONDERADAS PARA EL CASO DE RAZON Y PORCENTAJE;
	DATA DATA02;
		SET DATA00;

		IF _N_ = 1 THEN DO;
			MERGE _CATF2 (DROP = &DROPF) _CATC2 (DROP = &DROPC);
		END;
		
		UNO = 1;

		ARRAY CF {*} _CF:;
		ARRAY CC {*} _CC:;
		ARRAY INDF {&NCATCF, &NCATCC} ; *DUMMYS CRUCE FILA COLUMNA;
		ARRAY INDC {&NCATCC} ; *DUMMYS COLUMNA;
		ARRAY ZRS {&NCATCF, &NCATCC}; * DUMMYS PONDERADAS DENOMINADOR RAZON;
		ARRAY YRS {&NCATCF, &NCATCC}; * DUMMYS PONDERADAS NUMERADOR RAZON;
		ARRAY ZPS {&NCATCC}; * DUMMYS PONDERADAS DENOMINADOR PORCENTAJE;
		ARRAY YPS {&NCATCF, &NCATCC};	*DUMMYS PONDERADAS NUMERADOR PORCENTAJE;
		ARRAY P {*} &P;	* PESOS DE LAS DIFERENTES ETAPAS, REVISAR SI CAMBIA CON EL AJUSTE DE LA POSTESTRATIFICACION;

		DO J = 1 TO DIM(CC);
			DO I = 1 TO DIM(CF);
				IF &CAMPOCOL = CC[J] & &CAMPOFIL = CF[I] THEN DO; 
					INDF[I, J] = &ZKD;
					INDF[&NCATCF, J] = &ZKD;
					INDF[I, &NCATCC] = &ZKD;
				END;
				ELSE INDF[I, J] = 0;
			END;
				IF INDF[&NCATCF, J] = . THEN INDF[&NCATCF, J] = 0;
				INDC[J] = INDF[&NCATCF, J];
				IF INDF[&NCATCF, J] = 1 THEN DO;
					INDF[&NCATCF, &NCATCC] = &ZKD;
					INDC[&NCATCC] = &ZKD;
				END;
		END;

		DO I = 1 TO DIM(CF);
			IF INDF[I, &NCATCC] = . THEN INDF[I, &NCATCC] = 0;
		END;

		IF INDF[&NCATCF, &NCATCC] = . THEN INDF[&NCATCF, &NCATCC] = 0;
		IF INDC[&NCATCC] = . THEN INDC[&NCATCC] = 0;
		
		*DEFINICION DE LOS TOTALES DEL CUADRO;
		/*ZRST = 0;
		YRST = 0;

		ZPST = 0;
		YPST = 0;*/

		DO J = 1 TO &NCATCC;
			* DUMMYS DENOMINADOR PORCENTAJE;
			ZPS[J] = INDC[J] * &ZKD;
			* PONDERACION;
			*DO L = 1 TO DIM(P);
				ZPS[J] = ZPS[J] * &fkFinal;*1 / P[L];
			*END;

			*ZPST + ZPS[J];

			DO I = 1 TO &NCATCF;
				* DUMMYS DENOMINADOR NUMERADOR RAZON;
				ZRS[I, J] = INDF[I, J] * &ZK * &ZKD;
				YRS[I, J] = INDF[I, J] * &YK * &ZKD;
				
				* DUMMYS NUMERADOR PORCENTAJE;
				YPS[I, J] = INDF[I, J] * &ZKD;

				* PONDERACION DE LA DUMMY;
				*DO L = 1 TO DIM(P);

					YRS[I, J] = YRS[I, J] * &fkFinal;*1 / P[L];
					ZRS[I, J] = ZRS[I, J] * &fkFinal;*1 / P[L];	

					YPS[I, J] = YPS[I, J] * &fkFinal;*1 / P[L];
				*END;
			END;
		END;
		DROP _CF: _CC: I J;
	RUN;

	* CÁLCULO DE LOS TOTALES PONDERADOS DE LAS DUMMYS, REVISAR AJUSTE EN EL CASO DE POSTESTRATIFICACION;
	PROC SUMMARY DATA = DATA02 NOPRINT;
		VAR Z: Y:;
		OUTPUT OUT = DATA03 (DROP = _:) SUM = ;
	RUN;

	*CREACION DE UNA VARIABLE MACRO CON EL RENAME DE LOS TOTALES PARA PODER USARLOS DESPUES;
	proc sql noprint;
	SELECT TRIM(NAME) || '=' || 'T' || TRIM(NAME)
	INTO :RENAMELIST SEPARATED BY ' ' 
	FROM DICTIONARY.COLUMNS
	WHERE LIBNAME='WORK' AND MEMNAME='DATA03';
	QUIT;

	* CREACIÓN DE LAS UK PARA RAZON Y PORCENTAJES;
	DATA DATA04;
		SET DATA02;
		IF _N_ = 1 THEN SET DATA03 (RENAME = (&RENAMELIST));

		UNO = 1;
		
		ARRAY INDF {&NCATCF, &NCATCC} ; *DUMMYS CRUCE FILA COLUMNA;
		ARRAY INDC {&NCATCC} ; *DUMMYS COLUMNA;

		ARRAY ZRS {&NCATCF, &NCATCC}; * DUMMYS PONDERADAS DENOMINADOR RAZON;
		ARRAY YRS {&NCATCF, &NCATCC}; * DUMMYS PONDERADAS NUMERADOR RAZON;

		ARRAY ZPS {&NCATCC}; * DUMMYS PONDERADAS DENOMINADOR PORCENTAJE;
		ARRAY YPS {&NCATCF, &NCATCC};	*DUMMYS PONDERADAS NUMERADOR PORCENTAJE;
		*ARRAY P {*} &P;	* PESOS DE LAS DIFERENTES ETAPAS, REVISAR SI CAMBIA CON EL AJUSTE DE LA POSTESTRATIFICACION;
		
		*ARRAY TOTALES;
		ARRAY TZRS {&NCATCF, &NCATCC}; * TOTALES DENOMINADOR RAZON;
		ARRAY TYRS {&NCATCF, &NCATCC}; * TOTALES NUMERADOR RAZON;

		ARRAY TZPS {&NCATCC}; * TOTALES DENOMINADOR PORCENTAJE;
		ARRAY TYPS {&NCATCF, &NCATCC};	*TOTALES NUMERADOR PORCENTAJE;

		ARRAY CRK  {&NCATCF, &NCATCC} ; * RAZON ESTIMADA;
		ARRAY URK  {&NCATCF, &NCATCC} ; * UK PARA LA RAZON;
		*ARRAY URKC {&NCATCF, &NCATCC} ; * UK^2 PARA LA RAZON;	
		ARRAY VURK {&NCATCF, &NCATCC} ; * VARIANZA PARA LA RAZON;

		ARRAY CPK  {&NCATCF, &NCATCC} ; * PORCENTAJE ESTIMADA;
		ARRAY UPK  {&NCATCF, &NCATCC} ; * UK PARA PORCENTAJE;
		*ARRAY UPKC {&NCATCF, &NCATCC} ; * UK^2 PARA PORCENTAJE;	
		ARRAY VUPK {&NCATCF, &NCATCC} ; * VARIANZA PARA PORCENTAJE;


		DO J = 1 TO &NCATCC;
			* DUMMYS DENOMINADOR PORCENTAJE;
			ZPS[J] = INDC[J];

			DO I = 1 TO &NCATCF;
				* DUMMYS DENOMINADOR NUMERADOR RAZON;
				ZRS[I, J] = INDF[I, J] * &ZK;
				YRS[I, J] = INDF[I, J] * &YK;
				
				* DUMMYS NUMERADOR PORCENTAJE;
				YPS[I, J] = INDF[I, J];

				IF TZRS[I, J] NE 0 THEN DO; 
					CRK[I, J]  = TYRS[I, J] / TZRS[I, J];
					URK[I, J]  = (YRS[I, J] - CRK[I, J] * ZRS[I, J]) / TZRS[I, J];
					*URKC[I, J] = URK[I, J] * URK[I, J];
					VURK[I, J] = 0;
				END;
				*ELSE;
				*	CRK[I, J]  = TYRS[I, J] / TZRS[I, J];
				*	URK[I, J]  = (YRS[I, J] - CRK[I, J] * ZRS[I, J]) / TZRS[I, J];
					*URKC[I, J] = URK[I, J] * URK[I, J];
				*	VURK[I, J] = 0;
				*END;
				
				IF TZPS[J] NE 0 THEN DO;
					CPK[I, J]  = TYPS[I, J] / TZPS[J];
					UPK[I, J]  = (YPS[I, J] - CPK[I, J] * ZPS[J]) / TZPS[J];
					*UPKC[I, J] = UPK[I, J] * UPK[I, J];
					VUPK[I, J] = 0;
				END;
			END;
		END;

		DROP I J;
	RUN;

	* CUANTAS ETAPAS SE DEFINIERON;
	%LET NETAPAS = %SYSFUNC(COUNTW(&UM));

	DATA DATAE%EVAL(&NETAPAS + 1);
		SET DATA04;
	RUN;

	*VERIFICACION QUE TODAS SE ENCUENTREN BIEN DEFINIDAS;
	DATA _NULL_;
		IF &NETAPAS NE %SYSFUNC(COUNTW(&ESTRATO)) THEN 
			PUT "La cantidad de campos definidos para la estratificación no coinciden con"/ 
				"la cantidad definida para las unidades de muestreo"/
				"	ESTRATO = &ESTRATO" / 
				"	UM = &UM";
		IF &NETAPAS NE %SYSFUNC(COUNTW(&DISENO)) THEN 
			PUT "La cantidad de campos definidos para indicar el diseño no coinciden con"/ 
				"la cantidad definida para las unidades de muestreo"/
				"	DISENO = &DISENO" / 
				"	UM = &UM";
		IF &NETAPAS NE %SYSFUNC(COUNTW(&N)) THEN 
			PUT "La cantidad de campos definidos para N no coinciden con"/ 
				"la cantidad definida para las unidades de muestreo"/
				"	N = &N" / 
				"	UM = &UM";
		IF &NETAPAS NE %SYSFUNC(COUNTW(&NM)) THEN 
			PUT "La cantidad de campos definidos para nm no coinciden con"/ 
				"la cantidad definida para las unidades de muestreo"/
				"	nm = &nm" / 
				"	UM = &UM";
		IF &NETAPAS NE %SYSFUNC(COUNTW(&P)) THEN 
			PUT "La cantidad de campos definidos para P no coinciden con"/ 
				"la cantidad definida para las unidades de muestreo"/
				"	P = &P" / 
				"	UM = &UM";
	RUN;

	*INVOCACIÓN ITERATIVA PARA EL CÁLCULO DE LA VARIANZA POR ETAPAS;
	%DO ETAPAN = 1 %TO &NETAPAS;

		%LET ETAPA = %EVAL(&NETAPAS - (&ETAPAN - 1));

		* DEFINIENDO LOS CAMPOS DE LA ETAPA PARA LA CUAL SE REALIZA LA ESTIMACIÓN;
		%LET ESTRATOE 	= %SCAN(&ESTRATO, 	&ETAPA, %STR( ));
		%LET umE 		= %SCAN(&UM, 		&ETAPA, %STR( ));
		%LET disenoE 	= %SCAN(&DISENO, 	&ETAPA, %STR( ));
		%LET nE 		= %SCAN(&N, 		&ETAPA, %STR( ));
		%LET nmE 		= %SCAN(&NM, 		&ETAPA, %STR( ));
		%LET pE 		= %SCAN(&P, 		&ETAPA, %STR( ));

		*QUITANDO LOS CAMPOS DE LA ETAPA QUE SE VA A TRABAJAR;
		%LET ESTRATOC 	= ;
		%LET UMC 		= ;
		%LET DISENOC 	= ;
		%LET NC 		= ;
		%LET NMC 		= ;
		%LET PC 		= ;	

		%IF &ETAPA > 1 %THEN %DO;
			%DO ETAPC = 1 %TO %EVAL(&ETAPA - 1);
				*CREANDO COPIA DE LAS LISTAS QUE DEFINEN EL DISEÑO 
					SIN LA ETAPA DE TRABAJO ACTUAL;
				%LET ESTRATOC 	= &ESTRATOC	%STR( )	%SCAN(&ESTRATO, %EVAL(&ETAPC), %STR( ));
				%LET UMC 		= &UMC		%STR( )	%SCAN(&UM, 		%EVAL(&ETAPC), %STR( ));
				%LET DISENOC 	= &DISENOC	%STR( )	%SCAN(&DISENO, 	%EVAL(&ETAPC), %STR( ));
				%LET NC 		= &NC		%STR( )	%SCAN(&N, 		%EVAL(&ETAPC), %STR( ));
				%LET NMC 		= &NMC		%STR( )	%SCAN(&NM, 		%EVAL(&ETAPC), %STR( ));
				%LET PC 		= &PC		%STR( )	%SCAN(&P, 		%EVAL(&ETAPC), %STR( ));
			%END;
		%END;
		%LET varsKeep = &ESTRATOC %STR( ) &UMC %STR( ) &DISENOC %STR( ) &NC %STR( ) &NMC %STR( ) &PC;
		%ETAPAS_RAZON(estratoE = &estratoE, umE = &umE, disenoE = &disenoE, nE = &nE, nmE = &nmE, pE = &pE, etapa = &etapa,
						baseEntrada = DATAE%EVAL(&ETAPA + 1), baseSalida = DATAE&ETAPA, varsKeep = &varsKeep);
	%END;

	*CONSOLIDACION DE LA SALIDA;
	PROC TRANSPOSE DATA = DATAE1 OUT = DATA05;
		VAR VUP: VUR:;
	RUN;
	DATA DATA06;
		SET DATA05;
		
		STAT = SUBSTR(_NAME_, 3, 1);
		LEVELVAR = SUBSTR(_NAME_, 5, LENGTH(_NAME_) - 4);

		RENAME COL1 = VAR;
	RUN;
	DATA DATA07;
		SET DATA03;

		*ARRAY TOTALES;
		ARRAY ZRS {&NCATCF, &NCATCC}; * TOTALES DENOMINADOR RAZON;
		ARRAY YRS {&NCATCF, &NCATCC}; * TOTALES NUMERADOR RAZON;

		ARRAY ZPS {&NCATCC}; * TOTALES DENOMINADOR PORCENTAJE;
		ARRAY YPS {&NCATCF, &NCATCC};	*TOTALES NUMERADOR PORCENTAJE;

		ARRAY CRK  {&NCATCF, &NCATCC} ; * RAZON ESTIMADA;

		ARRAY CPK  {&NCATCF, &NCATCC} ; * PORCENTAJE ESTIMADA;

		DO J = 1 TO &NCATCC;
			DO I = 1 TO &NCATCF;
				*IF TRZS[I, J] NE 0 THEN; 
				IF ZRS[I, J] NE 0 THEN CRK[I, J]  = YRS[I, J] / ZRS[I, J];

				IF ZPS[J] NE 0 THEN CPK[I, J]  = YPS[I, J] / ZPS[J];
			END;
		END;

		KEEP CR: CP: YP:;
	RUN;
	PROC TRANSPOSE DATA = DATA07 OUT = DATA08;
		VAR CR: CP: YP:;
	RUN;
	DATA DATA09;
		SET DATA08;
		
		SELECT;
			WHEN (SUBSTR(_NAME_, 1, 1) = 'C') STAT = SUBSTR(_NAME_, 2, 1);
			OTHERWISE STAT = 'T';
		END;
		
		LEVELVAR = SUBSTR(_NAME_, 4, LENGTH(_NAME_) - 3);

		RENAME COL1 = VALOR;
	RUN;

	PROC SUMMARY DATA = DATA02;
		VAR INDF:;
		OUTPUT OUT = DATA13A SUM = ;
	RUN;
	PROC TRANSPOSE DATA = DATA13A OUT = DATA13B;
		VAR INDF:;
	RUN;
	DATA DATA13B;
		SET DATA13B;
		LEVELVAR = SUBSTR(_NAME_, 5, LENGTH(_NAME_) - 4);
		RENAME COL1 = N;
	RUN;
	DATA DATA10;
		RETAIN LEVELVAR 0;

		DO ETIQUETAF = 1 TO &NCATCF;
			DO ETIQUETAC = 1 TO &NCATCC;
				LEVELVAR + 1;
				OUTPUT;
			END;
		END;	
	RUN;

	PROC SQL;
	CREATE TABLE DATA11 AS SELECT
		PUT(D.LEVELVAR, 8. -L) AS LEVELVAR,
		CASE
			WHEN F.ETIQUETA NE . THEN PUT(F.&CAMPOFIL, 32. -L)
			ELSE 'T'
		END AS &CAMPOFIL, 
		CASE
			WHEN C.ETIQUETA NE . THEN PUT(C.&CAMPOCOL, 32. -L)
			ELSE 'T'
		END AS &CAMPOCOL
	FROM DATA10 D
	LEFT OUTER JOIN _CATF F 
		ON(D.ETIQUETAF = F.ETIQUETA)
	LEFT OUTER JOIN _CATC C
		ON(D.ETIQUETAC = C.ETIQUETA)
	ORDER BY LEVELVAR;
	QUIT;
	PROC SORT DATA = DATA09;BY LEVELVAR STAT;
	PROC TRANSPOSE DATA = DATA09 OUT = DATA12 (DROP = _NAME_) ;
		BY LEVELVAR;
		VAR VALOR;
		ID STAT;
	RUN;
	PROC SORT DATA = DATA06;BY LEVELVAR STAT;
	PROC TRANSPOSE DATA = DATA06 OUT = DATA13 (DROP = _NAME_) PREFIX=VAR_;
		BY LEVELVAR;
		VAR VAR;
		ID STAT;
	RUN;
	PROC SQL NOPRINT;
	SELECT TRIM(NAME)||'='||QUOTE(TRIM(LABEL))
	INTO :LABELS SEPARATED BY ' '
	FROM DICTIONARY.COLUMNS
	WHERE LIBNAME = 'WORK'
	  AND UPCASE(MEMNAME) = 'DATA00'
	  AND (UPCASE(NAME) = "%QUOTE(%UPCASE(&CAMPOCOL))" 
	   OR UPCASE(NAME) = "%QUOTE(%UPCASE(&CAMPOFIL))")
      AND LABEL NE '';

	SELECT SUM(LABEL NE '')
	INTO :NLABELS SEPARATED BY ' '
	FROM DICTIONARY.COLUMNS
	WHERE LIBNAME = 'WORK'
	  AND UPCASE(MEMNAME) = 'DATA00'
	  AND (UPCASE(NAME) = "%QUOTE(%UPCASE(&CAMPOCOL))" 
	   OR UPCASE(NAME) = "%QUOTE(%UPCASE(&CAMPOFIL))");

	*CREATE TABLE REVISION AS SELECT
		*
	FROM DICTIONARY.COLUMNS
	WHERE LIBNAME = 'WORK'
	  AND UPCASE(MEMNAME) = 'DATA00';
	QUIT;

	%IF &NLABELS > 0 %THEN %DO;
	PROC DATASETS NOLIST LIB = WORK;
		MODIFY DATA11;
		LABEL &LABELS;
	QUIT;
	%END;
	***********************************************************************************;
	OPTIONS SOURCE NOTES;
	PROC SQL;
	CREATE TABLE &BaseOut AS SELECT
		L.&CAMPOCOL, L.&CAMPOFIL,
		N.N AS N_R,
		E.T AS SUMA_PESOS, E.P, SQRT(V.VAR_P) AS P_EE, 
		SQRT(V.VAR_P) / E.P AS CVE_P,
		E.P - SQRT(V.VAR_P) * PROBIT(1 - &alphaSig /2) AS LI_P,
		E.P + SQRT(V.VAR_P) * PROBIT(1 - &alphaSig /2) AS LS_P,
		E.R AS R_ESTIMACION, SQRT(V.VAR_R) AS R_EE,
		SQRT(V.VAR_R) / E.R AS CVE_R,
		E.R - SQRT(V.VAR_R) * PROBIT(1 - &alphaSig /2) AS LI_R,
		E.R + SQRT(V.VAR_R) * PROBIT(1 - &alphaSig /2) AS LS_R
	FROM DATA13 V, DATA12 E, DATA11 L, DATA13B N
	WHERE V.LEVELVAR = E.LEVELVAR 
      AND E.LEVELVAR = L.LEVELVAR
	  AND L.LEVELVAR = N.LEVELVAR
	ORDER BY L.&CAMPOCOL, L.&CAMPOFIL;
	QUIT;

	***********************************************************************************;
	%IF &VERBOSE = FALSE %THEN %DO;
	OPTIONS NOSOURCE NONOTES;
	PROC DATASETS LIBRARY = WORK NODETAILS NOLIST;
		DELETE DATA: NCAT _CAT: _:/ GENNUM = ALL;
	RUN;
	%END;
	***********************************************************************************;
	OPTIONS SOURCE NOTES;
%MEND ESTIMA_RAZON;


/*********************************************************************************************
**	MACRO PARA ESTIMACIÓN DE TOTALES
*********************************************************************************************/

%MACRO ESTIMA_TOTALES(CampoCol, CampoFil, 
					yk = uno, zk = uno, zkd = uno,
					BaseIn = Libro, BaseOut = Resultado,
					Estrato = EstratoI EstratoII EstratoIII EstratoIV EstratoV EstratoVI, 
					UM = UPM USM UTM UCM UQM UXM, 
					Diseno = DisenoI DisenoII DisenoIII DisenoIV DisenoV DisenoVI, 
					N = NI NII NIII NIV NV NVI,
					nm = nmI nmII nmIII nmIV nmV nmVI, 
					p = pI pII pIII pIV pV pVI,
					fkFinal = fkFinal,
					alphaSig = 0.05,
					useMiss = FALSE);
/**************************************************************************************************
* * CALCULA ACORDE A LAS ESPECIFICACIONES DEL DISEÑO EL ESTIMADOR DE VARIANZA DEL ESTIMADOR DE
* * TOTAL Y PORCENTAJE USANDO LINEARIZACIÓN DE TAYLOR Y TODAS LAS ETAPAS Y DISEÑOS ESPECIFICADOS 
* * EN LOS ARGUMENTOS
* * 
* * ARG: 
* *   CampoCol: campo en el data set que trae la variable que define las categorías columna para el
* *             cuadro, debe ser una variable que este codificada de manera númerica, 
* *				las distribuciones  
* *   CampoFil: campo en el data set que trae la variable que define las categorías fila para el
* *             cuadro, debe ser una variable que este codificada de manera númerica, 
* *             y define las desagregaciones para las cuales se calculan los totales
* *   yk: campo que define el total que se va a calcular, númerica.
* *   zk: campo que define las categorías para las cuales se calculan los totales, 
* *					númerica.
* *   zkd: campo que define el denominador para el cálculo de los porcentajes en el caso 
* *			de desagregaciones, sólo toma valores 1 o 0
* *   BaseIn: data set con los datos de entrada, las variables fila, columna, numerador, denominador,
* *			  y variables que definen el diseño
* *	  BaseOut: data set que se crea de la macro y guarda los resultados
* *   Estrato: lista de campos en el data set, separados por espacios, que definen los estratos del 
* *			   diseño muestral de cada una de las etapas consideradas
* *   UM: lista de campos en el data set, separados por espacios, que definen los identificadores de cada
* *			   una de las etapas del diseño muestral considerado
* *   Diseno: lista de campos en el data set, separados por espacios, que definen los métodos de selección
* *			   usados en cada una de las etapas del diseño muestral considerado
* *   N: lista de campos en el data set, separados por espacios, que definen los N (total en la UM) de cada
* *			   una de las etapas del diseño muestral consideradas
* *   nm: lista de campos en el data set, separados por espacios, que definen los nm (tamaño de muestra en la UM)
* *			    de cada una de las etapas del diseño muestral consideradas 
* *   p: lista de campos en el data set, separados por espacios, que definen las probabilidades de inclusión o
* *		 selección de cada una de las etapas del diseño muestral consideradas  
* *   fkFinal: factor de expansión final a usar para el cálculo de los estimadores 
* *   alphaSig: nivel de significancia usado para el cálculo de los intervalos de confianza, por defecto se fija
* *             al 5% 
* *   useMiss: lógico, indica cuando usar o no los valores ausentes como categoría válida para el cálculo y reporte,
* *			   valor por defecto FALSE, no usar valores ausentes como válidos
* *
* * Ret: Crea el data set especificado en BaseOut con las estimaciones y estimaciones de la varianza
* *      del error
**************************************************************************************************/

	
	OPTIONS NOSOURCE NONOTES;

	* COPIA DE LA BASE INCLUYENDO LA CREACIÓN DE LA VARIABLE UNO;
	DATA DATA00; SET &BaseIn;
		UNO = 1;
		KEEP UNO &CAMPOCOL &CAMPOFIL &YK &ZK 
			&ESTRATO &UM &DISENO &N &NM &P &ZKD
			&fkFinal;
	RUN;

	* CANTIDAD DE CATEGORIAS POR VARIABLES FILA, COLUMNA Y LA INTERACCION
		CREACIÓN DE DICCIONARIO CON LA CODIFICACIÓN DE VARIABLES;
	PROC SQL NOPRINT;
	CREATE TABLE _CAT AS SELECT
		&CAMPOFIL, &CAMPOCOL, COUNT(*) AS N
	FROM DATA00
	GROUP BY &CAMPOFIL, &CAMPOCOL;

	CREATE TABLE _CATF AS SELECT
		&CAMPOFIL, SUM(N) AS N
	FROM _CAT
	GROUP BY &CAMPOFIL;

	CREATE TABLE _CATC AS SELECT
		&CAMPOCOL, COUNT(*) AS N
	FROM _CAT
	GROUP BY &CAMPOCOL;

	CREATE TABLE NCAT AS 
		SELECT COUNT(*) AS NCAT, 
		count(distinct &campofil) as ncatcf, count(distinct &campocol) as ncatcc
	FROM _CAT;
	QUIT;

	DATA _CATF;
		SET _CATF;

		RETAIN ETIQUETA 0;

		%IF %UPCASE(&useMiss) = FALSE %THEN %DO;
			IF &CAMPOFIL = . OR COMPRESS(&CAMPOFIL) = '' THEN DELETE;
			ELSE ETIQUETA + 1;
		%END;	
		%ELSE %DO;
			ETIQUETA + 1;
		%END;
	RUN;

	DATA _CATC;
		SET _CATC;

		RETAIN ETIQUETA 0;

		%IF %UPCASE(&useMiss) = FALSE %THEN %DO;
			IF &CAMPOCOL = . OR COMPRESS(&CAMPOCOL) = '' THEN DELETE;
			ELSE ETIQUETA + 1;
		%END;	
		%ELSE %DO;
			ETIQUETA + 1;
		%END;
	RUN;

	PROC TRANSPOSE DATA = _CATF OUT = _CATF2 
				PREFIX = _CF_ ;
		ID ETIQUETA;
		VAR &CAMPOFIL;
	RUN;
	
	PROC SQL NOPRINT;
	SELECT TRIM(NAME) 
	INTO :DROPF SEPARATED BY ' ' 
	FROM DICTIONARY.COLUMNS
	WHERE LIBNAME='WORK' AND MEMNAME='_CATF2'
	  AND UPCASE(NAME) IN('_NAME_', '_LABEL_');
	QUIT;

	PROC TRANSPOSE DATA = _CATC OUT = _CATC2  PREFIX = _CC_;
		ID ETIQUETA;
		VAR &CAMPOCOL;
	RUN;
	
	PROC SQL NOPRINT;
	SELECT TRIM(NAME) 
	INTO :DROPC SEPARATED BY ' ' 
	FROM DICTIONARY.COLUMNS
	WHERE LIBNAME='WORK' AND MEMNAME='_CATC2'
	  AND UPCASE(NAME) IN('_NAME_', '_LABEL_');
	*QUIT;

	*PROC SQL;
	CREATE TABLE _CATFM AS SELECT 
		MAX(ETIQUETA) as ncatcf
	FROM _CATF;

	CREATE TABLE _CATCM AS SELECT 
		MAX(ETIQUETA) as NCATCC
	FROM _CATC;
	QUIT;	
	* GUARDAR LAS CANTIDADES DE CATEGORIAS EN VARIABLES MACRO PARA POSTERIOR USO;
	DATA _NULL_;
		SET NCAT;
		call symput('NCAT',trim(left(put(NCAT, 8.))));
	RUN;
	DATA _NULL_;
		SET _CATFM;
		call symput('NCATCF',trim(left(put(NCATCF + 1, 8.))));
	RUN;
	DATA _NULL_;
		SET _CATCM;
		call symput('NCATCC',trim(left(put(NCATCC + 1, 8.))));
	RUN;
	
	* CREACIÓN DE LA BASE DE INDICADORAS DE CAMPOFILA * CAMPOCOL Y DE CAMPOCOL;

	* * CREACIÓN DE VARIABLES DUMMY PONDERADAS PARA EL CASO DE RAZON Y PORCENTAJE;
	DATA DATA02;
		SET DATA00;

		IF _N_ = 1 THEN DO;
			MERGE _CATF2 (DROP = &DROPF) _CATC2 (DROP = &DROPC);
		END;
		
		UNO = 1;

		ARRAY CF {*} _CF:;
		ARRAY CC {*} _CC:;
		ARRAY INDF {&NCATCF, &NCATCC} ; *DUMMYS CRUCE FILA COLUMNA;
		ARRAY INDC {&NCATCC} ; *DUMMYS COLUMNA;
		*ARRAY ZRS {&NCATCF, &NCATCC}; * DUMMYS PONDERADAS DENOMINADOR RAZON;
		ARRAY YRS {&NCATCF, &NCATCC}; * DUMMYS PONDERADAS NUMERADOR RAZON;
		ARRAY ZPS {&NCATCC}; * DUMMYS PONDERADAS DENOMINADOR PORCENTAJE;
		ARRAY YPS {&NCATCF, &NCATCC};	*DUMMYS PONDERADAS NUMERADOR PORCENTAJE;
		ARRAY P {*} &P;	* PESOS DE LAS DIFERENTES ETAPAS, REVISAR SI CAMBIA CON EL AJUSTE DE LA POSTESTRATIFICACION;
		
		DO J = 1 TO DIM(CC);
			DO I = 1 TO DIM(CF);
				IF &CAMPOCOL = CC[J] & &CAMPOFIL = CF[I] THEN DO; 
					INDF[I, J] = &ZKD;
					INDF[&NCATCF, J] = &ZKD;
					INDF[I, &NCATCC] = &ZKD;
				END;
				ELSE INDF[I, J] = 0;
			END;
				IF INDF[&NCATCF, J] = . THEN INDF[&NCATCF, J] = 0;
				INDC[J] = INDF[&NCATCF, J];
				IF INDF[&NCATCF, J] = 1 THEN DO;
					INDF[&NCATCF, &NCATCC] = &ZKD;
					INDC[&NCATCC] = &ZKD;
				END;
		END;

		DO I = 1 TO DIM(CF);
			IF INDF[I, &NCATCC] = . THEN INDF[I, &NCATCC] = 0;
		END;

		IF INDF[&NCATCF, &NCATCC] = . THEN INDF[&NCATCF, &NCATCC] = 0;
		IF INDC[&NCATCC] = . THEN INDC[&NCATCC] = 0;
	
		*DEFINICION DE LOS TOTALES DEL CUADRO;
		/*ZRST = 0;
		YRST = 0;

		ZPST = 0;
		YPST = 0;*/

		DO J = 1 TO &NCATCC;
			* DUMMYS DENOMINADOR PORCENTAJE;
			ZPS[J] = INDC[J] * &ZKD;
			* PONDERACION;
			*DO L = 1 TO DIM(P);
				ZPS[J] = ZPS[J] * &fkFinal * &ZKD;*1 / P[L];
			*END;

			*ZPST + ZPS[J];

			DO I = 1 TO &NCATCF;
				* DUMMYS DENOMINADOR NUMERADOR RAZON;
				*ZRS[I, J] = INDF[I, J] * &ZK;
				YRS[I, J] = INDF[I, J] * &YK * &ZKD;
				
				* DUMMYS NUMERADOR PORCENTAJE;
				YPS[I, J] = INDF[I, J] * &ZKD;

				* PONDERACION DE LA DUMMY;
				*DO L = 1 TO DIM(P);

					YRS[I, J] = YRS[I, J] * &fkFinal;*1 / P[L];
					*ZRS[I, J] = ZRS[I, J] * &fkFinal;*1 / P[L];	

					YPS[I, J] = YPS[I, J] * &fkFinal;*1 / P[L];
				*END;
			END;
		END;

		DROP _CF: _CC: I J;
	RUN;

	* CÁLCULO DE LOS TOTALES PONDERADOS DE LAS DUMMYS, REVISAR AJUSTE EN EL CASO DE POSTESTRATIFICACION;
	PROC SUMMARY DATA = DATA02 NOPRINT;
		VAR Z: Y:;
		OUTPUT OUT = DATA03 (DROP = _:) SUM = ;
	RUN;

	*CREACION DE UNA VARIABLE MACRO CON EL RENAME DE LOS TOTALES PARA PODER USARLOS DESPUES;
	proc sql noprint;
	SELECT TRIM(NAME) || '=' || 'T' || TRIM(NAME)
	INTO :RENAMELIST SEPARATED BY ' ' 
	FROM DICTIONARY.COLUMNS
	WHERE LIBNAME='WORK' AND MEMNAME='DATA03';
	QUIT;

	* CREACIÓN DE LAS UK PARA RAZON Y PORCENTAJES;
	DATA DATA04;
		SET DATA02;
		IF _N_ = 1 THEN SET DATA03 (RENAME = (&RENAMELIST));

		UNO = 1;
		
		ARRAY INDF {&NCATCF, &NCATCC} ; *DUMMYS CRUCE FILA COLUMNA;
		ARRAY INDC {&NCATCC} ; *DUMMYS COLUMNA;

		*ARRAY ZRS {&NCATCF, &NCATCC}; * DUMMYS PONDERADAS DENOMINADOR RAZON;
		ARRAY YRS {&NCATCF, &NCATCC}; * DUMMYS PONDERADAS NUMERADOR RAZON;

		ARRAY ZPS {&NCATCC}; * DUMMYS PONDERADAS DENOMINADOR PORCENTAJE;
		ARRAY YPS {&NCATCF, &NCATCC};	*DUMMYS PONDERADAS NUMERADOR PORCENTAJE;
		*ARRAY P {*} &P;	* PESOS DE LAS DIFERENTES ETAPAS, REVISAR SI CAMBIA CON EL AJUSTE DE LA POSTESTRATIFICACION;
		
		*ARRAY TOTALES;
		*ARRAY TZRS {&NCATCF, &NCATCC}; * TOTALES DENOMINADOR RAZON;
		ARRAY TYRS {&NCATCF, &NCATCC}; * TOTALES NUMERADOR RAZON;

		ARRAY TZPS {&NCATCC}; * TOTALES DENOMINADOR PORCENTAJE;
		ARRAY TYPS {&NCATCF, &NCATCC};	*TOTALES NUMERADOR PORCENTAJE;

		ARRAY CRK  {&NCATCF, &NCATCC} ; * RAZON ESTIMADA;
		ARRAY URK  {&NCATCF, &NCATCC} ; * UK PARA LA RAZON;
		*ARRAY URKC {&NCATCF, &NCATCC} ; * UK^2 PARA LA RAZON;	
		ARRAY VURK {&NCATCF, &NCATCC} ; * VARIANZA PARA LA RAZON;

		ARRAY CPK  {&NCATCF, &NCATCC} ; * PORCENTAJE ESTIMADA;
		ARRAY UPK  {&NCATCF, &NCATCC} ; * UK PARA PORCENTAJE;
		*ARRAY UPKC {&NCATCF, &NCATCC} ; * UK^2 PARA PORCENTAJE;	
		ARRAY VUPK {&NCATCF, &NCATCC} ; * VARIANZA PARA PORCENTAJE;


		DO J = 1 TO &NCATCC;
			* DUMMYS DENOMINADOR PORCENTAJE;
			ZPS[J] = INDC[J];

			DO I = 1 TO &NCATCF;
				* DUMMYS DENOMINADOR NUMERADOR RAZON;
				*ZRS[I, J] = INDF[I, J] * &ZK;
				YRS[I, J] = INDF[I, J] * &YK;
				
				* DUMMYS NUMERADOR PORCENTAJE;
				YPS[I, J] = INDF[I, J];

				*IF TRZS[I, J] NE 0 THEN; 
				CRK[I, J]  = TYRS[I, J];* / TZRS[I, J];
				URK[I, J]  = (YRS[I, J]); * - CRK[I, J] * ZRS[I, J]) / TZRS[I, J];
				*URKC[I, J] = URK[I, J] * URK[I, J];
				VURK[I, J] = 0;

				CPK[I, J]  = TYPS[I, J] / TZPS[J];
				UPK[I, J]  = (YPS[I, J] - CPK[I, J] * ZPS[J]) / TZPS[J];
				*UPKC[I, J] = UPK[I, J] * UPK[I, J];
				VUPK[I, J] = 0;
			END;
		END;

		DROP I J;
	RUN;

	* CUANTAS ETAPAS SE DEFINIERON;
	%LET NETAPAS = %SYSFUNC(COUNTW(&UM));

	DATA DATAE%EVAL(&NETAPAS + 1);
		SET DATA04;
	RUN;

	*VERIFICACION QUE TODAS SE ENCUENTREN BIEN DEFINIDAS;
	DATA _NULL_;
		IF &NETAPAS NE %SYSFUNC(COUNTW(&ESTRATO)) THEN 
			PUT "La cantidad de campos definidos para la estratificación no coinciden con"/ 
				"la cantidad definida para las unidades de muestreo"/
				"	ESTRATO = &ESTRATO" / 
				"	UM = &UM";
		IF &NETAPAS NE %SYSFUNC(COUNTW(&DISENO)) THEN 
			PUT "La cantidad de campos definidos para indicar el diseño no coinciden con"/ 
				"la cantidad definida para las unidades de muestreo"/
				"	DISENO = &DISENO" / 
				"	UM = &UM";
		IF &NETAPAS NE %SYSFUNC(COUNTW(&N)) THEN 
			PUT "La cantidad de campos definidos para N no coinciden con"/ 
				"la cantidad definida para las unidades de muestreo"/
				"	N = &N" / 
				"	UM = &UM";
		IF &NETAPAS NE %SYSFUNC(COUNTW(&NM)) THEN 
			PUT "La cantidad de campos definidos para nm no coinciden con"/ 
				"la cantidad definida para las unidades de muestreo"/
				"	nm = &nm" / 
				"	UM = &UM";
		IF &NETAPAS NE %SYSFUNC(COUNTW(&P)) THEN 
			PUT "La cantidad de campos definidos para P no coinciden con"/ 
				"la cantidad definida para las unidades de muestreo"/
				"	P = &P" / 
				"	UM = &UM";
	RUN;

	*INVOCACIÓN ITERATIVA PARA EL CÁLCULO DE LA VARIANZA POR ETAPAS;
	%DO ETAPAN = 1 %TO &NETAPAS;

		%LET ETAPA = %EVAL(&NETAPAS - (&ETAPAN - 1));

		* DEFINIENDO LOS CAMPOS DE LA ETAPA PARA LA CUAL SE REALIZA LA ESTIMACIÓN;
		%LET ESTRATOE 	= %SCAN(&ESTRATO, 	&ETAPA, %STR( ));
		%LET umE 		= %SCAN(&UM, 		&ETAPA, %STR( ));
		%LET disenoE 	= %SCAN(&DISENO, 	&ETAPA, %STR( ));
		%LET nE 		= %SCAN(&N, 		&ETAPA, %STR( ));
		%LET nmE 		= %SCAN(&NM, 		&ETAPA, %STR( ));
		%LET pE 		= %SCAN(&P, 		&ETAPA, %STR( ));

		*QUITANDO LOS CAMPOS DE LA ETAPA QUE SE VA A TRABAJAR;
		%LET ESTRATOC 	= ;
		%LET UMC 		= ;
		%LET DISENOC 	= ;
		%LET NC 		= ;
		%LET NMC 		= ;
		%LET PC 		= ;	

		%IF &ETAPA > 1 %THEN %DO;
			%DO ETAPC = 1 %TO %EVAL(&ETAPA - 1);
				*CREANDO COPIA DE LAS LISTAS QUE DEFINEN EL DISEÑO 
					SIN LA ETAPA DE TRABAJO ACTUAL;
				%LET ESTRATOC 	= &ESTRATOC	%STR( )	%SCAN(&ESTRATO, %EVAL(&ETAPC), %STR( ));
				%LET UMC 		= &UMC		%STR( )	%SCAN(&UM, 		%EVAL(&ETAPC), %STR( ));
				%LET DISENOC 	= &DISENOC	%STR( )	%SCAN(&DISENO, 	%EVAL(&ETAPC), %STR( ));
				%LET NC 		= &NC		%STR( )	%SCAN(&N, 		%EVAL(&ETAPC), %STR( ));
				%LET NMC 		= &NMC		%STR( )	%SCAN(&NM, 		%EVAL(&ETAPC), %STR( ));
				%LET PC 		= &PC		%STR( )	%SCAN(&P, 		%EVAL(&ETAPC), %STR( ));
			%END;
		%END;
		%LET varsKeep = &ESTRATOC %STR( ) &UMC %STR( ) &DISENOC %STR( ) &NC %STR( ) &NMC %STR( ) &PC;
		%ETAPAS_RAZON(estratoE = &estratoE, umE = &umE, disenoE = &disenoE, nE = &nE, nmE = &nmE, pE = &pE, etapa = &etapa,
						baseEntrada = DATAE%EVAL(&ETAPA + 1), baseSalida = DATAE&ETAPA, varsKeep = &varsKeep);
	%END;

	*CONSOLIDACION DE LA SALIDA;
	PROC TRANSPOSE DATA = DATAE1 OUT = DATA05;
		VAR VUP: VUR:;
	RUN;
	DATA DATA06;
		SET DATA05;
		
		STAT = SUBSTR(_NAME_, 3, 1);
		LEVELVAR = SUBSTR(_NAME_, 5, LENGTH(_NAME_) - 4);

		RENAME COL1 = VAR;
	RUN;
	DATA DATA07;
		SET DATA03;

		*ARRAY TOTALES;
		*ARRAY ZRS {&NCATCF, &NCATCC}; * TOTALES DENOMINADOR RAZON;
		ARRAY YRS {&NCATCF, &NCATCC}; * TOTALES NUMERADOR RAZON;

		ARRAY ZPS {&NCATCC}; * TOTALES DENOMINADOR PORCENTAJE;
		ARRAY YPS {&NCATCF, &NCATCC};	*TOTALES NUMERADOR PORCENTAJE;

		ARRAY CRK  {&NCATCF, &NCATCC} ; * RAZON ESTIMADA;

		ARRAY CPK  {&NCATCF, &NCATCC} ; * PORCENTAJE ESTIMADA;

		DO J = 1 TO &NCATCC;
			DO I = 1 TO &NCATCF;
				*IF TRZS[I, J] NE 0 THEN; 
				CRK[I, J]  = YRS[I, J]; */ ZRS[I, J];

				CPK[I, J]  = YPS[I, J] / ZPS[J];
			END;
		END;

		KEEP CR: CP: YP:;
	RUN;
	PROC TRANSPOSE DATA = DATA07 OUT = DATA08;
		VAR CR: CP: YP:;
	RUN;
	DATA DATA09;
		SET DATA08;
		
		SELECT;
			WHEN (SUBSTR(_NAME_, 1, 1) = 'C') STAT = SUBSTR(_NAME_, 2, 1);
			OTHERWISE STAT = 'T';
		END;
		
		LEVELVAR = SUBSTR(_NAME_, 4, LENGTH(_NAME_) - 3);

		RENAME COL1 = VALOR;
	RUN;

	PROC SUMMARY DATA = DATA02;
		VAR INDF:;
		OUTPUT OUT = DATA13A SUM = ;
	RUN;
	PROC TRANSPOSE DATA = DATA13A OUT = DATA13B;
		VAR INDF:;
	RUN;
	DATA DATA13B;
		SET DATA13B;
		LEVELVAR = SUBSTR(_NAME_, 5, LENGTH(_NAME_) - 4);
		RENAME COL1 = N;
	RUN;
	DATA DATA10;
		RETAIN LEVELVAR 0;

		DO ETIQUETAF = 1 TO &NCATCF;
			DO ETIQUETAC = 1 TO &NCATCC;
				LEVELVAR + 1;
				OUTPUT;
			END;
		END;	
	RUN;

	PROC SQL;
	CREATE TABLE DATA11 AS SELECT
		PUT(D.LEVELVAR, 8. -L) AS LEVELVAR,
		CASE
			WHEN F.ETIQUETA NE . THEN PUT(F.&CAMPOFIL, 32. -L)
			ELSE 'T'
		END AS &CAMPOFIL, 
		CASE
			WHEN C.ETIQUETA NE . THEN PUT(C.&CAMPOCOL, 32. -L)
			ELSE 'T'
		END AS &CAMPOCOL
	FROM DATA10 D
	LEFT OUTER JOIN _CATF F 
		ON(D.ETIQUETAF = F.ETIQUETA)
	LEFT OUTER JOIN _CATC C
		ON(D.ETIQUETAC = C.ETIQUETA)
	ORDER BY LEVELVAR;
	QUIT;

	PROC SORT DATA = DATA09;BY LEVELVAR STAT;
	PROC TRANSPOSE DATA = DATA09 OUT = DATA12 (DROP = _NAME_) ;
		BY LEVELVAR;
		VAR VALOR;
		ID STAT;
	RUN;
	PROC SORT DATA = DATA06;BY LEVELVAR STAT;
	PROC TRANSPOSE DATA = DATA06 OUT = DATA13 (DROP = _NAME_) PREFIX=VAR_;
		BY LEVELVAR;
		VAR VAR;
		ID STAT;
	RUN;
    
	
	PROC SQL NOPRINT;
	SELECT TRIM(NAME)||'='||QUOTE(TRIM(LABEL))
	INTO :LABELS SEPARATED BY ' '
	FROM DICTIONARY.COLUMNS
	WHERE LIBNAME = 'WORK'
	  AND UPCASE(MEMNAME) = 'DATA00'
	  AND (UPCASE(NAME) = "%QUOTE(%UPCASE(&CAMPOCOL))" 
	   OR UPCASE(NAME) = "%QUOTE(%UPCASE(&CAMPOFIL))");
 *     AND LABEL NE '';

	SELECT SUM(LABEL NE '')
	INTO :NLABELS SEPARATED BY ' '
	FROM DICTIONARY.COLUMNS
	WHERE LIBNAME = 'WORK'
	  AND UPCASE(MEMNAME) = 'DATA00'
	  AND (UPCASE(NAME) = "%QUOTE(%UPCASE(&CAMPOCOL))" 
	   OR UPCASE(NAME) = "%QUOTE(%UPCASE(&CAMPOFIL))");

	*CREATE TABLE REVISION AS SELECT
		*
	FROM DICTIONARY.COLUMNS
	WHERE LIBNAME = 'WORK'
	  AND UPCASE(MEMNAME) = 'DATA00';
	QUIT;

	%IF &NLABELS > 0 %THEN %DO;
	PROC DATASETS NOLIST LIB = WORK;
		MODIFY DATA11;
		LABEL &LABELS;
	QUIT;
	%END;
	***********************************************************************************;
	OPTIONS SOURCE NOTES;
	PROC SQL;
	CREATE TABLE &BaseOut AS SELECT
		L.&CAMPOCOL, L.&CAMPOFIL,
		N.N AS N_R,
		E.T AS SUMA_PESOS, E.P, SQRT(V.VAR_P) AS P_EE, 
		SQRT(V.VAR_P) / E.P AS CVE_P,
		E.P - SQRT(V.VAR_P) * PROBIT(1 - &alphaSig /2) AS LI_P,
		E.P + SQRT(V.VAR_P) * PROBIT(1 - &alphaSig /2) AS LS_P,
		E.R AS T_ESTIMACION, SQRT(V.VAR_R) AS T_EE,
		SQRT(V.VAR_R) / E.R AS CVE_R,
		E.R - SQRT(V.VAR_R) * PROBIT(1 - &alphaSig /2) AS LI_R,
		E.R + SQRT(V.VAR_R) * PROBIT(1 - &alphaSig /2) AS LS_R
	FROM DATA13 V, DATA12 E, DATA11 L, DATA13B N
	WHERE V.LEVELVAR = E.LEVELVAR 
      AND E.LEVELVAR = L.LEVELVAR
	  AND L.LEVELVAR = N.LEVELVAR
	ORDER BY L.&CAMPOCOL, L.&CAMPOFIL;
	QUIT;

	***********************************************************************************;
	OPTIONS NOSOURCE NONOTES;
	PROC DATASETS LIBRARY = WORK NODETAILS NOLIST;
		DELETE DATA: NCAT _CAT: _:/ GENNUM = ALL;
	RUN;
	***********************************************************************************;
	OPTIONS SOURCE NOTES;	
%MEND ESTIMA_TOTALES;


/*********************************************************************************************
**	MACRO PARA LA ESTIMACIÓN DE ETAPAS
*********************************************************************************************/


%MACRO ETAPAS_RAZON(estratoE, umE, disenoE, nE, nmE, pE, etapa,
				baseEntrada, baseSalida, varsKeep);
/**************************************************************************************************
* * CALCULA LAS ESTIMACIONES DE VARIANZA ACORDE AL DISEÑO, REQUIERE COMO ENTRADA LA SALIDA UN DATA 
* * SET DE ESTA MISMA MACRO, ES UN PROCESAMIENTO ITERACTIVO SECUENCIAL 
* * EN LOS ARGUMENTOS
* * 
* * ARG: 
* *   estratoE: lista de campos en el data set, separados por espacios, que definen los estratos del 
* *			   diseño muestral de cada una de las etapas consideradas hasta la etapa que se esta procesando
* *   umE: lista de campos en el data set, separados por espacios, que definen los identificadores de cada
* *			   una de las etapas del diseño muestral considerado  hasta la etapa que se esta procesando
* *   disenoE: lista de campos en el data set, separados por espacios, que definen los métodos de selección
* *			   usados en cada una de las etapas del diseño muestral considerado  hasta la etapa que se esta procesando
* *   NE: lista de campos en el data set, separados por espacios, que definen los N (total en la UM) de cada
* *			   una de las etapas del diseño muestral consideradas  hasta la etapa que se esta procesando
* *   nmE: lista de campos en el data set, separados por espacios, que definen los nm (tamaño de muestra en la UM)
* *			    de cada una de las etapas del diseño muestral consideradas  hasta la etapa que se esta procesando 
* *   pE: lista de campos en el data set, separados por espacios, que definen las probabilidades de inclusión o
* *		 selección de cada una de las etapas del diseño muestral consideradas  hasta la etapa que se esta procesando  
* *   etapa: número de la etapa que se esta procesando para marcar el archivo de salida
* *   BaseEntrada: data set con los datos de entrada, las variables fila, columna, numerador, denominador,
* *			  y variables que definen el diseño
* *	  BaseSalida: data set que se crea de la macro y guarda los resultados
* *
* * Ret: Crea el data set especificado en BaseOut con las estimaciones y estimaciones de la varianza
* *      del estimador
**************************************************************************************************/
	*CONSTRUCCIÓN DE LAS UK PARA PORCENTAJE Y PROMEDIO;
	DATA DATAV00;
		SET &BASEENTRADA;

		ARRAY URK  {&NCATCF, &NCATCC} ; * UK PARA LA RAZON;
		ARRAY URKC {&NCATCF, &NCATCC} ; * UK^2 PARA LA RAZON;	
		ARRAY VURK {&NCATCF, &NCATCC} ; * VARIANZA ETAPAS ANTERIORES PARA LA RAZON;
		ARRAY URKD {&NCATCF, &NCATCC} ; * UK PARA S^2 PARA LA RAZON;

		ARRAY UPK  {&NCATCF, &NCATCC} ; * UK PARA PORCENTAJE;
		ARRAY UPKC {&NCATCF, &NCATCC} ; * UK^2 PARA PORCENTAJE;	
		ARRAY VUPK {&NCATCF, &NCATCC} ; * VARIANZA ETAPAS ANTERIORES PARA PORCENTAJE;
		ARRAY UPKD {&NCATCF, &NCATCC} ; * UK PARA S^2 PORCENTAJE;


		DO J = 1 TO &NCATCC;
			DO I = 1 TO &NCATCF;
				IF &DISENOE = 'PPT' THEN DO;
					*RAZÓN;
					URKD[I, J] = URK[I, J]  * 1 / &PE;
					URKC[I, J] = URKD[I, J] * URKD[I, J];
					URK[I, J]  = URK[I, J]  * 1 / &PE;
					VURK[I, J] = VURK[I, J] * 1 / &PE;
					*PORCENTAJE;
					UPKD[I, J] = UPK[I, J]  * 1 / &PE;
					UPKC[I, J] = UPKD[I, J] * UPKD[I, J];
					UPK[I, J]  = UPK[I, J]  * 1 / &PE;
					VUPK[I, J] = VUPK[I, J] * 1 / &PE;
				END;
				IF &DISENOE = 'MAS' THEN DO;
					*RAZÓN;
					URKD[I, J] = URK[I, J];
					URKC[I, J] = URK[I, J] * URK[I, J];
					URK[I, J]  = URK[I, J]  * 1 / &PE;
					VURK[I, J] = VURK[I, J] * 1 / &PE;
					*PORCENTAJE;
					UPKD[I, J] = UPK[I, J];
					UPKC[I, J] = UPK[I, J] * UPK[I, J];
					UPK[I, J]  = UPK[I, J]  * 1 / &PE;
					VUPK[I, J] = VUPK[I, J] * 1 / &PE;
				END;
				IF &DISENOE = 'BER' THEN DO;
					*RAZÓN;
					URKD[I, J] = URK[I, J];
					URKC[I, J] = URK[I, J] * URK[I, J];
					URK[I, J]  = URK[I, J]  * 1 / &PE;
					VURK[I, J] = VURK[I, J] * 1 / &PE;
					*PORCENTAJE;
					UPKD[I, J] = UPK[I, J];
					UPKC[I, J] = UPK[I, J] * UPK[I, J];
					UPK[I, J]  = UPK[I, J]  * 1 / &PE;
					VUPK[I, J] = VUPK[I, J] * 1 / &PE;
				END;
			END;
		END;	

	RUN;
	*SUMAR POR ESTRATOS DE LA ETAPA;
	PROC SORT DATA = DATAV00;BY &ESTRATOC &UMC &DISENOC &NC &NMC &PC &ESTRATOE &DISENOE;
	PROC SUMMARY DATA = DATAV00 NOPRINT;
		BY &ESTRATOC &UMC &DISENOC &NC &NMC &PC &ESTRATOE &DISENOE;
		VAR UR: VUR: UP: VUP:;
		ID &NE &NME &PE;
		OUTPUT OUT = DATAV01 (DROP = _:) SUM = ;
	RUN;
	*CALCULOS DENTRO DEL ESTRATO;
	DATA DATAV02;
		SET DATAV01;

		ARRAY URK  {&NCATCF, &NCATCC} ; * UK PARA LA RAZON;
		ARRAY URKC {&NCATCF, &NCATCC} ; * UK^2 PARA LA RAZON;	
		ARRAY SURK {&NCATCF, &NCATCC} ; * S^2_{U_K} PARA LA RAZON;
		ARRAY VURK {&NCATCF, &NCATCC} ; * VARIANZA ETAPAS ANTERIORES PARA LA RAZON;
		ARRAY URKD {&NCATCF, &NCATCC} ; * UK PARA S^2 PARA LA RAZON;

		ARRAY UPK  {&NCATCF, &NCATCC} ; * UK PARA PORCENTAJE;
		ARRAY UPKC {&NCATCF, &NCATCC} ; * UK^2 PARA PORCENTAJE;	
		ARRAY SUPK {&NCATCF, &NCATCC} ; * S^2_{U_K} PARA PORCENTAJE;
		ARRAY VUPK {&NCATCF, &NCATCC} ; * VARIANZA ETAPAS ANTERIORES PARA PORCENTAJE;
		ARRAY UPKD {&NCATCF, &NCATCC} ; * UK PARA S^2 PORCENTAJE;


		DO J = 1 TO &NCATCC;
			DO I = 1 TO &NCATCF;
				IF &DISENOE = 'PPT' THEN DO;
					*RAZÓN;
					IF &NME > 1 THEN SURK[I, J] = (URKC[I, J] - (URKD[I, J] ** 2) / &NME) / (&NME * (&NME - 1));
					ELSE SURK[I, J] = 0;
					VURK[I, J] = SURK[I, J];

					*PORCENTAJE;
					IF &NME > 1 THEN SUPK[I, J] = (UPKC[I, J] - (UPKD[I, J] ** 2) / &NME) / (&NME * (&NME - 1));
					ELSE SUPK[I, J] = 0;
					VUPK[I, J] = SUPK[I, J];
				END;
				IF &DISENOE = 'MAS' THEN DO;
					*RAZÓN; *REVISAR NM - 1;
					FACVAR = &NE ** 2 * (1 - &NME / &NE) / &NME;
					IF &NME > 1 THEN SURK[I, J] = (URKC[I, J] - (URKD[I, J] ** 2) / &NME) / (&NME - 1);
					ELSE SURK[I, J] = 0;
					VURK[I, J] = VURK[I, J] + FACVAR * SURK[I, J];	

					*PORCENTAJE;
					IF &NME > 1 THEN SUPK[I, J] = (UPKC[I, J] - (UPKD[I, J] ** 2) / &NME) / (&NME - 1);
					ELSE SUPK[I, J] = 0;
					VUPK[I, J] = VUPK[I, J] + FACVAR * SUPK[I, J];	
				END;
				IF &DISENOE = 'BER' THEN DO;
					*RAZÓN;
					SURK[I, J] = (1 / &PE) * (1 / &PE - 1) * URKC[I, J];
					VURK[I, J] = VURK[I, J] + SURK[I, J];	
					*PORCENTAJE;
					SUPK[I, J] = (1 / &PE) * (1 / &PE - 1) * UPKC[I, J];
					VUPK[I, J] = VUPK[I, J] + SUPK[I, J];
				END;
			END;
		END;	

	RUN;
	*AGREGAR POR ESTRATO;
	PROC SUMMARY DATA = DATAV02 NOPRINT;
		BY &ESTRATOC &UMC &DISENOC &NC &NMC &PC;
		VAR UR: VUR: UP: VUP:;
		OUTPUT OUT = DATAV03 (DROP = _:) SUM = ;
	RUN;
	DATA &basesalida;set datav03;run;
%MEND ETAPAS_RAZON;


/******************************************************************************
* *	EDICION DE CUADROS EN UNA TABLA
******************************************************************************/
%MACRO JUNTAR(LIBNAME,
				BASES,
				VARFILA,
				FORMATFILA,
				VARCOL,
				BASEOUT,
				formatoNV = no,
				corteVar = 0,
				corteCat = 0);

/**************************************************************************************************
* * MACRO JUNTAR CREA UN DATASET CON LOS RESULTADOS CONSOLIDADOS
* * 
* * ARG: 
* *   LIBNAME: libreria donde estan los datasets a consolidar
* *   BASES: listado de los data set a consolidar, separados por espacios
* *   VARFILA: listado de los nombres de las variables fila en los data sets a consolidar en un nuevo campo, 
* *				separados por espacios, que definen los métodos de selección
* *   FORMATFILA: listado de los formatos fila a aplicar a las varfila, 
* *				separados por espacios
* *   VARCOL: nombre del campo columna, por ahora la macro no hace nada con este campo
* *   BASEOUT: nombre del dataset que se crea
* *   CORTE
* *
* * Ret: 
**************************************************************************************************/

	OPTIONS NOSOURCE NONOTES;
	* CUANTAS BASES SE VAN A JUNTAR;
	%LET NBASES = %SYSFUNC(COUNTW(&BASES));

	*VERIFICACION QUE LOS PARÁMETROS SE ENCUENTREN BIEN DEFINIDOS;
	DATA _NULL_;
		IF &NBASES NE %SYSFUNC(COUNTW(&VARFILA)) THEN 
			PUT "La cantidad de campos definidos para CAMPOFIL no coinciden con"/ 
				"la cantidad definida de BASES"/
				"	BASES = &BASES" / 
				"	VARFILA = &VARFILA";
		IF &NBASES NE %SYSFUNC(COUNTW(&FORMATFILA)) THEN 
			PUT "La cantidad de formatos definidos para FORMATFILA no coinciden con"/ 
				"la cantidad definida de BASES"/
				"	BASES = &BASES" / 
				"	FORMATFILA = &FORMATFILA";
	RUN;

	*INVOCACIÓN ITERATIVA PARA CONSOLIDACIÓN;
	%DO NVAR = 1 %TO &NBASES;

		* DEFINIENDO LOS CAMPOS DE LA BASE;
		%LET NAMEBASE 	= %SCAN(&BASES, 	&NVAR, %STR( ));
		%LET VAR 		= %SCAN(&VARFILA,	&NVAR, %STR( ));
		%LET FORMATO 	= %SCAN(&FORMATFILA,&NVAR, %STR( ));
		
		%IF &CORTECAT > 0 %THEN %DO;
			%IF &FORMATO = &FORMATONV %THEN %DO;
				DATA JN00;
					LENGTH FILAVALOR $100 NOMBREFILA $30 
							NEWVALOR $100;* NOMBRENEW $30  ;
					SET &LIBNAME..&NAMEBASE ;

					FILAVALOR = 'Total';
					NEWVALOR = PUT(&VAR, &FORMATO);
					IF &VAR NE 'T' THEN
						NEW = PUT(INPUT(&VAR, 4.0), Z2.);
					ELSE NEW = 'T';
					RENAME &VAR = FILA;
					NOMBREFILA = SUBSTR("&VAR", &CORTEVAR, LENGTH("&VAR")- &CORTEVAR + 1);;
				RUN;	
			%END;
			%ELSE %DO;
				DATA JN00;
					LENGTH FILAVALOR $100 NOMBREFILA $30 
							NEWVALOR $100  ;*NOMBRENEW $30 ;
					SET &LIBNAME..&NAMEBASE ;
					
					IF &VAR NOT IN('T', '0') THEN DO;
						&VAR = PUT(INPUT(&VAR, 8.0), Z4.);
						PREV1 = SUBSTR(&VAR, &CORTECAT);
						PREV1 = COMPRESS(PUT(INPUT(PREV1, 8.0), 4.));

						PREV2 = SUBSTR(&VAR, 1, &CORTECAT - 1);
						PREV2 = COMPRESS(PUT(INPUT(PREV2, 8.0), 4.));
						NEW = PUT(INPUT(PREV2, 4.0), Z2.);
					END;
					ELSE IF &VAR IN('T') THEN DO;
						PREV1 = 'T';
						PREV2 = 'T';
						NEW = 'T';
					END;
					ELSE DO;
						PREV1 = '0';
						PREV2 = '0';
						NEW = '0';
					END;

					FILAVALOR = PUT(PREV1, &FORMATO);
					NEWVALOR = PUT(PREV2, &FORMATONV);
					
					RENAME PREV1 = FILA;
					NOMBREFILA = SUBSTR("&VAR", &CORTEVAR, LENGTH("&VAR")- &CORTEVAR + 1);

					DROP &VAR PREV2;
				RUN;	
			%END;
		%END;
		%ELSE %DO;
		DATA JN00;
			LENGTH FILAVALOR $100 NOMBREFILA $30;
			SET &LIBNAME..&NAMEBASE ;

			FILAVALOR = PUT(&VAR, &FORMATO);
			RENAME &VAR = FILA;
			NOMBREFILA = "&VAR";
			
		RUN;
		%END;

		PROC APPEND BASE = JN01 DATA = JN00 FORCE;RUN;
	%END;

	DATA &BASEOUT;
		SET JN01;
	RUN;

	PROC DATASETS LIBRARY = WORK NODETAILS NOLIST;
		DELETE JN00 JN01/ GENNUM = ALL;
	RUN;
	OPTIONS SOURCE NOTES;
%MEND JUNTAR;
