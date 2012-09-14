Pod::Spec.new do |s|
  s.name     = 'DIYMenu'
  s.version  = '0.2.1'
  s.license  = 'Apache 2.0'
  s.summary  = 'A little menu intended to drop down below a titlebar.'
  s.homepage = 'https://github.com/dongle/DIYMenu'
  s.authors  = {'Jon Beilin' => 'jon@diy.org'}
  s.source   = { :git => 'https://github.com/dongle/DIYMenu.git', :tag => 'v0.2.1' }
  s.platform = :ios, '5.0'
  s.source_files = 'DIYMenu/*.{h,m,png}'
  s.requires_arc = true
  s.framework = 'UIKit', 'Foundation', 'CoreGraphics', 'QuartzCore'
end
