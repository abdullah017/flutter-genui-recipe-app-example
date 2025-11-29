# Flutter GENUI AI Recipe Assistant / AI Tarif Asistani

[English](#english) | [Turkce](#turkce)

---

## English

### About

AI Recipe Assistant is a Flutter application that uses Google's GenUI framework to create dynamic, AI-powered user interfaces. The app helps users discover recipes based on available ingredients using Gemini AI.

### Features

- **AI-Powered Recipes**: Get personalized recipe suggestions based on your ingredients
- **Dynamic UI Generation**: UI components are generated dynamically by AI using GenUI
- **Custom Widgets**: Beautiful recipe cards, ingredient lists, step cards, and serving sliders
- **Real-time Interaction**: Chat-based interface for natural conversation with AI

### Screenshots


<img width="400" height="2868" alt="Simulator Screenshot - iPhone 17 Pro Max - 2025-11-29 at 13 40 34" src="https://github.com/user-attachments/assets/e58bd6ad-e5b4-4c6c-a552-70f670a27f26" />
<img width="400" height="2868" alt="Simulator Screenshot - iPhone 17 Pro Max - 2025-11-29 at 13 40 28" src="https://github.com/user-attachments/assets/f5cb3fe5-de3b-4bee-bfd8-83e1c0e83697" />
<img width="400" height="2868" alt="Simulator Screenshot - iPhone 17 Pro Max - 2025-11-29 at 13 40 23" src="https://github.com/user-attachments/assets/527d3ad3-5b1c-48bf-ae4a-a119d4623650" />



https://github.com/user-attachments/assets/023b0b02-84ec-4bcb-82fb-f896e3442d1b



### Tech Stack

- **Flutter** - Cross-platform UI framework
- **GenUI** - Google's generative UI framework
- **Gemini AI** - Google's generative AI model
- **Material 3** - Modern design system

### Project Structure

```
lib/
├── main.dart                    # App entry point
├── screens/
│   └── chat_screens.dart        # Main chat screen
├── catalog/
│   ├── recipe_catalog.dart      # Widget catalog & system prompt
│   └── catelog_items/
│       ├── recipe_card.dart     # Recipe summary card
│       ├── ingredient_list.dart # Ingredients with checkboxes
│       ├── serving_slider.dart  # Portion adjuster
│       └── step_card.dart       # Cooking step card
└── widget/
    └── message_buble.dart       # Chat message bubble
```

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd recipe_genui_app_example
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Get Gemini API Key**
   - Go to [Google AI Studio](https://aistudio.google.com/apikey)
   - Create an API key

4. **Run the app**
   ```bash
   flutter run --dart-define=GEMINI_API_KEY=your_api_key_here
   ```

### VS Code Configuration

Create `.vscode/launch.json`:
```json
{
  "configurations": [
    {
      "name": "Flutter",
      "request": "launch",
      "type": "dart",
      "args": [
        "--dart-define=GEMINI_API_KEY=your_api_key_here"
      ]
    }
  ]
}
```

### Custom Widgets

| Widget | Description |
|--------|-------------|
| `RecipeCard` | Displays recipe title, duration, difficulty, and emoji |
| `IngredientList` | Interactive ingredient checklist with quantities |
| `ServingSlider` | Adjustable portion size slider |
| `StepCard` | Cooking instruction steps with tips and timing |

### Requirements

- Flutter SDK ^3.10.0
- Dart SDK ^3.10.0
- Gemini API Key

---

## Turkce

### Hakkinda

AI Tarif Asistani, Google'in GenUI framework'unu kullanarak dinamik, yapay zeka destekli kullanici arayuzleri olusturan bir Flutter uygulamasidir. Uygulama, Gemini AI kullanarak mevcut malzemelere gore tarif onerileri sunar.

### Ozellikler

- **AI Destekli Tarifler**: Malzemelerinize gore kisisellestirilmis tarif onerileri
- **Dinamik UI Olusturma**: GenUI ile AI tarafindan dinamik olarak olusturulan arayuz bilesenleri
- **Ozel Widget'lar**: Guzel tarif kartlari, malzeme listeleri, adim kartlari ve porsiyon ayarlayici
- **Gercek Zamanli Etkilesim**: AI ile dogal sohbet tabanli arayuz

### Ekran Goruntuleri

<img width="400" height="2868" alt="Simulator Screenshot - iPhone 17 Pro Max - 2025-11-29 at 13 40 34" src="https://github.com/user-attachments/assets/e58bd6ad-e5b4-4c6c-a552-70f670a27f26" />
<img width="400" height="2868" alt="Simulator Screenshot - iPhone 17 Pro Max - 2025-11-29 at 13 40 28" src="https://github.com/user-attachments/assets/f5cb3fe5-de3b-4bee-bfd8-83e1c0e83697" />
<img width="400" height="2868" alt="Simulator Screenshot - iPhone 17 Pro Max - 2025-11-29 at 13 40 23" src="https://github.com/user-attachments/assets/527d3ad3-5b1c-48bf-ae4a-a119d4623650" />

https://github.com/user-attachments/assets/023b0b02-84ec-4bcb-82fb-f896e3442d1b

### Teknoloji Yigini

- **Flutter** - Coklu platform UI framework'u
- **GenUI** - Google'in uretken UI framework'u
- **Gemini AI** - Google'in uretken AI modeli
- **Material 3** - Modern tasarim sistemi

### Proje Yapisi

```
lib/
├── main.dart                    # Uygulama giris noktasi
├── screens/
│   └── chat_screens.dart        # Ana sohbet ekrani
├── catalog/
│   ├── recipe_catalog.dart      # Widget katalogu & sistem promptu
│   └── catelog_items/
│       ├── recipe_card.dart     # Tarif ozet karti
│       ├── ingredient_list.dart # Isaretlenebilir malzeme listesi
│       ├── serving_slider.dart  # Porsiyon ayarlayici
│       └── step_card.dart       # Pisirme adimi karti
└── widget/
    └── message_buble.dart       # Sohbet mesaj baloncugu
```

### Kurulum

1. **Repoyu klonlayin**
   ```bash
   git clone <repository-url>
   cd recipe_genui_app_example
   ```

2. **Bagimliliklari yukleyin**
   ```bash
   flutter pub get
   ```

3. **Gemini API Anahtari Alin**
   - [Google AI Studio](https://aistudio.google.com/apikey) adresine gidin
   - Bir API anahtari olusturun

4. **Uygulamayi calistirin**
   ```bash
   flutter run --dart-define=GEMINI_API_KEY=api_anahtariniz
   ```

### VS Code Yapilandirmasi

`.vscode/launch.json` dosyasi olusturun:
```json
{
  "configurations": [
    {
      "name": "Flutter",
      "request": "launch",
      "type": "dart",
      "args": [
        "--dart-define=GEMINI_API_KEY=api_anahtariniz"
      ]
    }
  ]
}
```

### Ozel Widget'lar

| Widget | Aciklama |
|--------|----------|
| `RecipeCard` | Tarif basligi, suresi, zorlugu ve emojisini gosterir |
| `IngredientList` | Miktarlarla birlikte etkilesimli malzeme kontrol listesi |
| `ServingSlider` | Ayarlanabilir porsiyon boyutu kaydirici |
| `StepCard` | Ipuclari ve zamanlama ile pisirme talimati adimlari |

### Gereksinimler

- Flutter SDK ^3.10.0
- Dart SDK ^3.10.0
- Gemini API Anahtari

---

## License / Lisans

MIT License

## Contributing / Katki

Pull requests are welcome! / Pull request'ler memnuniyetle karsilanir!
