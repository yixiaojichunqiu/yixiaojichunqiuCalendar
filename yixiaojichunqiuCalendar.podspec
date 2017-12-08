Pod::Spec.new do |s|
  s.name             = 'yixiaojichunqiuCalendar'
  s.version          = '0.1.0'
  s.summary          = 'my yixiaojichunqiuCalendar'
  s.description      = <<-DESC
                            Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/yixiaojichunqiu/yixiaojichunqiuCalendar/'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'yixiao' => 'fdk785126868@qq.com' }
  s.source           = { :git => 'https://github.com/yixiaojichunqiu/yixiaojichunqiuCalendar.git', :tag => s.version }

  s.ios.deployment_target = '8.0'

  s.source_files = 'Pod/Classes/*'

end
