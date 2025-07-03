export const FocusEnd = {
  mounted() {
    const input = this.el;
    if (input && input.focus) {
      input.focus();
      const val = input.value;
      input.value = "";
      input.value = val;
    }
  },
};
