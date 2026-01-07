# Multi-Ruby Version Testing Guide

本專案已設定支援多個 Ruby 版本（2.7.6, 3.0.7, 3.1.7）與 Rails 版本（6.x, 7.x）的測試環境。

## 支援的版本組合

### Ruby 版本
- **Ruby 2.7.6**
- **Ruby 3.0.7**
- **Ruby 3.1.7**

### Rails 版本
- **Rails 6.1.x**
- **Rails 7.0.x**

### 測試矩陣（共 6 個組合）
1. Ruby 2.7.6 + Rails 6.1
2. Ruby 2.7.6 + Rails 7.0
3. Ruby 3.0.7 + Rails 6.1
4. Ruby 3.0.7 + Rails 7.0
5. Ruby 3.1.7 + Rails 6.1
6. Ruby 3.1.7 + Rails 7.0

## 專案結構

```
.
├── Appraisals                           # Appraisal 設定檔
├── gemfiles/                            # 各版本組合的 Gemfile
│   ├── ruby_2.7_rails_6.gemfile
│   ├── ruby_2.7_rails_7.gemfile
│   ├── ruby_3.0_rails_6.gemfile
│   ├── ruby_3.0_rails_7.gemfile
│   ├── ruby_3.1_rails_6.gemfile
│   └── ruby_3.1_rails_7.gemfile
├── bin/test_all                         # 本地測試所有版本的腳本
└── .github/workflows/test.yml           # GitHub Actions 設定
```

## 本地測試

### 測試所有組合

```bash
bin/test_all
```

此腳本會依序測試所有 6 個 Ruby + Rails 版本組合。

### 測試特定組合

```bash
# Ruby 2.7.6 + Rails 6
bundle exec appraisal ruby-2.7-rails-6 rake t

# Ruby 2.7.6 + Rails 7
bundle exec appraisal ruby-2.7-rails-7 rake t

# Ruby 3.0.7 + Rails 6
bundle exec appraisal ruby-3.0-rails-6 rake t

# Ruby 3.0.7 + Rails 7
bundle exec appraisal ruby-3.0-rails-7 rake t

# Ruby 3.1.7 + Rails 6
bundle exec appraisal ruby-3.1-rails-6 rake t

# Ruby 3.1.7 + Rails 7
bundle exec appraisal ruby-3.1-rails-7 rake t
```

### 安裝所有版本的依賴

```bash
bundle install
bundle exec appraisal install
```

## GitHub Actions

當你推送程式碼到以下分支時，GitHub Actions 會自動測試所有版本組合：
- `fix-**`
- `feat-**`
- `develop`
- `master`
- Pull Requests

測試矩陣會執行所有 6 個 Ruby + Rails 版本組合測試。

### CI 配置

GitHub Actions 使用明確的版本號：
- Ruby: `2.7.6`, `3.0.7`, `3.1.7`
- Rails: `~> 6.1.0`, `~> 7.0.0`

## 依賴套件相容性

所有主要依賴套件都支援 Ruby 2.7+ 和 Rails 6/7：

### 核心依賴
- **Rails** - 支援 6.1.x 和 7.0.x
- **nokogiri** >= 1.6 - 支援 Ruby 2.7+
- **fast_excel** - 支援 Ruby 2.5+
- **roo** - 支援 Ruby 2.5+
- **dry-types** 1.5.1 - 支援 Ruby 2.7+
- **dry-logic** 1.2.0 - 支援 Ruby 2.7+
- **reform** 2.6.2 - 支援 Ruby 2.5+
- **reform-rails** - 支援 Rails 6/7
- **searchkick** - 支援 Ruby 2.6+
- **virtus** ~> 1.0.5 - 支援 Ruby 2.7+

### Rails 7 特定依賴
Rails 7 會自動引入以下額外依賴：
- `benchmark`
- `drb`
- `mutex_m`
- `securerandom`

## 更新依賴

當你需要更新 gemfiles 時：

```bash
# 編輯 Appraisals 檔案
# 然後重新生成 gemfiles
bundle exec appraisal install
```

如需更新某個特定組合的依賴：

```bash
bundle exec appraisal ruby-3.1-rails-7 bundle update
```

## 開發建議

1. **本地開發環境**：建議使用 Ruby 2.7.6 作為預設開發版本（見 `.ruby-version`）

2. **提交前測試**：在提交 PR 前，建議至少測試以下組合：
   - 最低版本：Ruby 2.7.6 + Rails 6.1
   - 最高版本：Ruby 3.1.7 + Rails 7.0

3. **新增依賴**：確保新增的依賴套件都支援：
   - Ruby >= 2.7.0
   - Rails >= 6.1, < 8

## 注意事項

- `gemfiles/*.lock` 檔案已加入 `.gitignore`，不會被 commit
- `gemfiles/*.gemfile` 檔案會被 commit，確保 CI/CD 環境一致性
- gemspec 中 Rails 版本範圍設定為 `">= 6.1", "< 8"`，支援 Rails 6 和 7
- 確保新增的依賴套件都支援 Ruby 2.7+ 和 Rails 6/7

## 疑難排解

### 問題：bundle install 失敗

```bash
# 清理並重新安裝
rm -rf gemfiles/.bundle
bundle exec appraisal install
```

### 問題：某個組合測試失敗

```bash
# 重新安裝該組合的依賴
bundle exec appraisal ruby-3.1-rails-7 bundle install
bundle exec appraisal ruby-3.1-rails-7 rake t
```
