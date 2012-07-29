require 'test/unit'
require 'test/unit/assertions'
require 'os_grid_ref'

class OsGridRefTest < Test::Unit::TestCase
  def airy_lat(easting, northing)
    OsGridRef.new(easting, northing).airy1830_latitude
  end

  def test_airy1830_latitude
    assert_in_delta(0.8709117584154843, airy_lat(0, 0), 0.00001)
    assert_in_delta(0.8709117584154843, airy_lat(699999, 0), 0.00001)
    assert_in_delta(1.0748183142194723, airy_lat(0,1299999), 0.00001)
    assert_in_delta(1.0748183142194723, airy_lat(699999,1299999), 0.00001)
  end
end
