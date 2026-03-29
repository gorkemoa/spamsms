# SpamShield iOS — Copilot README / Geliştirme Kuralları

> Bu doküman, **Swift ile geliştirilecek iOS spam arama ve spam SMS engelleme uygulaması** için Copilot / yapay zekâ kod üreticilerine verilecek **bağlayıcı geliştirme kurallarını** içerir. Bu kurallar opsiyonel değildir. Üretilen tüm kod, mimari kararlar, dosya yapısı ve özellikler bu belgeye **tam uyumlu** olmak zorundadır.

---

# 1. Proje Amacı

Bu uygulamanın amacı:

* kullanıcının cihazında çalışan,
* **spam çağrıları tanımlayan / engelleyen**,
* **istenmeyen SMS mesajlarını filtreleyen**,
* **gizlilik odaklı**,
* **Apple kurallarına uyumlu**,
* **yüksek kalite, production-grade**

iOS uygulaması oluşturmaktır.

Bu ürün bir oyuncak demo değildir. Kod kalitesi, mimari netlik, sürdürülebilirlik, test edilebilirlik ve App Store uyumluluğu ilk önceliktir.

---

# 2. Zorunlu Teknoloji Kararları

## 2.1 Dil ve framework

* Uygulama dili: **Swift**
* UI framework: **SwiftUI**
* Yerel veri yönetimi: **SwiftData** veya ihtiyaç varsa kontrollü şekilde **Core Data**
* Apple frameworkleri:

  * **CallKit / Call Directory Extension**
  * **IdentityLookup / Message Filter Extension**
  * gerekiyorsa **App Groups**
* Minimum hedef: modern iOS sürümü seçilecek, eski sürümlere gereksiz destek verilmeyecek

## 2.2 Mimari

Zorunlu mimari:

* **Modüler MVVM**
* View katmanı sade kalmalı
* İş mantığı View içinde yazılmamalı
* Servisler protocol tabanlı olmalı
* Extension’lar ile ana app birbirinden net ayrılmalı
* Shared storage katmanı App Group üzerinden yönetilmeli

Tercih edilen modül ayrımı:

* `App`
* `Core`
* `Domain`
* `Data`
* `Features`
* `Extensions`
* `Shared`
* `Resources`
* `Tests`

---

# 3. Değiştirilemez Temel Kurallar

## 3.1 Apple uyumu

Bu proje Apple’ın ilgili privacy, call blocking ve message filtering kurallarına tam uyumlu olacak.

### Yasaklar

Aşağıdakiler yapılmayacak:

* SMS içeriğini keyfi şekilde sunucuya göndermek
* Kullanıcının özel mesajlarını toplamak
* Mesajları reklam / profil çıkarma amacıyla kullanmak
* Gereksiz tracking eklemek
* Karanlık desenler (dark patterns) kullanmak
* Uygulamada olmayan özellikleri varmış gibi göstermek
* Sahte AI / sahte güvenlik iddiaları kullanmak
* Kullanıcıyı yanıltan “tam koruma”, “%100 engelleme” gibi doğrulanamaz claims yazmak

### Zorunluluklar

* Gizlilik öncelikli mimari kurulacak
* Veri minimizasyonu uygulanacak
* Mümkün olan her şey cihaz içinde yapılacak
* Extension yetenekleri Apple API sınırları içinde ele alınacak
* App Store açıklamaları teknik olarak doğru olacak

## 3.2 Backend varsayımı

İlk sürüm için varsayım:

* **Backend yok**
* Ürün **offline-first** olacak
* Spam listeleri ve kullanıcı tercihleri yerelde yönetilecek
* Sonradan backend eklenebilecek şekilde soyut katman kurulacak, ancak mevcut sprintte backend yazılmayacak

## 3.3 Sahte veri yasağı

* View içinde hardcode sahte spam kayıtları kullanılmayacak
* Dummy veri yalnızca **preview / test target** içinde olabilir
* Production akışında demo veri gösterilmeyecek
* “Lorem ipsum”, anlamsız placeholder, uydurma istatistik kullanılmayacak

## 3.4 Kod kalitesi

* Force unwrap yasak, gerçekten zorunlu değilse kullanılmayacak
* Massive ViewModel oluşturulmayacak
* Singleton kullanımı sınırlandırılacak
* Global mutable state oluşturulmayacak
* Magic string ve magic number minimumda tutulacak
* `TODO`, `FIXME`, yarım bırakılmış bloklarla teslim verilmeyecek

---

# 4. Ürün Kapsamı

## 4.1 v1 kapsamı

İlk sürümde aşağıdaki çekirdek özellikler olacak:

### Arama tarafı

* spam numara bloklama
* numara bazlı caller identification
* kullanıcı tarafından manuel blok listesi yönetimi
* beyaz liste / trusted numbers yönetimi
* ülke kodu / format normalize etme
* bloklanan / tanımlanan kayıtlar için sade geçmiş görünümü

### Mesaj tarafı

* spam SMS filtreleme
* keyword tabanlı yerel kural sistemi
* kullanıcı özel filtre kuralları
* güvenli gönderenler listesi
* şüpheli pattern algılama için kural motoru

### Ayarlar

* call blocking açık / kapalı
* SMS filtering açık / kapalı
* hassasiyet seviyesi
* kullanıcı whitelist / blacklist yönetimi
* veri sıfırlama
* gizlilik ekranı

### Yönetim / veri

* App Group üzerinden shared data storage
* extension’ların ortak veriyi güvenli şekilde okuması
* migration planı
* lokal performans optimizasyonu

## 4.2 v1 dışında kalanlar

İlk sürümde yapılmayacak:

* canlı sunucu sorgusu
* kullanıcılar arası topluluk tabanlı reporting
* hesap sistemi / üyelik
* push notification backend akışı
* gerçek zamanlı reputation score servisi
* reklam SDK’ları
* analytics SDK şişkinliği
* gereksiz üçüncü taraf bağımlılıklar

---

# 5. Uygulama Davranış İlkeleri

## 5.1 Güvenlik ve gizlilik

* Kullanıcı verisi minimum tutulmalı
* Mesaj ve çağrı verileri sadece gerekli kapsamda işlenmeli
* Hassas veriler için güvenli depolama tercih edilmeli
* Gerekiyorsa Keychain kullanılmalı
* Log’larda telefon numarası maskeleme yapılmalı
* Production log’larında hassas veri yazılmamalı

## 5.2 Performans

* Call directory yükleme işlemleri verimli olmalı
* Büyük blok listeleri için bellek dostu yaklaşım kullanılmalı
* UI ana thread’i bloklamamalı
* Veri okuma / yazma async ve kontrollü yürütülmeli
* Extension başlangıç süreleri düşük tutulmalı

## 5.3 Kullanıcı deneyimi

* Tek bakışta anlaşılır arayüz
* Karmaşık jargon minimumda
* Her kritik ayarın yanında kısa açıklama
* Boş durum ekranları kaliteli hazırlanmalı
* Hata mesajları insan diliyle yazılmalı
* Kullanıcının neyin engellendiğini ve nedenini anlaması sağlanmalı

---

# 6. Tasarım Kuralları

## 6.1 Görsel dil

Arayüz:

* modern
* premium
* sade
* güven veren
* abartısız

Kaçınılacaklar:

* ucuz antivirüs estetiği
* aşırı kırmızı / korku odaklı UI
* kalabalık dashboard
* rastgele ikon kullanımı
* Android benzeri kaba görsel yoğunluk

## 6.2 SwiftUI kuralları

* View’lar küçük ve parçalı yazılmalı
* Tek dosyada devasa ekran oluşturulmamalı
* Tekrar eden UI parçaları reusable component yapılmalı
* Theme ve spacing merkezi yönetilmeli
* Accessibility desteklenmeli
* Dynamic Type ve Dark Mode düşünülmeli

---

# 7. Dosya ve Klasör Standartları

Örnek yapı:

```text
SpamShield/
├── App/
│   ├── SpamShieldApp.swift
│   ├── AppRouter.swift
│   └── DependencyContainer.swift
├── Core/
│   ├── Extensions/
│   ├── Utilities/
│   ├── Logging/
│   └── Constants/
├── Domain/
│   ├── Entities/
│   ├── ValueObjects/
│   ├── Repositories/
│   └── UseCases/
├── Data/
│   ├── Storage/
│   ├── Mappers/
│   ├── Repositories/
│   └── Services/
├── Shared/
│   ├── AppGroup/
│   ├── Models/
│   └── Configuration/
├── Features/
│   ├── Dashboard/
│   ├── CallProtection/
│   ├── MessageProtection/
│   ├── BlockList/
│   ├── AllowList/
│   ├── Rules/
│   ├── History/
│   ├── Settings/
│   └── Onboarding/
├── Extensions/
│   ├── CallDirectoryExtension/
│   └── MessageFilterExtension/
├── Resources/
│   ├── Assets.xcassets
│   ├── Localizable.xcstrings
│   └── Preview Content/
└── Tests/
    ├── UnitTests/
    ├── IntegrationTests/
    └── UITests/
```

Kurallar:

* Feature bazlı ayrım korunacak
* Her feature kendi View / ViewModel / UseCase / components yapısına sahip olacak
* Shared ve extension sınırı net olacak
* Ortak model kopyaları oluşturulmayacak

---

# 8. Domain Model Kuralları

Temel domain nesneleri açıkça tanımlanmalı.

Örnekler:

* `PhoneNumber`
* `BlockedNumber`
* `AllowedNumber`
* `SpamRule`
* `MessagePattern`
* `CallIdentificationEntry`
* `ProtectionStatus`
* `FilterDecision`
* `SpamCategory`
* `ProtectionEvent`

Kurallar:

* Telefon numarası string olarak rastgele taşınmayacak
* Mümkün olduğunca value object mantığı kullanılacak
* Normalize edilmemiş numara ile iş yapılmayacak
* Domain modelleri UI bağımsız olacak
* Codable, Hashable, Sendable ihtiyaçları dikkatli verilecek

---

# 9. Veri Depolama Kuralları

## 9.1 Shared storage

Ana uygulama ile extension’lar arasında paylaşılacak veri için:

* App Group kullanılacak
* Dosya / veri formatı tutarlı olacak
* Concurrency çakışmalarına dikkat edilecek
* Shared storage erişimi tek merkezden yapılacak

## 9.2 Veri kategorileri

Yerelde tutulabilecek veriler:

* bloklu numaralar
* izinli numaralar
* kullanıcı filtre kuralları
* uygulama ayarları
* hafif olay geçmişi

Yerelde tutulurken dikkat:

* gereksiz tarihçe biriktirme yok
* retention policy olmalı
* veri boyutu kontrol edilmeli

---

# 10. Call Blocking / Caller ID Kuralları

## 10.1 Teknik sınırlar

Call Directory Extension Apple’ın izin verdiği sınırlar içinde kullanılacak.

* Numara bazlı bloklama yapılır
* Numara bazlı tanımlama yapılır
* Apple’ın desteklemediği davranışlar simüle edilmeye çalışılmaz
* Kullanıcıya API’nin yapamadığı şey yapılabiliyormuş gibi anlatılmaz

## 10.2 Veri hazırlama

* Numara listeleri normalize edilmeli
* Duplicate kayıtlar temizlenmeli
* Büyük listeler incremental mantıkla yönetilmeli
* Yeniden yükleme işlemi kontrollü yapılmalı

## 10.3 UX

* “Koruma aktif” durumu net görünmeli
* Extension etkinleştirme adımları açık anlatılmalı
* Kullanıcıya Ayarlar içinde neyi açması gerektiği sade anlatılmalı

---

# 11. SMS Filtering Kuralları

## 11.1 Kural motoru

Mesaj filtreleme için v1 yaklaşımı:

* keyword tabanlı kurallar
* regex destekli pattern kuralları
* whitelist önceliği
* riskli kelime grupları için kategori sistemi
* lokal karar üretimi

Örnek spam kategorileri:

* sanal kumar / bahis
* sahte banka / ödeme
* kargo dolandırıcılığı
* yatırım / hızlı kazanç
* yetişkin içerik / tuzak link
* sahte kampanya / çekiliş

## 11.2 Kurallar

* Kural motoru deterministik olmalı
* Kararların nedeni açıklanabilir olmalı
* Kurallar test edilebilir yapıda yazılmalı
* ViewModel içine regex gömülmeyecek
* Kurallar merkezi bir policy katmanında tutulacak

## 11.3 False positive minimizasyonu

* güvenli gönderenler her zaman öncelikli
* yalnız tek bir kelimeyle agresif bloklama yapılmamalı
* hassasiyet seviyelerine göre farklı davranış desteklenmeli
* kritik mesajların yanlış engellenmesi azaltılmalı

---

# 12. Onboarding Kuralları

Onboarding sade ve dürüst olacak.

Anlatılması gerekenler:

* uygulamanın ne yaptığı
* ne yapamadığı
* çağrı korumasını açmak için hangi sistem ayarlarının gerekli olduğu
* SMS filtrelemenin nasıl çalıştığı
* gizlilik yaklaşımı

Onboarding’de yapılmayacaklar:

* sahte korku dili
* kullanıcıyı baskılayan full-screen manipülasyon
* yanıltıcı güvenlik söylemleri

---

# 13. Ayarlar ve Konfigürasyon

Ayarlar ekranı minimum şu alanları içermeli:

* call protection toggle
* message protection toggle
* spam sensitivity seçimi
* blocked numbers yönetimi
* allowed numbers yönetimi
* custom keywords yönetimi
* risk categories yönetimi
* data clear / reset
* privacy explanation
* support / feedback alanı

Kurallar:

* Her ayar tek cümlede açıklanmalı
* Kritik ayarlar geri alınabilir olmalı
* “Reset all” işlemleri için onay olmalı

---

# 14. Loglama ve Hata Yönetimi

## 14.1 Logging

* Structured logging kullanılmalı
* Debug ve production log seviyeleri ayrılmalı
* Hassas veri maskelenmeli
* Phone number, message content gibi veriler açık yazılmamalı

## 14.2 Error handling

* Sessizce yutulan error olmayacak
* Kullanıcıya teknik çöp hata gösterilmeyecek
* Recoverable error’lar için yönlendirici mesaj verilecek
* Extension hata senaryoları ayrıca ele alınacak

---

# 15. Test Kuralları

Test zorunludur. Testsiz kritik akış teslim edilmez.

## 15.1 Unit test

Test edilecek alanlar:

* phone number normalization
* spam rule evaluation
* whitelist / blacklist önceliği
* sensitivity behavior
* repository logic
* mapper logic

## 15.2 Integration test

* shared storage akışı
* app ile extension veri paylaşımı
* migration senaryoları
* rule persistence

## 15.3 UI test

* onboarding akışı
* ayarlar akışı
* blok listesi yönetimi
* özel kural ekleme / silme

Kurallar:

* flaky test yazılmayacak
* snapshot test kullanılırsa kontrollü kullanılacak
* test isimleri açık olacak

---

# 16. Copilot İçin Kod Üretim Talimatları

Bu bölüm Copilot’a doğrudan yön verir.

## 16.1 Üretim tarzı

Copilot aşağıdaki şekilde üretim yapmalı:

* production-grade kod yaz
* kısa ama yüzeysel olmayan çözümler üret
* önce mimariyi koru, sonra ekranı yaz
* iş mantığını View içine koyma
* reusable component çıkar
* protocol-first düşün
* dependency injection uygula
* async/await kullan
* test edilebilir kod yaz
* Apple framework sınırlarına sadık kal

## 16.2 Yapmaması gerekenler

Copilot şunları üretmemeli:

* tek dosyada devasa feature
* comments ile açıklanmış ama çalışmayan pseudo-code
* placeholder dolu demo ekranlar
* mimariyi bozan kestirme çözümler
* gizlilik riski doğuran veri toplama akışları
* App Store’da sorun çıkaracak yanıltıcı UI metinleri
* gereksiz third-party package bağımlılıkları

## 16.3 Kod üretmeden önce varsayması gerekenler

Copilot şu varsayımlarla çalışmalı:

* app backend’siz v1 olarak geliştiriliyor
* call blocking ve message filtering Apple extension’larıyla yapılacak
* veriler App Group shared storage ile paylaşılacak
* UI SwiftUI ile yazılacak
* yapı modüler MVVM olacak
* tüm public API’ler net isimlendirilecek

## 16.4 Çıktı standardı

Kod üretirken şu sırayı izle:

1. ilgili feature için klasör yapısını öner
2. domain modelini tanımla
3. protocol’leri oluştur
4. concrete repository / service yaz
5. use case yaz
6. view model yaz
7. swiftui view yaz
8. preview ve test örneklerini ekle

---

# 17. İsimlendirme Kuralları

* Açık ve niyet belirten isimler kullanılmalı
* `Manager`, `Helper`, `Utils` gibi belirsiz isimler minimumda tutulmalı
* Boolean isimleri `is`, `has`, `can`, `should` ile başlamalı
* Use case isimleri fiil odaklı olmalı

  * `NormalizePhoneNumberUseCase`
  * `EvaluateSpamMessageUseCase`
  * `ReloadCallDirectoryUseCase`

---

# 18. Concurrency Kuralları

* Swift Concurrency tercih edilecek
* Ana actor gereksiz kullanılmayacak
* Shared state erişimleri kontrollü yapılacak
* IO işlemleri ana thread’de yapılmayacak
* Race condition ihtimali olan shared storage akışları açıkça korunacak

---

# 19. Localization Kuralları

* Başlangıçta en az Türkçe ve İngilizce desteklenecek
* UI string’leri hardcode edilmeyecek
* Tüm kullanıcıya görünen metinler localizable olacak
* Güvenlik / gizlilik ekranları da lokalize edilecek

---

# 20. App Store Hazırlık Kuralları

Uygulama mağaza metinleri teknik gerçekle uyumlu olmalı.

Yapılacaklar:

* dürüst özellik anlatımı
* gizlilik odaklı positioning
* “works on device” yaklaşımı vurgulanabilir
* yanıltıcı claim yok

Yapılmayacaklar:

* “AI security engine” gibi içi boş pazarlama
* “100% block all spam” gibi doğrulanamaz vaat
* desteklenmeyen sistem özelliklerini destekliyormuş gibi anlatmak

---

# 21. Definition of Done

Bir feature tamamlanmış sayılması için:

* mimariye uygun olmalı
* compile olmalı
* testleri bulunmalı
* kullanıcı akışı çalışmalı
* hata durumları ele alınmış olmalı
* localizable string’ler çıkarılmış olmalı
* gizlilik riski doğurmamalı
* extension uyumu düşünülmüş olmalı
* teknik borç notu bırakmadan teslim edilmeli

---

# 22. Copilot Prompt Kısa Versiyon

Aşağıdaki kısa prompt, Copilot oturumlarında tekrar kullanılabilir:

```text
Bu proje SwiftUI + Swift tabanlı production-grade iOS spam arama ve spam SMS engelleme uygulamasıdır. Modüler MVVM mimarisi kullan. CallKit / Call Directory Extension ve IdentityLookup / Message Filter Extension ile Apple uyumlu çalış. v1 backend’sizdir. App Group shared storage kullan. View içinde iş mantığı yazma. Protocol-first ilerle. Test edilebilir, temiz, privacy-first kod üret. Sahte veri, placeholder, devasa dosya, pseudo-code, tracking ve yanıltıcı claim üretme. Tüm kullanıcı metinlerini localizable yaz. Her feature için model -> protocol -> repository/service -> use case -> viewmodel -> swiftui view sırasını izle.
```

---

# 23. Son Not

Bu proje için temel kalite eksenleri:

* **privacy-first**
* **Apple-safe**
* **clean architecture**
* **offline-first v1**
* **testability**
* **premium UX**

Copilot tarafından üretilen her kod parçası bu eksenlere göre değerlendirilecek. Bu kurallara uymayan öneriler reddedilmelidir.
