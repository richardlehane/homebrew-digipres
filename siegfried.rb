require "language/go"
require "yaml"

class Siegfried < Formula
  desc "Signature-based file identification tool"
  homepage "https://www.itforarchivists.com/siegfried"
  url "https://api.github.com/repos/richardlehane/siegfried/tarball/v1.11.1"
  sha256 "ca195a0f1b3601b8382f59775db25814e9e24409b4ae31679937bc3df617ed48"
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
