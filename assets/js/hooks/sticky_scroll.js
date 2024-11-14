export const StickyScroll = {
    mounted() {
        window.addEventListener("scroll",() => {
            const panel = document.getElementById("scroll-panel");
            if(panel == null) { window.removeEventListener("scroll", this); return; }
            if(window.innerHeight > panel.offsetHeight) return;
            panel.style.top = -Math.min(Math.max(window.scrollY, 0), panel.offsetHeight - window.innerHeight) + "px";
          });
    }
}