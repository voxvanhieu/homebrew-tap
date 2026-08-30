class CodeACv < Formula
  desc "Build CVs from Markdown or structured data"
  homepage "https://github.com/voxvanhieu/code-a-cv"
  url "https://github.com/voxvanhieu/code-a-cv/releases/download/v0.1.1/source.tar.gz"
  sha256 "57259c2f568e35670c4d9a3e066d44ef038cb3842bf4fd8b403250593984c34c"
  license "MIT"
  head "https://github.com/voxvanhieu/code-a-cv.git", branch: "main"

  bottle do
    root_url "https://github.com/voxvanhieu/homebrew-tap/releases/download/code-a-cv-0.1.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "8260c43032cdbafcdd3712059b2d8a9d6a992923ba4625855059627df0e99544"
    sha256 cellar: :any,                 x86_64_linux: "6a2ad67d6b799f599e84ac1aff56728ef3417b79d92525e3074e0a15ce85e78d"
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
