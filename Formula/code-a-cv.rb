class CodeACv < Formula
  desc "Build CVs from Markdown or structured data"
  homepage "https://github.com/voxvanhieu/code-a-cv"
  url "https://github.com/voxvanhieu/code-a-cv/releases/download/v0.3.0/source.tar.gz"
  sha256 "49d6a2cbe2d449d9d47ef087d5b12167d6c4f9617d536877e6f1efd98953d2f2"
  license "MIT"
  head "https://github.com/voxvanhieu/code-a-cv.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--profile=dist", *std_cargo_args(path: "crates/cac")
  end

  test do
    system bin/"cac", "init"
    assert_path_exists testpath/"cv.md"

    system bin/"cac", "build", "cv.md", "--format", "html"
    assert_path_exists testpath/"offering/cv.html"
  end
end
