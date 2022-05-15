Lparameters lxParam1

****************************************************************
****************************************************************
* Standard prefix for all tools for Thor, allowing this tool to
*   tell Thor about itself.

If Pcount() = 1								;
		And 'O' = Vartype(lxParam1)			;
		And 'thorinfo' == Lower(lxParam1.Class)

	With lxParam1

		* Required
		.Prompt		   = 'Finder' && used in menus

		* Optional
		Text To .Description Noshow && a description for the tool
Search engine to find files and classes.

UI to search for files or classes based on partial name match. Searching may be done in a project or folder (and sub-folders).

Provides a wide range of actions on selected files, including: Open, Run, Open with HackCX, Open Class, Pack, Re-Index, Add To or Remove from active project, and more, as well as folder manipulation.

Drag/drop functionality allows you to drop classes onto an open form or class.

Also provides new reports for classes: Descendant and Sibling classes, and Where Used.
		Endtext
		.CanRunAtStartUp = .T.

		* These are used to group and sort tools when they are displayed in menus or the Thor form
		.Category = 'Applications' && creates categorization of tools; defaults to .Source if empty
		.Sort	  = 0 && the sort order for all items from the same Category

		* For public tools, such as PEM Editor, etc.
		.Version   = '1.1 Beta'
		.Author	   = 'Jim Nelson'
		.Link	   = 'https://github.com/VFPX/Finder' && link to a page for this tool
		.VideoLink = 'http://youtu.be/uL4a9gsCLlk'
		.PlugInClasses = 'clsBuildProjectPlugIn, clsContextMenuPlugIn'
		.PlugIns   = 'Build Project, Finder context menu'

	Endwith

	Return lxParam1
Endif

If Pcount() = 0
	Do ToolCode
Else
	Do ToolCode With lxParam1
Endif

Return

****************************************************************
****************************************************************
* Normal processing for this tool begins here.                  
Procedure ToolCode
	Lparameters lxParam1

	Execscript(_Screen.cThorDispatcher, 'Thor_Proc_Finder.PRG')

Endproc


Define Class clsBuildProjectPlugIn As Custom
	Source				= 'SuperBrowse'
	PlugIn				= 'Build Project'
	Description			= 'Provides the Build Project dialog used in Finder.'
	Tools				= 'Finder'
	FileNames			= 'Thor_Proc_BuildProject.PRG'
	DefaultFileName		= '*Thor_Proc_BuildProject.PRG'
	DefaultFileContents	= ''
EndDefine 


Define Class clsContextMenuPlugIn As Custom
	Source				= 'SuperBrowse'
	PlugIn				= 'Finder context menu'
	Description			= "Adds new items to bottom of context menu in Finder's grid."
	Tools				= 'Finder'
	FileNames			= 'Thor_Proc_FinderContextMenu.PRG'
	DefaultFileName		= '*Thor_Proc_FinderContextMenu.PRG'
	DefaultFileContents	= ''
EndDefine 

