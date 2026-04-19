# Muistiinpanosovellus

Flutter + Firebase -kurssityö: kirjautuminen sähköpostilla ja omat muistiinpanot **Cloud Firestore** -tietokannassa.

**Repo:** [github.com/josbaa/Muistiinpanosovellus](https://github.com/josbaa/Muistiinpanosovellus)

## Ominaisuudet

- Firebase **Authentication** (sähköposti / salasana): rekisteröityminen, kirjautuminen, uloskirjautuminen
- **Firestore**-muistiinpanot polussa `users/{uid}/notes/{noteId}`: lisää, listaa, muokkaa, poista (vahvistus ennen poistoa)
- Reaaliaikainen lista (`StreamBuilder`)

## Vaatimukset

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Dart ^3.5)
- Firebase-projekti: **Authentication** (Email/Password) + **Firestore**
- `lib/firebase_options.dart` — generoi esim. [FlutterFire CLI](https://firebase.google.com/docs/flutter/setup): `dart pub global activate flutterfire_cli` → `flutterfire configure`

## Kloonaus ja ajo

```bash
git clone https://github.com/josbaa/Muistiinpanosovellus.git
cd Muistiinpanosovellus
flutter pub get
flutter run
```

Valitse laite tai alusta, kun Flutter pyytää (esim. **Chrome**, **Edge** tai Android-emulaattori).

## Projektin rakenne (tärkeimmät)

| Polku | Sisältö |
|--------|---------|
| `lib/main.dart` | UI, Auth, Firestore |
| `lib/firebase_options.dart` | Firebase-asetukset (generoitu, älä muokkaa käsin) |
| [DOCUMENTATION.md](DOCUMENTATION.md) | Kurssidokumentaatio |
| [SPEC.md](SPEC.md) | Tavoitteet / tehtäväkuvaus |

## Riippuvuudet

`firebase_core`, `firebase_auth`, `cloud_firestore` — versiot: [pubspec.yaml](pubspec.yaml).

## Lisätietoa

- **[DOCUMENTATION.md](DOCUMENTATION.md)** — palvelut, näkymät, paketit, laiteominaisuudet
- [Flutter-dokumentaatio](https://docs.flutter.dev/)
