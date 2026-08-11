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

- **Layout: feature-first.** `lib/features/<feature>/{data,domain,presentation}`, with
  cross-feature code in `lib/core/`. With one domain this costs a little ceremony, but the
  template exists to be copied into apps with many features, and layer-first → feature-first
  is a whole-tree move later. Only the folders that hold code exist today; `data/` and
  `domain/` appear in stage 3.
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
