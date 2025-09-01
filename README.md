# Ruby-bot
discordrbを使って作成したシンプルなDiscordBOTです　　

# 必要条件
- Ruby 3.x
- Bundler

# セットアップ
リポジトリをクローン
```bash
git clone https://github.com/VEDA00133912/Ruby-bot
cd Ruby-bot
```
必要なgemをインストール
```bash
bundle install
```
環境変数を設定
```.env
DISCORD_BOT_TOKEN=DiscordBOTのトークン
```
## 起動
```bash
ruby bot.rb
```
起動時に`Ready! Logged in as Bot名#0000`と表示が出ます