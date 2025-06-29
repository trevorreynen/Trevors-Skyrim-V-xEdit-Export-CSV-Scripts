{
  Trevors Skyrim V Exports - Armor & Weapons
  Exports all (conflict-winning) ARMO & WEAP records with nearly all information.
  Can choose to use the default merged csv flag (all records exported to one csv) or export to their own csv's.
}

unit TrevorsSkyrimVExports_ArmorWeapons;

var
  slOutputMerged, slOutputARMO, slOutputWEAP: TStringList;
  csvPathMerged, csvPathARMO, csvPathWEAP: string;
  USE_MERGED: Boolean;

// ==================================================

function Initialize: Integer;
begin

  //! Important: This is a True/False flag to create Merged csv (True) or split each record type into separate csv's (False).
  USE_MERGED     := True;

  slOutputMerged := TStringList.Create;
  slOutputARMO   := TStringList.Create;
  slOutputWEAP   := TStringList.Create;

  // Set the csv names.
  csvPathMerged  := ProgramPath + 'TrevorsSkyrimVExports_Armor, Weapons.csv';
  csvPathARMO    := ProgramPath + 'TrevorsSkyrimVExports_Armor.csv';
  csvPathWEAP    := ProgramPath + 'TrevorsSkyrimVExports_Weapons.csv';

  // Set the csv headers.
  slOutputMerged.Add(
    'File'           + ';' +
    'Record Type'    + ';' +
    'Form ID'        + ';' +
    'Editor ID'      + ';' +
    'Full Name'      + ';' +
    'Non-Playable'   + ';' +
    'Object Effect'  + ';' +
    'Armor Slots'    + ';' +
    'Armor Type'     + ';' +
    'Armor Rating'   + ';' +
    'Template'       + ';' +
    'Race'           + ';' +
    'Enchant Amount' + ';' +
    'Damage'         + ';' +
    'Speed'          + ';' +
    'Reach'          + ';' +
    'Range Min'      + ';' +
    'Range Max'      + ';' +
    'Skill'          + ';' +
    'Stagger'        + ';' +
    'Crit Damage'    + ';' +
    'Crit % Mult'    + ';' +
    'Value'          + ';' +
    'Weight'         + ';' +
    'Flags'          + ';' +
    'Keyword Count'  + ';' +
    'Keywords'       + ';' +
    'Description'
  );
  slOutputARMO.Add(
    'File'          + ';' +
    'Record Type'   + ';' +
    'Form ID'       + ';' +
    'Editor ID'     + ';' +
    'Full Name'     + ';' +
    'Non-Playable'  + ';' +
    'Object Effect' + ';' +
    'Armor Slots'   + ';' +
    'Armor Type'    + ';' +
    'Armor Rating'  + ';' +
    'Template'      + ';' +
    'Race'          + ';' +
    'Value'         + ';' +
    'Weight'        + ';' +
    'Keywords'      + ';' +
    'Description'
  );
  slOutputWEAP.Add(
    'File'           + ';' +
    'Record Type'    + ';' +
    'Form ID'        + ';' +
    'Editor ID'      + ';' +
    'Full Name'      + ';' +
    'Object Effect'  + ';' +
    'Enchant Amount' + ';' +
    'Value'          + ';' +
    'Weight'         + ';' +
    'Damage'         + ';' +
    'Speed'          + ';' +
    'Reach'          + ';' +
    'Range Min'      + ';' +
    'Range Max'      + ';' +
    'Skill'          + ';' +
    'Stagger'        + ';' +
    'Crit Damage'    + ';' +
    'Crit % Mult'    + ';' +
    'Template'       + ';' +
    'Flags'          + ';' +
    'Keyword Count'  + ';' +
    'Keywords'       + ';' +
    'Description'
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

function HasFlag(e: IInterface; path, expectedName: string): Boolean;
var
  flags, flagEntry: IInterface;
  i: Integer;
begin

  Result := False;
  flags := ElementByPath(e, path);
  if not Assigned(flags) then Exit;

  for i := 0 to ElementCount(flags) - 1 do begin
    flagEntry := ElementByIndex(flags, i);

    if GetEditValue(flagEntry) = '1' then begin
      if Name(flagEntry) = expectedName then begin
        Result := True;
        Exit;
      end;
    end;
  end;

end;

function HasAnyNonPlayableFlag(e: IInterface; path1, name1, path2, name2: string): string;
begin

  if HasFlag(e, path1, name1) or HasFlag(e, path2, name2) then
    Result := 'TRUE'
  else
    Result := 'FALSE';

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
    if (slotName = 'Unknown 6') or (slotName = 'Unknown 8') then
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
  sig, formID, editorID: string;
  fullName, nonPlayable, objEffect, armorSlots, armorType, armorRating,
  template, race, value, weight, keywordCount, keywords, description,
  enchantAmount, damage, speed, reach, rangeMin, rangeMax, skill, stagger,
  critDamage, critMult: string;
  flags, flags1, flags2: string;
begin

  // Grabs winning conflict record.
  if not Equals(e, WinningOverride(e)) then Exit;

  sig              := Signature(e);
  if (sig <> 'ARMO') and (sig <> 'WEAP') then Exit;

  formID           := '0x' + IntToHex(FixedFormID(e), 8);
  editorID         := GetElementSafe(e, 'EDID - Editor ID');


  if sig = 'ARMO' then begin
    fullName       := GetElementSafe(e, 'FULL - Name');
    if fullName = '' then Exit;

    nonPlayable    := HasAnyNonPlayableFlag(e,
      'Record Header\Record Flags', 'Non-Playable',
      'BOD2 - Biped Body Template\General Flags', '(ARMO)Non-Playable'
    );

    objEffect      := GetLinkedName(e,  'EITM - Object Effect');
    armorSlots     := GetNamedFlags(e,  'BOD2 - Biped Body Template\First Person Flags');
    armorType      := GetElementSafe(e, 'BOD2 - Biped Body Template\Armor Type');
    armorRating    := GetElementSafe(e, 'DNAM - Armor Rating');
    template       := GetLinkedName(e,  'TNAM - Template Armor');
    race           := GetLinkedName(e,  'RNAM - Race');
    value          := GetElementSafe(e, 'DATA - Data\Value');
    weight         := GetElementSafe(e, 'DATA - Data\Weight');
    keywords       := GetNamedFlags(e,  'KWDA - Keywords');
    description    := GetElementSafe(e, 'DESC - Description');

  end;


  if sig = 'WEAP' then begin
    fullName       := GetElementSafe(e, 'FULL - Name');
    if (Trim(fullName) = '') and (editorID <> 'Unarmed') then Exit;
    if (fullName = 'FXdustDropWEP') or (fullName = 'GasTrap Dummy') or (fullName = 'Test Vorpal Sword') then Exit;

    objEffect      := GetLinkedName(e,  'EITM - Object Effect');
    enchantAmount  := GetElementSafe(e, 'EAMT - Enchantment Amount');
    value          := GetElementSafe(e, 'DATA - Game Data\Value');
    weight         := GetElementSafe(e, 'DATA - Game Data\Weight');
    damage         := GetElementSafe(e, 'DATA - Game Data\Damage');
    speed          := GetElementSafe(e, 'DNAM - Data\Speed');
    reach          := GetElementSafe(e, 'DNAM - Data\Reach');
    rangeMin       := GetElementSafe(e, 'DNAM - Data\Range Min');
    rangeMax       := GetElementSafe(e, 'DNAM - Data\Range Max');
    skill          := GetElementSafe(e, 'DNAM - Data\Skill');
    stagger        := GetElementSafe(e, 'DNAM - Data\Stagger');
    critDamage     := GetElementSafe(e, 'CRDT - Critical Data\Damage');
    critMult       := GetElementSafe(e, 'CRDT - Critical Data\% Mult');
    template       := GetLinkedName(e,  'CNAM - Template');

    // Flag display as human-readable text instead of numeric values.
    flags1         := GetNamedFlags(e,  'DNAM - Data\Flags');
    flags2         := GetNamedFlags(e,  'DNAM - Data\Flags2');
    if (flags1 <> '') and (flags2 <> '') then
      flags := flags1 + ', ' + flags2
    else
      flags := flags1 + flags2;

    keywordCount   := GetElementSafe(e, 'KSIZ - Keyword Count');
    keywords       := GetNamedFlags(e,  'KWDA - Keywords');
    description    := GetElementSafe(e, 'DESC - Description');

  end;


  if USE_MERGED then
    slOutputMerged.Add(
      GetFileName(GetFile(e)) + ';' +
      sig                     + ';' +
      formID                  + ';' +
      EscapeCSV(editorID)     + ';' +
      EscapeCSV(fullName)     + ';' +
      nonPlayable             + ';' +
      EscapeCSV(objEffect)    + ';' +
      EscapeCSV(armorSlots)   + ';' +
      EscapeCSV(armorType)    + ';' +
      armorRating             + ';' +
      EscapeCSV(template)     + ';' +
      EscapeCSV(race)         + ';' +
      enchantAmount           + ';' +
      damage                  + ';' +
      speed                   + ';' +
      reach                   + ';' +
      rangeMin                + ';' +
      rangeMax                + ';' +
      EscapeCSV(skill)        + ';' +
      stagger                 + ';' +
      critDamage              + ';' +
      critMult                + ';' +
      value                   + ';' +
      weight                  + ';' +
      EscapeCSV(flags)        + ';' +
      keywordCount            + ';' +
      EscapeCSV(keywords)     + ';' +
      EscapeCSV(description)
    )
  else begin

    if sig = 'ARMO' then begin
      slOutputARMO.Add(
        GetFileName(GetFile(e)) + ';' +
        sig                     + ';' +
        formID                  + ';' +
        EscapeCSV(editorID)     + ';' +
        EscapeCSV(fullName)     + ';' +
        nonPlayable             + ';' +
        EscapeCSV(objEffect)    + ';' +
        EscapeCSV(armorSlots)   + ';' +
        EscapeCSV(armorType)    + ';' +
        armorRating             + ';' +
        EscapeCSV(template)     + ';' +
        EscapeCSV(race)         + ';' +
        value                   + ';' +
        weight                  + ';' +
        EscapeCSV(keywords)     + ';' +
        EscapeCSV(description)
      );
    end;

    if sig = 'WEAP' then begin
      slOutputWEAP.Add(
        GetFileName(GetFile(e)) + ';' +
        sig                     + ';' +
        formID                  + ';' +
        EscapeCSV(editorID)     + ';' +
        EscapeCSV(fullName)     + ';' +
        EscapeCSV(objEffect)    + ';' +
        enchantAmount           + ';' +
        value                   + ';' +
        weight                  + ';' +
        damage                  + ';' +
        speed                   + ';' +
        reach                   + ';' +
        rangeMin                + ';' +
        rangeMax                + ';' +
        EscapeCSV(skill)        + ';' +
        stagger                 + ';' +
        critDamage              + ';' +
        critMult                + ';' +
        EscapeCSV(template)     + ';' +
        EscapeCSV(flags)        + ';' +
        keywordCount            + ';' +
        EscapeCSV(keywords)     + ';' +
        EscapeCSV(description)
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
    slOutputARMO.SaveToFile(csvPathARMO);
    slOutputWEAP.SaveToFile(csvPathWEAP);
  end;

  slOutputMerged.Free;
  slOutputARMO.Free;
  slOutputWEAP.Free;

end;

end.

