# flutter_architecture_samples

A Flutter mobile app template. `main` holds the smallest architecture that is still complete.
Each branch demonstrates one extension topic on top of it.
Requires [fvm](https://fvm.app); the pinned Flutter version is in `.fvmrc`.

```sh
fvm install
fvm flutter run
```

## Conventions

Every rule here points at code in `main`. If one stops pointing at anything, delete it.

**Three top-level directories, one direction.** `lib/features/` holds features, `lib/core/`
holds what more than one of them needs, and `lib/app/` is the composition root — the only
place allowed to know every feature. Features depend on `core`; `core` never imports a
feature; features never import each other; nothing imports `app`.

**A feature is three layers.** `domain/` holds the model and the repository interface,
`data/` holds the DTO and the implementation, `presentation/` holds blocs and pages. The DTO
speaks the API's language (`image`, `""` for absent) and `toDomain()` translates; the domain
model has no `fromJson` and no wire names.

**Repositories return `Result`, they do not throw.** A caller cannot reach the value without
saying what happens when there isn't one. Exceptions stop at the repository implementation —
it is the last layer that knows `DioException` exists. `Failure` is sealed and its
user-facing text lives in one extension, so a new failure cannot ship unnamed.

**Blocs turn events into states and nothing else.** Events are named subject + past-tense
verb (`CharactersRequested`). States are sealed, so the widget's `switch` is exhaustive and a
forgotten state does not compile. A bloc imports `package:bloc`, never `package:flutter_bloc`
— no widget, no `BuildContext`, testable without a Flutter binding. There is no use case
layer: with one repository call per event it would be a one-line forward.

**Dependencies are registered in `lib/app/di.dart`**, one `register<Feature>()` per feature,
everything a lazy singleton. Blocs are not registered — a route creates one per screen and it
dies with the screen. Features receive their dependencies as arguments rather than reading the
locator, which is what keeps the arrow pointing at `core`.

**Each feature owns its routes.** It exports its paths and a `List<RouteBase>`;
`lib/app/router.dart` lists them. Parameters travel in the path (`/characters/:id`), and a
detail screen fetches by id rather than being handed an object — a link opened from a cold
start has an id and nothing else.

**Tests ship with the code that needs them, not at the end.** The HTTP boundary is faked by
swapping `Dio`'s transport, so the code under test is the code that ships; above the
repository, fakes are hand-written. No code generation anywhere: no `build_runner`, no
`freezed`, no generated mocks.

## Branch guide

`main` is deliberately small: it is one domain, two screens, and the wiring that makes those
two screens work. Everything a real app also needs — but which would make the architecture
harder to read — lives on its own branch, built on top of `main`.

Branches are rebased onto `main`, so `git diff main..<branch>` is always a clean increment.
That diff is the point: it is the shortest possible answer to "what does adding this actually
involve?"

To start a real project: clone, then merge the branches you know you need before writing any
feature code. Localization and flavors in particular are far cheaper merged on day one than
retrofitted later.

| Branch | Shows | Status |
|--------|-------|--------|
| `mvvm` | The same two screens with Flutter's ChangeNotifier + Command MVVM instead of bloc | Not built yet |
| `cache` | A caching strategy behind the repository interface, with the screens unchanged | Not built yet |
| `l10n` | `gen_l10n` wiring, and what it costs to move the `Failure` messages out of `core` | Not built yet |
| `flavors` | Development, staging and production entry points, including native configuration | Not built yet |
| `multi-package` | The same app split into pub workspace packages, and what that buys | Not built yet |

At most four branches exist at a time. A fifth one means retiring an existing one — a template
whose branch list nobody can hold in their head has the same problem `main` is avoiding.
