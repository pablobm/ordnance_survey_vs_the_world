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

#    def to_latlon
#      cosLat = Math.cos(lat)
#      sinLat = Math.sin(lat)
#      nu = a*F0/Math.sqrt(1-e2*sinLat*sinLat)              # transverse radius of curvature
#      rho = a*F0*(1-e2)/Math.pow(1-e2*sinLat*sinLat, 1.5)  # meridional radius of curvature
#      eta2 = nu/rho-1
#
#      tanLat = Math.tan(lat)
#      tan2lat = tanLat*tanLat
#      tan4lat = tan2lat*tan2lat
#      tan6lat = tan4lat*tan2lat
#      secLat = 1/cosLat
#      nu3 = nu*nu*nu
#      nu5 = nu3*nu*nu
#      nu7 = nu5*nu*nu
#      VII = tanLat/(2*rho*nu)
#      VIII = tanLat/(24*rho*nu3)*(5+3*tan2lat+eta2-9*tan2lat*eta2)
#      IX = tanLat/(720*rho*nu5)*(61+90*tan2lat+45*tan4lat)
#      X = secLat/nu
#      XI = secLat/(6*nu3)*(nu/rho+2*tan2lat)
#      XII = secLat/(120*nu5)*(5+28*tan2lat+24*tan4lat)
#      XIIA = secLat/(5040*nu7)*(61+662*tan2lat+1320*tan4lat+720*tan6lat)
#
#      dE = (E-E0)
#      dE2 = dE*dE
#      dE3 = dE2*dE
#      dE4 = dE2*dE2
#      dE5 = dE3*dE2
#      dE6 = dE4*dE2
#      dE7 = dE5*dE2
#      lat = lat - VII*dE2 + VIII*dE4 - IX*dE6;
#      lon = lon0 + X*dE - XI*dE3 + XII*dE5 - XIIA*dE7
#
#      return new LatLon(lat.toDeg(), lon.toDeg());
#    end

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
  end
end
