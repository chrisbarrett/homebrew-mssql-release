class MssqlTools < Formula
  desc "Sqlcmd and Bcp for Microsoft(R) SQL Server(R)"
  homepage "https://msdn.microsoft.com/en-us/library/ms162773.aspx"
  url Hardware::CPU.arch == :arm64 ? "https://download.microsoft.com/download/F/D/1/FD16AA69-F27D-440E-A15A-6C521A1972E6/mssql-tools-17.10.1.1-arm64.tar.gz" :
                                     "https://download.microsoft.com/download/F/D/1/FD16AA69-F27D-440E-A15A-6C521A1972E6/mssql-tools-17.10.1.1-amd64.tar.gz"
  version "17.10.1.1"
  sha256 Hardware::CPU.arch == :arm64 ? "ed93a2e233a70e8bea2cc566efce8554614944df9ffd42bc4c1b46bddc81ec64" :
                                        "5c11a2659e5a6cff2ad74fbf0a2fe011cf57896694ed9b0c7dc072a93e6dd80c"

  depends_on "unixodbc"
  depends_on "openssl"
  depends_on "msodbcsql17"

  option "accept-eula", "Accept the EULA at http://go.microsoft.com/fwlink/?LinkId=746949"

  def install
    if build.without? "accept-eula" then
      puts 'Must specify --accept-eula to proceed. EULA: http://go.microsoft.com/fwlink/?LinkId=746949'
      return false
    end
    ENV['HOMEBREW_ACCEPT_EULA'] = 'y'

    chmod 0444, "bin/sqlcmd"
    chmod 0444, "bin/bcp"
    chmod 0444, "share/resources/en_US/BatchParserGrammar.dfa"
    chmod 0444, "share/resources/en_US/BatchParserGrammar.llr"
    chmod 0444, "share/resources/en_US/bcp.rll"
    chmod 0444, "share/resources/en_US/SQLCMD.rll"
    chmod 0644, "usr/share/doc/mssql-tools/LICENSE.txt"
    chmod 0644, "usr/share/doc/mssql-tools/THIRDPARTYNOTICES.txt"

    cp_r ".", prefix.to_s
  end

  test do
    out = shell_output("#{bin}/sqlcmd -?")
    assert_match "Microsoft (R) SQL Server Command Line Tool", out
    out = shell_output("#{bin}/bcp -v")
    assert_match "BCP - Bulk Copy Program for Microsoft SQL Server", out
  end
end
