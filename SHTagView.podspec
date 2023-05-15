Pod::Spec.new do |s|
    s.name         = "SHTagView"
    s.version      = "1.1.0"
    s.summary      = "标签页编辑，仿微博"
    s.license      = "MIT"
    s.authors      = { "CCSH" => "624089195@qq.com" }
    s.platform     = :ios, "9.0"
    s.requires_arc = true
    s.homepage     = "https://github.com/CCSH/SHTagView"
    s.source       = { :git => "https://github.com/CCSH/SHTagView.git", :tag => s.version }
    
    s.source_files = "#{s.name}/*.{h,m}"
    s.resources = "#{s.name}/#{s.name}.bundle"
    
    s.dependency "SHExtension/UIButton"
    s.dependency "SHExtension/UIColor"
    s.dependency "SHExtension/UIView"
    s.dependency "Masonry"
    
end
