# Connect Study
![twitter-card](https://user-images.githubusercontent.com/70502790/107443909-fe35fd80-6b7c-11eb-8f53-38a3c68f219a.png)

## 概要
オフラインで勉強仲間と繋がることができるサービスです。
様々な条件から勉強仲間、勉強会を見つけることができます。

## URL
https://connect-study.xyz

トップページの【かんたんログイン】ボタンからテストユーザーとしてログインできます。

## 制作の背景
僕は地方に住んでいるため、周りにプログラミングをしている仲間を見つけられず、大学の友達に勧めてみても継続して勉強することはなかなか難しく、一人で勉強していました。
その時に、僕と同じようにプログラミングをしている人と出会えるようなサービスがあればいいのにな...という思いからこのサービスを開発することを決めました。


## 機能一覧
* ログイン機能(devise)
* 画像登録機能(CarrierWave, aws-fog)
  - JavaScriptを用いて即時プレビューできるよう実装。
* 通知機能 
  - フォローされた時、DMが届いた時、勉強会に招待された時、気になる勉強会に登録された時、勉強会に参加の申し込みをされた時、勉強会の参加を承認された時、勉強会の参加を拒否された時、勉強会のメンバーが勉強会のグループチャットから退出した時に通知される。
* DM機能(ActionCable, Ajax)
  - ActionCableを用いてWebSocketによる双方向通信を行うことでリアルタイムチャットを実現。ActionCableのデータ送信機能を用いると、メッセージ送信時にリロードが生じるため、メッセージの送信側は、Ajaxで実装し、メッセージを受け取る側は、broadcastで受け取るように実装。(broadcastの送信先にメッセージ送信者は含めない)。このように実装することにより、完全なリアルタイムチャットを実現。
* 無限スクロール機能
  - 最初はメッセージを15件のみ表示し、スクロールすることによってJavaScriptを用いて追加で30件を取得。
* 勉強会のグループチャット機能(ActionCable, Ajax)
  - メッセージの送受信はDM機能同様にリアルタイムチャットを実現。また、グループチャットのメンバー一覧を表示、グループチャットからの退出機能を実装。
* 通報機能
  - 管理ユーザーのみ閲覧可能。
* ユーザー検索機能（Ajax, geocoder, Geolocation API）
  - タグ、都道府県の複数条件から検索可能。また、登録されているタグをクリックすることにより、クリックしたタグを登録しているユーザーを非同期通信で取得。
  - Geolocation APIを用いて現在地の緯度経度を取得、そして取得した緯度経度から住所を取得し、geocoderを用いてその周辺のユーザーを検索。（5 ~100 km 以内でユーザーが検索範囲を指定可能）
* 勉強会検索機能（タグ、都道府県の複数検索）
* 勉強会作成機能
  - ステップ登録を実現するためにsessionにより、情報の受け渡しを行った。また、開催場所を登録する際はGeocoding APIを用いてGoogleマップで場所を検索した際に自動で住所を補填。
* GoogleMap表示 （Google Maps JavaScript API)
  - gonを用いてrailsの変数をjavascriptに受け渡す。
* カレンダー表示
  - 参加している勉強会を表示。
* マッチング（フォロー）機能(Ajax)
* ブックマーク機能（Ajax）
  - 気になる勉強会に登録。
* タグ機能
* レスポンシブデザイン

## 環境・使用技術
### フロントエンド
* Materialize
* HTML
* SCSS
* JavaScript、jQuery、Ajax

### バックエンド
* Ruby 2.7.1
* Rails 6.0.3.4

### 開発環境
* Docker/Docker-compose
* MySQL（8.0.21）

### 本番環境
* AWS (VPC, EC2, RDS, Route53, ALB, ACM, S3, IAM, SES, CloudFront)
* MySQL（8.0.21）
* Nginx、 Puma
* Capistranoを用いて自動デプロイ

### インフラ構成図

![connect-study-aws](https://user-images.githubusercontent.com/70502790/107458032-9b516000-6b96-11eb-9faa-386f3fc005dd.png)

### テスト
* Rspec (system, request, model） 計216
* FactoryBot
* Capybara

### その他使用技術
* ruby構文規約チェックツール(rubocop)
* rails構文規約チェックツール(rubocop-rails)
* HTTPS接続
* チーム開発を意識したGitHubの活用 （イシュー、プルリク、マージ）

## ER図
![connect-study@ER図](https://user-images.githubusercontent.com/70502790/107457987-87a5f980-6b96-11eb-8f71-ffc6ad8e7822.png)