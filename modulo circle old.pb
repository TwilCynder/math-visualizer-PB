InitSprite()
InitKeyboard()
UsePNGImageEncoder()

Global Pi2.d = #PI * 2

Global mod.l = 200
Global mult.l = 21
Global radius.l = 250
;201 1000
Structure PointDouble
    x.d
    y.d
EndStructure

Procedure getPointForAngle(angle.d, *p.PointDouble)
    *p\x = Sin(angle)
    *p\y = -Cos(angle) 
EndProcedure

Procedure getPointForID(id.l, mod.l, *p.PointDouble)

    getPointForAngle((Pi2 / mod) * id, *p)    
    
EndProcedure

Procedure draw(mod.l, mult.l, x.l, y.l, radius.l, output = -1)
    ClearScreen(0)
    out = output
    If out = -1
        out = ScreenOutput()
    EndIf
    StartDrawing(out)
    DrawingMode(#PB_2DDrawing_Outlined)
    Circle(300, 300, 250, RGB(255, 0, 255))
    
    p1.PointDouble
    p2.PointDouble
    For i = 0 To mod - 1 Step 2
        getPointForID(i, mod, @p1)
        getPointForID(i * mult % mod, mod, @p2)
        LineXY(p1\x * radius + x, p1\y * radius + y, p2\x * radius + x, p2\y * radius + y, RGB(255,255,255))
    Next
    
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
    draw(mod, mult, x, y, radius, ImageOutput(img))
    
    SaveImage(img, path, #PB_ImagePlugin_PNG)
    FreeImage(img)
EndProcedure

Macro drawG()
    draw(mod, mult, 300, 300, 250)
    FlipBuffers()
EndMacro

OpenWindow(1, 0, 0, 800, 600, "Cercle de congruence", #PB_Window_ScreenCentered | #PB_Window_SystemMenu )
OpenWindowedScreen(WindowID(1), 200, 0, 800, 800)

AddKeyboardShortcut(1, #PB_Shortcut_Escape, 1)
AddKeyboardShortcut(1, #PB_Shortcut_Control | #PB_Shortcut_S, 2)

TextGadget(0, 10, 100, 180, 20, "Modulo : number of points")
modSpinner.l = SpinGadget(#PB_Any, 20, 130, 50, 20, 0, 9999, #PB_Spin_Numeric)
SetGadgetState(modSpinner, mod)

TextGadget(2, 10, 170, 140, 20, "Multiplicator")
multSpinner.l = SpinGadget(#PB_Any, 20, 200, 50, 20, 0, 9999, #PB_Spin_Numeric)
SetGadgetState(multSpinner, mult)

drawG()

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
            Select EventType()
                Case #PB_EventType_Change
                    Select EventGadget()
                        Case modSpinner
                            mod = GetGadgetState(modSpinner)
                            drawG()
                        Case multSpinner
                            mult = GetGadgetState(multSpinner)
                            drawG()
                    EndSelect
            EndSelect    
    EndSelect        
Until quit

; IDE Options = PureBasic 6.00 LTS (Windows - x64)
; CursorPosition = 41
; FirstLine = 21
; Folding = -
; EnableXP
; DPIAware