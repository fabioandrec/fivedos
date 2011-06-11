

// configuraci¢n de colores
// mas adelante puede depender de un .INI, de momento est n
// a pedalillo ...

// ahora los colores de los controles ....

// naturalmente esto es una chorrada para salir del paso ...

Function Setdefcolor(cColor)

	local nRet := 7

	cColor := Upper( cColor )
	do case

	  case cColor = 'NORMAL' // NO ACTIVO , DISABLE
		nRet := nColorTon('N/B')

	  case cColor = 'HOTKEY' // NO ACTIVA
		nRet := nColorTon('R/B')

	  case cColor = 'UNSELECT'
		nRet := nColorTon('W/B')

	  case cColor = 'SELECT'
		nRet := nColorTon('N/b+')

	  case cColor = 'HOTUNSEL'
		nRet := nColorTon('B+/B')

	  case cColor = 'HOTSEL'
		nRet := nColorTon('w/b+')

	ENDCASE

return nRet
