module Phone exposing (format, valid)

import Mask
import PhoneNumber exposing (ValidationConfig)
import PhoneNumber.Countries as Countries


format : String -> String
format phone =
    Mask.number "(###) ###-####" phone


config : ValidationConfig
config =
    { defaultCountry = Countries.countryUS
    , otherCountries = []
    , types = PhoneNumber.anyType
    }


valid : String -> Bool
valid phone =
    PhoneNumber.valid config phone
