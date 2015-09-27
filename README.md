# 発車ベルスイッチ

## 概要
Raspberry Pi を用いて発車メロディーを鳴らすための装置

## 説明
GPIOでスイッチの検知を行い、それによってwavファイルを再生するだけです。  
内部でWeb Consoleを立てているので、そこから曲を切り替えられます。  

今のところは`./music`内のwavファイルを無慈悲に再生することしか出来ません。

## デプロイ
MacOSX(darwin)とLinuxのみ対応です。  

Windowsでは動かないと思います。  
ALSAを対応すれば、WebConsoleだけは動くかも。

### 必要言語
Node.js v4.1.1

### 普通に動かす場合

```
npm install --production
npm install -g coffee-script
coffee app.coffee
```

### デーモン化する場合

```
npm install -g pm2
pm2 start app.coffee
```

## Develop

```
npm install
coffee build.coffee
```

build.coffeeを実行すると、フロント側のassetsが自動でビルドされます。  
app.coffeeも実行しないとバックエンドは動かないので注意です。

## TODO
- GPIOの値を読み取る
- ~~WebConsoleの作成~~

## License


The MIT License (MIT)

Copyright (c) 2015 Koutarou Yabe.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
