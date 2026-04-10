# Muistiinpanosovellus — dokumentaatio

## 1. Sovelluksen nimi

**Muistiinpanosovellus**

## 2. Mitä sovellus tekee

Sovellus on kirjautumisen vaativa muistiinpanosovellus. Käyttäjä luo tilin sähköpostilla ja salasanalla tai kirjautuu sisään, minkä jälkeen hän voi lisätä, listata, muokata ja poistaa omia muistiinpanojaan. Muistiinpanot tallennetaan pilveen Firebase Firestoreen käyttäjäkohtaiseen kokoelmaan.

## 3. Ketkä ovat tehneet työn

Tekijänä toimi Johannes Könönen.
Opiskelijanumero: 2317960

## 4. Mitä ominaisuuksia sovelluksessa on

- **Firebase Authentication (sähköposti ja salasana)**  
  Kirjautuminen, rekisteröityminen ja uloskirjautuminen. Kirjautumistilan seuranta `authStateChanges()`-virran avulla.

- **Muistiinpanot Firestoressa**  
  Polku: `users/{käyttäjän uid}/notes/{muistiinpanon id}`.  
  Kentät: uudessa muistiinpanossa vähintään `text` ja `createdAt`; muokkauksessa päivitetään `text` ja `updatedAt`.

- **Lisäys**  
  Tekstikenttä ja painike uuden muistiinpanon lisäämiseen (tyhjää tekstiä ei tallenneta).

- **Listaus**  
  Reaaliaikainen lista käyttäjän omista muistiinpanoista (`StreamBuilder` + Firestore-kuuntelu).

- **Muokkaus**  
  Muistiinpanon tekstiä voi muokata dialogissa. Tyhjää tekstiä (trimauksen jälkeen) ei tallenneta.

- **Poisto**  
  Muistiinpanon voi poistaa; poisto vaatii erillisen vahvistuksen dialogissa.

- **Virheilmoitukset**  
  Kirjautumisessa, rekisteröinnissä sekä muistiinpanojen tallennuksessa, muokkauksessa ja poistossa näytetään käyttäjälle ymmärrettäviä virhe- tai palauteviestejä (esimerkiksi punainen teksti ja/tai SnackBar).

## 5. Mitä paketteja projekti käyttää

**Tuotantoriippuvuudet (`dependencies`):**

| Paketti        | Käyttötarkoitus                          |
|----------------|-------------------------------------------|
| `flutter`      | Flutter SDK, käyttöliittymä              |
| `firebase_core` | Firebase-alustus sovelluksessa        |
| `firebase_auth` | Käyttäjien tunnistus sähköpostilla     |
| `cloud_firestore` | Muistiinpanotietokanta pilvessä      |

**Kehitysriippuvuudet (`dev_dependencies`):**

| Paketti        | Käyttötarkoitus                |
|----------------|---------------------------------|
| `flutter_test` | Testaus (Flutterin mukana)     |
| `flutter_lints`| Koodityylin tarkistus          |

Lisäksi projektissa on FlutterFire CLI:n generoima `lib/firebase_options.dart`, jota käytetään Firebase-asetusten lukemiseen — se ei ole erillinen `pubspec`-paketti.

## 6. Mitä ulkoisia palveluita sovellus käyttää

- **Google Firebase**  
  - **Authentication:** sähköposti/salasana -tunnistus.  
  - **Cloud Firestore:** muistiinpanojen tallennus ja synkronointi.

Sovellus edellyttää verkkoyhteyttä näiden palveluiden käyttöön. Firebase-projektin ja palveluiden (Auth, Firestore) on oltava kytkettynä ja säännösten on sallittava kirjautuneen käyttäjän luku/kirjoitus omalle `users/{uid}/notes`-polulle.

## 7. Mitä puhelimen tai laitteen ominaisuuksia sovellus käyttää

Nykyisessä toteutuksessa ei käytetä erityisiä laite-API:ja (esimerkiksi kameraa, sijaintia, tiedostojärjestelmää tai ilmoituksia). Sovellus hyödyntää käytännössä:

- **verkkoyhteyttä** (Firebase-palveluihin yhdistäminen),
- **näppäimistösyötettä** tekstikentissä (sähköposti, salasana, muistiinpanotekstit).

Flutter-sovellus voidaan ajaa useilla alustoilla (esimerkiksi selain tai työpöytä), jolloin käytettävä “laite” on se ajoympäristö — sovelluksen `lib`-koodi ei kuitenkaan sido toimintoja tiettyyn puhelinominaisuuteen.

## 8. Mitä näkymiä sovelluksessa on

- **Kirjautumis- ja rekisteröintinäkymä** (`LoginView`): sähköposti- ja salasanakentät, painikkeet kirjautumiseen ja rekisteröitymiseen.

- **Muistiinpanonäkymä** (`HomeView`): uuden muistiinpanon syöttö ja lisäyspainike, lista omista muistiinpanoista (muokkaus- ja poistopainikkeet riveillä), uloskirjautumispainike.

- **Välilehti- tai erillinen “näkymä” authin ja sisällön välillä** ei ole: `AuthGate` valitsee automaattisesti kirjautumisnäkymän tai muistiinpanonäkymän tilan perusteella. Lisäksi käytössä on **dialogeja** muistiinpanon muokkaukseen ja poiston vahvistukseen.

## 9. Perustuuko toteutus johonkin esimerkkiin

Toteutus noudattaa yleisiä **FlutterFire- ja Firebase-dokumentaation** sekä kurssin **SPEC.md**-tavoitteiden mukaisia käytäntöjä (esimerkiksi `Firebase.initializeApp` + `DefaultFirebaseOptions`, Auth-streami, Firestore-alikokoelma käyttäjäkohtaisesti). Projektissa ei ole viitattu yhteen tiettyyn kopioitavaan opastusohjelmaan nimeltä; rakenne on yksinkertainen ja keskitetty tiedostoon `lib/main.dart`.

## 10. Onko toteutuksessa hyödynnetty tekoälyä, ja jos on, miten

Tekoälyapurina on toiminut Cursor AI.

---

*Tämä dokumentti perustuu projektin `pubspec.yaml`- ja `lib/main.dart` -toteutukseen sekä tiedostoon `SPEC.md`. 



<img width="1419" height="614" alt="image" src="https://github.com/user-attachments/assets/51fc2d6b-ad9d-4017-9692-fccca004d9cb" />
<img width="1036" height="786" alt="image" src="https://github.com/user-attachments/assets/23737a02-c749-49df-9836-5ec068c580b5" />
<img width="1624" height="682" alt="image" src="https://github.com/user-attachments/assets/f6b95539-8333-4da5-bba6-0ebc5b894638" />


