export const StickyScroll = {
    mounted() {
        window.addEventListener("scroll",() => {
            const panel = document.getElementById("scroll-panel");
            if(window.innerHeight > panel.offsetHeight) return;
            panel.style.top = -Math.min(Math.max(window.scrollY, 0), panel.offsetHeight - window.innerHeight) + "px";
          });
    }
}