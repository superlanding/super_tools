# 更新紀錄（Changelog）

本檔格式參考 [Keep a Changelog 1.1.0](https://keepachangelog.com/zh-TW/1.1.0/)，版本號遵循 [Semantic Versioning](https://semver.org/lang/zh-TW/)。

- 日期為該版本在 [rubygems.org](https://rubygems.org/gems/super_tools/versions) 上的發佈日（UTC）。
- 每一個 PR 都必須在這裡新增一筆紀錄（見 [CLAUDE.md](CLAUDE.md)）：不發版的 PR 寫在 `[Unreleased]`；要發版的 PR 直接新增 `## [x.y.z] - YYYY-MM-DD` 區塊，並同步修改 `lib/super_tools/version.rb`。

## [Unreleased]

### Changed

- 重寫 README.md：補上簡介、支援的 Ruby / Rails 版本、安裝與設定、各模組用法範例、開發 / 測試與發版流程。
- CLAUDE.md 新增規則：每個 PR 都必須同步更新 README.md 與 CHANGELOG.md。

### Added

- 新增本檔 CHANGELOG.md（依 git 歷史與 rubygems.org 版本紀錄回溯整理）。

## [4.0.3] - 2026-10-23

### Changed

- 只調整版號（`lib/` 內無其他程式變更）。同日合併的 CI 變更：新增 `publish.yml`，master 出現尚未發佈的版本號時，以 RubyGems Trusted Publishing（OIDC）自動發佈，並修正發佈前檢查會被 `gemfiles/.bundle/config` 干擾的問題。

## [4.0.2] - 2026-10-23

### Added

- 支援 Rails 8.0 / 8.1 與 Ruby 3.3 / 3.4：gemspec 的 `rails` 相依放寬為 `>= 6.1, < 8.2`，新增 `csv` 相依（Ruby 3.4 起 `csv` 不再是預設 gem），開發相依 `sqlite3` 放寬為 `>= 1.4, < 2`。
- CI 與 Appraisals 新增 Ruby 3.3 / 3.4 × Rails 8.0 / 8.1 組合。

## [4.0.1] - 2026-01-08

### Changed

- `warehouse_items` 相依由 `~> 0.3.0` 放寬為 `>= 0.3.0`。

## [4.0.0] - 2026-01-07

### Added

- 新增 `required_ruby_version >= 2.7.0`，並以 Appraisal 建立 Ruby 2.7 / 3.0 / 3.1 × Rails 6 / 7 的多版本測試矩陣（`gemfiles/`、`bin/test_all`、GitHub Actions）。

### Changed

- **相依變更**：`rails` 由 `> 6, < 7` 放寬為 `>= 6.1, < 8`（支援 Rails 7）。
- 專案的 Gemfile 改為固定使用 fork 版 `reform-rails` 的 tag `v0.2.6.f`（原本指向 branch `fix-infinite-parent-loop`）。

## [3.0.1] - 2022-08-08

> git 歷史中沒有 3.0.1 的版號提交（master 當時的 `version.rb` 仍為 3.0.0），以下內容依 2022-08-08 前後 master 的內容整理。`3.0.0` 在 2022-06-17 設定過版號，但**從未發佈**到 rubygems.org。

### Added

- 支援 Rails 6（`rails` 相依為 `> 6, < 7`，測試以 Rails 6.1.6 為主）。
- 新增 `SuperForm::Reform` 巢狀驗證（nested validations）的測試；專案改用 fork 版 `reform-rails` 以修正 `Disposable::Twin::Parent` 造成的無限迴圈（stack too deep）。

### Changed

- 升級 `reform` 2.6.2、`dry-types` 1.5.1、`dry-logic` 1.2.0。
- 移除 `iconv` 相依。

### Removed

- 移除 `SuperLogger::Formatter`（`lib/super_logger/formatter.rb`，2022-06-23）。

## [2.1.0] - 2021-04-01

### Changed

- 版號提升為 2.1.0（git 歷史中只有 `bump version`，沒有其他說明）。rubygems.org 上沒有 1.x 版本。

## [0.0.1] – [0.0.26]

早期版本，git 歷史大多只有 `bump version` / `FIX` 之類的訊息，這裡依發佈日期與 git 內容概略整理。rubygems.org 上實際存在的版本與日期如下（沒有列出的 0.0.16、0.0.18、0.0.19、0.0.22 – 0.0.24 未發佈）：

| 版本 | 發佈日 | 摘要 |
| --- | --- | --- |
| 0.0.1 – 0.0.6 | 2019-04-17 | 初始版本（2019-04-17 首次提交），同日新增 `SuperSearch`、`SuperZipcode`、`SuperInteraction`，並修正相依與 Rails 相容問題。 |
| 0.0.7 | 2019-04-22 | 版本更新。 |
| 0.0.8 | 2019-05-07 | 版本更新。 |
| 0.0.9 | 2019-05-10 | 版本更新。 |
| 0.0.10 | 2020-01-09 | 版本更新。 |
| 0.0.11 – 0.0.14 | 2020-01-30 – 2020-01-31 | 升級相依並修正 Rails 5 相容問題。 |
| 0.0.15 | 2020-09-21 | `SuperForm::AtomicSave` 的 callback 可以傳 block。 |
| 0.0.17 – 0.0.21 | 2021-01-22 | 版本更新。 |
| 0.0.25 – 0.0.26 | 2021-01-25 | 版本更新。 |

[Unreleased]: https://github.com/superlanding/super_tools/compare/v4.0.3...HEAD
[4.0.3]: https://github.com/superlanding/super_tools/compare/v4.0.2...v4.0.3
[4.0.2]: https://github.com/superlanding/super_tools/compare/4.0.1...v4.0.2
[4.0.1]: https://github.com/superlanding/super_tools/compare/v4.0.0...4.0.1
[4.0.0]: https://github.com/superlanding/super_tools/releases/tag/v4.0.0
