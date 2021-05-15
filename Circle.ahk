#SingleInstance

global pi := 3.141592653589793

global xcoords := []
global ycoords := []

CoordMode Mouse, Screen
SendMode Input

calcCoords(ByRef radius, ByRef pointNum, ByRef centerX, ByRef centerY){
    clearObject(xcoords)
    clearObject(ycoords)
    calcedPoints := 0
    selectedPoint := calcedPoints + 1
    interval := ((2 / pointNum) * pi)
    while calcedPoints < pointNum{
        xcoords.Push(centerX + (radius * cos(selectedPoint * interval)))
        ycoords.Push(centerY - (radius * sin(selectedPoint * interval)))
        selectedPoint += 1
        calcedPoints += 1
    }
}

drawCircle(ByRef pointNum){
    pointsDrawn := 0
    drawingPoint := pointsDrawn + 1
    while pointsDrawn < pointNum{
        MouseClick Left, xcoords[drawingPoint], ycoords[drawingPoint], , 0
        drawingPoint += 1
        pointsDrawn += 1
    }
}

clearObject(objectName){
    objectName.Delete(0, objectName.Length())
}

+Enter::
MouseGetPos mouseX, mouseY
InputBox chosenRadius, Required information, Provide the circle's radius in pixels.
InputBox chosenPointNum, Required information, Provide the number of points for the circle.
calcCoords(chosenRadius, chosenPointNum, mouseX, mouseY)
drawCircle(chosenPointNum)
return

!z::
MouseMove A_ScreenWidth / 2, A_ScreenHeight / 2
return

!x::
ExitApp