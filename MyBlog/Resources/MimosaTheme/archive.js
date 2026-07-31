(() => {
    "use strict";

    const filter = document.querySelector("[data-archive-filter]");
    const archive = document.querySelector(".archive-list");

    if (!filter || !archive) {
        return;
    }

    const buttons = Array.from(
        filter.querySelectorAll(".archive-filter-button")
    );
    const items = Array.from(
        archive.querySelectorAll("[data-archive-item]")
    );
    const yearGroups = Array.from(
        archive.querySelectorAll("[data-archive-year-group]")
    );
    const status = filter.querySelector(".archive-filter-status");

    function tagsFor(item) {
        return (item.dataset.tags || "").split(",").filter(Boolean);
    }

    function applyFilter(requestedTag, updateURL) {
        const selectedButton = buttons.find(
            (button) => button.dataset.tag === requestedTag
        );
        const selectedTag = selectedButton ? requestedTag : "";
        const selectedTagKey = selectedButton?.dataset.tagKey || "";
        let visibleCount = 0;

        items.forEach((item) => {
            const isVisible =
                selectedTag === "" || tagsFor(item).includes(selectedTagKey);
            item.hidden = !isVisible;

            if (isVisible) {
                visibleCount += 1;
            }
        });

        yearGroups.forEach((group) => {
            group.hidden = !Array.from(
                group.querySelectorAll("[data-archive-item]")
            ).some((item) => !item.hidden);
        });

        buttons.forEach((button) => {
            const isSelected =
                (selectedTag === "" && !button.dataset.tag) ||
                button.dataset.tag === selectedTag;
            button.classList.toggle("is-active", isSelected);
            button.setAttribute("aria-pressed", String(isSelected));
        });

        if (status) {
            status.textContent = selectedTag
                ? `${selectedTag} · ${visibleCount} 篇文章`
                : `全部 · ${visibleCount} 篇文章`;
        }

        if (updateURL) {
            const url = new URL(window.location.href);

            if (selectedTag) {
                url.searchParams.set("tag", selectedTag);
            } else {
                url.searchParams.delete("tag");
            }

            window.history.replaceState(
                null,
                "",
                `${url.pathname}${url.search}${url.hash}`
            );
        }
    }

    buttons.forEach((button) => {
        button.addEventListener("click", () => {
            applyFilter(button.dataset.tag || "", true);
        });
    });

    window.addEventListener("popstate", () => {
        const tag = new URL(window.location.href).searchParams.get("tag") || "";
        applyFilter(tag, false);
    });

    const initialTag =
        new URL(window.location.href).searchParams.get("tag") || "";
    applyFilter(initialTag, false);
})();
