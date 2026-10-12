# 解答パッチ

各節の実習で行う修正をパッチファイルとして置いています。実習に取り組んだうえで
行き詰まったとき、または答え合わせをしたいときに利用してください。

| ファイル | 対応する節 | 修正内容 |
|---|---|---|
| `8-04-sca.patch` | 8.4 SCAの利用 | `moment` を 2.29.1 → 2.31.0 に更新 |
| `8-05-sast.patch` | 8.5 SASTの利用 | 抽選一覧の絞り込みで、利用者の入力の連結をやめプレースホルダーでバインド |
| `8-06-dast.patch` | 8.6 DASTの利用 | `helmet` の導入、Cookie の `httpOnly`、EJS のエスケープ |
| `8-08-manual.patch` | 8.8 手動脆弱性診断 | 応募詳細の認可、抽選の認可、応募上限の競合状態 |

## 使い方

パッチは前の節の修正を前提としているため、**節の順に適用してください**。
コマンドはリポジトリのフォルダーで、実習アプリを起動した状態（`docker compose up -d`）で実行します。

```bash
# 8.4 の解答だけを適用する
git apply solutions/8-04-sca.patch
docker compose exec app npm install     # package.json を変更したのでロックファイルを更新する

# 8.6 まで一気に適用する
git apply solutions/8-04-sca.patch
git apply solutions/8-05-sast.patch
git apply solutions/8-06-dast.patch
docker compose exec app npm install
```

`8-04-sca.patch` と `8-06-dast.patch` は `app/package.json` を変更します。適用後に
`docker compose exec app npm install` を実行して `app/package-lock.json` を更新してください。

パッチを当てたあとも、本書にない脆弱性が「SCA - npm audit」で検出されることがあります
（本書の刊行後に公表されたもの）。次のコマンドで、互換性を保ったまま更新できる修正版に
`app/package-lock.json` を更新し、コミットしてプッシュしてください（本書の【8.4 SCAの利用】の
「本書にない脆弱性が検出された場合」を参照）。

```bash
docker compose exec app npm audit fix --omit=dev --package-lock-only
git add app/package-lock.json
git commit -m "SCA: 推移的依存の脆弱性を修正"
git push
```

修正版がまだない脆弱性の場合は、その脆弱性が実習アプリに影響するかを評価し、DAST を手動実行する際に
「Run workflow」のメニューの「SCAの失敗を受け入れる理由」に評価の結果を記入してください。理由が記入されて
いると、SCA ジョブはそれを実行結果に記録して失敗を受け入れ、DAST へ進みます（空のままなら止まります）。

適用を取り消すには `-R` を付けます（適用したときと逆の順に実行します）。

```bash
git apply -R solutions/8-06-dast.patch
```

すべて元に戻すなら次のほうが確実です。

```bash
git checkout -- app/
docker compose exec app npm install
```
