require 'pp'

class OsGridRef
  def initialize(easting, northing)
    @easting = easting
    @northing = northing
  end

  def airy1830_latitude
    # Airy 1830 major & minor semi-axes
    a = 6377563.396
    b = 6356256.910

    # NatGrid scale factor on central meridian
    f0 = 0.9996012717

    # NatGrid true origin
    lat0 = 49*Math::PI/180
    lon0 = -2*Math::PI/180

    # Northing & easting of true origin, metres
    n0 = -100000
    e0 = 400000

    # eccentricity squared
    e2 = 1 - (b*b)/(a*a)

    n = (a-b)/(a+b)
    n2 = n*n
    n3 = n*n*n

    lat = lat0
    m=0
    begin
      lat = (@northing-n0-m)/(a*f0) + lat

      ma = (1 + n + (5.to_f/4)*n2 + (5.to_f/4)*n3) * (lat-lat0)
      mb = (3*n + 3*n*n + (21.to_f/8)*n3) * Math.sin(lat-lat0) * Math.cos(lat+lat0)
      mc = ((15.to_f/8)*n2 + (15/8)*n3) * Math.sin(2*(lat-lat0)) * Math.cos(2*(lat+lat0))
      md = (35.to_f/24)*n3 * Math.sin(3*(lat-lat0)) * Math.cos(3*(lat+lat0))
      m = b * f0 * (ma - mb + mc - md) # meridional arc
    end while (@northing-n0-m >= 0.00001) # until error is < 0.01mm

    lat
  end
end
