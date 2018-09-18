class Droid < Formula
  desc "Java-based PRONOM file identification tool"
  homepage "http://digital-preservation.github.com/droid/"
  url "http://www.nationalarchives.gov.uk/documents/information-management/droid-binary-6.4-bin.zip"
  sha256 "9dd6289c1f03d8a9d628ab0127954e05acf4aa2f5f7d606b8a1b78996a98b815"

  def install
    libexec.install Dir["*.jar"]
    libexec.install "lib"
    inreplace "droid.sh" do |s|
      s.gsub! "droid-command-line-6.2.1.jar", "#{libexec}/droid-command-line-6.2.1.jar"
      s.gsub! "droid-ui-6.2.1.jar", "#{libexec}/droid-ui-6.2.1.jar"
    end
    bin.install "droid.sh" => "droid"
  end

  def test
    system "#{bin}/droid", "--version"
  end
end
