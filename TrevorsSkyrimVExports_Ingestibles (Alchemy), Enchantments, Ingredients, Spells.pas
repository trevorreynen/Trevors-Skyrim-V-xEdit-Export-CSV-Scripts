{
  Trevors Skyrim V Exports - Ingestibles (Alchemy), Enchantments, Ingredients, Spells
  Exports all (conflict-winning) ALCH, ENCH, INGR, SPEL records with nearly all information.
  Can choose to use the default merged csv flag (all records exported to one csv) or export to their own csv's.
}

unit TrevorsSkyrimVExports_IngestibleEnchantmentIngredientSpell;

var
  slOutputMerged, slOutputALCH, slOutputENCH, slOutputINGR, slOutputSPEL: TStringList;
  csvPathMerged, csvPathALCH, csvPathENCH, csvPathINGR, csvPathSPEL: string;
  USE_MERGED: Boolean;

// ==================================================

function Initialize: Integer;
begin

  //! Important: This is a True/False flag to create Merged csv (True) or split each record type into separate csv's (False).
  USE_MERGED     := True;

  slOutputMerged := TStringList.Create;
  slOutputALCH   := TStringList.Create;
  slOutputENCH   := TStringList.Create;
  slOutputINGR   := TStringList.Create;
  slOutputSPEL   := TStringList.Create;

  // Set the csv names.
  csvPathMerged  := ProgramPath + 'TrevorsSkyrimVExports_Ingestibles (Alchemy), Enchantments, Ingredients, Spells.csv';
  csvPathALCH    := ProgramPath + 'TrevorsSkyrimVExports_Ingestibles (Alchemy).csv';
  csvPathENCH    := ProgramPath + 'TrevorsSkyrimVExports_Enchantments.csv';
  csvPathINGR    := ProgramPath + 'TrevorsSkyrimVExports_Ingredients.csv';
  csvPathSPEL    := ProgramPath + 'TrevorsSkyrimVExports_Spells.csv';

  // Set the csv headers.
  slOutputMerged.Add(
    'File'                + ';' +
    'Record Type'         + ';' +
    'Form ID'             + ';' +
    'Editor ID'           + ';' +
    'Full Name'           + ';' +
    'Enchantment Cost'    + ';' +
    'Cast Type'           + ';' +
    'Target Type'         + ';' +
    'Enchantment Type'    + ';' +
    'Spell Type'          + ';' +
    'Equipment Type'      + ';' +
    'Charge Time'         + ';' +
    'Base Enchantment'    + ';' +
    'Enchantment Amount'  + ';' +
    'Base Cost'           + ';' +
    'Value'               + ';' +
    'Ingredient Value'    + ';' +
    'Weight'              + ';' +
    'Range'               + ';' +
    'Cast Duration'       + ';' +
    'Half-cost Perk'      + ';' +
    'Worn Restrictions'   + ';' +
    'Keyword Count'       + ';' +
    'Keywords'            + ';' +
    'Flags'               + ';' +
    'Effect 1 Name'       + ';' +
    'Effect 1 Magnitude'  + ';' +
    'Effect 1 Area'       + ';' +
    'Effect 1 Duration'   + ';' +
    'Effect 2 Name'       + ';' +
    'Effect 2 Magnitude'  + ';' +
    'Effect 2 Area'       + ';' +
    'Effect 2 Duration'   + ';' +
    'Effect 3 Name'       + ';' +
    'Effect 3 Magnitude'  + ';' +
    'Effect 3 Area'       + ';' +
    'Effect 3 Duration'   + ';' +
    'Effect 4 Name'       + ';' +
    'Effect 4 Magnitude'  + ';' +
    'Effect 4 Area'       + ';' +
    'Effect 4 Duration'   + ';' +
    'Effect 5 Name'       + ';' +
    'Effect 5 Magnitude'  + ';' +
    'Effect 5 Area'       + ';' +
    'Effect 5 Duration'   + ';' +
    'Effect 6 Name'       + ';' +
    'Effect 6 Magnitude'  + ';' +
    'Effect 6 Area'       + ';' +
    'Effect 6 Duration'   + ';' +
    'Effect 7 Name'       + ';' +
    'Effect 7 Magnitude'  + ';' +
    'Effect 7 Area'       + ';' +
    'Effect 7 Duration'   + ';' +
    'Effect 8 Name'       + ';' +
    'Effect 8 Magnitude'  + ';' +
    'Effect 8 Area'       + ';' +
    'Effect 8 Duration'   + ';' +
    'Effect 9 Name'       + ';' +
    'Effect 9 Magnitude'  + ';' +
    'Effect 9 Area'       + ';' +
    'Effect 9 Duration'   + ';' +
    'Effect 10 Name'      + ';' +
    'Effect 10 Magnitude' + ';' +
    'Effect 10 Area'      + ';' +
    'Effect 10 Duration'  + ';' +
    'Effect 11 Name'      + ';' +
    'Effect 11 Magnitude' + ';' +
    'Effect 11 Area'      + ';' +
    'Effect 11 Duration'
  );
  slOutputALCH.Add(
    'File'               + ';' +
    'Record Type'        + ';' +
    'Form ID'            + ';' +
    'Editor ID'          + ';' +
    'Full Name'          + ';' +
    'Weight'             + ';' +
    'Value'              + ';' +
    'Flags'              + ';' +
    'Keyword Count'      + ';' +
    'Keywords'           + ';' +
    'Effect 1 Name'      + ';' +
    'Effect 1 Magnitude' + ';' +
    'Effect 1 Duration'  + ';' +
    'Effect 2 Name'      + ';' +
    'Effect 2 Magnitude' + ';' +
    'Effect 2 Duration'  + ';' +
    'Effect 3 Name'      + ';' +
    'Effect 3 Magnitude' + ';' +
    'Effect 3 Duration'  + ';' +
    'Effect 4 Name'      + ';' +
    'Effect 4 Magnitude' + ';' +
    'Effect 4 Duration'
  );
  slOutputENCH.Add(
    'File'                + ';' +
    'Record Type'         + ';' +
    'Form ID'             + ';' +
    'Editor ID'           + ';' +
    'Full Name'           + ';' +
    'Enchantment Cost'    + ';' +
    'Cast Type'           + ';' +
    'Enchantment Amount'  + ';' +
    'Target Type'         + ';' +
    'Enchantment Type'    + ';' +
    'Charge Time'         + ';' +
    'Base Enchantment'    + ';' +
    'Worn Restrictions'   + ';' +
    'Flags'               + ';' +
    'Effect 1 Name'       + ';' +
    'Effect 1 Magnitude'  + ';' +
    'Effect 1 Area'       + ';' +
    'Effect 1 Duration'   + ';' +
    'Effect 2 Name'       + ';' +
    'Effect 2 Magnitude'  + ';' +
    'Effect 2 Area'       + ';' +
    'Effect 2 Duration'   + ';' +
    'Effect 3 Name'       + ';' +
    'Effect 3 Magnitude'  + ';' +
    'Effect 3 Area'       + ';' +
    'Effect 3 Duration'   + ';' +
    'Effect 4 Name'       + ';' +
    'Effect 4 Magnitude'  + ';' +
    'Effect 4 Area'       + ';' +
    'Effect 4 Duration'   + ';' +
    'Effect 5 Name'       + ';' +
    'Effect 5 Magnitude'  + ';' +
    'Effect 5 Area'       + ';' +
    'Effect 5 Duration'   + ';' +
    'Effect 6 Name'       + ';' +
    'Effect 6 Magnitude'  + ';' +
    'Effect 6 Area'       + ';' +
    'Effect 6 Duration'   + ';' +
    'Effect 7 Name'       + ';' +
    'Effect 7 Magnitude'  + ';' +
    'Effect 7 Area'       + ';' +
    'Effect 7 Duration'   + ';' +
    'Effect 8 Name'       + ';' +
    'Effect 8 Magnitude'  + ';' +
    'Effect 8 Area'       + ';' +
    'Effect 8 Duration'   + ';' +
    'Effect 9 Name'       + ';' +
    'Effect 9 Magnitude'  + ';' +
    'Effect 9 Area'       + ';' +
    'Effect 9 Duration'   + ';' +
    'Effect 10 Name'      + ';' +
    'Effect 10 Magnitude' + ';' +
    'Effect 10 Area'      + ';' +
    'Effect 10 Duration'  + ';' +
    'Effect 11 Name'      + ';' +
    'Effect 11 Magnitude' + ';' +
    'Effect 11 Area'      + ';' +
    'Effect 11 Duration'
  );
  slOutputINGR.Add(
    'File'               + ';' +
    'Record Type'        + ';' +
    'Form ID'            + ';' +
    'Editor ID'          + ';' +
    'Full Name'          + ';' +
    'Value'              + ';' +
    'Weight'             + ';' +
    'Ingredient Value'   + ';' +
    'Keyword Count'      + ';' +
    'Keywords'           + ';' +
    'Effect 1 Name'      + ';' +
    'Effect 1 Magnitude' + ';' +
    'Effect 1 Duration'  + ';' +
    'Effect 2 Name'      + ';' +
    'Effect 2 Magnitude' + ';' +
    'Effect 2 Duration'  + ';' +
    'Effect 3 Name'      + ';' +
    'Effect 3 Magnitude' + ';' +
    'Effect 3 Duration'  + ';' +
    'Effect 4 Name'      + ';' +
    'Effect 4 Magnitude' + ';' +
    'Effect 4 Duration'
  );
  slOutputSPEL.Add(
    'File'               + ';' +
    'Record Type'        + ';' +
    'Form ID'            + ';' +
    'Editor ID'          + ';' +
    'Full Name'          + ';' +
    'Equipment Type'     + ';' +
    'Base Cost'          + ';' +
    'Spell Type'         + ';' +
    'Charge Time'        + ';' +
    'Cast Type'          + ';' +
    'Target Type'        + ';' +
    'Cast Duration'      + ';' +
    'Range'              + ';' +
    'Half-cost Perk'     + ';' +
    'Flags'              + ';' +
    'Effect 1 Name'      + ';' +
    'Effect 1 Magnitude' + ';' +
    'Effect 1 Area'      + ';' +
    'Effect 1 Duration'  + ';' +
    'Effect 2 Name'      + ';' +
    'Effect 2 Magnitude' + ';' +
    'Effect 2 Area'      + ';' +
    'Effect 2 Duration'  + ';' +
    'Effect 3 Name'      + ';' +
    'Effect 3 Magnitude' + ';' +
    'Effect 3 Area'      + ';' +
    'Effect 3 Duration'  + ';' +
    'Effect 4 Name'      + ';' +
    'Effect 4 Magnitude' + ';' +
    'Effect 4 Area'      + ';' +
    'Effect 4 Duration'  + ';' +
    'Effect 5 Name'      + ';' +
    'Effect 5 Magnitude' + ';' +
    'Effect 5 Area'      + ';' +
    'Effect 5 Duration'  + ';' +
    'Effect 6 Name'      + ';' +
    'Effect 6 Magnitude' + ';' +
    'Effect 6 Area'      + ';' +
    'Effect 6 Duration'  + ';' +
    'Effect 7 Name'      + ';' +
    'Effect 7 Magnitude' + ';' +
    'Effect 7 Area'      + ';' +
    'Effect 7 Duration'  + ';' +
    'Effect 8 Name'      + ';' +
    'Effect 8 Magnitude' + ';' +
    'Effect 8 Area'      + ';' +
    'Effect 8 Duration'
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
  sig, formID, editorID, fullName, weight, value, ingredientValue, equipType, enchantCost, castType, enchantAmount, targetType,
  enchantType, chargeTime, baseEnchant, wornRestriction, flags, spellType, cost, range, halfCostPerk,
  castDur, keywordCount, keywords, csvLine: string;
  effectNames: array[1..11] of string;
  effectMagnitudes: array[1..11] of string;
  effectAreas: array[1..11] of string;
  effectDurations: array[1..11] of string;
  effectsElement, singleEffect: IInterface;
  index, maxCount: Integer;
begin

  // Clear effects prior to filling for each record and before any early-returns can reach it.
  for index := 1 to 11 do begin
    effectNames[index] := '';
    effectMagnitudes[index] := '';
    effectAreas[index] := '';
    effectDurations[index] := '';
  end;

  // Grabs winning conflict record.
  if not Equals(e, WinningOverride(e)) then Exit;

  sig                := Signature(e);
  if (sig <> 'ALCH') and (sig <> 'ENCH') and (sig <> 'INGR') and (sig <> 'SPEL') then Exit;

  formID             := '0x' + IntToHex(FixedFormID(e), 8);
  editorID           := GetElementSafe(e,      'EDID - Editor ID');

  if sig = 'ALCH' then begin
    fullName         := GetElementSafe(e,      'FULL - Name');
    if fullName = '' then Exit;

    flags            := GetNamedFlags(e,       'ENIT - Effect Data\Flags');
    weight           := GetElementSafe(e,      'DATA - Weight');
    value            := GetElementSafe(e,      'ENIT - Effect Data\Value');
    ingredientValue  := GetElementSafe(e,      'ENIT - Effect Data\Ingredient Value');
    keywordCount     := GetElementSafe(e,      'KSIZ - Keyword Count');
    keywords         := GetNamedFlags(e,       'KWDA - Keywords');

    maxCount := 4;
  end;


  if sig = 'ENCH' then begin
    fullName         := GetElementSafe(e,      'FULL - Name');
    enchantCost      := GetElementSafe(e,      'ENIT - Effect Data\Enchantment Cost');
    castType         := GetElementSafe(e,      'ENIT - Effect Data\Cast Type');
    enchantAmount    := GetElementSafe(e,      'ENIT - Effect Data\Enchantment Amount');
    targetType       := GetElementSafe(e,      'ENIT - Effect Data\Target Type');
    enchantType      := GetElementSafe(e,      'ENIT - Effect Data\Enchant Type');
    chargeTime       := GetElementSafe(e,      'ENIT - Effect Data\Charge Time');
    baseEnchant      := GetLinkedName(e,       'ENIT - Effect Data\Base Enchantment');
    wornRestriction  := GetElementSafeStrip(e, 'ENIT - Effect Data\Worn Restrictions', 16);
    flags            := GetNamedFlags(e,       'ENIT - Effect Data\Flags');

    maxCount := 11;
  end;


  if sig = 'INGR' then begin
    fullName         := GetElementSafe(e,      'FULL - Name');
    weight           := GetElementSafe(e,      'DATA - DATA\Weight');
    value            := GetElementSafe(e,      'DATA - DATA\Value');
    ingredientValue  := GetElementSafe(e,      'ENIT - Effect Data\Ingredient Value');
    keywordCount     := GetElementSafe(e,      'KSIZ - Keyword Count');
    keywords         := GetNamedFlags(e,       'KWDA - Keywords');

    maxCount := 4;
  end;


  if sig = 'SPEL' then begin
    fullName         := GetElementSafe(e,      'FULL - Name');
    equipType        := GetElementSafeStrip(e, 'ETYP - Equipment Type', 16);
    cost             := GetElementSafe(e,      'SPIT - Data\Base Cost');
    spellType        := GetElementSafe(e,      'SPIT - Data\Type');
    chargeTime       := GetElementSafe(e,      'SPIT - Data\Charge Time');
    castType         := GetElementSafe(e,      'SPIT - Data\Cast Type');
    targetType       := GetElementSafe(e,      'SPIT - Data\Target Type');
    castDur          := GetElementSafe(e,      'SPIT - Data\Cast Duration');
    range            := GetElementSafe(e,      'SPIT - Data\Range');
    halfCostPerk     := GetLinkedName(e,       'SPIT - Data\Half-cost Perk');
    flags            := GetNamedFlags(e,       'SPIT - Data\Flags');

    maxCount := 8;
  end;


  // Populate effect data.
  effectsElement     := ElementByPath(e,       'Effects');
  if Assigned(effectsElement) then begin
    for index := 0 to ElementCount(effectsElement) - 1 do begin
      if index >= maxCount then Break;

      singleEffect := ElementByIndex(effectsElement, index);

      effectNames[index + 1]       := GetLinkedName(singleEffect,  'EFID - Base Effect');
      effectMagnitudes[index + 1]  := GetElementSafe(singleEffect, 'EFIT - EFIT\Magnitude');
      effectAreas[index + 1]       := GetElementSafe(singleEffect, 'EFIT - EFIT\Area');
      effectDurations[index + 1]   := GetElementSafe(singleEffect, 'EFIT - EFIT\Duration');
    end;
  end;


  if USE_MERGED then
    slOutputMerged.Add(
      GetFileName(GetFile(e))     + ';' +
      sig                         + ';' +
      formID                      + ';' +
      EscapeCSV(editorID)         + ';' +
      EscapeCSV(fullName)         + ';' +
      enchantCost                 + ';' +
      EscapeCSV(castType)         + ';' +
      EscapeCSV(targetType)       + ';' +
      EscapeCSV(enchantType)      + ';' +
      EscapeCSV(spellType)        + ';' +
      EscapeCSV(equipType)        + ';' +
      chargeTime                  + ';' +
      EscapeCSV(baseEnchant)      + ';' +
      EscapeCSV(enchantAmount)    + ';' +
      cost                        + ';' +
      value                       + ';' +
      ingredientValue             + ';' +
      weight                      + ';' +
      range                       + ';' +
      castDur                     + ';' +
      EscapeCSV(halfCostPerk)     + ';' +
      EscapeCSV(wornRestriction)  + ';' +
      keywordCount                + ';' +
      EscapeCSV(keywords)         + ';' +
      EscapeCSV(flags)            + ';' +
      EscapeCSV(effectNames[1])   + ';' + effectMagnitudes[1]  + ';' + effectAreas[1]  + ';' + effectDurations[1]  + ';' +
      EscapeCSV(effectNames[2])   + ';' + effectMagnitudes[2]  + ';' + effectAreas[2]  + ';' + effectDurations[2]  + ';' +
      EscapeCSV(effectNames[3])   + ';' + effectMagnitudes[3]  + ';' + effectAreas[3]  + ';' + effectDurations[3]  + ';' +
      EscapeCSV(effectNames[4])   + ';' + effectMagnitudes[4]  + ';' + effectAreas[4]  + ';' + effectDurations[4]  + ';' +
      EscapeCSV(effectNames[5])   + ';' + effectMagnitudes[5]  + ';' + effectAreas[5]  + ';' + effectDurations[5]  + ';' +
      EscapeCSV(effectNames[6])   + ';' + effectMagnitudes[6]  + ';' + effectAreas[6]  + ';' + effectDurations[6]  + ';' +
      EscapeCSV(effectNames[7])   + ';' + effectMagnitudes[7]  + ';' + effectAreas[7]  + ';' + effectDurations[7]  + ';' +
      EscapeCSV(effectNames[8])   + ';' + effectMagnitudes[8]  + ';' + effectAreas[8]  + ';' + effectDurations[8]  + ';' +
      EscapeCSV(effectNames[9])   + ';' + effectMagnitudes[9]  + ';' + effectAreas[9]  + ';' + effectDurations[9]  + ';' +
      EscapeCSV(effectNames[10])  + ';' + effectMagnitudes[10] + ';' + effectAreas[10] + ';' + effectDurations[10] + ';' +
      EscapeCSV(effectNames[11])  + ';' + effectMagnitudes[11] + ';' + effectAreas[11] + ';' + effectDurations[11]
    )
  else begin

    if sig = 'ALCH' then begin
      slOutputALCH.Add(
        GetFileName(GetFile(e))   + ';' +
        sig                       + ';' +
        formID                    + ';' +
        EscapeCSV(editorID)       + ';' +
        fullName                  + ';' +
        weight                    + ';' +
        value                     + ';' +
        EscapeCSV(flags)          + ';' +
        keywordCount              + ';' +
        EscapeCSV(keywords)       + ';' +
        EscapeCSV(effectNames[1]) + ';' + effectMagnitudes[1] + ';' + effectDurations[1] + ';' +
        EscapeCSV(effectNames[2]) + ';' + effectMagnitudes[2] + ';' + effectDurations[2] + ';' +
        EscapeCSV(effectNames[3]) + ';' + effectMagnitudes[3] + ';' + effectDurations[3] + ';' +
        EscapeCSV(effectNames[4]) + ';' + effectMagnitudes[4] + ';' + effectDurations[4]
      );
    end;

    if sig = 'ENCH' then begin
      slOutputENCH.Add(
        GetFileName(GetFile(e))    + ';' +
        sig                        + ';' +
        formID                     + ';' +
        EscapeCSV(editorID)        + ';' +
        EscapeCSV(fullName)        + ';' +
        enchantCost                + ';' +
        EscapeCSV(castType)        + ';' +
        enchantAmount              + ';' +
        EscapeCSV(targetType)      + ';' +
        EscapeCSV(enchantType)     + ';' +
        chargeTime                 + ';' +
        EscapeCSV(baseEnchant)     + ';' +
        EscapeCSV(wornRestriction) + ';' +
        EscapeCSV(flags)           + ';' +
        EscapeCSV(effectNames[1])  + ';' + effectMagnitudes[1]  + ';' + effectAreas[1]  + ';' + effectDurations[1]  + ';' +
        EscapeCSV(effectNames[2])  + ';' + effectMagnitudes[2]  + ';' + effectAreas[2]  + ';' + effectDurations[2]  + ';' +
        EscapeCSV(effectNames[3])  + ';' + effectMagnitudes[3]  + ';' + effectAreas[3]  + ';' + effectDurations[3]  + ';' +
        EscapeCSV(effectNames[4])  + ';' + effectMagnitudes[4]  + ';' + effectAreas[4]  + ';' + effectDurations[4]  + ';' +
        EscapeCSV(effectNames[5])  + ';' + effectMagnitudes[5]  + ';' + effectAreas[5]  + ';' + effectDurations[5]  + ';' +
        EscapeCSV(effectNames[6])  + ';' + effectMagnitudes[6]  + ';' + effectAreas[6]  + ';' + effectDurations[6]  + ';' +
        EscapeCSV(effectNames[7])  + ';' + effectMagnitudes[7]  + ';' + effectAreas[7]  + ';' + effectDurations[7]  + ';' +
        EscapeCSV(effectNames[8])  + ';' + effectMagnitudes[8]  + ';' + effectAreas[8]  + ';' + effectDurations[8]  + ';' +
        EscapeCSV(effectNames[9])  + ';' + effectMagnitudes[9]  + ';' + effectAreas[9]  + ';' + effectDurations[9]  + ';' +
        EscapeCSV(effectNames[10]) + ';' + effectMagnitudes[10] + ';' + effectAreas[10] + ';' + effectDurations[10] + ';' +
        EscapeCSV(effectNames[11]) + ';' + effectMagnitudes[11] + ';' + effectAreas[11] + ';' + effectDurations[11]
      );
    end;

    if sig = 'INGR' then begin
      slOutputINGR.Add(
        GetFileName(GetFile(e))   + ';' +
        sig                       + ';' +
        formID                    + ';' +
        EscapeCSV(editorID)       + ';' +
        EscapeCSV(fullName)       + ';' +
        value                     + ';' +
        weight                    + ';' +
        ingredientValue           + ';' +
        keywordCount              + ';' +
        EscapeCSV(keywords)       + ';' +
        EscapeCSV(effectNames[1]) + ';' + effectMagnitudes[1] + ';' + effectDurations[1] + ';' +
        EscapeCSV(effectNames[2]) + ';' + effectMagnitudes[2] + ';' + effectDurations[2] + ';' +
        EscapeCSV(effectNames[3]) + ';' + effectMagnitudes[3] + ';' + effectDurations[3] + ';' +
        EscapeCSV(effectNames[4]) + ';' + effectMagnitudes[4] + ';' + effectDurations[4]
      );
    end;

    if sig = 'SPEL' then begin
      slOutputSPEL.Add(
        GetFileName(GetFile(e))   + ';' +
        sig                       + ';' +
        formID                    + ';' +
        EscapeCSV(editorID)       + ';' +
        EscapeCSV(fullName)       + ';' +
        EscapeCSV(equipType)      + ';' +
        cost                      + ';' +
        EscapeCSV(spellType)      + ';' +
        chargeTime                + ';' +
        EscapeCSV(castType)       + ';' +
        EscapeCSV(targetType)     + ';' +
        castDur                   + ';' +
        range                     + ';' +
        EscapeCSV(halfCostPerk)   + ';' +
        EscapeCSV(flags)          + ';' +
        EscapeCSV(effectNames[1]) + ';' + effectMagnitudes[1] + ';' + effectAreas[1] + ';' + effectDurations[1] + ';' +
        EscapeCSV(effectNames[2]) + ';' + effectMagnitudes[2] + ';' + effectAreas[2] + ';' + effectDurations[2] + ';' +
        EscapeCSV(effectNames[3]) + ';' + effectMagnitudes[3] + ';' + effectAreas[3] + ';' + effectDurations[3] + ';' +
        EscapeCSV(effectNames[4]) + ';' + effectMagnitudes[4] + ';' + effectAreas[4] + ';' + effectDurations[4] + ';' +
        EscapeCSV(effectNames[5]) + ';' + effectMagnitudes[5] + ';' + effectAreas[5] + ';' + effectDurations[5] + ';' +
        EscapeCSV(effectNames[6]) + ';' + effectMagnitudes[6] + ';' + effectAreas[6] + ';' + effectDurations[6] + ';' +
        EscapeCSV(effectNames[7]) + ';' + effectMagnitudes[7] + ';' + effectAreas[7] + ';' + effectDurations[7] + ';' +
        EscapeCSV(effectNames[8]) + ';' + effectMagnitudes[8] + ';' + effectAreas[8] + ';' + effectDurations[8]
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
    slOutputALCH.SaveToFile(csvPathALCH);
    slOutputENCH.SaveToFile(csvPathENCH);
    slOutputINGR.SaveToFile(csvPathINGR);
    slOutputSPEL.SaveToFile(csvPathSPEL);
  end;

  slOutputMerged.Free;
  slOutputALCH.Free;
  slOutputENCH.Free;
  slOutputINGR.Free;
  slOutputSPEL.Free;

end;

end.

