class Bagger < Formula
  desc "Java-based BagIt bag creator and validator"
  homepage "https://github.com/LibraryOfCongress/bagger"
  version "2.8.1"
  url "https://github.com/LibraryOfCongress/bagger/releases/download/v2.8.1/bagger-2.8.1.zip"
  sha256 "8a1991e39764e007a336a5585e7c2c79a8edf406a63ef81d587b3c70b421af23"

  depends_on :java => "1.8+"

  def install
    inreplace "bin/bagger" do |s|
      s.gsub! "`pwd -P`", "#{libexec}"
    end
    bin.install "bin/bagger" => "bagger"
    libexec.install "bin"
    libexec.install "lib"
  end

  def test
    
  end
end
