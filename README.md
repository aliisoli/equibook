# EquiBook

Marketplace for horse owners to book equine veterinary services — like Airbnb for horse vets.

Owners manage multiple horses (photos + ownership documents), browse vets, and book visits with **rates shown and confirmed up front**. Payment is **cash offline**. Vets manage services, rates, availability, and accept/decline bookings.

Built with **Flutter** (Android now, iOS-ready later). Data currently persists in a **local demo store** on the device so you can run and test without setting up a cloud backend. Firebase rules and migration notes are in [`docs/FIREBASE.md`](docs/FIREBASE.md).

## Demo accounts

After first launch, these accounts are seeded automatically:

| Role  | Email                 | Password  |
|-------|-----------------------|-----------|
| Owner | `owner@equibook.demo` | `demo1234` |
| Vet   | `vet@equibook.demo`   | `demo1234` |

Or tap **Try as owner** / **Try as vet** on the welcome screen.

## What you need on your Mac

Already installed for this project workspace where possible:

1. **Flutter SDK** — `brew install --cask flutter`
2. **Android Studio** — `brew install --cask android-studio`
3. Inside Android Studio: install the **Android SDK**, accept licenses, and create a **Virtual Device** (emulator)
4. (Later for iPhone) **Xcode** from the Mac App Store

## Run on an Android emulator

1. Open **Android Studio** once and finish the setup wizard (SDK + device manager).
2. Start an emulator: Device Manager → Play on a virtual phone.
3. From this project:

```bash
cd ~/Projects/equibook
flutter pub get
flutter doctor
flutter run
```

## App map

**Owner**

- Horses — add/edit horses, photos, ownership docs
- Find vets — browse profiles, services, rates, open slots
- Book — pick horse + service + slot, confirm cash rate, send request
- Bookings — track pending / confirmed / completed

**Vet**

- Bookings inbox — accept, decline, mark completed
- Services & rates — set cash prices owners will see
- Availability — open time slots
- Profile — bio, credentials, service area

## Project layout

```
lib/
  main.dart                 # app entry
  app.dart                  # role-based routing
  data/app_store.dart       # local auth + marketplace data
  models/                   # users, horses, services, bookings
  screens/auth|owner|vet/   # persona UIs
  theme/                    # EquiBook visual theme
firebase/                   # Firestore + Storage security rules (for later)
docs/FIREBASE.md            # how to connect Firebase
```

## GitHub

```bash
gh repo view --web
```

## License

MIT
