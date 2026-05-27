# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'ToDoListTask' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ToDoListTask

  pod 'SnapKit'
  pod 'Alamofire'


end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      # Устанавливаем минимальную версию 13.0 для всех подов
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '16.0'
    end
  end
end
