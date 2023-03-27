module Spreadsheet exposing (fromSecrets)

import Pages.Secrets as Secrets


fromSecrets : String -> String -> Secrets.Value String
fromSecrets sheetId selection =
    Secrets.succeed
        (\id env apiKey -> url { environment = env, apiKey = apiKey, id = id, sheetId = sheetId, selection = selection })
        |> Secrets.with "DB_ID"
        |> Secrets.with "ENV"
        |> Secrets.with "GOOGLE_API_KEY"


base : String
base =
    "https://sheets.googleapis.com/v4/spreadsheets"


selectionFromEnv : String -> String -> String
selectionFromEnv environment selection =
    selection
        ++ (if environment == "ci" then
                "2"

            else
                ""
           )


url :
    { id : String
    , sheetId : String
    , selection : String
    , apiKey : String
    , environment : String
    }
    -> String
url { environment, apiKey, id, sheetId, selection } =
    let
        range : String
        range =
            selectionFromEnv environment selection
    in
    base ++ "/" ++ id ++ "/values/" ++ sheetId ++ "!" ++ range ++ "?key=" ++ apiKey ++ "&valueRenderOption=UNFORMATTED_VALUE"
