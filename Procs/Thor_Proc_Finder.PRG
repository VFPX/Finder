Lparameters tcProject

Local lcActiveProject, lcFinderScope, llGotScope, llMultipleInstances, llOpened, loException
Local loFinder, loForm

llMultipleInstances = Execscript(_Screen.cThorDispatcher, 'Get Option=', 'Multiple Instances', 'Finder')
Do Case
	Case Not Empty(tcProject)
		lcActiveProject = tcProject
	Case _vfp.Projects.Count = 0
		lcActiveProject = ''
	Otherwise
		lcActiveProject = _vfp.ActiveProject.Name
Endcase

llOpened = .F.
For Each loForm In _Screen.Forms FoxObject
	If Pemstatus(loForm, 'GetFinderScope', 5)
		Try
			lcFinderScope = loForm.GetFinderScope()
		Catch To loException
		Endtry

		Do Case
			Case Vartype(lcFinderScope) # 'C'

			Case Not llMultipleInstances
				loForm.Show()
				llOpened = .T.
				Exit

			Case Upper(lcFinderScope) = Upper(lcActiveProject)
				loForm.Show()
				llOpened = .T.
				Exit
		Endcase
	Endif

Endfor

If Not llOpened
	loFinder = Execscript(_Screen.cThorDispatcher, 'Class= FrmFinder of Thor_Proc_Finder.VCX', tcProject)
	loFinder.Show()
Endif
