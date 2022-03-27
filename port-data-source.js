const fetch = require("node-fetch");

const SHEETS_BASE = "https://sheets.googleapis.com/v4/spreadsheets"
const ID = "10tGJn9MCEJ10CraGIf7HP57phJ4FF5Jkw--JwOmkvA0"

const sheetUrl = (sheetId, selection, apiKey) =>
    `${SHEETS_BASE}/${ID}/values/${sheetId}!${selection}?key=${apiKey}&valueRenderOption=UNFORMATTED_VALUE`

module.exports =
/**
 * @param { unknown } fromElm
 * @returns { Promise<unknown> }
 */
{
    services: async function (args) {
        console.log('services')
        const token = process.env['GOOGLE_API_TOKEN'];
        return fetch(sheetUrl('Services', 'A2:P', token))
            .then(response => response.json());
    },
    organizations: async function (args) {
        const token = process.env['GOOGLE_API_TOKEN'];
        return fetch(sheetUrl('Organizations', 'A2:P', token))
            .then(response => response.json());
    }
}