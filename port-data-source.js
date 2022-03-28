const fetch = require("node-fetch");

const SHEETS_BASE = "https://sheets.googleapis.com/v4/spreadsheets"
const ID = "10tGJn9MCEJ10CraGIf7HP57phJ4FF5Jkw--JwOmkvA0"

const sheetUrl = (sheetId, selection, apiKey) =>
    `${SHEETS_BASE}/${ID}/values/${sheetId}!${selection}?key=${apiKey}&valueRenderOption=UNFORMATTED_VALUE`

const GOOGLE_API_KEY = process.env['GOOGLE_API_KEY'];

const SPREADSHEET_RANGE = 'A2:P'

var servicesSheet; 
var organizationsSheet;
var searchIndex = null;

function fetchSheet(sheetId) {
    return fetch(sheetUrl(sheetId, SPREADSHEET_RANGE, GOOGLE_API_KEY))
            .then(response => response.json());
}

function findById(id, sheet) {
    return sheet['values'].filter(s => s[0] == id)[0];
}

module.exports =
/**
 * @param { unknown } fromElm
 * @returns { Promise<unknown> }
 */
{
    searchIndex: async function (index) {
        if (index == null && searchIndex == null) {
            return null;
        } else if (index == null) {
            return searchIndex;
        } else {
            searchIndex = index;
            return searchIndex;
        }
    },
    services: async function (args) {
        if (servicesSheet) {
            return servicesSheet;
        } else {
            return fetchSheet('Services').then(sheet => {
                servicesSheet = sheet;
                return servicesSheet;
            });
        }
    },
    service: async function (serviceId) {
        if (servicesSheet) {
            return findById(serviceId, servicesSheet);
        } else {
            return fetchSheet('Services').then(sheet => {
                servicesSheet = sheet;
                return findById(serviceId, servicesSheet);
            });
        }
    },
    organizations: async function (args) {
        if (organizationsSheet) {
            return organizationsSheet;
        } else {
            return fetchSheet('Organizations').then(sheet => {
                organizationsSheet = sheet;
                return organizationsSheet;
            });
        }
    },
    organization: async function (orgId) {
        if (organizationsSheet) {
            return findById(orgId, organizationsSheet);
        } else {
            return fetchSheet('Organizations').then(sheet => {
                organizationsSheet = sheet;
                return findById(orgId, organizationsSheet);
            });
        }
    },
}