# tests-go

Test repository for https://github.com/makefile-inc/go

Upgrade module:

```bash
checkout_ref=""
make common/git/submodule/upgrade SUBMODULE_DIR="makefile-go" CHECKOUT_TO="$checkout_ref"
```