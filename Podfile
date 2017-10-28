# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

target 'PushySquaresAI' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  pod 'RealmSwift'
end

post_install do |installer|
    files = Dir.glob("*.xcodeproj")
    proj_file = files[0]
    app_project = Xcodeproj::Project.open(proj_file)
    
    app_project.native_targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['LD_RUNPATH_SEARCH_PATHS'] = '$(inherited) @executable_path/../Frameworks @loader_path/Frameworks'
            prefix = ' @executable_path/'
            
            # For each pod, add the framework path to LD_RUNPATH_SEARCH_PATHS
            installer.pods_project.targets.each do |pod_target|
                config.build_settings['LD_RUNPATH_SEARCH_PATHS'] = config.build_settings['LD_RUNPATH_SEARCH_PATHS'] + prefix + pod_target.name + '/'
                
                pod_target.build_configurations.each do |pod_config|
                    #if you want embed swift stdlib into every framework, uncommend 1,2 and commend 3,4
                    #1
                    #pod_config.build_settings['ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES'] = 'YES'
                    #2
                    #pod_config.build_settings['LD_RUNPATH_SEARCH_PATHS'] = '$(inherited) @executable_path/../Frameworks @loader_path/Frameworks'
                    
                    #3
                    pod_config.build_settings['ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES'] = 'NO'
                    #4
                    pod_config.build_settings['LD_RUNPATH_SEARCH_PATHS'] = '$(inherited) /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/macosx/'
                end
            end
        end
    end
    
    app_project.save
end
