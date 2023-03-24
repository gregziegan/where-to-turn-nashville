const fetch = require("node-fetch");

const SHEETS_BASE = "https://sheets.googleapis.com/v4/spreadsheets"
const ID = "1TQh_ZpY9Afz1sx7jfVLOXpGXvfvXAGmpQ9k0qP-zyvM"

const sheetUrl = (sheetId, selection, apiKey) =>
    `${SHEETS_BASE}/${ID}/values/${sheetId}!${selection}?key=${apiKey}&valueRenderOption=UNFORMATTED_VALUE`

const GOOGLE_API_KEY = process.env['GOOGLE_API_KEY'];

module.exports =
/**
 * @param { unknown } fromElm
 * @returns { Promise<unknown> }
 */
{
    services: async function (args) {
        return fetch(sheetUrl('Services', 'A2:H', GOOGLE_API_KEY))
            .then(response => response.json());
    },
    organizations: async function (args) {
        return fetch(sheetUrl('Organizations', 'A2:M', GOOGLE_API_KEY))
            .then(response => response.json());
    }
}