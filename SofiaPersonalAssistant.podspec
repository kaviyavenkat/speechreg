Pod::Spec.new do |s|
  s.name         = "SofiaPersonalAssistant"
  s.version      = "0.0.1"
  s.summary      = "A short description of SofiaPersonalAssistant."
  s.homepage     = "https://github.com/kaviyavenkat/speechreg"
  s.license      = "MIT"
  s.author             = { "kaviya" => "vkaviya96@gmail.com" }
   s.platform     = :ios, "10.13.3"
  s.source       = { :git => "https://github.com/kaviyavenkat/speechreg.git", :tag => "0.0.1" }
 s.source_files  = "SofiaPersonalAssistant", "SofiaPersonalAssistant/**/*.{h,m,swift}"  
end
