module Spreadsheet exposing (url)


id : String
id =
    "1TQh_ZpY9Afz1sx7jfVLOXpGXvfvXAGmpQ9k0qP-zyvM"


base : String
base =
    "https://sheets.googleapis.com/v4/spreadsheets"


url : String -> String -> String -> String
url sheetId selection apiKey =
    base ++ "/" ++ id ++ "/values/" ++ sheetId ++ "!" ++ selection ++ "?key=" ++ apiKey ++ "&valueRenderOption=UNFORMATTED_VALUE"
