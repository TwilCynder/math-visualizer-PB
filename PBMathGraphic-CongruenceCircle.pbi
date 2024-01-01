mainGraph.Graph

AddElement(mainGraph\parameters())
mainGraph\title = "Cercle de congruence"
mainGraph\parameters()\title = "Modulo : number of points"
AddElement(mainGraph\parameters()\inputs())
mainGraph\parameters()\inputs()\type = #INPUT_NUMBER
mainGraph\parameters()\inputs()\numberInput\maximum = 9999
mainGraph\parameters()\inputs()\numberInput\minimum = 1
mainGraph\parameters()\inputs()\numberInput\defaultValue = #CC_DEFAULT_MOD
AddElement(mainGraph\parameters())
mainGraph\parameters()\title = "Multiplier"
AddElement(mainGraph\parameters()\inputs())
mainGraph\parameters()\inputs()\type = #INPUT_NUMBER
mainGraph\parameters()\inputs()\numberInput\maximum = 9999
mainGraph\parameters()\inputs()\numberInput\minimum = 1
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

    DrawingMode(#PB_2DDrawing_Outlined | #PB_2DDrawing_Gradient)
    LinearGradient(x - radius, y, x + radius, y)
    FrontColor(RGB(255, 0, 0))
    BackColor(RGB(0, 255, 0))
    
    Circle(300, 300, 250, RGB(255, 0, 255))
    
    modF.f = mod  
    
    p1.PointDouble
    p2.PointDouble
    For i = 0 To mod - 1 Step 1
        getPointForID(i, mod, @p1)
        getPointForID(i * mult % mod, mod, @p2)
        LineXY(p1\x * radius + x, p1\y * radius + y, p2\x * radius + x, p2\y * radius + y)
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
; IDE Options = PureBasic 6.04 LTS (Windows - x64)
; CursorPosition = 76
; FirstLine = 51
; Folding = --
; EnableXP
; DPIAware