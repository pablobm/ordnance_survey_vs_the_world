require 'test/unit'
require 'test/unit/assertions'
require 'ordnance_survey_vs_the_world/os_grid_ref'

module OrdnanceSurveyVsTheWorld
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


    def latlon(easting, northing)
      ll = OsGridRef.new(easting, northing).to_latlon
      [ll.lat, ll.lon]
    end

#    def test_to_latlon
#      assert_equal([49.76618579670919, -7.556448482562568], latlon(0, 0))
#      assert_equal([49.82444269457118,  2.171856193294114], latlon(699999, 0))
#      assert_equal([61.37589692662293, -9.496595230094060], latlon(0, 1299999))
#      assert_equal([49.82444269457118,  2.171856193294114], latlon(699999, 1299999))
#    end

  end
end
