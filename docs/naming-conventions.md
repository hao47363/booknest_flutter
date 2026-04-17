# Naming conventions — branches and commits

This project enforces the rules below in **local Git hooks** (Lefthook) and **GitHub Actions** CI. Messages and branch names that do not match will fail `commit-msg` / `pre-push` locally and the **CI** check on push and pull requests.

---

## Commit messages

### Format

Use a **single first line** in this shape (Conventional Commits–style):

```text
<type>(<scope>): <short description>
```

- **`type`** — what kind of change it is (see allowed list below).
- **`scope`** — short hint for the area (feature, screen, module, or concern). **Lowercase**, may use `a-z`, `0-9`, `.`, `_`, `-`.
- **`short description`** — imperative, concise summary (not empty). You can add a blank line and body bullets **after** the first line if you want more detail; **only the first line** is validated by the hook.

### Allowed `type` values

| `type`     | Typical use |
|-----------|-------------|
| `feat`    | New user-facing behavior |
| `fix`     | Bug fix |
| `chore`   | Maintenance, deps, tooling without feature/fix semantics |
| `docs`    | Documentation only |
| `refactor`| Code change without behavior change |
| `test`    | Tests only |
| `perf`    | Performance |
| `ci`      | CI / automation config |
| `build`   | Build system or packaging |
| `style`   | Formatting / style only (no logic change) |
| `revert`  | Reverts a previous commit |

### `scope` rules

- Lowercase **letters and numbers**, plus **`.`**, **`_`**, **`-`** only.
- Keep it short (e.g. `cart`, `catalog`, `auth`, `profile`, `workflows`).

### Examples — valid

```text
feat(cart): implement add to cart option
fix(auth): handle empty password on login
chore(deps): bump go_router to 14.8.1
docs(readme): document local Hive setup
ci(workflows): add branch name validation to CI
refactor(catalog): extract filter chips widget
```

### Examples — invalid

```text
Add cart feature                           # missing type(scope):
FEAT(cart): add item                       # type must be lowercase
feat(Cart): add item                      # scope must be lowercase
feat: add item                             # scope is required
feat(my cart): add item                    # spaces not allowed in scope
wip                                        # wrong format
```

---

## Branch names

### Format

```text
<type>/<short-description>
```

- **`type`** — allowed prefix (see list below).
- **`short-description`** — **lowercase** slug: `a-z`, `0-9`, `.`, `_`, `-`. Must not be empty.

### Allowed `type` prefixes

`feature`, `feat`, `fix`, `chore`, `docs`, `refactor`, `test`, `perf`, `ci`, `build`, `style`, `revert`

Use **`feature/...`** or **`feat/...`** for new work; both are accepted.

### Exempt branches (no `type/...` pattern)

These names are **not** checked against the pattern:

- `main`
- `develop`
- `staging`

### Examples — valid

```text
feature/cart-add-item
feat/catalog-filters
fix/login-null-check
chore/update-readme
ci/github-actions-cache
```

### Examples — invalid

```text
main-feature                               # use feature/foo, not main-foo
Feature/cart                               # type must be lowercase
feat/CART                                  # description must be lowercase slug
fix                                        # missing /description
cart-feature                               # missing type prefix
```

---

## Enforcement

| Where | What runs |
|-------|-----------|
| Lefthook `commit-msg` | `./scripts/validate_commit_msg.sh` |
| Lefthook `pre-commit` / `pre-push` | `./scripts/validate_branch_name.sh` (and analyze/test on commit) |
| `.github/workflows/ci.yml` | Same validators + `flutter analyze` / `flutter test` |

After changing hooks or scripts, run **`lefthook install`** from the repo root.

---

## Quick copy-paste

**Commit**

```text
feat(<scope>): <what you did in present tense>
```

**Branch**

```text
feature/<kebab-case-description>
```
