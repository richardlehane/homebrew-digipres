require "language/go"
require "yaml"

class Siegfried < Formula
  desc "Signature-based file identification tool"
  homepage "https://www.itforarchivists.com/siegfried"
  url "https://api.github.com/repos/richardlehane/siegfried/tarball/v1.11.0"
  sha256 "6b5aae7098cf6a1fd616cbee8c7286ef9c4d0f7b07ab58450f56a7588ffad2d8"
  head "https://github.com/richardlehane/siegfried.git", :branch => "main"

  depends_on "go" => :build

  def install
    # Avoid installing signature files into the user's home directory;
    # install them into share instead.
    inreplace "pkg/config/brew.go", "/usr/share/siegfried", share/"siegfried"

    mkdir_p buildpath/"src/github.com/richardlehane"
    ln_s buildpath, buildpath/"src/github.com/richardlehane/siegfried"

    system "go", "build", "-tags", "brew", "github.com/richardlehane/siegfried/cmd/sf"
                 
    system "go", "build", "-tags", "brew", "github.com/richardlehane/siegfried/cmd/roy"

    bin.install "sf", "roy"
    (share/"siegfried").install Dir["src/github.com/richardlehane/siegfried/cmd/roy/data/*"]
  end

  test do
    results = YAML.load_documents `"#{bin}/sf" "#{test_fixtures("test.jpg")}"`
    assert_equal version.to_s, results[0]["siegfried"]
    assert_equal "fmt/43", results[1]["matches"][0]["puid"]
  end
end
