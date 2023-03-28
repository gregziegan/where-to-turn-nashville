const fetch = require("node-fetch");

const SHEETS_BASE = "https://sheets.googleapis.com/v4/spreadsheets"

const GOOGLE_API_KEY = process.env['GOOGLE_API_KEY'];
const ID = process.env['DB_ID'];
const ENVIRONMENT = process.env['ENV'];

const servicesRange = ENVIRONMENT == 'ci' ? 'A2:H2' : 'A2:H'
const organizationsRange = ENVIRONMENT == 'ci' ? 'A2:M2' : 'A2:M'

const sheetUrl = (sheetId, selection, apiKey) =>
    `${SHEETS_BASE}/${ID}/values/${sheetId}!${selection}?key=${apiKey}&valueRenderOption=UNFORMATTED_VALUE`

module.exports =
/**
 * @param { unknown } fromElm
 * @returns { Promise<unknown> }
 */
{
    services: async function (args) {
        return fetch(sheetUrl('Services', servicesRange, GOOGLE_API_KEY))
            .then(response => response.json());
    },
    organizations: async function (args) {
        return fetch(sheetUrl('Organizations', organizationsRange, GOOGLE_API_KEY))
            .then(response => response.json());
    },
    mapUrl: async function (address) {
        return `https://www.google.com/maps/embed/v1/place?key=${GOOGLE_API_KEY}&q=${address}`;
    }
}