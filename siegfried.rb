require "language/go"
require "yaml"

class Siegfried < Formula
  desc "Signature-based file identification tool"
  homepage "http://www.itforarchivists.com/siegfried"
  url "https://github.com/richardlehane/siegfried/archive/v1.7.0.tar.gz"
  sha256 "c432d631857ebd4df1dc43dbd87c7208874da7f92850f184006de87e9c70546b"
  head "https://github.com/richardlehane/siegfried.git", :branch => "develop"

  depends_on "go" => :build

  def install
    # Avoid installing signature files into the user's home directory;
    # install them into share instead.
    inreplace "pkg/config/brew.go", "/usr/share/siegfried", share/"siegfried"

    mkdir_p buildpath/"src/github.com/richardlehane"
    ln_s buildpath, buildpath/"src/github.com/richardlehane/siegfried"

    ENV["GOPATH"] = buildpath

    system "go", "build", "-tags", "brew",
                 "github.com/richardlehane/siegfried/cmd/sf"
    system "go", "build", "-tags", "brew",
                 "github.com/richardlehane/siegfried/cmd/roy"

    bin.install "sf", "roy"
    (share/"siegfried").install Dir["src/github.com/richardlehane/siegfried/cmd/roy/data/*"]
  end

  test do
    results = YAML.load_documents `"#{bin}/sf" "#{test_fixtures("test.jpg")}"`
    assert_equal version.to_s, results[0]["siegfried"]
    assert_equal "fmt/43", results[1]["matches"][0]["puid"]
  end
end
