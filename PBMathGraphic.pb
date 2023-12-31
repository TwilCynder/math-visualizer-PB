InitSprite()
InitKeyboard()
UsePNGImageEncoder()

#PANEL_W = 200
#PANEL_START_Y = 100

#CC_DEFAULT_MOD = 200
#CC_DEFAULT_MULT = 21

Global Pi2.d = #PI * 2

Global radius.l = 250

Structure InputValue
    StructureUnion 
        number.l
    EndStructureUnion
EndStructure

Prototype InputCallback(*graphState, gadgetID.l, *inputValue.InputValue)
Prototype InitFunction()
Prototype EndFunction(*graphState)
Prototype DrawFunction(*graphState, x.l, y.l)

;201 1000
Structure PointDouble
    x.d
    y.d
EndStructure

Structure NumberInputModel
    minimum.l
    maximum.l
    defaultValue.l
EndStructure

Enumeration
    #INPUT_NUMBER
EndEnumeration    

Structure InputModel
    type.b
    StructureUnion
        numberInput.NumberInputModel
    EndStructureUnion
EndStructure

Structure Parameter
    title.s
    List inputs.InputModel()
EndStructure

Structure Graph
    title.s
    List parameters.Parameter()
    inputsCount.l
    *inputCallback.InputCallback
    *initFunction.InitFunction
    *endFunction.EndFunction
    *drawFunction.DrawFunction
EndStructure

Structure GraphInstance
    *model.Graph
    *graphState
    gadgetIDDomain.l
EndStructure


;--====== GRAPH CONFIG ======================

XIncludeFile "PBMathGraphicConfig.pbi"

;-=============================================

inputValue.InputValue

Dim graphInstances.GraphInstance(1)

Procedure initGraphState(*inst.GraphInstance, *graph.Graph)
    *inst\graphState = *graph\initFunction()
EndProcedure


Procedure.l initInputCount(*graph.Graph)
    count.l = 0
    ForEach *graph\parameters()
        count + ListSize(*graph\parameters()\inputs())
    Next
    ProcedureReturn count
EndProcedure

currentDomain.l = 1
Procedure initGraphInputs(*graph.Graph, *graphInst.GraphInstance)
    Shared currentDomain
    currentY.l = #PANEL_START_Y
    currentX.l = 0
    
    currentID.l = currentDomain * 1000 + 1    
    
    ForEach *graph\parameters()
        TextGadget(#PB_Any, 10, currentY, #PANEL_W - 20, 20, *graph\parameters()\title)
        currentY + 20
        currentX = 20
        ForEach *graph\parameters()\inputs()
            Select *graph\parameters()\inputs()\type
                Case #INPUT_NUMBER
                    SpinGadget(currentID, currentX, currentY, 50, 20, *graph\parameters()\inputs()\numberInput\minimum, *graph\parameters()\inputs()\numberInput\maximum, #PB_Spin_Numeric)
                    SetGadgetState(currentID, *graph\parameters()\inputs()\numberInput\defaultValue)
                    SetGadgetData(currentID, *graphInst)
                Default
                    Debug "Unsupported input type"
                    End
            EndSelect
            currentID + 1
            currentX + 60
        Next
        currentY + 30
    Next
    
    initGraphState(*graphInst, *graph)
    *graphInst\model = *graph
    *graphInst\gadgetIDDomain = currentDomain
    
    currentDomain + 1
EndProcedure

Procedure drawGraph(*graphInst.GraphInstance, x.l, y.l, output = -1)
    ClearScreen(0)
    out = output
    If out = -1
        out = ScreenOutput()
    EndIf
    StartDrawing(out)
    
    *graphInst\model\drawFunction(*graphInst\graphState, x, y)
    
    StopDrawing()
EndProcedure

Procedure save(mod.l, mult.l, x.l, y.l, radius.l)
    path.s = SaveFileRequester("Save as image ...", "", "PNG Image | *.png", -1)
    If path = ""
        ProcedureReturn
    EndIf
    
    If Not Right(path, 4) = ".png"
        path + ".png"
    EndIf 
    
    img.l = CreateImage(#PB_Any, 600, 600)
    drawGraph(0, 0, 0)
    
    SaveImage(img, path, #PB_ImagePlugin_PNG)
    FreeImage(img)
EndProcedure

Procedure drawGraphToScreen(*graphInst.GraphInstance)
    drawGraph(*graphInst, 300, 300)    
    FlipBuffers()
EndProcedure


OpenWindow(1, 0, 0, 800, 600, "Cercle de congruence", #PB_Window_ScreenCentered | #PB_Window_SystemMenu )
OpenWindowedScreen(WindowID(1), #PANEL_W, 0, 800, 800)

AddKeyboardShortcut(1, #PB_Shortcut_Escape, 1)
AddKeyboardShortcut(1, #PB_Shortcut_Control | #PB_Shortcut_S, 2)

initGraphInputs(@mainGraph, @graphInstances(0))

drawGraphToScreen(@graphInstances(0))

quit = #False
Repeat 
    Select WaitWindowEvent(20)
        Case #PB_Event_CloseWindow
            quit = #True
        Case #PB_Event_Menu
            Select  EventMenu() 
                Case 1
                    quit = #True
                Case 2
                    save(mod, mult, 300, 300, 250)
            EndSelect
        Case #PB_Event_Gadget
            gadgetID_.l = EventGadget()
            Select EventType()
                Case #PB_EventType_Change
                    *graphInst.GraphInstance = GetGadgetData(gadgetID_)
                    
                    Select GadgetType(gadgetID_)
                        Case #PB_GadgetType_Spin
                            inputValue\number = GetGadgetState(gadgetID_)
                    EndSelect
                    
                    mainGraph\inputCallback(*graphInst\graphState, gadgetID_ - (*graphInst\gadgetIDDomain * 1000), @inputValue)
                    drawGraphToScreen(*graphInst)
            EndSelect    
    EndSelect        
Until quit

; IDE Options = PureBasic 6.00 LTS (Windows - x64)
; CursorPosition = 12
; Folding = --
; EnableXP
; DPIAware