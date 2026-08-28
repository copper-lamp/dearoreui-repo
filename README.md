# dearoreui-repo

Self-hosted [xmake](https://xmake.io) repository for DearOreUI.

It distributes the **header-only public API** of
[Dear-OreUI](https://github.com/copper-lamp/Dear-OreUI) to external mods
declaratively — no GitHub Release zip artifact, no patching the upstream
LiteLDev/xmake-repo, fully self-controlled.

The package git-references the source repo directly: each published version
pins a git commit of `copper-lamp/Dear-OreUI`, and `on_install` copies the
public headers (`src/api/**`, `src/bridge/DearOreUIBridge.h`) into the package.

## Usage

In your mod's `xmake.lua`:

```lua
add_repositories("dearoreui-repo", "https://github.com/copper-lamp/dearoreui-repo.git")
add_requires("dearoreui") -- e.g. add_requires("dearoreui 0.1.1")

target("my-mod")
    add_packages("dearoreui")
    -- `#include "api/..."` / `#include "bridge/..."` now resolve automatically.
```

At runtime the consuming mod resolves `DearOreUI_QueryApi` from the already
loaded `DearOreUI.dll` via `GetProcAddress` (C ABI bridge); load order is
guaranteed by LeviLamina's `manifest.json` `dependencies`. This package only
supplies the compile-time headers.

## Layout

```
packages/
└── d/
    └── dearoreui/
        └── xmake.lua   # package description (git form)
```

## Updating the headers

To publish a new header set:

1. Push the new `Dear-OreUI` commit (or tag).
2. Update the commit id / tag in `packages/d/dearoreui/xmake.lua`.
3. Commit & push this repo.
4. Consumers run `xmake f -y` to refresh.