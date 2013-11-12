Pod::Spec.new do |s|
  s.name     = 'PSImageView'
  s.version  = '0.0.1'
  s.license  = 'MIT'
  s.summary  = 'High performance rounded view with image and border.'
  s.homepage = 'https://github.com/johnezang/JSONKit'
  s.author   = 'Paul Semionov'
  s.source   = { :git => 'https://github.com/Duffpod/JSONKit.git' }

  s.source_files   = 'Public', 'TestRoundedImage/Public/*.{h,m}'
end
