class CodeACv < Formula
  desc "Build CVs from Markdown or structured data"
  homepage "https://github.com/voxvanhieu/code-a-cv"
  url "https://github.com/voxvanhieu/code-a-cv/releases/download/v0.3.0/source.tar.gz"
  sha256 "49d6a2cbe2d449d9d47ef087d5b12167d6c4f9617d536877e6f1efd98953d2f2"
  license "MIT"
  head "https://github.com/voxvanhieu/code-a-cv.git", branch: "main"

  bottle do
    root_url "https://github.com/voxvanhieu/homebrew-tap/releases/download/code-a-cv-0.3.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "0341042ca8bb9219534f1cb316aad80bd9201e26907de7a5dd387d8858ce7f72"
    sha256 cellar: :any,                 x86_64_linux: "edf7a6a55113162a7cff201b2edab02545dc169dff4404e4b9bcdf8ddeeafe00"
  end

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
