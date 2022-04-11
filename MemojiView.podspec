Pod::Spec.new do |spec|
  spec.name             = 'MemojiView'
  spec.version          = '0.0.1'
  spec.summary          = 'Retrieve and display the users memoji'
  spec.homepage         = 'https://github.com/emrearmagan/MemojiView'
  spec.license          = { :type => 'MIT', :file => 'LICENSE' }
  spec.author           = { 'Emre Armagan' => 'emrearmagan.dev@gmail.com' }
  spec.source           = { :git => 'https://github.com/emrearmagan/MemojiView.git', :tag => spec.version }
  spec.swift_version = '5.0'
  spec.ios.deployment_target = '12.0'
  spec.source_files = 'MemojiView/**/*'
end
