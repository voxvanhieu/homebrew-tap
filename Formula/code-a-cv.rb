class CodeACv < Formula
  desc "Build CVs from Markdown or structured data"
  homepage "https://github.com/voxvanhieu/code-a-cv"
  url "https://github.com/voxvanhieu/code-a-cv/releases/download/v0.2.0/source.tar.gz"
  sha256 "09648823f4949ffc5de298f653a5beddfd993cdaff9dddb9a450355c148dbd8c"
  license "MIT"
  head "https://github.com/voxvanhieu/code-a-cv.git", branch: "main"

  bottle do
    root_url "https://github.com/voxvanhieu/homebrew-tap/releases/download/code-a-cv-0.2.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "3be8ca1035083d5a503f0c51d42a4b43985c8891cb740ef485a1e894b33d5c8d"
    sha256 cellar: :any,                 x86_64_linux: "38b5ca62d139ff966defbaafdbe9a6750c3298a0292492b7c5e141b8739fee54"
  end

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
