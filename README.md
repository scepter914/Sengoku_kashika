## 概要
1562年地点での各武家毎の関係を経度緯度上にGraphvizで可視化
赤が敵対、青が同盟or友好

##環境
* ruby
* Graphviz

##関数の概要
* show\_allgraph すべての武家の関係を表示
* show\_surround(name) ある武家の周辺のみ表示
* relation(buke\_a,buke\_b) 武家aと武家bの関係
* isolation(name) 孤立しているかどうかの判定

## 実行
* ruby sengoku.rb
main関数の中をいじると武家を変えることができる
* dot to png 
dot -Tpng sengoku.dot -o sengoku.png

