# bufferings/homebrew-tap の Formula/jai-smell.rb のテンプレート。
#
# 0.2.0 と ab7448b3d58fd660d0ecf1ee471e570e57e4c1bc852063514967d249c39b715b は、GitHub のリリースを公開した際に
# .github/workflows/bump-formula.yml が置換し、tap にプッシュする。
# ci.yml ではダミーの値に置換して brew style を実行する。
#
# 対応環境は arm64 の macOS のみ（その他の環境では、README に記載の手順でソースからビルドする）。
# formula はインストール時にホームディレクトリへ書き込めないため、設定ファイルとプラグインは
# インストール後に利用者が jai-smell init を実行して導入する。
class JaiSmell < Formula
  desc "Flags unnatural Japanese expressions in text written by Claude Code"
  homepage "https://github.com/bufferings/jai-smell"
  url "https://github.com/bufferings/jai-smell/releases/download/v0.2.0/jai-smell-0.2.0-arm64.tar.gz"
  # URL の「arm64」から「64」をバージョンとして解析するため、明記する
  version "0.2.0"
  sha256 "ab7448b3d58fd660d0ecf1ee471e570e57e4c1bc852063514967d249c39b715b"
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
      After upgrading, run jai-smell init again to update preset-rules.toml.
    EOS
  end

  test do
    (testpath/"jai-smell.toml").write <<~TOML
      [[rule_sets]]
      name = "test"

      [[rule_sets.entries]]
      message = "found"
      tokens = [{ basic_form = "見張る" }]
    TOML
    (testpath/"a.md").write "ログを見張る。\n"
    assert_match "a.md:1:4: found", shell_output("#{bin}/jai-smell a.md", 1)
  end
end
