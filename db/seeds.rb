course_list = [
  ["LESI", "Licenciatura em Engenharia de Sistemas e Informática"],
  ["LEI", "Licenciatura em Engenharia Informática"],
  ["MIEI", "Mestrado Integrado em Engenharia Informática"],
  ["MEI", "Mestrado em Engenharia Informática"],
  ["DI", "Doutoramento em Informática"],
  ["MI", "Mestrado em Informática"],
  ["MES", "Mestrado em Engenharia de Sistemas"],
  ["MERSCOM", "Mestrado em Engenharia de Redes e Comunicações"],
  ["BIOINF", "Mestrado em Bioinformática"]
]

course_list.each do |acronym, description|
  Course.create( acronym: acronym, description: description )
end
