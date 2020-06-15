# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
class Pnscan < Formula
  desc "A tool to probe IPv4 networks for TCP services"
  homepage "https://github.com/ptrrkssn/pnscan"
  url "https://github.com/ptrrkssn/pnscan/archive/v1.14.1.tar.gz"

  ## This line must be uncommented and updated with the correct hash value
  ## The correct value will be displayed when doing 'brew install pnscan'
  # sha256 "15430b64cb493571f6e46a38482402746bee7ed134c0e99d7976d231cab1c7d5"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/pnscan", "-v", "127.0.0.1" "22"
  end
end
