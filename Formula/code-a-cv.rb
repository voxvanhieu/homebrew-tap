class CodeACv < Formula
  desc "Build CVs from Markdown or structured data"
  homepage "https://github.com/voxvanhieu/code-a-cv"
  url "https://github.com/voxvanhieu/code-a-cv/releases/download/v0.2.0/source.tar.gz"
  sha256 "09648823f4949ffc5de298f653a5beddfd993cdaff9dddb9a450355c148dbd8c"
  license "MIT"
  head "https://github.com/voxvanhieu/code-a-cv.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--profile=dist", *std_cargo_args(path: "crates/cac")
  end

  test do
    system bin/"cac", "init"
    assert_path_exists testpath/"cv.md"

    system bin/"cac", "build", "cv.md", "--format", "html", "--output", "dist"
    assert_path_exists testpath/"dist/cv.html"
  end
end
