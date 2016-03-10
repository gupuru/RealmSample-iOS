
# [Realm](https://realm.io/jp/ "Realm")の基本

iOS(swift)のRealmのサンプルと基本的な使い方ガイド

## インストール方法

```ruby
use_frameworks!  

pod 'RealmSwift'
```

## モデル

sqlで言うと、Tableのようなものになる。

```swift
import RealmSwift

// Pokemon model
class Pokemon: Object {

    dynamic var name: String = ""
    dynamic var height: Float = 0.0
    dynamic var weight: Float = 0.0
    dynamic var type: String = ""

    override static func primaryKey() -> String? {
        return "name"
    }

}
```

対応している型は、こんな感じ。

```
Bool、Int8、Int16、Int32、Int64、Double、Float、String、NSDate（ミリ秒以下は切り捨て）、NSData。
```

プロパティ属性は以下のものがある。

- インデックス

```swift
override static func indexedProperties() -> [String] {
  return ["name"]
}
```

- プライマリキー

```swift
override static func primaryKey() -> String? {
  return "name"
}
```

- 保存しない

```swift
override static func ignoredProperties() -> [String] {
  return ["name"]
}
```

## 書き込み

基本的には、こういう風に書く。

```java
let pokemon = Pokemon()
pokemon.name = "ピカチュウ"
pokemon.height = 0.4
pokemon.type = "でんき"
pokemon.weight = 6.0

let realm = try! Realm()

try! realm.write({ () -> Void in
  realm.add(pokemon)
})
```

ちなみに、realmファイルの保存場所は以下になる。
また、ファイル名は、default.realm。

```
/Users/<username>/Library/Developer/CoreSimulator/Devices/<simulator-uuid>/data/Containers/Data/Application/<application-uuid>/Documents/default.realm
```

ファイル名を変更したい場合は、以下のようにする。

```swift
var config = Realm.Configuration()

// 保存先のディレクトリはデフォルトのままで、ファイル名を「pokemon」に変更
config.path = NSURL.fileURLWithPath(config.path!)
          .URLByDeletingLastPathComponent?
          .URLByAppendingPathComponent("pokemon")
          .URLByAppendingPathExtension("realm")
          .path

// ConfigurationオブジェクトをデフォルトRealmで使用するように設定
Realm.Configuration.defaultConfiguration = config
```

また、このファイルは、「[Realm Browser](https://github.com/realm/realm-browser-osx/releases)」 を使えば、中身を見ることができる。

Mac App Storeにもあるが、こちらは古い可能性がある。

Githubのほうに最新版があるので、できるだけGithubのやつを使うのが良い。

## クエリ

```swift
let realm = try! Realm()

//全件取得
let pokemons = realm.objects(Pokemon)

//検索条件
let pokemon = realm.objects(Pokemon).filter("name = 'ピカチュウ'").first
```

検索条件は以下のとおりです。(他にもある)

```
//比較演算子
==、<=、<、>=、>、!=

//論理演算子
“AND”、“OR”、“NOT”

//いずれかの条件と一致するかどうか
IN

//集計関数
@count、@min、@max、@sum、@avg
```

クエリは、つなげていくことも可能です。

```swift
let pokemons = realm.objects(Pokemon).filter("name = 'ピカチュウ'")
let pokemon = pokemons.filter("name BEGINSWITH 'ピ'")
```

## update

更新処理は、このやり方以外にもあるので、時と場合によって使い分ける。

```java
let realm = try! Realm()

let pokemon = realm.objects(Pokemon).filter("name = 'ピカチュウ'").first
try! realm.write {
  pokemon?.weight = 10.0
}
```

## 削除

```swift
let pokemon = realm.objects(Pokemon).filter("name = 'ピカチュウ'").first
try! realm.write {
  realm.delete(pokemon!)
}
```

## 通知

Realmが変更されたときの通知を受け取ることが出来ます。

```swift
let token = realm.objects(Pokemon).addNotificationBlock { results, error in
        print("変更")
}

token!.stop()
```
必要なくなったら、stop()を呼ぶ

## マイグレーション

```swift
let config = Realm.Configuration(

  schemaVersion: 1,

  migrationBlock: { migration, oldSchemaVersion in
    // 最初のマイグレーションの場合、`oldSchemaVersion`は0
    if (oldSchemaVersion < 1) {

    }
  })

// デフォルトRealmに新しい設定を適用
Realm.Configuration.defaultConfiguration = config

// 自動的にマイグレーションが実行
let realm = try! Realm()
```

この辺りの書き方は、[Realm公式のサンプル](https://github.com/realm/realm-cocoa/tree/master/examples/ios/swift-2.1.1/Migration
)を見たほうが良いです。
