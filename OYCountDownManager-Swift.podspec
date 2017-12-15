Pod::Spec.new do |s|
s.name        = 'OYCountDownManager-Swift'
s.version     = '2.0.4'
s.authors     = { 'herob' => '869765745@qq.com' }
s.homepage    = 'https://github.com/herobin22/OYCountDownManager-Swift'
s.summary     = 'iOS在cell中使用倒计时的处理方法'
s.source      = { :git => 'https://github.com/herobin22/OYCountDownManager-Swift.git', :tag => s.version }
s.license     = { :type => "MIT", :file => "LICENSE" }
s.platform = :ios, '8.0'
s.requires_arc = true
s.source_files = 'CellCountDown-Swift/OYCountDownManager/*.swift'

end

