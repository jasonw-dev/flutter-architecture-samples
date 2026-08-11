# Build Plan — main

This repo is built one stage at a time, by hand. This file is the source of truth for
what the build is allowed to become. Read it before starting any stage.

## Roles

- **Jason** decides. Every stage ends with a decision he makes.
- **The planning session** guards scope and hands over one stage at a time.
- **A build session** — one per stage, started in this repo — discusses that stage's open
  questions, implements the decision, and reports the result and the reasoning back.

Sessions are disposable. Knowledge lives in this file, not in chat history.

## Workflow

- Each stage is built on its own branch: `stage-<n>-<name>`, e.g. `stage-1-skeleton`.
- Jason reviews the finished stage. Once he approves, it is squash-merged into `main` —
  one commit per stage, no pull request.
- Stage branches are short-lived and do **not** count towards the 4-branch cap below, which
  covers topic branches only.

## What this repo is

A Flutter mobile app template. `main` holds the smallest architecture that is still
complete. Each branch demonstrates one extension topic on top of it.

It is **not** a CI/CD reference, not a feature showcase, and not a teaching sample.
A previous attempt at the same idea grew to 9 packages, ~9,250 lines of Dart, 14 how-to
guides and 6 ADRs before it stopped being followable. It failed by accumulation — every
addition was individually reasonable. Every rule below exists to stop that repeating.

## Hard constraints

1. `main` is a **single package**. Layers are folders under `lib/`, not workspace packages.
2. `main` is **bloc + get_it**.
3. `main` is **one domain, two screens**: list → detail, with loading/error/data states.
4. `lib/` stays under **1,500 lines** of Dart, excluding tests and generated code.
   Check with `find lib -name '*.dart' | xargs wc -l`.
   This ceiling may be adjusted **exactly once**, at stage 7, and only if `main` itself
   exceeds it — to the measured value plus 20%, with the reason recorded below. Never again.
5. `README.md` is two sections: conventions (one page) and branch guide (one page). Intro is
   three lines. No `docs/`, no ADRs.
6. No custom lint, no import-boundary scripts, no CI workflow in `main`.
   `analysis_options.yaml` carries a standard lint set only.
7. At most **4 active branches**. A fifth one requires retiring an existing one.
8. **If discussing a stage takes longer than implementing it, take the default answer and
   move on.** Ritual fatigue is the most likely way this plan dies — more likely than
   complexity.

## What may enter `main`

All three must hold:

1. Every app needs it.
2. Adding it later costs clearly more than adding it now (asymmetric migration cost).
3. No branch could carry it and be merged in at project start.

Zero-footprint constraints — lint config, folder layout, naming conventions — enter `main`
freely; they do not consume the line budget.

Explicitly **not** in `main`: auth/session, localization, theming system, permissions, push,
crash reporting, flavors, code generation, CI.

`main` does carry a minimal `ColorScheme.fromSeed` theme (~20 lines). That is a default,
not a theming system.

## Branch discipline

- Branch names are the topic in kebab-case, no prefix: `mvvm`, `cache`, `flavors`, `l10n`,
  `multi-package`.
- Branches **rebase** onto `main`, so `git diff main..<branch>` is always a clean increment.
  That diff is the teaching material.
- `main` does not move except when something graduates into it. Rebase every branch once,
  as a batch, after each graduation — not continuously.
- Graduation uses the three rules above and must respect the line ceiling. If it would break
  the ceiling, something already in `main` gets demoted to a branch first.

## Stages

Technology choices are **not** made here. Each stage decides its own, with the code from the
previous stage in front of it.

| # | Stage | Decides | Done when |
|---|-------|---------|-----------|
| 1 | Skeleton | feature-first vs layer-first layout; Flutter version via fvm; lint set; the domain subject; minimal theme | App runs; stage 1 decisions recorded below |
| 2 | Routing | Routing package; where routes are declared; how parameters are passed | Two empty screens navigate with a parameter; test passes |
| 3 | Networking + DI | HTTP client; DTO vs domain model; where the repository interface lives; get_it registration policy; test double strategy | A real API response parses into a model; parse test passes; DI resolves the repository |
| 4 | Error handling | How failure is represented (`Result` vs exceptions); which layer converts it | A network failure is asserted in a test; the shape is consistent across layers |
| 5 | List screen | bloc event/state conventions; whether a use case layer sits between bloc and repository | loading, error and data all render; bloc test passes |
| 6 | Detail screen | How data crosses screens: pass the object, or pass an id and refetch | Both screens connected; widget test passes |
| 7 | Freeze | What the README conventions section keeps and cuts; whether anything should be demoted to a branch | `lib/` under the ceiling; `flutter test` green; every conventions line points at real code in `main` |

Testing is not a stage. Each stage's "done when" includes its own tests — writing the
template so tests come last would teach exactly the wrong order.

Layering is not a stage either. Whether a domain layer or a use case layer exists is decided
in stages 3 and 5, once there is real code to judge it against — not up front.

## Decisions

Each completed stage records what was decided and why. Keep entries short.

### Stage 1 — Skeleton

- **Layout: feature-first.** Each feature owns a folder under `lib/features/`, with
  cross-feature code in `lib/core/`. With one domain this costs a little ceremony, but the
  template exists to be copied into apps with many features, and layer-first → feature-first
  is a whole-tree move later. Only `presentation/` exists today. Which layers sit beside it
  is decided in stages 3 and 5, once there is code to judge it against.
- **Flutter 3.44.9, pinned with fvm** (`.fvmrc`). Latest stable at the time of the stage.
  fvm keeps the pin in the repo without a global install; `.fvm/` is gitignored.
- **Lint: `flutter_lints`.** The Flutter default, which is what constraint 6 means by a
  standard lint set. `very_good_analysis` was rejected: stricter, but it forces doc comments
  and explicit types, which spends the line budget on ceremony.
- **Domain: Rick and Morty characters** (`rickandmortyapi.com`). No API key, stable, natural
  list → detail shape, and a payload with enough fields to make the DTO/model split in
  stage 3 mean something. PokéAPI's detail payload is too fat to read; JSONPlaceholder's is
  too thin to teach anything.
- **Theme:** `AppTheme` in `lib/core/theme/`, one seed color, light + dark from
  `ColorScheme.fromSeed`. 20 lines.
- Package name `flutter_architecture_samples`, platforms iOS + Android only, created with
  `flutter create --empty`. A one-test smoke suite (`test/app_test.dart`) asserts the app
  boots, so `flutter test` is green from stage 1 on.
- `lib/` is 56 lines. `flutter analyze` clean, `flutter test` green, app runs on the iOS
  simulator.

### Stage 2 — Routing

- **Package: `go_router`.** Declarative, maintained by the Flutter team, no codegen. Named
  `Navigator 1.0` routes were rejected: arguments arrive as `dynamic` and deep links have to
  be hand-rolled, so the template would teach the thing real apps replace first. `auto_route`
  is typed but needs `build_runner`, which constraint 6 keeps out of `main`.
- **Dependency direction: `features → core`, and `core` never imports a feature.** `core` is
  code shared by several features and owned by none — theme today, http client and error
  types later. Features do not import each other either; they navigate by path.
- **Routes are declared per feature, composed in `lib/app/`.** Each feature exports its own
  `List<RouteBase>` plus the paths it answers to (`CharactersRoutes`); `lib/app/router.dart`
  only lists them. `lib/app/` is the composition root — the one layer allowed to know every
  feature — which is why the router does not live in `core/`. Adding a feature is a one-line
  change there, and stage 3's DI registration has an obvious home.
- **Parameters travel in the path** (`/characters/:id`). Deep-linkable and typed as `String`
  at the edge. This deliberately leaves stage 6 free: passing the object instead only adds
  `extra` to the same route.
- `App` builds its own `GoRouter`, so each test gets a clean navigation stack.
- `lib/` is 128 lines. `flutter analyze` clean, `flutter test` green (list → detail with an
  id, and back).

### Stage 3 — Networking + DI

- **HTTP client: `dio`.** Base URL, timeouts and typed `DioException`s come with it, and
  stage 4 has an interceptor slot waiting rather than a wrapper to grow. `package:http` is
  smaller and its `MockClient` needs no test dependency, but it decodes nothing and times out
  nothing on its own, so the difference is where the boilerplate sits, not whether it exists.
  `createApiClient()` in `lib/core/network/` is the only place a `Dio` is built.
- **DTO and domain model are separate.** `CharacterDto` in `data/` speaks the API's
  vocabulary — `image`, `""` for "no sub-species", `origin` as a nested object — and
  `toDomain()` translates. `Character` in `domain/` has no `fromJson` and no wire names.
  A single class with a `fromJson` would be ~25 lines against ~90, and cleans the payload in
  the same one place; what the split adds is that the domain shape is written down
  independently, and that `domain/` contains nothing that knows HTTP exists. The DTO models
  only the fields the app reads: `url`, `created` and the 51-entry `episode` list are
  ignored, because a DTO is a translation of the response, not an archive of it.
- **The repository interface lives in `domain/`, the implementation in `data/`.** So
  `features/characters/` now has three layers: `domain/`, `data/`, `presentation/`. Dart
  makes every class an implicit interface, so an explicit `abstract interface class` is not
  what makes the repository swappable in tests — it is what keeps `domain/` free of `dio`.
  There is **no** data source class between the repository and `Dio`: with one backend it
  would only forward calls.
- **Whether a use case layer sits between bloc and repository is still stage 5's question.**
  `domain/` existing does not settle it.
- **get_it registers per feature, composed in `lib/app/di.dart`** — the same shape as the
  router. Each feature exports `registerCharacters(GetIt)`; the composition root calls it and
  registers the shared `Dio`. The registration file sits at the feature root, not in a layer,
  because it is the one file that spans them. **Everything is a lazy singleton**: everything
  registered here is stateless and shared, and anything holding per-screen state belongs to
  that screen instead. `main()` calls `configureDependencies()` before `runApp`.
- **Test doubles are faked at the boundary, never generated.** The HTTP layer is faked with
  `http_mock_adapter`, which swaps `Dio`'s transport, so repository tests exercise the
  shipping code against captured production responses (`test/fixtures/`, unedited). Above the
  repository, tests hand-write a class that `implements CharacterRepository`. `mockito` was
  never an option — it needs `build_runner`, which constraint 6 keeps out of `main` — and
  `mocktail` would add a `when`/`verify` DSL for a single collaborator.
- `lib/` is 315 lines. `flutter analyze` clean, `flutter test` green (11 tests: parse,
  empty-`type` and nested-`origin` translation, both endpoints, DI resolution and sharing).
  Verified once against the live API outside the test suite; the suite itself never uses the
  network.

### Stages 4–7 — built in one pass

Stages 1–3 were built one at a time, with Jason deciding at each stage. Stages 4 to 7 were
not: he asked for them in a single pass and reviewed once at the end. The decisions below were
made against the constraints already written down rather than by discussion, and are recorded
in the same detail so the reasoning is still auditable.

### Stage 4 — Error handling

- **Failure is a return value, not an exception.** `Result<T>` in `lib/core/result.dart` is
  sealed with `Ok` and `Err`, so there is no way to reach the value without deciding what
  happens when there isn't one. `Err` rather than `Error`, which `dart:core` already owns for
  something different — a bug, not a handled outcome.
- **`Failure` is a sealed type with three cases**, in `lib/core/failure.dart`:
  `NetworkFailure` (never reached the server), `ServerFailure(statusCode)` (reached it, it
  refused), `UnexpectedFailure` (anything else, including a payload that did not parse). A
  case earns its place only when a screen would say something different about it. Sealed, so
  handling failures is exhaustive at the compiler rather than by convention.
- **The conversion happens in the repository implementation.** It is the last layer that knows
  what a `DioException` is, so it is the layer that stops one. `core/network/` still only
  configures transport; `domain/` and everything above it never see dio. A private `_guard`
  wraps each call, and its bare `on Object` is deliberate — a malformed payload throws a cast
  error, not a `DioException`, and that should read as "something broke", not a crash.
- **Failure text lives in one extension** (`FailureMessage`), one exhaustive switch. English
  literals sit there because `main` has no localization; that extension is the single seam an
  `l10n` branch replaces, instead of every screen that renders an error.

### Stage 5 — List screen

- **No use case layer.** The bloc calls `CharacterRepository` directly. With one repository
  call per event, a use case would be a one-line forward, and the boundary it would protect is
  already the repository interface. Adding one later is a local change; adding one now would
  be ceremony the template teaches by example.
- **Bloc conventions.** Events are named subject + past-tense verb (`CharactersRequested`) and
  say what happened, never what to do about it. States are sealed, so the widget's `switch` is
  exhaustive and a new state cannot be forgotten in the UI. A bloc file imports
  `package:bloc`, never `package:flutter_bloc` — hence both packages in `pubspec.yaml`: that
  split is what makes "no Flutter inside a bloc" checkable by reading the imports.
- **Blocs are not registered in get_it.** A route creates one per screen and it dies with the
  screen, which is exactly what stage 3's registration policy said the locator is not for.
  Features receive their repository as an argument (`charactersRoutes(repository)`) rather
  than reading the locator, because a feature importing `lib/app/` would reverse the
  dependency arrow. `main()` is now the only place that both registers and resolves.
- **`FailureView` in `core/`** renders any `Failure` with a retry button. It is in `core`
  because a retry that some screens have and others forget is how an app grows dead ends.
- **Images carry an `errorBuilder`.** Without one a broken image throws, and in a widget test
  — where nothing answers an HTTP request — every row would. The alternative was ~55 lines of
  `HttpOverrides` scaffolding in `test/`; handling a broken image is what a real app needs
  anyway.

### Stage 6 — Detail screen

- **The detail screen is given an id and fetches.** The list could have handed over the
  character it already has and saved a request. It does not: `/characters/2` opened from a
  link or a cold start has an id and nothing else, and a screen that works one way from the
  list and another way from a link is two screens. The cost is one request; the benefit is
  that deep linking is not a special case.
- The detail bloc repeats the list bloc's shape rather than sharing a generic base. Two
  concrete blocs are easier to read than one abstraction over two cases, and a template is
  copied more often than it is extended.

### Stage 7 — Freeze

- **The line ceiling was not adjusted.** `lib/` is 699 lines against 1,500 — 47%. The
  one-time adjustment written into constraint 4 stays unused, and stays available.
- **Nothing was demoted to a branch.** Every file in `main` is on the path from a URL to a
  rendered screen, or is the wiring that connects them.
- **README carries the conventions and the branch guide**, each about a page, every rule
  pointing at code that exists. The branch table lists the five planned topics as not built
  yet rather than pretending otherwise.
- `flutter analyze` clean, `flutter test` green (20 tests), app runs.
