class Fits < Formula
  homepage "http://fitstool.org"
  url "https://projects.iq.harvard.edu/files/fits/files/fits-1.3.0.zip"
  version "1.3.0"
  sha256 "8dbca703609939e0be36d9678f17447294181731d42fb6dc738a42dc744e788a"

  def install
    libexec.install "version.properties"
    libexec.install "log4j.properties"
    libexec.install "lib"
    libexec.install "tools"
    libexec.install "xml"
    inreplace "fits-env.sh" do |s|
      s.gsub! "`dirname $FITS_ENV_SCRIPT`", "#{libexec}"
    end
    bin.install "fits-env.sh"
    bin.install "fits.sh" => "fits"
  end

  def test
    system "#{bin}/fits", "-v"
  end
end
