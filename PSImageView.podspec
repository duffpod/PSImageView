Pod::Spec.new do |s|
  s.name     = 'PSImageView'
  s.version  = '0.0.8'
  s.license  = 'MIT'
  s.summary  = 'High performance rounded view with image and border.'
  s.homepage = 'https://github.com/duffpod/PSImageView'
  s.author   = 'Paul Semionov'
  s.source   = { :git => 'https://github.com/duffpod/PSImageView.git', :tag => '#{s.version}' }

  s.source_files   = 'Public', 'TestRoundedImage/Public/*.{h,m}'
end
