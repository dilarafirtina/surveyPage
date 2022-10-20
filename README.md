# surveyPage

## 1. adım 
flutter pub get 

## 2. adım
flutter build web --release
- Eğer flutter.js oluşmazsa:
  - önce flutter clean, sonra flutter build web --release

## 3. adım 
build klasörü içindeki web klasöründe index.html'de değişiklik yapılacak: 
Derledikten sonra, build/web içindeki index.html'in 17. satırında <base href="/"> olan ifade  => <base href="./"> olarak değişmeli ya da flutter'ın sayfasında şöyle bir ifade var: 

Update the <base href="/"> tag in web/index.html to the path where your app is hosted. For example, to host your Flutter app at my_app.dev/flutter_app, change this tag to <base href="/flutter_app/">.
Kaynak: https://docs.flutter.dev/development/ui/navigation/url-strategies


## 4. adım
build klasörü içindeki web klasörü server'a olduğu gibi kopyalanır.




