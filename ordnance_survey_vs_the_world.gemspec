lib     = File.expand_path('../lib/ordnance_survey_vs_the_world.rb', __FILE__)
version = File.read(lib)[/^\s*VERSION\s*=\s*(['"])(\d\.\d\.\d+)\1/, 2] #'# gedit messing with highlighting...

Gem::Specification.new do |spec|
  spec.name = 'ordnance_survey_vs_the_world'
  spec.authors = "Pablo Brasero"
  spec.email = "pablobm@gmail.com"
  spec.homepage = 'https://github.com/pablobm/ordnance_survey_vs_the_world'
  spec.summary = %{Convert from easting/northing to latitude/longitude}
  spec.description = %{Converts from the Bristish Ordnance Survey's own easting/northing OSGB-36 coordinates to WGS-84 latitude/longitude}

  spec.version = version
  spec.files = Dir["{lib,test}/**/*.rb"]
  spec.test_files = spec.files.grep(/^test\/.*_test\.rb$/)
end
