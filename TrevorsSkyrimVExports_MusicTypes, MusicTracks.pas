{
  Trevors Skyrim V Exports - Music Types & Music Tracks
  Exports all (conflict-winning) MUSC & MUST records with nearly all information.
  Can choose to use the default merged csv flag (all records exported to one csv) or export to their own csv's.
}

unit TrevorsSkyrimVExports_MusicTypeMusicTrack;

var
  slOutputMerged, slOutputMUSC, slOutputMUST: TStringList;
  csvPathMerged, csvPathMUSC, csvPathMUST: string;
  USE_MERGED: Boolean;

// ==================================================

function Initialize: Integer;
begin

  //! Important: This is a True/False flag to create Merged csv (True) or split each record type into separate csv's (False).
  USE_MERGED     := True;

  slOutputMerged := TStringList.Create;
  slOutputMUSC   := TStringList.Create;
  slOutputMUST   := TStringList.Create;

  // Set the csv names.
  csvPathMerged  := ProgramPath + 'TrevorsSkyrimVExports_MusicTypes, MusicTracks.csv';
  csvPathMUSC    := ProgramPath + 'TrevorsSkyrimVExports_MusicTypes.csv';
  csvPathMUST    := ProgramPath + 'TrevorsSkyrimVExports_MusicTracks.csv';

  // Set the csv headers.
  slOutputMerged.Add(
    'File'            + ';' +
    'Record Type'     + ';' +
    'Form ID'         + ';' +
    'Editor ID'       + ';' +
    'Track Type'      + ';' +
    'Duration'        + ';' +
    'Fade Duration'   + ';' +
    'Fade-Out'        + ';' +
    'Track FileName'  + ';' +
    'Finale FileName' + ';' +
    'Priority'        + ';' +
    'Ducking (dB)'    + ';' +
    'Flags'           + ';' +
    'Tracks'
  );
  slOutputMUSC.Add(
    'File'            + ';' +
    'Record Type'     + ';' +
    'Form ID'         + ';' +
    'Editor ID'       + ';' +
    'Fade Duration'   + ';' +
    'Priority'        + ';' +
    'Ducking (dB)'    + ';' +
    'Flags'           + ';' +
    'Tracks'
  );
  slOutputMUST.Add(
    'File'            + ';' +
    'Record Type'     + ';' +
    'Form ID'         + ';' +
    'Editor ID'       + ';' +
    'Track Type'      + ';' +
    'Duration'        + ';' +
    'Fade-Out'        + ';' +
    'Track FileName'  + ';' +
    'Finale FileName' + ';' +
    'Tracks'
  );

end;

// ==================================================

// Useful for getting cells that are either a number or basic data like "Iron Gloves" (FULL) or "ArmorIronGauntlets" (EDID)
function GetElementSafe(e: IInterface; path: string): string;
var
  el: IInterface;
begin

  Result := '';
  el := ElementByPath(e, path);

  if Assigned(el) then
    Result := GetEditValue(el);

end;

// ==================================================

// Same as GetElementSafe() however this properly avoids NULL references and allows trimming the last X index from a string.
function GetElementSafeStrip(e: IInterface; path: string; stripCount: Integer): string;
var
  el: IInterface;
begin

  Result := '';
  el := ElementByPath(e, path);
  if not Assigned(el) then Exit;

  Result := GetEditValue(el);

  // Skip if it's null reference
  if Pos('NULL - Null Reference', Result) = 1 then begin
    Result := '';
    Exit;
  end;

  // Remove trailing [XX:00000000] or similar, if requested
  if (stripCount > 0) and (Length(Result) > stripCount) then
    Result := Copy(Result, 1, Length(Result) - stripCount);

end;

// ==================================================

// Useful for getting cells where the value originally is "DefaultRace "Default Race" [RACE:00000019]" or "ArmorSteelPlateGauntlets "Steel Plate Gauntlets" [ARMO:0001395D]".
function GetLinkedName(e: IInterface; path: string): string;
var
  el: IInterface;
begin

  Result := '';
  el := ElementByPath(e, path);

  if Assigned(el) then begin
    el := LinksTo(el);

    if Assigned(el) then
      Result := DisplayName(el);
  end;

end;

// ==================================================

function GetNamedFlags(e: IInterface; path: string): string;
var
  el, sub, linked: IInterface;
  i, dashPos: Integer;
  slotName, resultList: string;
begin

  Result := '';
  el := ElementByPath(e, path);
  if not Assigned(el) then Exit;

  for i := 0 to ElementCount(el) - 1 do begin
    sub := ElementByIndex(el, i);

    // Try keyword-style (LinksTo with EditorID)
    linked := LinksTo(sub);
    if Assigned(linked) and (EditorID(linked) <> '') then begin
      slotName := EditorID(linked);
    end

    // Try named flag-style (Name with dash stripping)
    else if Name(sub) <> '' then begin
      slotName := Name(sub);
      dashPos := Pos(' - ', slotName);

      if dashPos > 0 then
        slotName := Copy(slotName, dashPos + 3, Length(slotName) - dashPos - 2);
    end

    // Fallback to raw GetEditValue
    else begin
      slotName := GetEditValue(sub);
    end;

    // === Filter out unwanted flag names ===
    if (slotName = 'Unknown 8') or (slotName = 'Unknown 12') or (slotName = 'Unknown 17') or (slotName = 'Unknown 19') or (slotName = 'Unknown 23') then
      Continue;

    if resultList <> '' then
      resultList := resultList + ', ';

    resultList := resultList + slotName;
  end;

  Result := resultList;

end;

// ==================================================

// Used when a cell might contain commas inside. Adds double quotes or doesn't if no commas detected.
function EscapeCSV(s: string): string;
begin

  if (Pos(',', s) > 0) or (Pos(';', s) > 0) then
    Result := '"' + s + '"'
  else
    Result := s;

end;

// ==================================================

function Process(e: IInterface): Integer;
var
  sig, formID, editorID, fadeDuration, priority, ducking,
  flags, tracks, trackType, duration, fadeOut,
  trackFileName, finaleFileName: string;
begin

  // Grabs winning conflict record.
  if not Equals(e, WinningOverride(e)) then Exit;

  sig               := Signature(e);
  if (sig <> 'MUSC') and (sig <> 'MUST') then Exit;

  formID            := '0x' + IntToHex(FixedFormID(e), 8);
  editorID          := GetElementSafe(e, 'EDID - Editor ID');
  if (editorID = '_NONE') and (sig = 'MUSC') then Exit;


  if sig = 'MUSC' then begin
    fadeDuration    := GetElementSafe(e, 'WNAM - Fade Duration');
    priority        := GetElementSafe(e, 'PNAM - Data\Priority');
    ducking         := GetElementSafe(e, 'PNAM - Data\ducking (dB)');
    flags           := GetNamedFlags(e,  'FNAM - Flags');
    tracks          := GetNamedFlags(e,  'TNAM - Music Tracks');
  end;


  if sig = 'MUST' then begin
    trackType       := GetElementSafe(e, 'CNAM - Track Type');
    if (trackType = 'Silent Track') then Exit;

    duration        := GetElementSafe(e, 'FLTV - Duration');
    fadeOut         := GetElementSafe(e, 'DNAM - Fade-Out');
    trackFileName   := GetElementSafe(e, 'ANAM - Track FileName');
    finaleFileName  := GetElementSafe(e, 'BNAM - Finale FileName');
    tracks          := GetNamedFlags(e,  'SNAM - Tracks');
  end;


  if USE_MERGED then
    slOutputMerged.Add(
      GetFileName(GetFile(e))   + ';' +
      sig                       + ';' +
      formID                    + ';' +
      EscapeCSV(editorID)       + ';' +
      EscapeCSV(trackType)      + ';' +
      duration                  + ';' +
      fadeDuration              + ';' +
      fadeOut                   + ';' +
      EscapeCSV(trackFileName)  + ';' +
      EscapeCSV(finaleFileName) + ';' +
      priority                  + ';' +
      ducking                   + ';' +
      EscapeCSV(flags)          + ';' +
      EscapeCSV(tracks)
    )
  else begin

    if sig = 'MUSC' then begin
      slOutputMUSC.Add(
        GetFileName(GetFile(e)) + ';' +
        sig                     + ';' +
        formID                  + ';' +
        EscapeCSV(editorID)     + ';' +
        fadeDuration            + ';' +
        priority                + ';' +
        ducking                 + ';' +
        EscapeCSV(flags)        + ';' +
        EscapeCSV(tracks)
      );
    end;

    if sig = 'MUST' then begin
      slOutputMUST.Add(
        GetFileName(GetFile(e))   + ';' +
        sig                       + ';' +
        formID                    + ';' +
        EscapeCSV(editorID)       + ';' +
        EscapeCSV(trackType)      + ';' +
        duration                  + ';' +
        fadeOut                   + ';' +
        EscapeCSV(trackFileName)  + ';' +
        EscapeCSV(finaleFileName) + ';' +
        EscapeCSV(tracks)
      );
    end;

  end;

end;

// ==================================================

function Finalize: Integer;
begin

  if USE_MERGED then
    slOutputMerged.SaveToFile(csvPathMerged)
  else begin
    slOutputMUSC.SaveToFile(csvPathMUSC);
    slOutputMUST.SaveToFile(csvPathMUST);
  end;

  slOutputMerged.Free;
  slOutputMUSC.Free;
  slOutputMUST.Free;

end;

end.

