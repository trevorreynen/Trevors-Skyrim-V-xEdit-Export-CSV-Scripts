{
  Trevors Skyrim V Exports - Books, Recipes (Contructible Objects), Misc, Relationships, Shouts
  Exports all (conflict-winning) BOOK, COBJ, MISC, RELA, SHOU records to a semicolon-delimited CSV.
  Books: Book Text is currently commented out but can be uncomment if wanted (untested but should be fine).
  Relationships: This only exports NPC to NPC relationships. Doesn't include data about player related relationships.
}

unit TrevorsSkyrimVExports_BooksRecipesMiscRelationshipsShouts;

var
  slOutputBOOK, slOutputCOBJ, slOutputMISC, slOutputRELA, slOutputSHOU: TStringList;
  csvPathBOOK, csvPathCOBJ, csvPathMISC, csvPathRELA, csvPathSHOU: string;
  maxCOBJItems: Integer;
  EXPORT_BOOKS, EXPORT_RECIPES, EXPORT_MISC, EXPORT_RELATIONSHIPS, EXPORT_SHOUTS: Boolean;

// ==================================================

function Initialize: Integer;
begin

  //! Important: These are True/False flags to create the csv for the corresponding record type (True) or skip it (False).
  EXPORT_BOOKS         := True;
  EXPORT_RECIPES       := True;
  EXPORT_MISC          := True;
  EXPORT_RELATIONSHIPS := True;
  EXPORT_SHOUTS        := True;

  slOutputBOOK := TStringList.Create;
  slOutputCOBJ := TStringList.Create;
  slOutputMISC := TStringList.Create;
  slOutputRELA := TStringList.Create;
  slOutputSHOU := TStringList.Create;

  // If this value is ever changes, must manually edit headers.
  maxCOBJItems := 7;

  // Set the csv names.
  csvPathBOOK := ProgramPath + 'TrevorsSkyrimVExports_Books.csv';
  csvPathCOBJ := ProgramPath + 'TrevorsSkyrimVExports_Recipes.csv';
  csvPathMISC := ProgramPath + 'TrevorsSkyrimVExports_Misc.csv';
  csvPathRELA := ProgramPath + 'TrevorsSkyrimVExports_Relationships.csv';
  csvPathSHOU := ProgramPath + 'TrevorsSkyrimVExports_Shouts.csv';

  // Set the csv headers.
  slOutputBOOK.Add(
    'File'          + ';' +
    'Record Type'   + ';' +
    'Form ID'       + ';' +
    'Editor ID'     + ';' +
    'Full Name'     + ';' +
    'Skill'         + ';' +
    'Value'         + ';' +
    'Weight'        + ';' +
    'Flags'         + ';' +
    'Description'   + ';' +
    'Keyword Count' + ';' +
    'Keywords'//      + ';' +
    //'Book Text'
  );
  slOutputCOBJ.Add(
    'File'         + ';' +
    'Record Type'  + ';' +
    'Form ID'      + ';' +
    'Editor ID'    + ';' +
    'COBJ Name'    + ';' +
    'Workbench'    + ';' +
    'COBJ Count'   + ';' +
    'Item Count'   + ';' +
    'Item 1'       + ';' +
    'Item 1 Count' + ';' +
    'Item 2'       + ';' +
    'Item 2 Count' + ';' +
    'Item 3'       + ';' +
    'Item 3 Count' + ';' +
    'Item 4'       + ';' +
    'Item 4 Count' + ';' +
    'Item 5'       + ';' +
    'Item 5 Count' + ';' +
    'Item 6'       + ';' +
    'Item 6 Count' + ';' +
    'Item 7'       + ';' +
    'Item 7 Count'
  );
  slOutputMISC.Add(
    'File'          + ';' +
    'Record Type'   + ';' +
    'Form ID'       + ';' +
    'Editor ID'     + ';' +
    'Full Name'     + ';' +
    'Value'         + ';' +
    'Weight'        + ';' +
    'Keyword Count' + ';' +
    'Keywords'
  );
  slOutputRELA.Add(
    'File'          + ';' +
    'Record Type'   + ';' +
    'Form ID'       + ';' +
    'Editor ID'     + ';' +
    'Parent'        + ';' +
    'Child'         + ';' +
    'Rank'          + ';' +
    'Secret (Flag)' + ';' +
    'Association Type'
  );
  slOutputSHOU.Add(
    'File'                 + ';' +
    'Record Type'          + ';' +
    'Form ID'              + ';' +
    'Editor ID'            + ';' +
    'Full Name'            + ';' +
    'Word 1 Word'          + ';' +
    'Word 1 Spell'         + ';' +
    'Word 1 Recovery Time' + ';' +
    'Word 2 Word'          + ';' +
    'Word 2 Spell'         + ';' +
    'Word 2 Recovery Time' + ';' +
    'Word 3 Word'          + ';' +
    'Word 3 Spell'         + ';' +
    'Word 3 Recovery Time' + ';' +
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
    if (slotName = 'Unknown 8') or (slotName = 'Unknown 12') then
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

  // Replace line breaks with a space (or anything neutral)
  s := StringReplace(s, #13, ' ', [rfReplaceAll]); // Carriage Return
  s := StringReplace(s, #10, ' ', [rfReplaceAll]); // Line Feed

  // Escape double quotes by doubling them
  s := StringReplace(s, '"', '""', [rfReplaceAll]);

  if (Pos(',', s) > 0) or (Pos(';', s) > 0) then
    Result := '"' + s + '"'
  else
    Result := s;

end;

// ==================================================


function Process(e: IInterface): Integer;
var
  sig, formID, editorID: string;
  fullName, skill, value, weight, flags, description, keywordCount, keywords, bookText: string;
  cobjName, workbench, cobjCount, itemCount: string;
  parent, child, rank, secret, associationType: string;
  itemNames: array[1..7] of string;
  itemCounts: array[1..7] of string;
  itemsElement, singleItem, itemEntry: IInterface;
  itemIndex, itemCountInt: integer;
  spellWords: array[1..3] of string;
  spellSpells: array[1..3] of string;
  spellRecoveryTimes: array[1..3] of string;
  spellsElement, singleSpell, spellEntry: IInterface;
  spellIndex, spellCountInt: integer;
begin

  // Grabs winning conflict record.
  if not Equals(e, WinningOverride(e)) then Exit;

  sig                              := Signature(e);
  if (sig <> 'BOOK') and (sig <> 'COBJ') and (sig <> 'MISC') and (sig <> 'RELA') and (sig <> 'SHOU') then Exit;

  formID                           := '0x' + IntToHex(FixedFormID(e), 8);
  editorID                         := GetElementSafe(e,              'EDID - Editor ID');
  fullName                         := GetElementSafe(e,              'FULL - Name');


  if (sig = 'BOOK') then begin

    if (fullName = '') then Exit;
    if (editorID = 'QABook') or (editorID = 'QAbookFrench') or (editorID = 'QAbookgerman') or (editorID = 'QABookItalian') or (editorID = 'QABookSpanish') then Exit;

    skill                          := GetElementSafe(e,              'DATA - Data\Skill');
    value                          := GetElementSafe(e,              'DATA - Data\Value');
    weight                         := GetElementSafe(e,              'DATA - Data\Weight');
    flags                          := GetNamedFlags(e,               'DATA - Data\Flags');
    description                    := GetElementSafe(e,              'CNAM - Description');
    keywordCount                   := GetElementSafe(e,              'KSIZ - Keyword Count');
    keywords                       := GetNamedFlags(e,               'KWDA - Keywords');
    //bookText                       := GetElementSafe(e,              'DESC - Book Text');

  end;


  if (sig = 'COBJ') then begin

    cobjName                       := GetLinkedName(e,               'CNAM - Created Object');
    workbench                      := GetElementSafe(e,              'BNAM - Workbench Keyword');
    if Length(workbench) > 16 then
      workbench := Copy(workbench, 1, Length(workbench) - 16);

    cobjCount                      := GetElementSafe(e,              'NAM1 - Created Object Count');
    itemCount                      := GetElementSafe(e,              'COCT - Count');
    if (Trim(itemCount) = '') or (StrToIntDef(itemCount, 0) = 0) then begin
      if not SameText(cobjName, 'Blade of Woe') then
        Exit;
    end;

    itemsElement                   := ElementByName(e,               'Items');
    if Assigned(itemsElement) then begin
      itemCountInt := Min(ElementCount(itemsElement), maxCOBJItems);

      for itemIndex := 0 to itemCountInt - 1 do begin
        if itemIndex >= maxCOBJItems then Break;

        singleItem := ElementByIndex(itemsElement, itemIndex);
        itemEntry                  := ElementBySignature(singleItem, 'CNTO');

        itemNames[itemIndex + 1]   := GetLinkedName(itemEntry,       'Item');
        itemCounts[itemIndex + 1]  := GetElementSafe(itemEntry,      'Count');
      end;
    end;

  end;


  if (sig = 'MISC') then begin

    if (fullName = '') then Exit;

    value                          := GetElementSafe(e,              'DATA - Data\Value');
    weight                         := GetElementSafe(e,              'DATA - Data\Weight');
    keywordCount                   := GetElementSafe(e,              'KSIZ - Keyword Count');
    keywords                       := GetNamedFlags(e,               'KWDA - Keywords');

  end;


  if (sig = 'RELA') then begin

    parent                         := GetLinkedName(e,               'DATA - Data\Parent');
    child                          := GetLinkedName(e,               'DATA - Data\Child');
    rank                           := GetElementSafe(e,              'DATA - Data\Rank');
    secret                         := GetNamedFlags(e,               'DATA - Data\Flags');
    associationType                := GetElementSafeStrip(e,         'DATA - Data\Association Type', 16);

  end;


  if (sig = 'SHOU') then begin

    description                    := GetElementSafe(e,              'DESC - Description');
    spellsElement                  := ElementByPath(e,               'Words of Power');
    if Assigned(spellsElement) then begin
      spellCountInt := ElementCount(spellsElement);

      for spellIndex := 0 to spellCountInt - 1 do begin
        if spellIndex >= 3 then Break;

        singleSpell := ElementByIndex(spellsElement, spellIndex);

        spellWords[spellIndex + 1]          := GetLinkedName(singleSpell,  'Word');
        spellSpells[spellIndex + 1]         := GetLinkedName(singleSpell,  'Spell');
        spellRecoveryTimes[spellIndex + 1]  := GetElementSafe(singleSpell, 'Recovery Time');
      end;
    end;

  end;


  if (sig = 'BOOK') and EXPORT_BOOKS then
    slOutputBOOK.Add(
      GetFileName(GetFile(e)) + ';' +
      sig                     + ';' +
      formID                  + ';' +
      EscapeCSV(editorID)     + ';' +
      EscapeCSV(fullName)     + ';' +
      EscapeCSV(skill)        + ';' +
      value                   + ';' +
      weight                  + ';' +
      EscapeCSV(flags)        + ';' +
      EscapeCSV(description)  + ';' +
      keywordCount            + ';' +
      EscapeCSV(keywords)//     + ';' +
      //EscapeCSV(bookText)
    );

  if (sig = 'COBJ') and EXPORT_RECIPES then
    slOutputCOBJ.Add(
      GetFileName(GetFile(e)) + ';' +
      sig                     + ';' +
      formID                  + ';' +
      EscapeCSV(editorID)     + ';' +
      EscapeCSV(cobjName)     + ';' +
      EscapeCSV(workbench)    + ';' +
      cobjCount               + ';' +
      itemCount               + ';' +
      EscapeCSV(itemNames[1]) + ';' + itemCounts[1] + ';' +
      EscapeCSV(itemNames[2]) + ';' + itemCounts[2] + ';' +
      EscapeCSV(itemNames[3]) + ';' + itemCounts[3] + ';' +
      EscapeCSV(itemNames[4]) + ';' + itemCounts[4] + ';' +
      EscapeCSV(itemNames[5]) + ';' + itemCounts[5] + ';' +
      EscapeCSV(itemNames[6]) + ';' + itemCounts[6] + ';' +
      EscapeCSV(itemNames[7]) + ';' + itemCounts[7]
    );

  if (sig = 'MISC') and EXPORT_MISC then
    slOutputMISC.Add(
      GetFileName(GetFile(e)) + ';' +
      sig                     + ';' +
      formID                  + ';' +
      EscapeCSV(editorID)     + ';' +
      EscapeCSV(fullName)     + ';' +
      value                   + ';' +
      weight                  + ';' +
      keywordCount            + ';' +
      EscapeCSV(keywords)
    );

  if (sig = 'RELA') and EXPORT_RELATIONSHIPS then
    slOutputRELA.Add(
      GetFileName(GetFile(e)) + ';' +
      sig                     + ';' +
      formID                  + ';' +
      EscapeCSV(editorID)     + ';' +
      EscapeCSV(parent)       + ';' +
      EscapeCSV(child)        + ';' +
      EscapeCSV(rank)         + ';' +
      EscapeCSV(secret)       + ';' +
      EscapeCSV(associationType)
    );

  if (sig = 'SHOU') and EXPORT_SHOUTS then
    slOutputSHOU.Add(
      GetFileName(GetFile(e))  + ';' +
      sig                      + ';' +
      formID                   + ';' +
      EscapeCSV(editorID)      + ';' +
      EscapeCSV(fullName)      + ';' +
      EscapeCSV(spellWords[1]) + ';' + EscapeCSV(spellSpells[1]) + ';' + spellRecoveryTimes[1] + ';' +
      EscapeCSV(spellWords[2]) + ';' + EscapeCSV(spellSpells[2]) + ';' + spellRecoveryTimes[2] + ';' +
      EscapeCSV(spellWords[3]) + ';' + EscapeCSV(spellSpells[3]) + ';' + spellRecoveryTimes[3] + ';' +
      EscapeCSV(description)
    );

end;

// ==================================================

function Finalize: Integer;
begin

  if EXPORT_BOOKS then
    slOutputBOOK.SaveToFile(csvPathBOOK);

  if EXPORT_RECIPES then
    slOutputCOBJ.SaveToFile(csvPathCOBJ);

  if EXPORT_MISC then
    slOutputMISC.SaveToFile(csvPathMISC);

  if EXPORT_RELATIONSHIPS then
    slOutputRELA.SaveToFile(csvPathRELA);

  if EXPORT_SHOUTS then
    slOutputSHOU.SaveToFile(csvPathSHOU);

  slOutputBOOK.Free;
  slOutputCOBJ.Free;
  slOutputMISC.Free;
  slOutputRELA.Free;
  slOutputSHOU.Free;

end;

end.

