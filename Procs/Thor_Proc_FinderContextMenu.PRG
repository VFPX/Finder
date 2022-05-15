Lparameters loContextMenu, lcFileName, lcClass

* ContextMenu home page = http://vfpx.codeplex.com/wikipage?title=Thor%20Framework%20ContextMenu

Local lcExec, lcExt, lcFName, lcPRGName, lcQuote

If Not Inlist(Upper(Justext(m.lcFileName)), 'DBC', 'DBF', 'SCX', 'LBX', 'MNX', 'FRX', 'VCX')
	Return
Endif

lcExt	  = Upper(Left(Justext(m.lcFileName), 2))
lcPRGName = _Screen.cThorFolder + '\Tools\Components\FoxBin2PRG\FoxBin2PRG.prg'
If File(m.lcPRGName)
	lcExec	  = [Do "] + m.lcPRGName + [" With "] + m.lcFileName + ["]

	lcFName = Juststem(m.lcFileName)
	If (' ' $ m.lcFName)
		lcQuote = [']
	Else
		lcQuote = ''
	Endif

	* AddMenuItem('Caption in context menu', 'Text to be executed')
	m.loContextMenu.AddMenuItem('Create ' +										;
		  m.lcQuote + m.lcFName + '.' + Left(m.lcExt, 2) + '2' + m.lcQuote		;
		  + ' using FoxBin2PRG', m.lcExec)
Endif