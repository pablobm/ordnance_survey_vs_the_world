# Extracted from code by Chris Veness, who kindly published it under
# the CC-BY license (http://creativecommons.org/licenses/by/3.0/) with
# the request that the below copyright notice is retained.
#
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#  ordnance survey grid reference functions  (c) chris veness 2005-2012
#   - www.movable-type.co.uk/scripts/gridref.js
#   - www.movable-type.co.uk/scripts/latlon-gridref.html
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

require 'ordnance_survey_vs_the_world/lat_lon'

module OrdnanceSurveyVsTheWorld
  class OsGridRef
    # Airy 1830 major & minor semi-axes
    A = 6377563.396
    B = 6356256.910

    # eccentricity squared
    E2 = 1 - (B*B)/(A*A)
    N = (A-B)/(A+B)
    N2 = N*N
    N3 = N*N*N

    # NatGrid scale factor on central meridian
    F0 = 0.9996012717

    # NatGrid true origin
    LAT_0 = 49*Math::PI/180
    LON_0 = -2*Math::PI/180

    # Northing & easting of true origin, metres
    N0 = -100000
    E0 =  400000

    def initialize(easting, northing)
      @easting = easting
      @northing = northing
    end

    def to_latlon
      lat = airy1830_latitude

      cosLat = Math.cos(lat)
      sinLat = Math.sin(lat)
      nu = A*F0/Math.sqrt(1-E2*sinLat*sinLat)              # transverse radius of curvature
      rho = A*F0*(1-E2)/((1-E2*sinLat*sinLat)**1.5)  # meridional radius of curvature
      eta2 = nu/rho-1

      tanLat = Math.tan(lat)
      tan2lat = tanLat*tanLat
      tan4lat = tan2lat*tan2lat
      tan6lat = tan4lat*tan2lat
      secLat = 1/cosLat
      nu3 = nu*nu*nu
      nu5 = nu3*nu*nu
      nu7 = nu5*nu*nu
      vii = tanLat/(2*rho*nu)
      viii = tanLat/(24*rho*nu3)*(5+3*tan2lat+eta2-9*tan2lat*eta2)
      ix = tanLat/(720*rho*nu5)*(61+90*tan2lat+45*tan4lat)
      x = secLat/nu
      xi = secLat/(6*nu3)*(nu/rho+2*tan2lat)
      xii = secLat/(120*nu5)*(5+28*tan2lat+24*tan4lat)
      xiia = secLat/(5040*nu7)*(61+662*tan2lat+1320*tan4lat+720*tan6lat)

      dE = (@easting-E0)
      dE2 = dE*dE
      dE3 = dE2*dE
      dE4 = dE2*dE2
      dE5 = dE3*dE2
      dE6 = dE4*dE2
      dE7 = dE5*dE2
      lat = lat - vii*dE2 + viii*dE4 - ix*dE6;
      lon = LON_0 + x*dE - xi*dE3 + xii*dE5 - xiia*dE7

      LatLon.new(rad_to_deg(lat), rad_to_deg(lon));
    end

    def airy1830_latitude
      lat = LAT_0
      m=0
      begin
        lat = (@northing-N0-m)/(A*F0) + lat

        ma = (1 + N + (5.to_f/4)*N2 + (5.to_f/4)*N3) * (lat-LAT_0)
        mb = (3*N + 3*N*N + (21.to_f/8)*N3) * Math.sin(lat-LAT_0) * Math.cos(lat+LAT_0)
        mc = ((15.to_f/8)*N2 + (15/8)*N3) * Math.sin(2*(lat-LAT_0)) * Math.cos(2*(lat+LAT_0))
        md = (35.to_f/24)*N3 * Math.sin(3*(lat-LAT_0)) * Math.cos(3*(lat+LAT_0))
        m = B * F0 * (ma - mb + mc - md) # meridional arc
      end while (@northing-N0-m >= 0.00001) # until error is < 0.01mm

      lat
    end

    private

    def rad_to_deg(rad)
      rad * 180 / Math::PI
    end

  end
end
