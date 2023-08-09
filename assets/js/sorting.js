import Sortable from "../vendor/sortable.js"

export const InitSorting = {
  mounted() {
    new Sortable(this.el, {
      animation: 150,
      ghostClass: "bg-slate-100",
      dragClass: "shadow-2xl",
      handle: ".handle",
      onEnd: (evt) => {
        const elements = Array.from(this.el.children)
        const ids = elements.map(elm => elm.id)
        this.pushEvent("update-sorting", {ids: ids})
      }
    })
  }
}