# Ordnance Survey vs. The World

This little gem converts from the Bristish Ordnance Survey's own
easting/northing OSGB-36 coordinates to the WGS-84 latitude/longitude
we have come to know and love (and is used thoroughly in GPS,
Google Maps and all that stuff).

# How to use

    easting = 531182
    northing = 182409
    gr = OrdnanceSurveyVsTheWorld::OSGridRef.new(easting, northing)
    ll = gr.to_latlon
    ll.lat # =>  51.5248579430871
    ll.lon # => -0.108828758467826

# Why the long names?

Was feeling like it.

# License

Public Domain for yeah!
