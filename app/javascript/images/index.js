function importAll (r) {
  r.keys().forEach(r);
}

importAll(require.context('./', true, /\.png$/));
importAll(require.context('./', true, /\.jpg$/));
