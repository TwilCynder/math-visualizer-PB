
mainGraph.Graph

AddElement(mainGraph\parameters())
mainGraph\title = "Cercle de congruence"
mainGraph\parameters()\title = "Modulo : number of points"
AddElement(mainGraph\parameters()\inputs())
mainGraph\parameters()\inputs()\type = #INPUT_NUMBER
mainGraph\parameters()\inputs()\numberInput\maximum = 9999
mainGraph\parameters()\inputs()\numberInput\minimum = 2
mainGraph\parameters()\inputs()\numberInput\defaultValue = #CC_DEFAULT_MOD
AddElement(mainGraph\parameters())
mainGraph\parameters()\title = "Multiplier"
AddElement(mainGraph\parameters()\inputs())
mainGraph\parameters()\inputs()\type = #INPUT_NUMBER
mainGraph\parameters()\inputs()\numberInput\maximum = 9999
mainGraph\parameters()\inputs()\numberInput\minimum = 2
mainGraph\parameters()\inputs()\numberInput\defaultValue = #CC_DEFAULT_MULT

Structure CongruenceCircleState
    mod.l
    mult.l
EndStructure    
    
Procedure congruenceCircleInputCallback(*state.CongruenceCircleState, gadgetID.l, *inputValue.InputValue)
    Select gadgetID
        Case 1
            *state\mod = *inputValue\number
        Case 2
            *state\mult = *inputValue\number
    EndSelect
EndProcedure

Procedure congruenceCircleInit()
    *state.CongruenceCircleState = AllocateStructure(CongruenceCircleState)
    *state\mod = #CC_DEFAULT_MOD
    *state\mult = #CC_DEFAULT_MULT
    ProcedureReturn *state
EndProcedure

Procedure congruenceCircleEnd(*graphState.CongruenceCircleState)
    ProcedureReturn FreeMemory(*graphState)
EndProcedure

Procedure getPointForAngle(angle.d, *p.PointDouble)
    *p\x = Sin(angle)
    *p\y = -Cos(angle) 
EndProcedure

Procedure getPointForID(id.l, mod.l, *p.PointDouble)

    getPointForAngle((Pi2 / mod) * id, *p)    
    
EndProcedure

Procedure DrawCongruenceCircle(mod.l, mult.l, x.l, y.l, radius.l)
    ;ClearScreen(0)
    ;out = output
    ;If out = -1
    ;    out = ScreenOutput()
    ;EndIf
    ;StartDrawing(out)
    
    Debug mod
    Debug mult
    Debug radius
    DrawingMode(#PB_2DDrawing_Outlined)
    Circle(300, 300, 250, RGB(255, 0, 255))
    
    p1.PointDouble
    p2.PointDouble
    For i = 0 To mod - 1 Step 2
        getPointForID(i, mod, @p1)
        getPointForID(i * mult % mod, mod, @p2)
        LineXY(p1\x * radius + x, p1\y * radius + y, p2\x * radius + x, p2\y * radius + y, RGB(255,255,255))
    Next
    
    ;StopDrawing()
EndProcedure

Procedure congruenceCircleDraw(*graphState.CongruenceCircleState, x.l, y.l)
    DrawCongruenceCircle(*graphState\mod, *graphState\mult, x, y, radius)
EndProcedure




mainGraph\inputCallback = @congruenceCircleInputCallback()
mainGraph\initFunction = @congruenceCircleInit()
mainGraph\endFunction = @congruenceCircleEnd()
mainGraph\drawFunction = @congruenceCircleDraw()
; IDE Options = PureBasic 6.00 LTS (Windows - x64)
; CursorPosition = 81
; FirstLine = 52
; Folding = --
; EnableXP
; DPIAware