Attribute VB_Name = "MODULE1"
Sub Main




End Sub
Public Sub Script_AutoBackUpForLabviewMaster

Dim LeFichierExiste As Boolean
Dim LectureFichierOK As Boolean
Dim repertoireSauvegarde As String
Dim NomDuFichierPourSauvegarde As String 'le nom du fichier Catman qui va enregistrer les mesures en format XXX
Dim NomDufichierDeConfigLabview As String 'lenomdufichier ou on va récupérer les infos de fichier
Dim resultatEnvoiFichier As Long
Dim NomFichierCatman As String 'le nom du fichier Catman qui va enregistrer les mesures en format Catman
Dim EtatRestart As Long 'on ne redémarre pas automatiquement

Const FormatCatman = 1
Const FormatASCII = 3
Const FormatMatlab = 10
Const FormatTdms=15
Const ToutesLesMesures =0	'On prend toutes les mesures et pas une portion
Const NbreBytes = 1 		'8 Byte Float
Const SansCommentaire=""
Const ExportToutesLesvoies=0 '

EtatRestart = 0
LeFichierExiste = False
LectureFichierOK =False

repertoireSauvegarde = "C:\Mesures\MesuresHBM\"

NomDufichierDeConfigLabview = "C:\Mesures\nexttest.txt"

LeFichierExiste = EA_Comm.FILE_Exists(NomDufichierDeConfigLabview) 'test si le fichier existe
	If LeFichierExiste Then
		Open NomDufichierDeConfigLabview For Input As #1 'dans VBA quand on ouvre un fichier
													'il porte un index ici #1 ensuite
													'On s'adresse à cet index pour lire écrire
			'on va lire la seule ligne du fichier
			'on pourrait faire dans le même fihcier et y inscrire des commentaires ....
			Line Input #1 , NomDuFichierPourSauvegarde
			'Line Input #1 , NomDuFichierPourSauvegarde
			'MsgBox (NomDuFichierPourSauvegarde) 'indication du nom de fichier par pure information
		Close #1
	Else 'le fihcier n'existe pas il ne faut pas perdre les datas!!
		MsgBox ("Le fichier n'existe pas")
		'NomDuFichierPourSauvegarde = repertoireSauvegarde & "PasDeNom" 'on met quand même un nom pour ne pas perdre les datas
		NomDuFichierPourSauvegarde = "PasDeNom" 'on met quand même un nom pour ne pas perdre les datas
	End If

'Sauvegarde du fichier en natif Catman à un endroit!
'NomFichierCatman = repertoireSauvegarde & NomDuFichierPourSauvegarde
resultatEnvoiFichier=EA_DAQ.SaveData(NomFichierCatman, FormatCatman, NbreBytes,SansCommentaire ,ToutesLesMesures,ExportToutesLesvoies)
'MsgBox ("Le fichier Catman a été généré correctement",vbOkOnly+vbInformation,"Bassin ECN")

'Sauvegarde du fichier en export ASCII à un autre endroit!
'NomFichierASCII = repertoireSauvegarde & NomDuFichierPourSauvegarde
'resultatEnvoiFichier=EA_DAQ.SaveData(NomFichierASCII, FormatASCII, NbreBytes,SansCommentaire ,ToutesLesMesures,ExportToutesLesvoies)
'MsgBox ("Le fichier ASCII a été généré correctement",vbOkOnly+vbInformation,"Bassin ECN")

'Sauvegarde du fichier en export Matlab à un autre endroit!
'NomFichierMatlab = repertoireSauvegarde & NomDuFichierPourSauvegarde
'resultatEnvoiFichier=EA_DAQ.SaveData(NomFichierMatlab, FormatMatlab, NbreBytes,SansCommentaire ,ToutesLesMesures,ExportToutesLesvoies)
'MsgBox ("Le fichier Matlab a été généré correctement",vbOkOnly+vbInformation,"Bassin ECN")

'Sauvegarde du fichier en export à TDMS un autre endroit!
'NomFichierLabview = repertoireSauvegarde & NomDuFichierPourSauvegarde
'resultatEnvoiFichier=EA_DAQ.SaveData(NomFichierLabview, FormatTdms, NbreBytes,SansCommentaire ,ToutesLesMesures,ExportToutesLesvoies)
resultatEnvoiFichier=EA_DAQ.SaveData(NomDuFichierPourSauvegarde, FormatTdms, NbreBytes,SansCommentaire ,ToutesLesMesures,ExportToutesLesvoies)
'MsgBox ("Le fichier TDMS a été généré correctement",vbOkOnly+vbInformation,"Bassin ECN")



End Sub










