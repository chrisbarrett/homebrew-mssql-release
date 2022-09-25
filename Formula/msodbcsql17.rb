class Msodbcsql17 < Formula
  desc "ODBC Driver for Microsoft(R) SQL Server(R)"
  homepage "https://msdn.microsoft.com/en-us/library/mt654048(v=sql.1).aspx"
  url Hardware::CPU.arch == :arm64 ? "https://download.microsoft.com/download/1/9/A/19AF548A-6DD3-4B48-88DC-724E9ABCEB9A/msodbcsql17-17.10.1.1-arm64.tar.gz" :
                                     "https://download.microsoft.com/download/1/9/A/19AF548A-6DD3-4B48-88DC-724E9ABCEB9A/msodbcsql17-17.10.1.1-amd64.tar.gz"
  version "17.10.1.1"
  sha256 Hardware::CPU.arch == :arm64 ? "89547be542e761cdb27f59ea5ba04fcf5f8bb72f17d050d466ef71ea3d71a1a5" :
                                        "490811ea713eab189d9c9cb9aa7cd0e37f0ace3de0c204f9aff14a43909351df"

  option "without-registration", "Don't register the driver in odbcinst.ini"
  option "with-accept-eula", "Accept the EULA at https://aka.ms/odbc17eula"

  depends_on "unixodbc"
  depends_on "openssl"

  def install
    if build.with? "accept-eula" then
      puts 'EULA accepted for msodbcsql17'
    else
      STDERR.puts 'Must specify --with-accept-eula to proceed. EULA: https://aka.ms/odbc17eula'
      return false
    end

    chmod 0444, "lib/libmsodbcsql.17.dylib"
    chmod 0444, "share/msodbcsql17/resources/en_US/msodbcsqlr17.rll"
    chmod 0644, "include/msodbcsql17/msodbcsql.h"
    chmod 0644, "odbcinst.ini"
    chmod 0644, "share/doc/msodbcsql17/LICENSE.txt"
    chmod 0644, "share/doc/msodbcsql17/RELEASE_NOTES"

    cp_r ".", prefix.to_s

    if build.with? "registration"
      system "odbcinst", "-u", "-d", "-n", "\"ODBC Driver 17 for SQL Server\""
      system "odbcinst", "-i", "-d", "-f", "./odbcinst.ini"
    end
  end

  def caveats; <<~EOS
    If you installed this formula with the registration option (default), you'll
    need to manually remove [ODBC Driver 17 for SQL Server] section from
    odbcinst.ini after the formula is uninstalled. This can be done by executing
    the following command:
        odbcinst -u -d -n "ODBC Driver 17 for SQL Server"
  EOS
  end

  test do
    if build.with? "registration"
      out = shell_output("#{Formula["unixodbc"].opt_bin}/odbcinst -q -d")
      assert_match "ODBC Driver 17 for SQL Server", out
    end
  end
end
