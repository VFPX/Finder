Lparameters tuProject
* Called with object for a project (a la _vfp.activeProject)
* or the fully qualified name of the project, as would be
* returned by _vfp.ActiveProject.Name

Local loForm As Form
Local lcExt, lcFile, lcFileName, llResult, llSuccess, loProject

loProject = GetProject(tuProject)
If 'O' # Vartype(loProject)
	Messagebox('Build failed', 16, 'Unable to open project')
	Return
Endif

lcFileName = Execscript(_Screen.cThorDispatcher, 'Full Path=Thor_Proc_BuildAction.SCX')
Do Form (lcFileName) Name loForm with loProject
If 'O' # Vartype(loForm)
	Return
Endif

If loForm.lResult
	BuildProject(loProject, loForm)
Endif

loForm.Release()
Return


Procedure BuildProject(loProject, loForm)

	Local lcExt, lcFile, llSuccess, lnMsgBoxAns
	Do Case
		Case loForm.nBuildAction = 1
			lcExt = ''
		Case loForm.nBuildAction = 2
			lcExt = 'APP'
		Case loForm.nBuildAction = 3
			lcExt = 'EXE'
		Case loForm.nBuildAction = 4
			lcExt = 'DLL'
		Case loForm.nBuildAction = 5
			lcExt = 'DLL'
		Otherwise
			lcExt = ''
	Endcase

	lcFile = Getfile(lcExt, 'File: ', 'Create')
	Do Case
		Case Empty(lcFile)
			Return
		Case File(lcFile)
			lnMsgBoxAns = Messagebox(Justfname(lcFile) + ' already exists.' + Chr(13) + 'Do you want to replace it?', 52, 'Confirm Save As')
			Do Case
				Case lnMsgBoxAns = 6 && Yes
					Erase (lcFile)
				Case lnMsgBoxAns = 7 && No
					Return
			Endcase
	Endcase

	llSuccess = loProject.Build(lcFile, loForm.nBuildAction, loForm.lRebuildAll, loForm.lShowErrors, loForm.lBuildNewGUIDs)
	If Not llSuccess
		Messagebox('Build failed', 16, 'Build failed')
		Return
	EndIf
	
	If loForm.lPackAll
		ExecScript(_Screen.cThorDispatcher, 'Thor_Proc_PackProject', loProject.Name)
	EndIf
	
	If loForm.lRunAfterBuild
		Do (lcFile)
	Endif
	
Endproc


Procedure GetProject(tuProject)

	Local llOpened, loErr, loProjectRef
	If 'O' = Vartype(tuProject)
		Return tuProject
	Endif

	For Each loProjectRef In Application.Projects
		If Upper(loProjectRef.Name) == Upper(tuProject)
			Return loProjectRef
		Endif
	Endfor

	* We get here if project is not open
	Try
		Modify Project(tuProject) Nowait Noshow
		llOpened = .T.
	Catch To loErr
		Messagebox('Unable to open project file' + Chr[13] + Chr[13] + loErr.Message, 16, 'Failure')
		llOpened = .F.
	Endtry

	If llOpened
		Return _vfp.ActiveProject
	Else
		Return .F.
	Endif
Endproc
