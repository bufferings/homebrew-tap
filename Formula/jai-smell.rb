# bufferings/homebrew-tap の Formula/jai-smell.rb のテンプレート。
#
# 0.5.2 と 5c44ef7d8881f3d39419c231bea443ad17b6ceb63aafc5cf82e21e7868628c3d は、GitHub のリリースを公開した際に
# .github/workflows/bump-formula.yml が置換し、tap にプッシュする。
# ci.yml ではダミーの値に置換して brew style を実行する。
#
# 対応環境は arm64 の macOS のみ（その他の環境では、README に記載の手順でソースからビルドする）。
# formula はインストール時にホームディレクトリへ書き込めないため、Claude Code のプラグインは
# インストール後に利用者が jai-smell setup を実行して導入する。
class JaiSmell < Formula
  desc "Flags unnatural Japanese expressions in text written by Claude Code"
  homepage "https://github.com/bufferings/jai-smell"
  url "https://github.com/bufferings/jai-smell/releases/download/v0.5.2/jai-smell-0.5.2-arm64.tar.gz"
  # URL の「arm64」から「64」をバージョンとして解析するため、明記する
  version "0.5.2"
  sha256 "5c44ef7d8881f3d39419c231bea443ad17b6ceb63aafc5cf82e21e7868628c3d"
  license "MIT"

  depends_on arch: :arm64
  depends_on :macos

  def install
    bin.install "jai-smell"
    prefix.install "THIRD-PARTY-NOTICES.txt"
  end

  def caveats
    <<~EOS
      Run the following after each install and upgrade.
      It installs or updates the Claude Code plugin:
        jai-smell setup
    EOS
  end

  test do
    (testpath/"a.md").write "ログを見張る。\n"
    assert_match "a.md:1:4: \"見張る\"", shell_output("#{bin}/jai-smell a.md", 1)
  end
end
