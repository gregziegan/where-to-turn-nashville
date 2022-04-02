const fetch = require("node-fetch");

const SHEETS_BASE = "https://sheets.googleapis.com/v4/spreadsheets"
const ID = "10tGJn9MCEJ10CraGIf7HP57phJ4FF5Jkw--JwOmkvA0"

const sheetUrl = (sheetId, selection, apiKey) =>
    `${SHEETS_BASE}/${ID}/values/${sheetId}!${selection}?key=${apiKey}&valueRenderOption=UNFORMATTED_VALUE`

const GOOGLE_API_KEY = process.env['GOOGLE_API_KEY'];

const SPREADSHEET_RANGE = 'A2:P'

module.exports =
/**
 * @param { unknown } fromElm
 * @returns { Promise<unknown> }
 */
{
    services: async function (args) {
        return fetch(sheetUrl('Services', SPREADSHEET_RANGE, GOOGLE_API_KEY))
            .then(response => response.json());
    },
    organizations: async function (args) {
        return fetch(sheetUrl('Organizations', SPREADSHEET_RANGE, GOOGLE_API_KEY))
            .then(response => response.json());
    }
}