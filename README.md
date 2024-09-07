# sphinx-example

## SphinxをMarkdownで記述する方法

```sh
(.venv) % pip install --upgrade myst-parser
```

conf.py ファイルを編集

```python
extensions = [
    'myst_parser'
]
```

source_suffixを追記

```python
source_suffix = {
    '.rst': 'restructuredtext',
    '.md': 'markdown',
}
```
[マークダウン｜Sphinx の使い方](https://zenn.dev/y_mrok/books/sphinx-no-tsukaikata/viewer/chapter26)

## Sphinxのドキュメントが変更されたら、自動的にビルドをしてブラウザを再読み込みする方法

```sh
(.venv) % pip install sphinx-autobuild
(.venv) % sphinx-autobuild source build/html
(.venv) % sphinx-autobuild source build/html --port 8001  # ポート番号を指定する場合
```

[Python製静的サイトジェネレーターSphinxでWebサイトを構築して公開 | gihyo.jp](https://gihyo.jp/article/2024/06/monthly-python-2406#ghdhq_VseY)
