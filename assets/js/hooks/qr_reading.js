import { Html5Qrcode, Html5QrcodeSupportedFormats } from "../../vendor/html5-qrcode.js"

function parseURL(url) {
  try {
    const url_obj = new URL(url);

    if (url_obj.host !== window.location.host) return null;
    return url_obj.pathname.split("/").splice(1).join("/");
  } catch {
    return null;
  }
}

export const QrScanner = {

  mounted() {
    const config = { fps: 4, qrbox: (width, height) => {return { width: width * 0.8, height: height * 0.9 }}};
    this.scanner = new Html5Qrcode(this.el.id, { formatsToSupport: [ Html5QrcodeSupportedFormats.QR_CODE ] });

    const onScanSuccess = (decodedText, decodedResult) => {
      const pathname = parseURL(decodedText);
      if (pathname != null && pathname !== this.lastRead) {
        this.lastRead = pathname;
        if (this.el.dataset.on_success)
          Function("hook", "pathname", this.el.dataset.on_success)(this, pathname);
      }
    }

    const startScanner = () => {
      this.scanner.start({ facingMode: "environment" }, config, onScanSuccess)
      .then((_) => {
        if (this.el.dataset.on_start)
          Function("hook", this.el.dataset.on_start)(this);
      }, (e) => {
        if (this.el.dataset.on_error)
          Function("hook", this.el.dataset.on_error)(this);
      });
    }

    if (this.el.dataset.ask_perm) {
      document.getElementById(this.el.dataset.ask_perm).addEventListener("click", startScanner);
    }

    if (this.el.dataset.open_on_mount !== undefined)
      startScanner();
  },

  destroyed() {
    this.scanner.stop().then((_) => {
      if (this.el.dataset.on_stop)
        Function("hook", this.el.dataset.on_stop)(this);
    });
  }
}