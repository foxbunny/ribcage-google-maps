# # gmaps shim
#
# When working with RequireJS and Ribcage-Google-Maps, you will need to make
# adjustments to your RequireJS configurations as well as build profile. This
# is due to the way Google Maps API library is loaded. On the other hand, this
# also presents an opportunity to configure the API key which cannot be
# otherwise set at runtime, and therefore Ribcage-Google-Maps cannot support
# setting.
#
# Here is an example of a 'gmaps' shim for RequireJS:
#
#     shim: {
#       'ribcage-google-maps/gmaps': {
#         deps: ['async!http://maps.google.com/maps/api/js?sensor=false'],
#         exports: 'google.maps'
#       }
#     }
#
# When building, the shimmed 'gmap' module should be excluded to prevent
# errors:
#
#     "modules": [
#       {
#         "name": "main",
#         "exclude": ["ribcage-google-maps/gmaps"]
#       }
#     ]
#
# The `lib` directory contains a `gmaps.js` module which is an empty JS file
# used to make the above shimming work.
#
# After the shim is in place, the `gmaps` module is required as:
#
#     var maps = require('ribcage-google-maps/gmaps');
#
# The `maps` variable should be the same as `google.maps`. All
# Ribcage-Google-Maps modules require `gmaps` module to get access to the
# Google Maps API library, so shimming it correctly is essential.
#
