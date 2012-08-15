Pod::Spec.new do |s|
  s.name     = 'DIYHeaderMenu'
  s.version  = '0.1.0'
  s.license  = 'Apache 2.0'
  s.summary  = 'YEFDDM (Yet Another, uh, Flashy Drop Down Menu).'
  s.homepage = 'https://github.com/dongle/diyheadermenu'
  s.authors  = {'Jon Beilin' => 'jon@diy.org'}
  s.source   = { :git => 'https://github.com/dongle/diyheadermenu.git', :tag => 'v0.1.0' }
  s.platform = :ios, '5.0'
  s.source_files = 'DIYHeaderMenu/*.{h,m,png}'
  s.framework = 'UIKit', 'Foundation'
end