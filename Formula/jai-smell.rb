# bufferings/homebrew-tap の Formula/jai-smell.rb のテンプレート。
#
# 0.3.0 と 56ab8b8abd9c935f1cac0bf12e47507951cff8b5821a8676d15275aa1753b432 は、GitHub のリリースを公開した際に
# .github/workflows/bump-formula.yml が置換し、tap にプッシュする。
# ci.yml ではダミーの値に置換して brew style を実行する。
#
# 対応環境は arm64 の macOS のみ（その他の環境では、README に記載の手順でソースからビルドする）。
# formula はインストール時にホームディレクトリへ書き込めないため、設定ファイルとプラグインは
# インストール後に利用者が jai-smell init を実行して導入する。
class JaiSmell < Formula
  desc "Flags unnatural Japanese expressions in text written by Claude Code"
  homepage "https://github.com/bufferings/jai-smell"
  url "https://github.com/bufferings/jai-smell/releases/download/v0.3.0/jai-smell-0.3.0-arm64.tar.gz"
  # URL の「arm64」から「64」をバージョンとして解析するため、明記する
  version "0.3.0"
  sha256 "56ab8b8abd9c935f1cac0bf12e47507951cff8b5821a8676d15275aa1753b432"
  license "MIT"

  depends_on arch: :arm64
  depends_on :macos

  def install
    bin.install "jai-smell"
    pkgshare.install "jai-smell.toml", "preset-rules.toml", "custom-rules.toml"
    prefix.install "THIRD-PARTY-NOTICES.txt"
  end

  def caveats
    <<~EOS
      Run the following to create the config files in ~/.config/jai-smell
      and install the Claude Code plugin:
        jai-smell init
    EOS
  end

  test do
    (testpath/"a.md").write "ログを見張る。\n"
    assert_match "a.md:1:4: \"見張る\"", shell_output("#{bin}/jai-smell a.md", 1)
  end
end
