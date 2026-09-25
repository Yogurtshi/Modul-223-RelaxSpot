# Testdokumentation RelaxSpot

## 1. Ziel der Tests

Die Tests sichern die fachlichen Regeln und die Multi-User-Funktionen der Anwendung ab. Der Fokus liegt auf:

- Authentifizierung und Berechtigungen
- Datenkonsistenz bei gleichzeitigen Check-ins
- Kernfunktion der Kapazitätsprüfung
- Rollenmodell für Nutzer, Moderator und Admin
- Controller-Logik für das typische Nutzer- und Moderations-Workflow

## 2. Test-Framework und Ausführung

Das Projekt verwendet Rails Minitest.

Ausführung:

```sh
bin/rails test
```

## 3. Prüfungsbereiche

### 3.1 Model-Tests

Abgedeckt durch die Modelle unter `test/models/`:

- `check_in_test.rb`
- `place_test.rb`
- `user_test.rb`
- `status_report_test.rb`
- `check_in_hold_test.rb`

Diese Tests prüfen unter anderem:

- Kapazitätsgrenzen bei Check-ins
- Verhinderung doppelter aktiver Check-ins am gleichen Ort
- Validierung von Zeitfenstern (`ends_at` muss nach `started_at` liegen)
- gleichzeitige Zugriffe und Overbooking-Prävention

### 3.2 Policy-Tests

Abgedeckt durch die Dateien unter `test/policies/`:

- `user_policy_test.rb`
- `profile_policy_test.rb`
- `check_in_policy_test.rb`
- `status_report_policy_test.rb`
- `place_policy_test.rb`

Diese Tests prüfen:

- erlaubte und verweigerte Zugriffe je nach Rolle
- Sichtbarkeit eigener und fremder Ressourcen
- Zugriffsschutz bei Admin-, Moderator- und Nutzerrollen

### 3.3 Controller-/Integrationstests

Abgedeckt durch die Dateien unter `test/controllers/`:

- `check_ins_controller_test.rb`
- `sessions_controller_test.rb`
- `users_controller_test.rb`
- `profile_controller_test.rb`
- `places_controller_test.rb`
- `status_reports_controller_test.rb`
- `admin/users_controller_test.rb`
- `moderation/places_controller_test.rb`
- `moderation/status_reports_controller_test.rb`
- `moderation/dashboards_controller_test.rb`

Diese Tests prüfen:

- Login und Session-Flows
- Formulare und Weiterleitungen
- Fehlermeldungen bei vollem Ort oder unerlaubtem Zugriff
- Moderations- und Admin-Aktionen
- Locking bei paralleler Bearbeitung

## 4. Prüfung der Anforderungen

| ID | Anforderung | Prüfung | Ergebnis |
|---|---|---|---|
| A1 | Registrierung und Login | Controller-Tests für Login/Registrierung und Policy-Tests für Zugriff | Erfüllt |
| A2 | Orte suchen und filtern | Places-Controller- und Model-Tests | Erfüllt |
| A3 | Check-in mit Kapazitätsprüfung | Modell- und Controller-Tests für volle Orte und Kapazitätsgrenzen | Erfüllt |
| A4 | Vorschlag neuer Orte | Moderations- und Controller-Tests | Erfüllt |
| A5 | Statusmeldung | Status-Report-Tests und Controller-Tests | Erfüllt |
| A6 | Rollen- und Berechtigungslogik | Policy-Tests und Admin-/Moderator-Controller-Tests | Erfüllt |
| A7 | Locking bei Bearbeitung | Moderation-Place-Tests mit edit-lock und Parallelbearbeitung | Erfüllt |
| A8 | Datenkonsistenz | Modell-Tests für gleichzeitige Check-ins und Overbooking | Erfüllt |

## 5. Ergebnis der aktuellen Testausführung

Die Test-Suite wurde am 25.09.2026 ausgeführt. Ergebnis:

```text
92 runs, 282 assertions, 0 failures, 0 errors, 0 skips
```

Damit erfüllt das aktuelle Projekt den dokumentierten Prüfungsstand für die zentralen fachlichen Regeln und Multiuser-Anforderungen.

## 6. Fazit

Die Tests decken die wichtigsten fachlichen Regeln und Sicherheitsaspekte der Anwendung ab. Sie dienen als Nachweis für die Umsetzung der Kernfunktionalität und für die Stabilität im Mehrbenutzerbetrieb.
