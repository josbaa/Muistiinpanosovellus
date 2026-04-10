# Muistiinpanosovellus

Flutterilla toteutettu kurssityö: muistiinpanot pilvessä **Firebase**-palveluilla (**Authentication** + **Cloud Firestore**). Käyttäjä kirjautuu sähköpostilla ja hallitsee omia muistiinpanojaan.

## Vaatimukset

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Dart SDK mukana)
- Firebase-projekti, jossa on käytössä **Authentication** (Email/Password) ja **Firestore**
- Tiedosto `lib/firebase_options.dart` (yleensä [FlutterFire CLI](https://firebase.flutter.dev/docs/cli/): `flutterfire configure`)

## Asennus ja ajo

Projektin juuressa:

```bash
flutter pub get
flutter run
```

Valitse laite tai alusta, kun Flutter pyytää (esim. Chrome tai Android-emulaattori).

## Mitä repossa on

| Tiedosto / kansio        | Kuvaus                                      |
|--------------------------|---------------------------------------------|
| `lib/main.dart`          | Sovelluksen UI ja Firebase-logiikka         |
| `lib/firebase_options.dart` | Firebase-asetukset (generoitu)          |
| `DOCUMENTATION.md`       | Kurssidokumentaatio (tarkempi kuvaus)       |
| `SPEC.md`                | Tehtävänanto / tavoitteet                   |

## Teknologiat

- **Flutter** (Material)
- **firebase_core**, **firebase_auth**, **cloud_firestore**

## Lisätietoa

Katso **[DOCUMENTATION.md](DOCUMENTATION.md)** (ominaisuudet, paketit, palvelut, näkymät).


