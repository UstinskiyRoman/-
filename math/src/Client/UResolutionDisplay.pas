unit UResolutionDisplay;

interface

type
  TResolutionDisplay = class
    private
      CONST
        MIN_HEIGHT_PANEL_CONTROL = 650;
        MAX_HEIGHT_PANEL_CONTROL = 900;
        STEP_HEIGHT_PANEL = 190;

    public
      function GetHeightControl(formHeight: Integer):integer;
end;

implementation

function TResolutionDisplay.GetHeightControl(formHeight: Integer):integer;
begin
  if(formHeight > MIN_HEIGHT_PANEL_CONTROL) and (formHeight < MAX_HEIGHT_PANEL_CONTROL)then
    Result:=MIN_HEIGHT_PANEL_CONTROL - STEP_HEIGHT_PANEL;

  if(formHeight >= MAX_HEIGHT_PANEL_CONTROL)then
    Result:=MAX_HEIGHT_PANEL_CONTROL - STEP_HEIGHT_PANEL;
end;

end.
