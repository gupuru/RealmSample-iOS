//
//  ViewController.swift
//  RealmSample
//
//  Created by 新見晃平 on 2016/03/05.
//  Copyright © 2016年 kohei. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    //private var token: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCustomDefaultRealm()
        
        /*通知
        let realm = try! Realm()
        token = realm.objects(Pokemon).addNotificationBlock { results, error in
            print("変更")
        }
        */
        
        insert()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        //token!.stop()
    }

    //realmファイル名変更
    private func setCustomDefaultRealm() {
        var config = Realm.Configuration()
        
        // 保存先のディレクトリはデフォルトのままで、ファイル名を変更
        config.path = NSURL.fileURLWithPath(config.path!)
            .URLByDeletingLastPathComponent?
            .URLByAppendingPathComponent("pokemon")
            .URLByAppendingPathExtension("realm")
            .path
        
        // ConfigurationオブジェクトをデフォルトRealmで使用するように設定
        Realm.Configuration.defaultConfiguration = config
    }

    //書き込み
    private func insert() {
        let pokemon = Pokemon()
        pokemon.name = "ピカチュウ"
        pokemon.height = 0.4
        pokemon.type = "でんき"
        pokemon.weight = 6.0
        
        let realm = try! Realm()
        
        try! realm.write({ () -> Void in
            realm.add(pokemon)
        })
    }
    
    //クエリ
    private func select() {
        let realm = try! Realm()
        
        /* 全件取得
        let pokemons = realm.objects(Pokemon)
        for pokemon in pokemons {
            print(pokemon.name)
        }
        */
   
        /*クエリの連鎖
        let pokemons = realm.objects(Pokemon).filter("name = 'ピカチュウ'")
        let pokemon = pokemons.filter("name BEGINSWITH 'ピ'")
        print(pokemon.first?.name)
        */
        
        //検索条件指定
        let pokemon = realm.objects(Pokemon).filter("name = 'ピカチュウ'").first
        print(pokemon?.name)
    }
    
    //更新
    private func update() {
        let realm = try! Realm()
        let pokemon = realm.objects(Pokemon).filter("name = 'ピカチュウ'").first
        try! realm.write {
            pokemon?.weight = 10.0
        }
    }
    
    //削除
    private func delete() {
        let realm = try! Realm()
        
        let pokemon = realm.objects(Pokemon).filter("name = 'ピカチュウ'").first
        try! realm.write {
            realm.delete(pokemon!)
        }
    }

}

