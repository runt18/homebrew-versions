class Isl011 < Formula
  desc "Integer Set Library for the polyhedral model"
  homepage "http://freecode.com/projects/isl"
  # Track gcc infrastructure releases.
  url "http://isl.gforge.inria.fr/isl-0.11.1.tar.bz2"
  mirror "ftp://gcc.gnu.org/pub/gcc/infrastructure/isl-0.11.1.tar.bz2"
  sha256 "095f4b54c88ca13a80d2b025d9c551f89ea7ba6f6201d701960bfe5c1466a98d"

  bottle do
    cellar :any
    sha256 "9f4a6d0ff2f5cd7208a1c29c84eb6c452e6bcb7b7249b597507b1f0aad13e2ef" => :yosemite
    sha256 "c1ebc3499a91cad85af852f293fc330f5bf4b168af031d1927f2183736246ca9" => :mavericks
    sha256 "43d1e0023ea8c7df4199668c9cb76927c22756bbc7b0b7db5b047715db8d6001" => :mountain_lion
    sha1 "49d0c81d3d0e72abe18e171b58e6159122ba07bc" => :tiger_g3
    sha1 "7500d4495c2da2059b484d96190d8e563b01a357" => :tiger_altivec
    sha1 "5cf2a19ddde50e65786a2d5957a0d0b20f1db94c" => :leopard_g3
    sha1 "3c97c65cdacf43c0f310309a9b5f0a242fd7b925" => :leopard_altivec
  end

  keg_only "Conflicts with isl in main repository."

  depends_on "gmp4"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-gmp=system",
                          "--with-gmp-prefix=#{Formula["gmp4"].opt_prefix}"
    system "make", "install"
    (share/"gdb/auto-load").install Dir["#{lib}/*-gdb.py"]
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <isl/ctx.h>

      int main()
      {
        isl_ctx* ctx = isl_ctx_alloc();
        isl_ctx_free(ctx);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lisl",
      "-I#{include}", "-I#{Formula["gmp4"].include}", "-o", "test"
    system "./test"
  end
end
