module Spreadsheet exposing (url)


id : String
id =
    "10tGJn9MCEJ10CraGIf7HP57phJ4FF5Jkw--JwOmkvA0"


base : String
base =
    "https://sheets.googleapis.com/v4/spreadsheets"


url : String -> String -> String -> String
url sheetId selection apiKey =
    base ++ "/" ++ id ++ "/values/" ++ sheetId ++ "!" ++ selection ++ "?key=" ++ apiKey ++ "&valueRenderOption=UNFORMATTED_VALUE"
