package("dearoreui")
    set_description("DearOreUI: header-only public API for OreUI client mods")
    set_license("CC0-1.0")

    -- 版本 = git ref（commit/tag）。升级头时更新下方 commit id 并推送到本 repo。
    add_urls("https://github.com/copper-lamp/Dear-OreUI.git")
    add_versions("v0.1.1", "67716d60155b007e585cda8e37948931c9cb7ee8")

    -- 公开头内部互引用与消费者 include 都是 "api/..."、"bridge/..."，因此把公开头
    -- 平铺到 <install>/include/{api,bridge}：xmake 默认 includedir = <install>/include
    -- 直接命中，无需 on_load 额外注入，consumers `#include "api/..."` 立即解析。
    on_install(function(package)
        -- 从 Dear-OreUI 源码直接拷贝公开头（单一来源 = src/），不维护 include/ 副本
        local inc = path.join(package:installdir(), "include")
        os.mkdir(path.join(inc, "api", "types"))
        os.mkdir(path.join(inc, "api", "manifest"))
        os.mkdir(path.join(inc, "bridge"))
        os.vcp("src/api/I*.h",                       path.join(inc, "api") .. "/")
        os.vcp("src/api/types/*.h",                  path.join(inc, "api", "types") .. "/")
        os.vcp("src/bridge/DearOreUIBridge.h",       path.join(inc, "bridge") .. "/")
        for _, f in ipairs({
            "ModManifest.h", "ResourceManifest.h", "ScriptManifest.h",
            "StyleSheetManifest.h", "UiManifest.h", "Dependency.h", "Permission.h",
        }) do
            os.vcp("src/api/manifest/" .. f, path.join(inc, "api", "manifest") .. "/")
        end
    end)
package_end()
