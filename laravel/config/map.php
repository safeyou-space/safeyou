<?php

return [

    /*
     * Link to a location on a map, used in emergency help SMS and emails.
     * {lat} and {lng} are replaced with the coordinates.
     * Any map service can be used; the default is OpenStreetMap.
     */
    'link_template' => env('MAP_LINK_TEMPLATE', 'https://www.openstreetmap.org/?mlat={lat}&mlon={lng}#map=16/{lat}/{lng}'),

];
