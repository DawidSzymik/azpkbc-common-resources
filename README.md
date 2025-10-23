# Boilerplate do IaC w podstawach rozwiązań chmurowych

## Dodatkowe narzędzia

Ten projekt zawiera dodatkowe narzędzia, które mogą być przydatne podczas pracy z infrastrukturą jako kod (IaC)
w chmurze. Poniżej znajdują się instrukcje dotyczące ich instalacji i konfiguracji.

### pre-commit

Pre-commit to narzędzie automatyzujące uruchamianie testów, formatowania i kontroli jakości kodu przed każdym
commitem. W tym projekcie pre-commit sprawdza m.in. poprawność plików OpenTofu/Terraform, bezpieczeństwo
oraz formatowanie.

**Instalacja:**

```bash
pip install pre-commit
```

**Aktywacja w projekcie:**

```bash
pre-commit install
```

**Ręczne uruchomienie wszystkich hooków:**

```bash
pre-commit run --all-files
```

W razie problemów z hookami, można je pominąć podczas commita używając flagi `--no-verify`:

<!-- BEGIN_TF_DOCS -->

<!-- END_TF_DOCS -->
