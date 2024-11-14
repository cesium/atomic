export const ScrollToTop = {
    mounted() {
      this.el.addEventListener("click", e => {
        e.preventDefault()
        window.scrollTo({
          top: 0,
          behavior: 'smooth'
        });
      })
    }
}