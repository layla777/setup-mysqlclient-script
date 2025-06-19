# MySQL クライアントセットアップスクリプト (`mclient.sh`)
**Current Version:** v0.9.0


[![MIT ライセンス](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

このスクリプトは、macOS上でのMySQLクライアントに関連する環境変数のセットアップと、Pythonライブラリである `mysqlclient` パッケージのインストールを自動化します。HomebrewでインストールしたMySQLバージョンとの統合を容易にし、手動作業を簡略化します。

## 特徴

- **マルチアーキテクチャ対応**: Apple Silicon (M1/M2) およびIntelベースのmacOSシステムで動作します。
- **自動環境設定**: `PATH`、`CFLAGS`、`LDFLAGS` など、`mysqlclient` が正しく動作するために必要なすべての環境変数を設定します。
- **バージョン柔軟性**: 複数のMySQLバージョン（デフォルトは `mysql@8.0`）をサポートします。
- **プロジェクト固有のインストール**: カレントディレクトリに `requirements.txt` ファイルがあれば、それを読み取り `mysqlclient` バージョンをインストールします。
- **便利なエラーハンドリング**: 必要な依存関係が不足している場合に明確な解決手順を提示します。

## 必要条件

このスクリプトを使用する前に、以下を確認してください：

1. **macOS環境**  
   このスクリプトは現在、macOS（Apple SiliconおよびIntel）専用です。

2. **Homebrewがインストールされていること**  
   MySQLはHomebrewを使用してインストールされている必要があります。例：`brew install mysql@8.0`

3. **Pythonとpipがインストールされていること**  
   Python（推奨バージョン3.x）および `pip` をインストールしてください。

4. **任意**: `requirements.txt` ファイルの用意  
   現在のディレクトリにこのファイルが存在する場合、スクリプトはその中で指定された `mysqlclient` のバージョンを使用します。

## インストール

スクリプトを `/usr/local/bin` のような環境変数 `PATH` に含まれるディレクトリに配置します。
```
mv mclient.sh /usr/local/bin/mclient
chmod +x /usr/local/bin/mclient
``` 

## 使用方法

MySQLバージョンを指定するかどうかに関わらず、以下のようにスクリプトを実行します。

### 例1: デフォルトのMySQLバージョン (`mysql@8.0`) を使用する場合
```
mclient
``` 

### 例2: MySQLバージョンを指定する場合
```
mclient mysql@8.4
``` 

### 例3: ヘルプメニューを表示する場合
```
mclient --help
``` 

## 仕組み

1. **環境検出**  
   システムのアーキテクチャ（Apple SiliconまたはIntel）を検出し、MySQLの正しいパスを初期化します。

2. **環境変数の設定**  
   `CFLAGS`、`LDFLAGS` など、`mysqlclient` をビルドするために必要な環境変数を設定します。

3. **mysqlclient パッケージのセットアップ**  
   既存の `mysqlclient` バージョンをアンインストールし、必要なバージョンをインストールします。このとき、`requirements.txt` をオプションで読み取ります。

4. **エラーチェック**  
   必要な依存関係（例：`pkg-config` や `pip`）がインストールされているかを検証し、問題があれば解決手順を提示します。

## コントリビューション

バグを見つけた場合や改善の提案がある場合は、[issueページ](https://github.com/your-repo-link/issues) を開くか、[Pull Request](https://github.com/your-repo-link/pulls) を作成してください。

## ライセンス

このプロジェクトは [MITライセンス](LICENSE) の元でライセンスされています。
