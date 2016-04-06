Pod::Spec.new do |s|
  s.name         = "HUD"
  s.version      = "1.1.0"
  s.summary      = "A Simple HUD for iOS 8 and up"
  s.homepage     = "https://github.com/Chakery/HUD"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "chakery" => "striveordeath@gmail.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/Chakery/HUD.git", :tag => s.version }
  s.source_files  = "HUD/*"
  s.requires_arc = true
end
