require "language/go"

class Asciinema < Formula
  homepage "https://asciinema.org/"
  url "https://github.com/asciinema/asciinema/archive/v1.0.0.tar.gz"
  sha1 "8e9862309a5bc1723cb27a40a412401ed05e4586"

  head "https://github.com/asciinema/asciinema.git"

  bottle do
    cellar :any
    sha1 "18071c7dc6d7fb738db64b864e7d5b48e935e0eb" => :yosemite
    sha1 "975785a19567a9a7aca8ea7a53b1cfea3f822734" => :mavericks
    sha1 "cba30872e33a44b4042ef768fd871175e76fc502" => :mountain_lion
  end

  depends_on "go" => :build

  go_resource "github.com/kr/pty" do
    url "https://github.com/kr/pty.git",
      :revision => "67e2db24c831afa6c64fc17b4a143390674365ef"
  end

  go_resource "code.google.com/p/go.crypto" do
    url "https://code.google.com/p/go.crypto/",
      :revision => "aa2644fe4aa5", :using => :hg
  end

  go_resource "code.google.com/p/gcfg" do
    url "https://code.google.com/p/gcfg/",
      :revision => "c2d3050044d05357eaf6c3547249ba57c5e235cb", :using => :git
  end

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/asciinema"
    ln_s buildpath, buildpath/"src/github.com/asciinema/asciinema"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", "asciinema"

    bin.install "asciinema"
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    system "#{bin}/asciinema", "--version"
    system "#{bin}/asciinema", "--help"
  end
end
