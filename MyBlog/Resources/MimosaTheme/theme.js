(() => {
    const storageKey = "mimosa-theme";
    const root = document.documentElement;
    const systemTheme = window.matchMedia("(prefers-color-scheme: dark)");

    const readTheme = () => {
        try {
            const value = localStorage.getItem(storageKey);
            return value === "light" || value === "dark" ? value : null;
        } catch {
            return null;
        }
    };

    const applyTheme = (theme) => {
        root.dataset.theme = theme;
        root.style.colorScheme = theme;

        const toggle = document.querySelector(".theme-toggle");
        if (!toggle) {
            return;
        }

        const nextThemeName = theme === "dark" ? "白天" : "黑夜";
        const label = `切换到${nextThemeName}模式`;
        toggle.setAttribute("aria-label", label);
        toggle.setAttribute("title", label);
    };

    let selectedTheme = readTheme();
    applyTheme(selectedTheme ?? (systemTheme.matches ? "dark" : "light"));

    const connectToggle = () => {
        const toggle = document.querySelector(".theme-toggle");
        if (!toggle) {
            return;
        }

        applyTheme(root.dataset.theme);

        toggle.addEventListener("click", () => {
            selectedTheme = root.dataset.theme === "dark" ? "light" : "dark";

            try {
                localStorage.setItem(storageKey, selectedTheme);
            } catch {
                // The active theme still works when storage is unavailable.
            }

            applyTheme(selectedTheme);
        });
    };

    if (document.readyState === "loading") {
        document.addEventListener("DOMContentLoaded", connectToggle, { once: true });
    } else {
        connectToggle();
    }

    systemTheme.addEventListener("change", (event) => {
        if (readTheme() === null) {
            selectedTheme = null;
            applyTheme(event.matches ? "dark" : "light");
        }
    });
})();
